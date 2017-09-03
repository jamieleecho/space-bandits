#!/usr/bin/env python

import argparse
from coco import create_color_map_image


# Setup parser
parser = argparse.ArgumentParser(description='Creates an image with a Color Computer color map')
parser.add_argument('path', metavar='PATH', type=str, help='path to output file')
parser.add_argument('--cmp', action='store_true', default=False, help='Output cmp map')
parser.add_argument('--alpha', action='store_true', default=False, help='Output alpha')

# Parse the args and execute
args = parser.parse_args()
image = create_color_map_image(cmp=args.cmp, alpha=args.alpha)
image.save(filename=args.path)






