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
        self.enableMusic = YES;
    }
    return self;
}

- (BOOL)isEqual:(id)obj {
    if (!obj || ![self isKindOfClass:[obj class]]) {
        return NO;
    }
    DSDefaultsConfig *config = obj;
    return (self.firstLevel == config.firstLevel) && (self.useKeyboard == config.useKeyboard) && (self.hiresMode == config.hiresMode) && (self.hifiMode == config.hifiMode) && (self.enableSound == config.enableSound) && (self.enableMusic == config.enableMusic);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"DSDefaultsConfig(firstLevel=%ld, useKeyboard=%d, hiresMode=%d, hifiMode=%d, enableSound=%d, enableMusic=%d)",
            (long)self.firstLevel, self.useKeyboard, self.hiresMode, self.hifiMode, self.enableSound, self.enableMusic];
}

@end
