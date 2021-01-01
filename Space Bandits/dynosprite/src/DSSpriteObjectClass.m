//
//  DSSpriteObjectClass.m
//  Space Bandits
//
//  Created by Jamie Cho on 4/18/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSSpriteObjectClass.h"

@implementation DSSpriteObjectClass

- (id)init {
    if (self = [super init]) {
        self.imagePath = @"";
        self.transparentColor = [NSColor colorNamed:@"black"];
        self.sprites = @[];
    }
    return self;
}

@end
