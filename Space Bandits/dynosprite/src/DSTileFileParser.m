//
//  DSTileFileParser.m
//  Space Bandits
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSConfigFileParser.h"
#import "DSLevelFileParser.h"
#import "DSTileFileParser.h"

@implementation DSTileFileParser

- (void)parseFile:(NSString *)path forTileInfo:(DSTileInfo *)info {
    DSConfigFileParser *parser = [[DSConfigFileParser alloc] init];
    NSDictionary *tileInfoData = [parser parseFile:path];
    NSAssert(tileInfoData != nil, ([NSString stringWithFormat:@"Failed to parse %@", path]));

    info.imagePath = [NSString pathWithComponents:@[@"tiles", [tileInfoData[@"Image"] stringByDeletingLastPathComponent], [tileInfoData[@"Image"] lastPathComponent]]];    
    info.tileSetStart = [DSLevelFileParser pointFromArray:tileInfoData[@"TileSetStart"]];
    info.tileSetSize = [DSLevelFileParser pointFromArray:tileInfoData[@"TileSetSize"]];
}

@end
