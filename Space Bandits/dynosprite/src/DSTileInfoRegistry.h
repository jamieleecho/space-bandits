//
//  DSTileInfoRegistry.h
//  Space Bandits
//
//  Created by Jamie Cho on 5/8/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSTileInfo.h"
#import "DSTileFileParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSTileInfoRegistry : NSObject {
    NSMutableDictionary<NSNumber *, DSTileInfo *> *_tileInfoNumberToTileInfo;
}

@property DSTileFileParser *tileFileParser;

- (id)init;
- (void)addTileInfoFromFile:(NSString *)file forNumber:(int)number;
- (void)clear;
- (DSTileInfo *)tileInfoForNumber:(int)number;
- (NSUInteger)count;

@end

NS_ASSUME_NONNULL_END
