//
//  DSImageUtil.m
//  Space Bandits
//
//  Created by Jamie Cho on 6/23/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSImageUtil.h"


static CGContextRef CreateARGBBitmapContext (CGImageRef inImage);


/**
 * Implementation borrowed from: https://developer.apple.com/library/archive/qa/qa1509/_index.html
 * @param inImage image data to process
 * @return an ImageInfo structure that contains a pointer to the image data specified in inImage in ARGB 8-bit format. imageData
 *         will be NULL if a failure occurred. If non-null imageData must be freed via free();
 */
DSImageUtilImageInfo DSImageUtilGetImagePixelData(CGImageRef inImage) {
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
    CGRect rect = {{0, 0}, {imageInfo.width, imageInfo.height}};

    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);

    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    imageInfo.imageData = CGBitmapContextGetData (cgctx);

    // When finished, release the context
    CGContextRelease(cgctx);

    return imageInfo;
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
