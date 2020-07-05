//
//  DSImageUtil.mm
//  Space Bandits
//
//  Created by Jamie Cho on 6/23/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSImageUtil.h"
#import <algorithm>
#import <deque>
#import <vector>


static CGContextRef CreateARGBBitmapContext (CGImageRef inImage);
DSImageUtilARGB8 DSImageUtilARGB8::transparentColor = DSImageUtilARGB8(0, 0, 0, 0);

/**
 * Implementation borrowed from: https://developer.apple.com/library/archive/qa/qa1509/_index.html
 * @param inImage image data to process
 * @return an ImageInfo structure that contains a pointer to the image data specified in inImage in ARGB 8-bit format. imageData
 *         will be NULL if a failure occurred. If non-null imageData must be freed via free();
 */
extern "C" DSImageUtilImageInfo DSImageUtilGetImagePixelData(CGImageRef inImage) {
    DSImageUtilImageInfo imageInfo = { NULL, 0, 0 };

    // Create the bitmap context
    CGContextRef cgctx = CreateARGBBitmapContext(inImage);
    if (cgctx == NULL)
    {
        // error creating context
        return imageInfo;
    }

     // Get image width, height. We'll use the entire image.
    imageInfo.width = CGImageGetWidth(inImage);
    imageInfo.height = CGImageGetHeight(inImage);
    CGRect rect = {{0, 0}, {(CGFloat)imageInfo.width, (CGFloat)imageInfo.height}};

    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);

    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    imageInfo.imageData = (DSImageUtilARGB8 *)CGBitmapContextGetData(cgctx);

    // When finished, release the context
    CGContextRelease(cgctx);

    return imageInfo;
}

extern "C" CGImageRef DSImageUtilMakeCGImage(DSImageUtilImageInfo imageInfo) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGContextRef bitmapContext = CGBitmapContextCreate(
                                                       imageInfo.imageData,
                                                       imageInfo.width,
                                                       imageInfo.height,
                                                       8, // bitsPerComponent
                                                       4 * imageInfo.width, // bytesPerRow
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedFirst);

    CFRelease(colorSpace);
    CGImageRef image = CGBitmapContextCreateImage(bitmapContext);
    CFRelease(bitmapContext);
    return image;
}

/**
* Implementation borrowed from: https://developer.apple.com/library/archive/qa/qa1509/_index.html
*/
static CGContextRef CreateARGBBitmapContext(CGImageRef inImage) {
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    unsigned long   bitmapByteCount;
    unsigned long   bitmapBytesPerRow;

     // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);

    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);

    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    if (colorSpace == NULL)
    {
        NSLog(@"Error allocating color space\n");
        return NULL;
    }

    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        NSLog(@"Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }

    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                    pixelsWide,
                                    pixelsHigh,
                                    8,      // bits per component
                                    bitmapBytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        NSLog(@"Context not created!");
    }

    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );

    return context;
}

/**
 * Replaces all instances of inColor found in imageInfo to outColor.
 * @param imageInfo image to find and replace colors
 * @param inColor color to find
 * @param outColor color to replace found colors with
 */
extern "C" void DSImageUtilReplaceColor(DSImageUtilImageInfo imageInfo, DSImageUtilARGB8 inColor, DSImageUtilARGB8 outColor) {
    std::transform(imageInfo.imageData, imageInfo.imageData + (imageInfo.width * imageInfo.height), imageInfo.imageData, [inColor, outColor](DSImageUtilARGB8 p) mutable
    {
        return (p == inColor) ? outColor : p;
    });
}

typedef enum FindSpriteDir {
  FindSpriteDirUp = 1,
  FindSpriteDirRight,
  FindSpriteDirDown,
  FindSpriteDirLeft,
  FindSpriteDirStop
} FindSpriteDir;

const static size_t DSImageUtilFindSpritePixelsMaxSteps = 40;

static void nonRecursivePaint(DSImageWrapper<DSImageUtilARGB8> &image, NSPoint p, std::vector<NSPoint> &pixCoordColorList);


/**
 * Uses a flood fill algorithm to find the location of a sprite in imageInfo.
 *  @param imageInfo image to look for the sprite
 *  @param name of the sprite for diagnostic purposes only
 *  @param point to start looking for the sprite which then becomes the hitpoint of the sprite.
 */
extern "C" NSRect DSImageUtilFindSpritePixels(DSImageUtilImageInfo imageInfo, NSString *name, NSPoint point) {
    DSImageWrapper<DSImageUtilARGB8> image(imageInfo.imageData, imageInfo.width, imageInfo.height);
    
    size_t x = point.x;
    size_t y = point.y;
    FindSpriteDir dir = FindSpriteDirUp;
    
    // start by searching around the starting point in a spiral pattern until we find a non-transparent pixel
    // direction is up, right, down, left
    size_t totalSteps = 1;
    size_t curSteps = 0;
    while (totalSteps < DSImageUtilFindSpritePixelsMaxSteps) {
        // test for opaque pixel
        if ((x >= 0) && (y >= 0) && (x < image.width()) && (y < image.height()) && !image(x, y).isTransparent()) {
            break;
        }

        // take a step
        if (dir == FindSpriteDirUp) {
            y -= 1;
        } else if (dir == FindSpriteDirRight) {
            x += 1;
        } else if (dir == FindSpriteDirDown) {
            y += 1;
        } else if (dir == FindSpriteDirLeft) {
            x -= 1;
        }

        // advance state
        curSteps += 1;
        if (curSteps == totalSteps) {
            curSteps = 0;
            dir = (FindSpriteDir)((dir + 1) % 4);
            if ((dir == 0) || (dir == 2)) {
                totalSteps += 1;
            }
         }
    }

    NSCAssert(totalSteps <= 40, @"****Error: sprite %@ not found within 20 pixels of location (%lf, %lf)", name, point.x, point.y);

    // now we apply a painting algoritm to produce a list of all of the touching non-transparent pixels
    std::vector<NSPoint> pixCoordColorList;
    nonRecursivePaint(image, NSMakePoint(x, y), pixCoordColorList);
    
    // get lists of all X coordinates and Y coordinates, then calculate width and height of sprite matrix
    std::vector<CGFloat> xCoords(pixCoordColorList.size());
    std::transform(pixCoordColorList.begin(), pixCoordColorList.end(), xCoords.begin(), [](NSPoint p)
    {
        return p.x;
    });
    std::vector<CGFloat> yCoords(pixCoordColorList.size());
    std::transform(pixCoordColorList.begin(), pixCoordColorList.end(), yCoords.begin(), [](NSPoint p)
    {
        return p.y;
    });
    CGFloat minX = *std::min_element(xCoords.begin(), xCoords.end());
    CGFloat minY = *std::min_element(yCoords.begin(), yCoords.end());
    CGFloat matrixWidth = *std::max_element(xCoords.begin(), xCoords.end()) - minX + 1;
    CGFloat matrixHeight = *std::max_element(yCoords.begin(), yCoords.end()) - minY + 1;

    return NSMakeRect(minX, minY, matrixWidth, matrixHeight);
}


/**
* Uses a flood fill algorithm to find the location of a sprite in image, replacing found non transparent pixels with transparent ones.
*  @param image image to start with
*  @param p point to start the flood fill
*  @param pixCoordColorList list of found points
*/
static void nonRecursivePaint(DSImageWrapper<DSImageUtilARGB8> &image, NSPoint p, std::vector<NSPoint> &pixCoordColorList) {

    std::deque<NSPoint> hitlist;
    hitlist.push_back(p);
    while(hitlist.size()) {
        // get coordinates of pixel to examine
        NSPoint p0 = hitlist.back();
        hitlist.pop_back();

        // return if coordinates are outside image boundary
        if ((p0.x < 0) || (p0.y < 0) || (p0.x >= image.width()) || (p0.y >= image.height())) {
            continue;
        }
        
        // return if pixel at current coordinate is transparent
        if (image(p0.x, p0.y).isTransparent()) {
            continue;
        }

        // we have a non-transparent pixel, so record the color and coordinate
        pixCoordColorList.push_back(p0);

        // then make this pixel transparent to avoid processing it again
        image(p0.x, p0.y) = DSImageUtilARGB8::transparentColor;
        hitlist.push_back(NSMakePoint(p0.x-1, p0.y));
        hitlist.push_back(NSMakePoint(p0.x-1, p0.y+1));
        hitlist.push_back(NSMakePoint(p0.x, p0.y+1));
        hitlist.push_back(NSMakePoint(p0.x+1, p0.y+1));
        hitlist.push_back(NSMakePoint(p0.x+1, p0.y));
        hitlist.push_back(NSMakePoint(p0.x+1, p0.y-1));
        hitlist.push_back(NSMakePoint(p0.x, p0.y-1));
        hitlist.push_back(NSMakePoint(p0.x-1, p0.y-1));
    }
}
