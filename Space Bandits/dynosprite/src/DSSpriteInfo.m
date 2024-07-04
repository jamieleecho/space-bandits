//
//  DSSpriteInfo.m
//  Space Bandits
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSSpriteInfo.h"

@implementation DSSpriteInfo

- (id)init {
    if (self = [super init]) {
        self.name = @"";
        self.location = DSPointMake(0, 0);
        self.singlePixelPosition = NO;
        self.saveBackground = YES;
    }
    return self;
}

@end
