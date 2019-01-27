//
//  DSImageController.m
//  Space Bandits
//
//  Created by Jamie Cho on 1/27/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSImageController.h"
#import "DSTransitionScene.h"


@implementation DSImageController

+ (NSColor *)colorFromRGBString:(NSString *)color {
    NSError *err;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"^[0-9a-f]{6}$" options:NSRegularExpressionCaseInsensitive error:&err];
    NSAssert(err == nil, @"Failed to create NSRegularExpression.");
    NSArray *matches = [regex matchesInString:color options:0 range:NSMakeRange(0, color.length)];
    if (matches.count < 1) {
        @throw [NSException exceptionWithName:@"Failed to parse color" reason:@"invalid hex" userInfo:nil];
    }
    NSScanner *scanner = [NSScanner scannerWithString:color];
    unsigned int rgb, r, g, b;
    [scanner scanHexInt:&rgb];
    r = rgb >> 16;
    g = (rgb >> 8) & 0xff;
    b = rgb & 0xff;
    return [NSColor colorWithCalibratedRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
}

- (id)initWithImageDictionaries:(NSArray *)images {
    if (self = [super init]) {
        _images = images;
    }
    return self;
}

- (DSTransitionScene *)transitionSceneForLevel:(int)level {
    DSTransitionScene *transitionScene = [[DSTransitionScene alloc] init];
    transitionScene.backgroundColor = [DSImageController colorFromRGBString:_images[level][@"BackgroundColor"]];
    transitionScene.foregroundColor = [DSImageController colorFromRGBString:_images[level][@"ForegroundColor"]];
    transitionScene.progressBarColor = [DSImageController colorFromRGBString:_images[level][@"ProgressColor"]];
    return transitionScene;
}

@end
