//
//  DSAssetLoader.m
//  Space Bandits
//
//  Created by Jamie Cho on 4/24/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSAssetLoader.h"

@implementation DSAssetLoader

- (id)init {
    if (self = [super init]) {
        self.bundle = NSBundle.mainBundle;
        self.registry = DSLevelRegistry.sharedInstance;
        self.sceneInfos = [NSMutableArray array];
    }
    return self;
}

- (void)loadLevels {
    NSError *error;
    NSRegularExpression *levelFilenameRegex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d\\d)\\-.*\\.json$" options:NSRegularExpressionCaseInsensitive error:&error];

    // Make sure the files in paths specify valid filenames
    NSArray<NSString *> *paths = [self.bundle pathsForResourcesOfType:@"json" inDirectory:@"levels"];
    NSMutableDictionary<NSNumber *, NSString *> *levelToPath = [NSMutableDictionary dictionary];
    for(NSString *path in paths) {
        // Make sure the paths are in the right format
        NSCAssert([levelFilenameRegex numberOfMatchesInString:path.lastPathComponent options:0 range:NSMakeRange(0, path.lastPathComponent.length)] == 1, ([NSString stringWithFormat:@"Unexpected level filename %@", path.lastPathComponent]));
        NSTextCheckingResult *result = [levelFilenameRegex firstMatchInString:path.lastPathComponent options:0 range:NSMakeRange(0, path.lastPathComponent.length)];

        // Make sure there are no duplicates
        int level = [path.lastPathComponent substringWithRange:[result rangeAtIndex:1]].intValue;
        NSCAssert([levelToPath objectForKey:[NSNumber numberWithInt:level]] == nil, ([NSString stringWithFormat:@"Multiple level files found for level %d", level]));
        levelToPath[[NSNumber numberWithInt:level]] = path;
    }
    
    // Make sure there are no missing files
    NSArray<NSNumber *> *levels = [levelToPath.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSCAssert(levels.count >= 1, @"No level files found.");
    NSCAssert([levels[0] isEqualToNumber:@1], ([NSString stringWithFormat:@"First level starts at level %@ not level 1", levels[0]]));
    NSCAssert([levels[levels.count - 1] isEqualToNumber:[NSNumber numberWithUnsignedLong:levels.count]], ([NSString stringWithFormat:@"Last level should be level %@ not level %lu", levels[levels.count - 1], levels.count]));
    NSCAssert(levels.count == self.registry.count, ([NSString stringWithFormat:@"Read %lu level files, but registered %lu levels", levels.count, _registry.count]));
    
    // Load all of the files
    for(NSNumber *levelNumber in levels) {
        NSString *path = levelToPath[levelNumber];
        DSLevel *level = [self.registry levelForIndex:levelNumber.intValue];
        [self.levelFileParser parseFile:path forLevel:level];
    }
}

- (void)loadSprites {
    NSError *error;
    NSRegularExpression *spriteFilenameRegex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d\\d)\\-.*\\.json$" options:NSRegularExpressionCaseInsensitive error:&error];

    // Make sure the files in paths specify valid filenames
    NSArray<NSString *> *paths = [self.bundle pathsForResourcesOfType:@"json" inDirectory:@"sprites"];
    NSMutableDictionary<NSNumber *, NSString *> *spriteSetToPath = [NSMutableDictionary dictionary];
    for(NSString *path in paths) {
        // Ignore image files
        if (![path.pathExtension isEqualToString:@"json"]) {
            continue;
        }
        
        // Make sure the paths are in the right format
        NSCAssert([spriteFilenameRegex numberOfMatchesInString:path.lastPathComponent options:0 range:NSMakeRange(0, path.lastPathComponent.length)] == 1, ([NSString stringWithFormat:@"Unexpected object filename %@", path.lastPathComponent]));
        NSTextCheckingResult *result = [spriteFilenameRegex firstMatchInString:path.lastPathComponent options:0 range:NSMakeRange(0, path.lastPathComponent.length)];

        // Make sure there are no duplicates
        int objectSetNumber = [path.lastPathComponent substringWithRange:[result rangeAtIndex:1]].intValue;
        NSCAssert([spriteSetToPath objectForKey:[NSNumber numberWithInt:objectSetNumber]] == nil, ([NSString stringWithFormat:@"Multiple object files found for object set %d", objectSetNumber]));
        spriteSetToPath[[NSNumber numberWithInt:objectSetNumber]] = path;
    }
    
    // Load all of the files
    NSArray<NSNumber *> *spriteSets = [spriteSetToPath.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for(NSNumber *objectClassNumber in spriteSets) {
        NSString *path = spriteSetToPath[objectClassNumber];
        DSSpriteObjectClass *spriteObjectClass = [[DSSpriteObjectClass alloc] init];
        [self.objectParser parseFile:path forObjectClass:spriteObjectClass];
        NSLog(@"([spriteObjectClassFactory addSpriteObjectClass:%@ forNumber:%@]", path, objectClassNumber);
        [self.spriteObjectClassFactory addSpriteObjectClass:spriteObjectClass forNumber:objectClassNumber];
    }
}

- (void)loadTileSets {
    NSError *error;
    NSRegularExpression *tileFilenameRegex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d\\d)\\-.*\\.json$" options:NSRegularExpressionCaseInsensitive error:&error];

    // Make sure the files in paths specify valid filenames
    NSArray<NSString *> *paths = [self.bundle pathsForResourcesOfType:@"json" inDirectory:@"tiles"];
    NSMutableDictionary<NSNumber *, NSString *> *tileSetToPath = [NSMutableDictionary dictionary];
    for(NSString *path in paths) {
        // Ignore image files
        if (![path.pathExtension isEqualToString:@"json"]) {
            continue;
        }
        
        // Make sure the paths are in the right format
        NSCAssert([tileFilenameRegex numberOfMatchesInString:path.lastPathComponent options:0 range:NSMakeRange(0, path.lastPathComponent.length)] == 1, ([NSString stringWithFormat:@"Unexpected tile filename %@", path.lastPathComponent]));
        NSTextCheckingResult *result = [tileFilenameRegex firstMatchInString:path.lastPathComponent options:0 range:NSMakeRange(0, path.lastPathComponent.length)];

        // Make sure there are no duplicates
        int tileSetNumber = [path.lastPathComponent substringWithRange:[result rangeAtIndex:1]].intValue;
        NSCAssert([tileSetToPath objectForKey:[NSNumber numberWithInt:tileSetNumber]] == nil, ([NSString stringWithFormat:@"Multiple tiles files found for tile set %d", tileSetNumber]));
        tileSetToPath[[NSNumber numberWithInt:tileSetNumber]] = path;
    }
    
    // Make sure there are no missing tile sets
    NSArray<NSNumber *> *tileSets = [tileSetToPath.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSCAssert(tileSets.count >= 1, @"No level files found.");
    NSCAssert([tileSets[0] isEqualToNumber:@1], ([NSString stringWithFormat:@"First tile set starts at number %@ not number 1", tileSets[0]]));
    NSCAssert([tileSets[tileSets.count - 1] isEqualToNumber:[NSNumber numberWithUnsignedLong:tileSets.count]], ([NSString stringWithFormat:@"Last tile set should be number %@ not number %lu", tileSets[tileSets.count - 1], tileSets.count]));
    
    // Load all of the files
    for(NSNumber *tileSetNumber in tileSets) {
        NSString *path = tileSetToPath[tileSetNumber];
        NSLog(@"([_tileInfoRegistry addTileInfoFromFile:%@ forNumber:%@]", path, tileSetNumber);
        [self.tileInfoRegistry addTileInfoFromFile:path forNumber:tileSetNumber.intValue];
    }
}

- (void)loadSceneInfos {
    NSString *sceneInfoPath = [self.resourceController pathForConfigFileWithName:@"images/images.json"];
    [self.transitionSceneInfoFileParser parseFile:sceneInfoPath forTransitionInfo:self.sceneInfos];
    NSCAssert((self.registry.count + 1) == self.sceneInfos.count, ([NSString stringWithFormat:@"%@ contains %lu entries but was expecting %lu because there must be an entry for the initial screen plus %lu entries for the game levels", sceneInfoPath, self.registry.count, (self.registry.count + 1), self.sceneInfos.count]));
}

- (void)loadTransitionSceneImages {
    [self.imageLoader loadImagesForTransitionInfo:self.sceneInfos];
}

@end
