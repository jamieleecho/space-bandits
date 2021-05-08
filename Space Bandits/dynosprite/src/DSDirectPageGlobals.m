//
//  DSDirectPageGlobals.m
//  dynosprite
//
//  Created by Jamie Cho on 3/29/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSDirectPageGlobals.h"


DynospriteDirectPageGlobals DynospriteDirectPageGlobalData;
DynospriteDirectPageGlobals *DynospriteDirectPageGlobalsPtr = &DynospriteDirectPageGlobalData;
static DSDirectPageGlobals *_sharedInstance;

DynospriteGlobals DynospriteGlobalData;
void *DynospriteGlobalsPtr = &DynospriteGlobalData;
static DSDirectPageGlobals *_sharedInstance;


@implementation DSDirectPageGlobals

+ (DSDirectPageGlobals *)sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[DSDirectPageGlobals alloc] init];
    }
    return _sharedInstance;
}

- (id)init {
    return [self initWithDirectPageGlobals:&DynospriteDirectPageGlobalData andGlobals:&DynospriteGlobalData];
}

- (id)initWithDirectPageGlobals:(DynospriteDirectPageGlobals *)directPageGlobals andGlobals:(DynospriteGlobals *)globals {
    if (self = [super init]) {
        _directPageGlobals = directPageGlobals;
        _globals = globals;
    }
    return self;
}

- (DynospriteDirectPageGlobals *)directPageGlobals {
    return _directPageGlobals;
}

- (DynospriteGlobals *)globals {
    return _globals;
}

@end
