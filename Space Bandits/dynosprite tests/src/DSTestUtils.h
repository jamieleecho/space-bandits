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

+ (BOOL)color:(UIColor *)color1 isSameAs:(UIColor *)color2;
+ (UIImage *)convertToUIImage:(CGImageRef)cgImage;
+ (BOOL)image:(UIImage *)image1 isSameAsImage:(UIImage *)image2;

@end

NS_ASSUME_NONNULL_END
