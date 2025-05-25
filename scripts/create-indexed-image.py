#!/usr/bin/env python3

import click
from pathlib import Path
from PIL import Image


@click.command()
@click.argument("infile", type=click.Path(exists=True, dir_okay=False))
@click.argument("outfile", type=click.Path(dir_okay=False))
@click.option("--num-colors", default=17, help="Number of colors in the indexed image.")
def create_indexed_image(infile: Path, outfile: Path, num_colors: int) -> None:
    """
    Convert an image to an indexed format with a limited number of colors.

    Args:
        infile (Path): Path to the input image file.
        outfile (Path): Path to save the output indexed image.
        num_colors (int): Number of colors in the indexed image.
    """
    # Open the input image
    with Image.open(infile) as img:
        palette = list(set(img.getdata()))
        palette_image = Image.new("P", (1, 1))
        palette_image.putpalette([c for color in palette for c in color])
        img = img.quantize(colors=len(palette), palette=palette_image)
        img.save(outfile, format="PNG")


if __name__ == "__main__":
    create_indexed_image()
