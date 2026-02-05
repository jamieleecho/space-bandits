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
        self.backgroundColor = UIColor.whiteColor;
        self.foregroundColor = UIColor.blackColor;
        self.progressColor = UIColor.greenColor;
        self.backgroundImageName = @"";
    }
    return self;
}

@end
