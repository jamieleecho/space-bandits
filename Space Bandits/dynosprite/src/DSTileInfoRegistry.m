//
//  DSTileInfoRegistry.m
//  Space Bandits
//
//  Created by Jamie Cho on 5/8/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSTileInfoRegistry.h"

@implementation DSTileInfoRegistry

- (id)init {
    if (self = [super init]) {
        _tileInfoNumberToTileInfo = [NSMutableDictionary dictionary];
        self.tileFileParser = [[DSTileFileParser alloc] init];
    }
    return self;
}

- (void)addTileInfoFromFile:(NSString *)file forNumber:(int)number {
    DSTileInfo *tileInfo = [[DSTileInfo alloc] init];
    [self.tileFileParser parseFile:file forTileInfo:tileInfo];
    _tileInfoNumberToTileInfo[[NSNumber numberWithInt:number]] = tileInfo;
}

- (void)clear {
    [_tileInfoNumberToTileInfo removeAllObjects];
}

- (DSTileInfo *)tileInfoForNumber:(int)number {
    return _tileInfoNumberToTileInfo[[NSNumber numberWithInt:number]];
}

- (NSUInteger)count {
    return _tileInfoNumberToTileInfo.count;
}

@end
