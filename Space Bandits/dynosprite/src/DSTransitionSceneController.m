//
//  DSImageController.m
//  dynosprite
//
//  Created by Jamie Cho on 1/27/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSTransitionSceneController.h"
#import "DSInitScene.h"
#import "DSTransitionScene.h"


@implementation DSTransitionSceneController

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

- (id)init {
    return [self initWithImageDictionaries:@[]];
}

- (id)initWithImageDictionaries:(NSArray *)images {
    if (self = [super init]) {
        self.images = images;
    }
    return self;
}

- (DSTransitionScene *)transitionSceneForLevel:(int)level {
    if (level < 0) {
        return nil;
    }
    DSTransitionScene *transitionScene = (level == 0) ? [[DSInitScene alloc] init] : [[DSTransitionScene alloc] init];
    transitionScene.resourceController = self.resourceController;
    transitionScene.joystickController = self.joystickController;
    transitionScene.backgroundColor = [DSTransitionSceneController colorFromRGBString:self.images[level][@"BackgroundColor"]];
    transitionScene.foregroundColor = [DSTransitionSceneController colorFromRGBString:self.images[level][@"ForegroundColor"]];
    transitionScene.progressBarColor = [DSTransitionSceneController colorFromRGBString:self.images[level][@"ProgressColor"]];
    return transitionScene;
}

@end
