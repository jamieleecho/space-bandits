//
//  DSDirectPageGlobals.m
//  dynosprite
//
//  Created by Jamie Cho on 3/29/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSDirectPageGlobals.h"


DynospriteDirectPageGlobals DynospriteGlobals;
DynospriteDirectPageGlobals *DynospriteDirectPageGlobalsPtr = &DynospriteGlobals;
static DSDirectPageGlobals *_sharedInstance;


@implementation DSDirectPageGlobals

+ (DSDirectPageGlobals *)sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[DSDirectPageGlobals alloc] init];
    }
    return _sharedInstance;
}

- (id)init {
    return [self initWithGlobals:&DynospriteGlobals];
}

- (id)initWithGlobals:(DynospriteDirectPageGlobals *)globals {
    if (self = [super init]) {
        self->_globals = globals;
    }
    return self;
}

- (DynospriteDirectPageGlobals *)globals {
    return _globals;
}

@end
