#!/usr/bin/env python3
#********************************************************************************
# DynoSprite - scripts/cmoc-wrapper.py
# Copyright (c) 2018, Jamie Cho
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#********************************************************************************

import argparse
import errno
import os
import shutil
import subprocess
import sys



def move_or_remove(src, dest):
    """
    Try to move src to dest. If this fails tries to delete src.
    Returns an error message on failure and None if successful.
    """
    try:
        shutil.move(src, dest)
    except Exception as err:
        try:
            os.remove(src)
        except:
            pass
        return str(err)
    return None


def change_ext(path, newext):
    """
    Changes the extension of path to newext which must begin with a '.'
    """
    (fdir, basename) = os.path.split(path)
    (base, ext) = os.path.splitext(basename)
    return os.path.join(fdir, newext if base.startswith('.') else base + newext)


def change_dir(path, new_dir):
    """
    Returns path but with new_dir instead of its directory
    """
    return os.path.join(new_dir, os.path.basename(path))


def get_object_name(path):
    """
    Given a path with a basename of the form xx-object.c, return Object
    """
    (fdir, basename) = os.path.split(path)
    (base, ext) = os.path.splitext(basename)
    return base[3:].capitalize()


def main(argv):
    # Setup parser
    parser = argparse.ArgumentParser(
      description='Wrap CMOC so that it can generate the output needed by Dynosprite')
    parser.add_argument('-I', dest='include_path', metavar='PATH', action='append',
      required=False, help='Include path')
    parser.add_argument('--define', action='append',
      required=False, help='LWASM defines')
    parser.add_argument('-O', dest='optimization_level', metavar='LEVEL', type=int, default=2,
      help='Optimization level')
    parser.add_argument('--output-dir', metavar='DIR', type=str, required=True,
      help='Output directory')
    parser.add_argument('--file-type', metavar='TYPE', choices=['object', 'level'], required=True,
      help='Type of file being compiled')
    parser.add_argument('file', type=str, help='File to compile')

    # Parse args
    args = parser.parse_args(argv[1:])

    # Make the output dir if needed
    try:
        os.makedirs(args.output_dir)
    except OSError as e:
      if e.errno != errno.EEXIST:
          print(str(e))
          sys.exit(1)

    # Call cmoc
    cmoc_args = ['cmoc', '-S', '--intermediate',
      f'-O{args.optimization_level}']
    for include_dir in args.include_path or []:
        cmoc_args.append('-I')
        cmoc_args.append(include_dir)
    cmoc_args.append(args.file)
    retval = subprocess.call(cmoc_args)

    # Get the list of files created by cmoc
    s_file = change_ext(args.file, '.s')
    src_files = [s_file]
    dst_files = [change_dir(f, args.output_dir) for f in src_files]
    [dst_s_file] = dst_files

    # Move all of the files into the proper location
    errs = []
    for (src, dst) in zip(src_files, dst_files):
        err = move_or_remove(src, dst)
        if err:
            errs.append(err)
    if retval:
        sys.exit(retval)
    if errs:
        print("Failed to move a file: {}".format(errs[0]))
        sys.exit(1)

    # Open dst_s_file and append extra stuff at end
    with open(dst_s_file) as f:
        lines = f.readlines()
    lines = lines[:-1]
    lines.append(' SECTION define_the_object\n')
    lines.append('#define DynospriteObject_DataDefinition\n')
    obj_name = get_object_name(s_file)
    if args.file_type == 'level':
        lines.append(f'#define _LevelInit _{obj_name}Init\n')
        lines.append(f'#define _LevelCalculateBkgrndNewXY _{obj_name}CalculateBkgrndNewXY\n')
    else:
        lines.append(f'#define _ObjectInit _{obj_name}Init\n')
        lines.append(f'#define _ObjectReactivate _{obj_name}Reactivate\n')
        lines.append(f'#define _ObjectUpdate _{obj_name}Update\n')
    if args.file_type == 'object':
        lines.append('#include "{}"\n'.format(change_ext(s_file, '.h')))
    with open(f'../../engine/c-{args.file_type}-entry.asm') as f:
        lines.extend(f.readlines())
    lines.append(' ENDSECTION\n')
    with open(dst_s_file, 'w') as f:
        f.writelines(lines)

    # Apply CPP
    dst_asm_file = change_ext(dst_s_file, '.asm')
    cpp_args = ['cpp', '-I.', dst_s_file, dst_asm_file]
    retval = subprocess.call(cpp_args)
    if retval:
        sys.exit(retval)

    # Now assemble the resulting dst_s_file
    dst_obj_file = change_ext(dst_s_file, '.o')
    dst_lst_file = change_ext(dst_s_file, '.lst')
    cmoc_asm_args = ['../../tools/cmoc-asm', '-fobj', '--pragma=forwardrefmax',
      '-I', '../../engine', '-I', '../../build/asm',
      f'--output={dst_obj_file}',
      f'--list={dst_lst_file}',
      dst_asm_file]
    for define in args.define or []:
        cmoc_asm_args.append(f'--define={define}')
    retval = subprocess.call(cmoc_asm_args)
    if retval:
        sys.exit(retval)

    # Now link. cmoc strips the object directory passed to the linker so
    # trickery here with cwd
    cwd = os.getcwd()
    os.chdir(os.path.dirname(dst_obj_file))
    cmoc_link_args = ['cmoc', '--intermediate',
      '--org=0x{}'.format('6000' if args.file_type=='level' else '0'),
      '--lwlink=../../tools/cmoc-link', os.path.basename(dst_obj_file)]
    retval = subprocess.call(cmoc_link_args)
    os.chdir(cwd)
    if retval:
        sys.exit(retval)


if __name__ == "__main__":
    main(sys.argv)

