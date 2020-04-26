//
//  DSTransitionSceneInfo.m
//  Space Bandits
//
//  Created by Jamie Cho on 4/25/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSTransitionSceneInfo.h"

@implementation DSTransitionSceneInfo

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = NSColor.whiteColor;
        self.foregroundColor = NSColor.blackColor;
        self.progressColor = NSColor.greenColor;
        self.backgroundImageName = @"";
    }
    return self;
}

@end
