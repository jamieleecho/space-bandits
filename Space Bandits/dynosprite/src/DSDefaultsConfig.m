//
//  DSDefaultsConfig.m
//  Space Bandits
//
//  Created by Jamie Cho on 9/11/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//

#import "DSDefaultsConfig.h"

@implementation DSDefaultsConfig

- (id)init {
    if (self = [super init]) {
        self.firstLevel = 1;
        self.useKeyboard = YES;
        self.enableSound = YES;
    }
    return self;
}

@end
