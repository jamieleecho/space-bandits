//
//  DSObjectClassInstance.m
//  Space Bandits
//
//  Created by Jamie Cho on 7/7/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSObjectClassInstance.h"

@implementation DSObjectClassInstance

- (id)initWithObjectClass:(DSObjectClass *)objectClass objectMethods:(DSObjectClassData *)methods cobs:(DynospriteCOB *)cobs odts:(DynospriteODT *)odts {
    if (self = [super init]) {
        _objectClass = objectClass;
        _methods = methods;
        _cobs = cobs;
        _odts = odts;

        size_t sz = _objectClass.sprites.count;
        _textures = [[NSMutableArray alloc] initWithCapacity:sz];
        _sprites = [[NSMutableArray alloc] initWithCapacity:sz];
        _statePtr = calloc(sz, sizeof(byte *));
        
        /** State Pointers for each individual cob above */
    }
    return self;
}


- (void)reset {
}


- (byte)update {
    return 0;
}


- (DSObjectClass *)objectClass {
    return _objectClass;
}


- (DSObjectClassData *)methods {
    return _methods;
}


- (DynospriteCOB *)cobs {
    return _cobs;
}


- (DynospriteODT *)odts {
    return _odts;
}


- (byte *)statePtr {
    return _statePtr;
}


- (NSArray<SKSpriteNode *> *)sprites {
    return _sprites;
}

@end
