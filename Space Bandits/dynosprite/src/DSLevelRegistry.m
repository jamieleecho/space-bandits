//
//  DSLevelRegistry.m
//  Space Bandits
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import "DSLevelRegistry.h"

static DSLevelRegistry *_sharedInstance = nil;

@implementation DSLevelRegistry

+ (DSLevelRegistry *)sharedInstance {
    if (!_sharedInstance) {
        _sharedInstance = [[DSLevelRegistry alloc] init];
    }
    return _sharedInstance;
}


- (id)init {
    self = [super init];
    
    if (self) {
        _indexToLevel = [[NSDictionary alloc] init];
    }
    
    return self;
}


- (void)addLevel:(DSLevel *)level fromFile:(NSString *)file {
}


- (DSLevelRegistry *)getLevel:(int)index {
    return [_indexToLevel objectForKey:[NSNumber numberWithInt:index]];
}

@end
