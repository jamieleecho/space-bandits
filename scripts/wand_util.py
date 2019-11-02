#!/usr/bin/env python3
import ctypes

from wand.api import library
from wand.image import Image


# Register C-type arguments
library.MagickQuantizeImage.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.c_int,
                                        ctypes.c_size_t, ctypes.c_int, ctypes.c_int]
library.MagickQuantizeImage.restype = None

library.MagickRemapImage.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_int]
library.MagickRemapImage.restype = None


def reduce_colors(img, color_count, dither=1):
  '''
  Reduce image color count
  From: http://stackoverflow.com/questions/22815215/quantize-using-wand/22840565#22840565
  '''
  assert isinstance(img, Image)
  assert isinstance(color_count, int)
  assert isinstance(dither, int)
  colorspace = 1 # assuming RGB?
  treedepth = 8
  merror = 0
  library.MagickQuantizeImage(img.wand, color_count, colorspace, treedepth, dither, merror)


def remap_colors(img, color_map_img, dither=1):
  '''
  Remaps the colors in img to the colors in color_map.
  :param img: image to modify
  :param color_map_img: image containing the colors to use
  '''
  assert isinstance(img, Image)
  assert isinstance(color_map_img, Image)
  assert isinstance(dither, int)
  library.MagickRemapImage(img.wand, color_map_img.wand, dither)

