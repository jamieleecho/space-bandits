//
//  DSSpriteObjectClassFactory.m
//  Space Bandits
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSSpriteObjectClassFactory.h"

@implementation DSSpriteObjectClassFactory

- (id)init {
    if (self = [super init]) {
        _levelToObjectClass = NSMutableDictionary.dictionary;
        return self;
    }
    return self;
}

- (void)addSpriteObjectClass:(DSSpriteObjectClass *)objectClass forNumber:(NSNumber *)levelNumber {
    [_textureManager addSpriteObjectClass:objectClass];
}

@end
