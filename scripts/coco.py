import math

from wand.color import Color
from wand.drawing import Drawing
from wand.image import Image


def __GetCompositeColor(palidx):
    if palidx == 0:
        r = g = b = 0
    elif palidx == 16:
        r = g = b = 47
    elif palidx == 32:
        r = g = b = 120
    elif palidx == 48 or palidx == 63:
        r = g = b = 255
    else:
        w = 0.4195456981879 * 1.01
        contrast = 70
        saturation = 92
        brightness = -50
        brightness += ((palidx // 16) + 1) * contrast
        offset = (palidx % 16) - 1 + (palidx // 16) * 15
        r = math.cos(w * (offset + 9.2)) * saturation + brightness
        g = math.cos(w * (offset + 14.2)) * saturation + brightness
        b = math.cos(w * (offset + 19.2)) * saturation + brightness
        if r < 0:
            r = 0
        elif r > 255:
            r = 255
        if g < 0:
            g = 0
        elif g > 255:
            g = 255
        if b < 0:
            b = 0
        elif b > 255:
            b = 255
    return (r, g, b)


# Maps Color Computer 3 RGB palette value to corresponding CMP palette value
COCO_RGB_TO_CMP = [
    0,
    13,
    4,
    14,
    8,
    9,
    4,
    16,
    11,
    27,
    13,
    27,
    10,
    27,
    13,
    27,
    2,
    2,
    34,
    34,
    2,
    2,
    34,
    34,
    30,
    44,
    33,
    62,
    30,
    44,
    33,
    62,
    7,
    8,
    5,
    8,
    22,
    38,
    38,
    38,
    25,
    26,
    25,
    42,
    39,
    41,
    39,
    41,
    20,
    20,
    34,
    34,
    37,
    37,
    52,
    52,
    32,
    43,
    33,
    62,
    38,
    57,
    52,
    48,
]

# Maps Color Computer 3 CMP palette value to corresponding RGB palette value
COCO_CMP_TO_RGB = [
    0,
    16,
    16,
    16,
    6,
    34,
    32,
    32,
    33,
    5,
    12,
    8,
    8,
    10,
    3,
    17,
    7,
    26,
    19,
    20,
    48,
    34,
    36,
    35,
    42,
    40,
    12,
    9,
    10,
    25,
    24,
    21,
    56,
    58,
    51,
    50,
    62,
    52,
    60,
    46,
    45,
    45,
    43,
    57,
    29,
    59,
    27,
    26,
    63,
    58,
    62,
    62,
    62,
    62,
    60,
    61,
    61,
    61,
    61,
    57,
    59,
    59,
    59,
    63,
]


def _rgb_val(c1: int, c0: int) -> int:
    """
    Given the lsb and msb of a coco 3 color element, returns the corresponding
    RGB value.
    """
    return ((2 * c1) + c0) * 85


# Color Computer 3 RGB colors - assumed to map directly to modern standards
COCO_RGB_RGB8_COLORS = [
    (_rgb_val(r1, r0), _rgb_val(g1, g0), _rgb_val(b1, b0))
    for r1 in range(2)
        for g1 in range(2)
            for b1 in range(2)
                for r0 in range(2)
                    for g0 in range(2)
                        for b0 in range(2)
]


# Color Computer 3 CMP colors
COCO_CMP_RGB8_COLORS = [__GetCompositeColor(ii) for ii in range(0, 64)]

# Maps RGB8 colors to Color Computer 3 RGB colors
RGB8_TO_COCO_RGB_COLORS = {
    COCO_RGB_RGB8_COLORS[ii]: ii for ii in range(0, len(COCO_RGB_RGB8_COLORS))
}

# Maps RGB8 colors to Color Computer 3 CMP colors
RGB8_TO_COCO_CMP_COLORS = {
    COCO_CMP_RGB8_COLORS[ii]: ii for ii in range(0, len(COCO_CMP_RGB8_COLORS))
}


# Color used for transparency
COCO_TRANSPARENT_COLOR = (255, 0, 255)


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
            draw.fill_color = Color("#{:02x}{:02x}{:02x}".format(*color))
            draw.point(ii, 0)
        if alpha:
            draw.fill_color = Color(
                "#{:02x}{:02x}{:02x}".format(*COCO_TRANSPARENT_COLOR)
            )
            draw.point(len(colors), 0)
        draw(image)
    return image
