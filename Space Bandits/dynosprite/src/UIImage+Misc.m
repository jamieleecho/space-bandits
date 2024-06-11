//
//  UIImage+Misc.m
//  Space Bandits
//
//  Created by Jamie Cho on 5/27/24.
//

#import "UIImage+Misc.h"
#import <CoreImage/CoreImage.h>

@implementation UIImage (Misc)

- (UIImage *)rgbImageWithAlpha {
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(Nil, self.size.width, self.size.height, 8, 0, rgb, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    CGImageRef cgimage0 = CGBitmapContextCreateImage(context);
    UIImage *image0 = [UIImage imageWithCGImage:cgimage0];
    CGImageRelease(cgimage0);
    CGContextRelease(context);
    CGColorSpaceRelease(rgb);
    return image0;
}

@end
