#!/usr/bin/env python3
#******************************************************************************
# DynoSprite - scripts/build-config.py
# Copyright (c) 2022, Jamie Cho
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
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#******************************************************************************

import click
import json


@click.command()
@click.argument('input_filename', type=click.Path(exists=True))
@click.argument('output_filename', type=click.Path(exists=False))
def build_config(input_filename, output_filename):
    """DynoSprites config.asm builder. Build config.asm from config.json """
    """specified by INPUT_FILENAME and output specified by OUTPUT_FILENAME"""
    with open(input_filename, 'r') as json_file:
        config_json = json.load(json_file)

    sound_modes = {
        'NoSound': 0,
        'Internal': 1,
        'Orc90': 2,
    }

    config_dict = {
        'FirstLevel': str(config_json['FirstLevel'] if 'FirstLevel'
                          in config_json else 1),
        'MonitorIsRGB': str(0 if (not ('MonitorIsRGB' in config_json) or
                                 (not config_json['MonitorIsRGB']))
                              else 1),
        'UseKeyboard': str(0 if (not ('UseKeyboard' in config_json) or
                                (not config_json['UseKeyboard']))
                              else 1),
        'SoundMode': str(1 if not ('SoundMode' in config_json)
                           else config_json['SoundMode'])
    }

    with open(output_filename, 'w') as asm_file:
        for key, value in config_dict.items():
            asm_file.write(f'{key}\tequ\t{value}\n')
    


if __name__ == "__main__":
    build_config()
