//
//  DSObjectClass.m
//  Space Bandits
//
//  Created by Jamie Cho on 4/18/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSObjectClass.h"

@implementation DSObjectClass

- (id)init {
    if (self = [super init]) {
        self.imagePath = @"";
        self.transparentColor = [NSColor colorNamed:@"black"];
        self.sprites = [NSArray array];
    }
    return self;
}

@end
