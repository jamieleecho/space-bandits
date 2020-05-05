//
//  DSTestUtils.h
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 5/2/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSTestUtils : NSObject

+ (BOOL)color:(NSColor *)color1 isSameAs:(NSColor *)color2;
+ (NSImage *)convertToNSImage:(CGImageRef)cgImage;
+ (NSImage *)convertToNSImage:(CGImageRef)cgImage withSize:(NSSize)size;
+ (NSBitmapImageRep *)convertTo8x4ImageRep:(NSImage *)nsImage;
+ (BOOL)image:(NSImage *)image1 isSameAsImage:(NSImage *)image2;

@end

NS_ASSUME_NONNULL_END
