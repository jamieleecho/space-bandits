//
//  DSObjectRegistry.m
//  dynosprite
//
//  Created by Jamie Cho on 3/29/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSObjectRegistry.h"

/**
 * Registers the given object into the shared registry.
 *
 * @return some value
 */
int DSObjectRegistryRegister() {
    return 1;
}

static DSObjectRegistry *_sharedInstance = nil;

@implementation DSObjectRegistry

+ (DSObjectRegistry *)sharedInstance {
    if (!_sharedInstance) {
        _sharedInstance = [[DSObjectRegistry alloc] init];
    }
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    
    if (self) {
        _indexToObject = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)addObject:(DSObject *)object forIndex:(int)index {
}

- (void)clear {
    [_indexToObject removeAllObjects];
}

- (DSObject *)objectForIndex:(int)index {
    return _indexToObject[[NSNumber numberWithInt:index]];
}

@end
