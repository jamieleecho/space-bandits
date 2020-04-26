//
//  DSImageController.m
//  dynosprite
//
//  Created by Jamie Cho on 1/27/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSInitScene.h"
#import "DSTransitionScene.h"
#import "DSTransitionSceneController.h"
#import "DSTransitionSceneInfoFileParser.h"


@implementation DSTransitionSceneController

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
    transitionScene.backgroundColor = [DSTransitionSceneInfoFileParser colorFromRGBString:self.images[level][@"BackgroundColor"]];
    transitionScene.foregroundColor = [DSTransitionSceneInfoFileParser colorFromRGBString:self.images[level][@"ForegroundColor"]];
    transitionScene.progressBarColor = [DSTransitionSceneInfoFileParser colorFromRGBString:self.images[level][@"ProgressColor"]];
    return transitionScene;
}

@end
