#!/usr/bin/env python

import argparse
from os import path 

from wand.color import Color
from wand.drawing import Drawing
from wand.image import Image

import coco
import wand_util


def load_images(image_paths):
  """
  Loads Images from image_paths and returns the corresponding list of Images.
  :param image_paths: list of image paths
  :return: list of Images corresponding to image_paths
  """
  return [
      Image(filename=path) for path in image_paths
  ]


def create_image_from_images(images):
  """
  Creates a single image from the list of Images.
  :param images: list of Images
  :return: A single Image that has all Images
  """
  max_height = max(image.size[1] for image in images)
  width = sum(image.size[0] for image in images)
  img = Image(width=width, height=max_height, background=Color('#fe00fe'))
  with Drawing() as draw:
    xx = 0
    for image in images:
      draw.composite('atop', xx, 0, image.size[0], image.size[1], image)
      xx += image.size[0]
    draw(img)
  return img


image_paths = [
    '/Users/jcho/Desktop/balloons_twitter_art_design_wallpaper_backgorund_background_tweet-1331px.png',
    '/Users/jcho/Desktop/Blender3D_Lisc_lipy-Transparent.png',
]
cmp = False
dither_remap_mode = 2

images = load_images(image_paths)
main_image = create_image_from_images(images)
main_image.save(filename='/Users/jcho/Desktop/foo.png')
wand_util.remap_colors(main_image, coco.create_color_map_image(cmp=cmp, alpha=True), dither=dither_remap_mode)
main_image.save(filename='/Users/jcho/Desktop/foo_reduced.png')

