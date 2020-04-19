//
//  DSLevelRegistry.m
//  dynosprite
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import "DSLevelRegistry.h"


/**
 * Registers the given level into the shared registry.
 * @param init level initialization function
 * @param backgroundNewXY function used to compute new XY location
 * @param file path to file that defines the functions - ust begin with XY where XY are digits
 * @return some value
 */
int DSLevelRegistryRegister(void init(void), byte backgroundNewXY(void), const char *file) {
    DSLevel *level = [[DSLevel alloc] initWithInitLevel:init backgroundNewXY:backgroundNewXY];
    [[DSLevelRegistry sharedInstance] addLevel:level fromFile:[NSString stringWithUTF8String:file]];
    return 1;
}

static DSLevelRegistry *_sharedInstance = nil;

@implementation DSLevelRegistry

+ (DSLevelRegistry *)sharedInstance {
    if (!_sharedInstance) {
        _sharedInstance = [[DSLevelRegistry alloc] init];
    }
    return _sharedInstance;
}

+ (int)indexFromFilename:(NSString *)file {
    return [[[file lastPathComponent] substringToIndex:2] intValue];
}

- (id)init {
    self = [super init];
    
    if (self) {
        _indexToLevel = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)addLevel:(DSLevel *)level fromFile:(NSString *)file {
    NSNumber *index = [NSNumber numberWithInteger:[DSLevelRegistry indexFromFilename:file]];
    _indexToLevel[index] = level;
}

- (void)clear {
    [_indexToLevel removeAllObjects];
}

- (DSLevel *)levelForIndex:(int)index {
    return _indexToLevel[[NSNumber numberWithInt:index]];
}

@end
