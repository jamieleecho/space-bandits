from wand.color import Color
from wand.drawing import Drawing
from wand.image import Image


# Color Computer 3 Color Palette data derived from work by John Kowalski,
# Erik Gavriluk and Jamie Cho

# Maps Color Computer 3 RGB palette value to corresponding CMP palette value
COCO_RGB_TO_CMP = [0, 13, 4, 14, 8, 9, 4, 16, 11, 27, 13, 27, 10, 27, 13, 27, 2, 2,
  34, 34, 2, 2, 34, 34, 30, 44, 33, 62, 30, 44, 33, 62, 7, 8, 5, 8, 22, 38, 38,
  38, 25, 26, 25, 42, 39, 41, 39, 41, 20, 20, 34, 34, 37, 37, 52, 52, 32, 43,
  33, 62, 38, 57, 52, 48]

# Maps Color Computer 3 CMP palette value to corresponding RGB palette value
COCO_CMP_TO_RGB = [0, 16, 16, 16, 6, 34, 32, 32, 33, 5, 12, 8, 8, 10, 3, 17, 7, 26,
  19, 20, 48, 34, 36, 35, 42, 40, 12, 9, 10, 25, 24, 21, 56, 58, 51, 50, 62,
  52, 60, 46, 45, 45, 43, 57, 29, 59, 27, 26, 63, 58, 62, 62, 62, 62, 60, 61,
  61, 61, 61, 57, 59, 59, 59, 63]

# Color Computer 3 RGB colors
COCO_RGB_RGB8_COLORS = [
    (0, 0, 0), (0, 0, 47), (0, 47, 0), (0, 47, 47), (47, 0, 0), (47, 0, 47),
    (47, 47, 0), (47, 47, 47), (0, 0, 120), (0, 0, 255), (0, 47, 120),
    (0, 47, 255), (47, 0, 120), (47, 0, 255), (47, 47, 120), (47, 47, 255),
    (0, 120, 0), (0, 120, 47), (0, 255, 0), (0, 255, 47), (47, 120, 0),
    (47, 120, 47), (47, 255, 0), (47, 255, 47), (0, 120, 120), (0, 120, 255),
    (0, 255, 120), (0, 255, 255), (47, 120, 120), (47, 120, 255), (47, 255, 120),
    (47, 255, 255), (120, 0, 0), (120, 0, 47), (120, 47, 0), (120, 47, 47),
    (255, 0, 0), (255, 0, 47), (255, 47, 0), (255, 47, 47), (120, 0, 120),
    (120, 0, 255), (120, 47, 120), (120, 47, 255), (255, 0, 120), (255, 0, 255),
    (255, 47, 120), (255, 47, 255), (120, 120, 0), (120, 120, 47), (120, 255, 0),
    (120, 255, 47), (255, 120, 0), (255, 120, 47), (255, 255, 0), (255, 255, 47),
    (120, 120, 120), (120, 120, 255), (120, 255, 120), (120, 255, 255),
    (255, 120, 120), (255, 120, 255), (255, 255, 120), (255, 255, 255),
]

# Color Computer 3 CMP colors
COCO_CMP_RGB8_COLORS = [
    (0, 0, 0), (0, 108, 0), (0, 110, 0), (23, 96, 0), (60, 69, 0),
    (90, 33, 0), (108, 0, 0), (110, 0, 0), (96, 0, 29), (69, 0, 66),
    (33, 0, 95), (0, 0, 110), (0, 0, 109), (0, 29, 92), (0, 66, 63),
    (0, 95, 26), (47, 47, 47), (27, 180, 58), (61, 179, 25), (99, 162, 4),
    (136, 133, 0), (165, 96, 8), (180, 58, 33), (179, 25, 67), (162, 4, 106),
    (133, 0, 142), (96, 8, 168), (58, 33, 181), (25, 67, 177), (4, 106, 158),
    (0, 142, 127), (8, 168, 89), (120, 120, 120), (103, 251, 121),
    (137, 247, 90), (176, 228, 71), (212, 197, 68), (238, 159, 81),
    (251, 121, 108), (247, 90, 144), (228, 71, 182), (197, 68, 217),
    (159, 81, 241), (121, 108, 251), (90, 144, 245), (71, 182, 224),
    (68, 217, 191), (81, 241, 152), (255, 255, 255), (178, 255, 185),
    (214, 255, 156), (252, 255, 140), (255, 255, 139), (255, 222, 155),
    (255, 185, 184), (255, 156, 220), (255, 140, 255), (255, 139, 255),
    (222, 155, 255), (185, 184, 255), (156, 220, 255), (140, 255, 255),
    (139, 255, 254), (255, 255, 255),
]

# Maps RGB8 colors to Color Computer 3 RGB colors
RGB8_TO_COCO_RGB_COLORS = {
    COCO_RGB_RGB8_COLORS[ii]: ii for ii in xrange(0, len(COCO_RGB_RGB8_COLORS))
}

# Maps RGB8 colors to Color Computer 3 CMP colors
RGB8_TO_COCO_CMP_COLORS = {
    COCO_CMP_RGB8_COLORS[ii]: ii for ii in xrange(0, len(COCO_CMP_RGB8_COLORS))
}


# Color used for transparency
COCO_TRANSPARENT_COLOR = (254, 0, 254)


def create_color_map_image(cmp=False, alpha=False):
  """
  Creates an Image that contains the entire Color Computer 3 palette.
  :param cmp: if False, generate an RGB color map. Otherwise generate a CMP
              color map.
  :param alpha: whether or not to include the transparent color
  """
  colors = COCO_CMP_RGB8_COLORS if cmp else COCO_RGB_RGB8_COLORS
  image = Image(
      width=len(colors) + (1 if alpha else 0),
      height=1,
  )
  with Drawing() as draw:
    for ii, color in enumerate(colors):
      draw.fill_color = Color('#{:02x}{:02x}{:02x}'.format(*color))
      draw.point(ii, 0)
    if alpha:
      draw.fill_color = Color('#{:02x}{:02x}{:02x}'.format(*COCO_TRANSPARENT_COLOR))
      draw.point(len(color), 0)
    draw(image)
  return image


