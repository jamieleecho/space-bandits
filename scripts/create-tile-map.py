#!/usr/bin/env python
import argparse
from os import path

from wand.drawing import Drawing
from wand.image import Image

import coco
import wand_util


def tile_image(image, width=16, height=16, image_size=None):
  """
  Returns a double array of image tiles where each tile is sized width and
  height. Extra space at the right and bottom of image is ignored.
  :param image: Wand Image to tile
  :param width: width in pixels of Wand Image tiles
  :param width: height in pixels of Wand Image tiles
  :return: double array of image tiles
  """
  image_size = image.size
  image_size_tiles = (image_size[0] / width, image_size[1] / height)
  if image_size_tiles[0] == 0 or image_size_tiles[1] == 0:
    raise Exception('Image too small')
  tiles = [[None] * image_size_tiles[1] for xx in range(0, image_size_tiles[0])]
  for xx in xrange(0, image_size_tiles[0]):
    start_x = xx * width
    end_x = start_x + width
    for yy in xrange(0, image_size_tiles[1]):
      start_y = yy * height
      end_y = start_y + height
      tiles[xx][yy] = image[start_x:end_x, start_y:end_y]
  return tiles


def reduce_tiles(tiles, threshold=0.01):
  """
  Reduces the number of unique tile objects in tiles by reusing images that are similar.
  :param tiles: images returned by tile_image
  :return: tiles modified with a reduced number of unique tiles
  """
  for xx1 in xrange(0, len(tiles)):
    for yy1 in xrange(0, len(tiles[0])):
      image1 = tiles[xx1][yy1]
      for xx2 in xrange(0, len(tiles)):
        for yy2 in xrange(0, len(tiles[0])):
          image2 = tiles[xx2][yy2]
          if image1.compare(image2, metric='root_mean_square')[1] <= threshold:
            tiles[xx2][yy2] = image1
  return tiles


def rebuild_image(tiles):
  """
  Rebuilds the image from the tiles.
  :param tiles: images returned by tile_image
  :return: Image rebuilt from tiles
  """
  width = tiles[0][0].size[0]
  height = tiles[0][0].size[1]
  image = Image(
      width=len(tiles) * width,
      height=len(tiles[0]) * height,
  )
  with Drawing() as draw:
    for xx in xrange(0, len(tiles)):
      start_x = xx * width
      for yy in xrange(0, len(tiles[0])):
        start_y = yy * height
        draw.composite('copy', start_x, start_y, width, height, tiles[xx][yy])
    draw(image)
  return image


def tile_set(tiles):
  """
  :param tiles: images returned by tile_image
  :return: set of unique tiles
  """
  return list(set(img for column in tiles for img in column))


def tile_color_map(tiles):
  """
  :param tiles: images returned by tile_image
  :return: map that maps a color to its corresponding unique colors found in tiles.
  """
  color_set = set()
  for img in tile_set(tiles):
    for yy in xrange(0, img.size[1]):
      for xx in xrange(0, img.size[0]):
        color_set.add(img[xx, yy])
  return {
      ii: (color.red_int8, color.green_int8, color.blue_int8)
        for ii, color in enumerate(color_set)
  }


def create_tile_and_tile_map_files(tiles, tile_file_path, tile_image, image_path,
                                   tile_map_file_path=None, cmp=False, image_size=None):
  """
  Outputs the tile file.
  :param tiles: images returned by tile_image
  :param tile_file_path: location of new tile file
  :param tile_map_file_path: location of new tile map file
  :param cmp: whether or not tiles was created for CMP palette
  """
  # Get the RGB8 colors defined in tiles
  rgb8_color_map = tile_color_map(tiles)
  rev_rgb8_color_map = {
      v: k for k, v in rgb8_color_map.items()
  }
  if len(rgb8_color_map) > 16:
    raise Exception('Too many unique colors ({}) in tiles!'.format(len(rgb8_color_map)))

  # Convert the RGB8 colors to palette colors
  rgb8_to_palette = coco.RGB8_TO_COCO_CMP_COLORS if cmp else coco.RGB8_TO_COCO_RGB_COLORS
  pal_to_other_palette = coco.COCO_CMP_TO_RGB if cmp else coco.COCO_RGB_TO_CMP
  pal1 = [
      rgb8_to_palette[rgb8_color_map[ii]] for ii in xrange(0, len(rgb8_color_map))
  ] + [0] * (16 - len(rgb8_color_map))
  pal2 = [
      pal_to_other_palette[pal] for pal in pal1
  ]
  rgb_pal = pal2 if cmp else pal1
  cmp_pal = pal1 if cmp else pal2

  # Get the set of unique tiles
  tile_list = tile_set(tiles)
  tile_to_index = {
      tile: ii for ii, tile in enumerate(tile_list)
  }

  # Output the tile file
  with open(tile_file_path, 'wb') as tile_file:
    image_size = image_size or tile_image.size
    tile_file.write('Image = {}\n'.format(path.split(image_path)[1]))
    tile_file.write('TileSetStart = 0,0\n')
    tile_file.write('TileSetSize = {},{}\n'.format(image_size[0], image_size[1]))

  # Output the tile map file
  if tile_map_file_path:
    with open(tile_map_file_path, 'wb') as tile_map_file:
      tile_map_file.write('*' * 59 + '\n')
      tile_map_file.write('* {}\n'.format(path.basename(tile_map_file_path)))
      tile_map_file.write('*' * 59 + '\n')
      tile_map_file.write('* This file gives the tilemap for the level\n')
      tile_map_file.write('\n')
      for yy in xrange(0, len(tiles[0])):
        tile_row = [
            '{:02x}'.format(tile_to_index[tiles[xx][yy]]) for xx in xrange(0, len(tiles))
        ]
        tile_map_file.write(' '.join(tile_row) + '\n')


def output_palette(tile_file, pal, cmp=False):
  """
  Outputs the palette part of the tile file.
  :param tile_file: opened stream to which data is written
  :param pal: 16 element array containing CoCo palette values
  :param cmp: whether or not to output the CMP or RGB palette section
  """
  if cmp:
    tile_file.write('[Palette-CMP]\n')
  else:
    tile_file.write('[Palette-RGB]\n')
  tile_file.write('{} {} {} {}\n'.format(*pal[0:4]))
  tile_file.write('{} {} {} {}\n'.format(*pal[4:8]))
  tile_file.write('{} {} {} {}\n'.format(*pal[8:12]))
  tile_file.write('{} {} {} {}\n\n'.format(*pal[12:16]))


def output_tile(tile_file, img, rev_rgb8_color_map):
  """
  Outputs the tile to the tile file.
  :param tile_file: opened stream to which data is written
  :param img: 16x16 tile to output
  :param rev_rgb8_color_map: color map to use to output data
  """
  for yy in xrange(0, img.size[1]):
    row = extract_row(img, yy, rev_rgb8_color_map)
    hex_line = convert_to_hex_line(row)
    tile_file.write('{}'.format(hex_line))
  tile_file.write('\n')


def extract_row(img, row, rev_rgb8_color_map):
  """
  Extracts a row from the image
  :param img: Tile image from which row will be extracted
  :param row: Integer row number to extract
  :param rev_rgb8_color_map: color map to use to output data
  """
  colors = [img[xx, row] for xx in xrange(0, img.size[0])]
  rgb8 = [
      (color.red_int8, color.green_int8, color.blue_int8)
        for color in colors
  ]
  pal_slots = [
      rev_rgb8_color_map[rgb8_color] for rgb8_color in rgb8
  ]
  return pal_slots


def convert_to_hex(val):
  """
  Returns a hex representation of val.
  :param val: a list containing 2 ints on [0, 15]
  :return: str hex representation of val[0:2]
  """
  return '{:02x}'.format(val[0] * 16 + val[1])


def convert_to_hex_line(val):
  """
  Returns a line of hex characters representing val[0:16]
  :param val: a list containing 16 ints on [0, 15]
  :return: str hex representation of val[0:16]
  """
  return "{} {} {} {} {} {} {} {}\n".format(
      convert_to_hex(val[0:2]),
      convert_to_hex(val[2:4]),
      convert_to_hex(val[4:6]),
      convert_to_hex(val[6:8]),
      convert_to_hex(val[8:10]),
      convert_to_hex(val[10:12]),
      convert_to_hex(val[12:14]),
      convert_to_hex(val[14:16]),
  )


# Define Argument parser
parser = argparse.ArgumentParser(description='Create tile and tile map files from an image')
parser.add_argument('image_path', type=str, help='Path to image used to create tile and tile map')
parser.add_argument('tile_file_path', type=str, help='Path to output tile file')
parser.add_argument('--threshold', type=float, default=0.05, help='Threshold to use for comparing tiles')
parser.add_argument('--num-colors', type=int, default=16, help='Maximum number of colors to use')
parser.add_argument('--dither-reduce-mode', type=int, default=0, help='Dither mode to use when reducing colors')
parser.add_argument('--dither-remap-mode', type=int, default=1, help='Dither mode to use when remapping colors')
parser.add_argument('--cmp', default=False, action='store_true', help='Optimize for CMP palette')
parser.add_argument('--width', default=None, type=int, help='Width to tile in pixels')
parser.add_argument('--height', default=None, type=int, help='Height to tile in pixels')
args = parser.parse_args()

# Perform the real work
with Image(filename=args.image_path) as img:
  # Reduce the number of colors and tile the image
  wand_util.reduce_colors(img, 256, dither=args.dither_reduce_mode)
  wand_util.remap_colors(img, coco.create_color_map_image(cmp=args.cmp), dither=args.dither_remap_mode)
  wand_util.reduce_colors(img, args.num_colors, dither=args.dither_reduce_mode)
  wand_util.remap_colors(img, coco.create_color_map_image(cmp=args.cmp), dither=1)
  image_size = (args.width or img.size[0], args.height or img.size[1])
  tiles = tile_image(img, image_size=image_size)
  tiles = reduce_tiles(tiles, threshold=args.threshold)

  # Output the result image
  pre, ext = path.splitext(args.tile_file_path)
  new_image = rebuild_image(tiles)
  with new_image.convert('GIF') as new_converted_image:
    image_path = pre + '.gif'
    new_converted_image.save(filename=image_path)

    # Create the tile and tile map files
    create_tile_and_tile_map_files(tiles, args.tile_file_path, new_converted_image,
                                   image_path, cmp=args.cmp, image_size=image_size)


