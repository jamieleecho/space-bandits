//
//  DSDirectPageGlobals.m
//  Space Bandits
//
//  Created by Jamie Cho on 3/29/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSDirectPageGlobals.h"


DynospriteDirectPageGlobals *DynospriteDirectPageGlobalsPtr;
static DSDirectPageGlobals *_sharedInstance;


@implementation DSDirectPageGlobals

+ (DSDirectPageGlobals *)sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[DSDirectPageGlobals alloc] initWithGlobals:DynospriteDirectPageGlobalsPtr];
    }
    return _sharedInstance;
}

- (id)initWithGlobals:(DynospriteDirectPageGlobals *)globals {
    if (self = [self init]) {
        self->_globals = globals;
    }
    return self;
}

- (DynospriteDirectPageGlobals *)globals {
    return _globals;
}

@end
