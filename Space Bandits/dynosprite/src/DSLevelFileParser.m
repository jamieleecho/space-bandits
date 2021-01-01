//
//  DSLevelFileParser.m
//  Space Bandits
//
//  Created by Jamie Cho on 4/11/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSLevelFileParser.h"
#import "DSObject.h"


@implementation DSLevelFileParser

+ (DSPoint)pointFromArray:(NSArray *)array {
    NSCAssert(array.count == 2, ([NSString stringWithFormat:@"Wrong number of elements in array. Found %lu, expected 2", array.count]));
    NSCAssert([array[0] isKindOfClass:NSNumber.class], @"Array element 0 is not an NSNumber");
    NSCAssert([array[1] isKindOfClass:NSNumber.class], @"Array element 1 is not an NSNumber");
    int v1 = [array[0] intValue], v2 = [array[1] intValue];
    return DSPointMake(v1, v2);
}

+ (NSArray<NSNumber *> *)intArrayFromArray:(NSArray *)array {
    NSMutableArray<NSNumber *> *retval = [[NSMutableArray alloc] initWithCapacity:array.count];
    int ii = 0;
    for(NSNumber *num in array) {
        NSCAssert([num isKindOfClass:NSNumber.class], ([NSString stringWithFormat:@"Array element %d not an integer.", ii]));
        [retval addObject:[NSNumber numberWithInt:num.intValue]];
        ii++;
    }
    return retval;
}

- (void)parseFile:(NSString *)path forLevel:(DSLevel *)level {
    DSConfigFileParser *parser = [[DSConfigFileParser alloc] init];
    NSDictionary *levelDict = [parser parseFile:path];
    NSCAssert(levelDict != nil, ([NSString stringWithFormat:@"Failed to parse %@", path]));
    
    // Extract the main level data
    NSDictionary *levelData = [levelDict objectForKey:@"Level"];
    NSCAssert(levelData != nil, ([NSString stringWithFormat:@"Failed to find Level in %@", path]));
    level.name = levelData[@"Name"];
    level.levelDescription = levelData[@"Description"];
    level.objectGroupIndices = [DSLevelFileParser intArrayFromArray:levelData[@"ObjectGroups"]];
    level.maxObjectTableSize = [levelData[@"MaxObjectTableSize"] intValue];
    level.tilesetIndex = [levelData[@"Tileset"] intValue];
    level.tilemapImagePath = levelData[@"TilemapImage"];
    level.tilemapStart = [DSLevelFileParser pointFromArray:levelData[@"TilemapStart"]];
    level.tilemapSize = [DSLevelFileParser pointFromArray:levelData[@"TilemapSize"]];
    level.bkgrndStartX = [levelData[@"BkgrndStartX"] intValue];
    level.bkgrndStartY = [levelData[@"BkgrndStartY"] intValue];
    
    // Extract the object data
    NSArray *objectData = [levelDict objectForKey:@"Objects"];
    NSMutableArray *levelObjects = [[NSMutableArray alloc] initWithCapacity:objectData.count];
    level.objects = levelObjects;
    for(NSDictionary *objectInfo in objectData) {
        DSObject *obj = [[DSObject alloc] init];
        [levelObjects addObject:obj];
        obj.groupID = [objectInfo[@"GroupID"] intValue];
        obj.objectID = [objectInfo[@"ObjectID"] intValue];
        obj.initialActive = [objectInfo[@"Active"] intValue];
        obj.initialGlobalX = [objectInfo[@"globalX"] intValue];
        obj.initialGlobalY = [objectInfo[@"globalY"] intValue];
        obj.initialData = [DSLevelFileParser intArrayFromArray:objectInfo[@"InitData"]];
    }
}

@end
