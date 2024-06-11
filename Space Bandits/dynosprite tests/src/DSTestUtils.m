//
//  DSTestUtils.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 5/2/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "UIImage+Misc.h"
#import "DSNSDataMD5Extensions.h"
#import "DSTestUtils.h"

@implementation DSTestUtils

/**
 * Returns YES IFF color1 is the same as color2 in rgb space.
 */
+ (BOOL)color:(UIColor *)color1 isSameAs:(UIColor *)color2 {
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGColorRef cgcolor1 = color1.CGColor;
    CGColorRef cgcolor2 = color2.CGColor;
    CGColorRef cgcolor1p = CGColorCreateCopyByMatchingToColorSpace(rgb, kCGRenderingIntentDefault, cgcolor1, nil);
    CGColorRef cgcolor2p = CGColorCreateCopyByMatchingToColorSpace(rgb, kCGRenderingIntentDefault, cgcolor2, nil);
    UIColor *color1p = [UIColor colorWithCGColor:cgcolor1p];
    UIColor *color2p = [UIColor colorWithCGColor:cgcolor2p];
    CGColorRelease(cgcolor2p);
    CGColorRelease(cgcolor1p);
    CGColorSpaceRelease(rgb);
    return [color1p isEqual:color2p];
}

/**
 * Converts UIImage equivalent to cgImage.
 */
+ (UIImage *)convertToUIImage:(CGImageRef)cgImage {
    return [[UIImage alloc] initWithCGImage:cgImage];
}

/**
 * Returns YES IFF image1 renders identically to image2 as an 8*3 BitmapImageRep.
 */
+ (BOOL)image:(UIImage *)image1 isSameAsImage:(UIImage *)image2 {
    UIImage *image1p = image1.rgbImageWithAlpha;
    UIImage *image2p = image2.rgbImageWithAlpha;
    NSData *png1 = UIImagePNGRepresentation(image1p);
    NSData *png2 = UIImagePNGRepresentation(image2p);
    return [png1.SHA256 isEqualToString:png2.SHA256];
}

@end
