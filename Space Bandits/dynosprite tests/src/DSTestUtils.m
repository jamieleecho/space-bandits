//
//  DSTestUtils.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 5/2/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DSTestUtils.h"

@implementation DSTestUtils

+ (BOOL)color:(NSColor *)color1 isSameAs:(NSColor *)color2 {
    return [[color1 colorUsingColorSpace:NSColorSpace.sRGBColorSpace] isEqual:[color2 colorUsingColorSpace:NSColorSpace.sRGBColorSpace]];
}

/**
 * Converts NSImage equivalent to cgImage.
 */
+ (NSImage *)convertToNSImage:(CGImageRef)cgImage {
    NSSize imageSize = CGSizeMake(CGImageGetWidth(cgImage), CGImageGetHeight(cgImage));
    return [[NSImage alloc] initWithCGImage:cgImage size:imageSize];
}

/**
 * Converts NSImage equivalent to cgImage.
 */
+ (NSImage *)convertToNSImage:(CGImageRef)cgImage withSize:(NSSize)size {
    return [[NSImage alloc] initWithCGImage:cgImage size:size];
}

/**
 * Converts nsImage to an 8x4 Color NSBitmapImageRep.
 */
+ (NSBitmapImageRep *)convertTo8x4ImageRep:(NSImage *)nsImage {
    NSBitmapImageRep *nsImageRep = [[NSBitmapImageRep alloc]                                     initWithBitmapDataPlanes:NULL pixelsWide:nsImage.size.width pixelsHigh:nsImage.size.height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:nsImage.size.width * 4 bitsPerPixel:32];
    [NSGraphicsContext saveGraphicsState];
    NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep: nsImageRep];
    [NSGraphicsContext setCurrentContext: ctx];
    [nsImage drawInRect:NSMakeRect(0, 0, nsImage.size.width, nsImage.size.height)];
    [ctx flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    return nsImageRep;
}

/**
 * Returns YES IFF image1 renders identically to image2 as an 8*3 BitmapImageRep.
 */
+ (BOOL)image:(NSImage *)image1 isSameAsImage:(NSImage *)image2 {
    NSBitmapImageRep *imageRep1 = [DSTestUtils convertTo8x4ImageRep:image1];
    NSBitmapImageRep *imageRep2 = [DSTestUtils convertTo8x4ImageRep:image2];
    return [imageRep1.TIFFRepresentation isEqual:imageRep2.TIFFRepresentation];
}

@end
