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
        NSAssert([levelFilenameRegex numberOfMatchesInString:path.lastPathComponent options:0 range:NSMakeRange(0, path.lastPathComponent.length)] == 1, ([NSString stringWithFormat:@"Unexpected level filename %@", path.lastPathComponent]));
        NSTextCheckingResult *result = [levelFilenameRegex firstMatchInString:path.lastPathComponent options:0 range:NSMakeRange(0, path.lastPathComponent.length)];

        // Make sure there are no duplicates
        int level = [[path.lastPathComponent substringWithRange:[result rangeAtIndex:1]] intValue];
        NSAssert([levelToPath objectForKey:[NSNumber numberWithInt:level]] == nil, ([NSString stringWithFormat:@"Multiple level files found for level %d", level]));
        levelToPath[[NSNumber numberWithInt:level]] = path;
    }
    
    // Make sure there are no missing files
    NSArray<NSNumber *> *levels = [levelToPath.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSAssert(levels.count >= 1, @"No level files found.");
    NSAssert([levels[0] isEqualToNumber:@1], ([NSString stringWithFormat:@"First level starts at level %@ not level 1", levels[0]]));
    NSAssert([levels[levels.count - 1] isEqualToNumber:[NSNumber numberWithUnsignedLong:levels.count]], ([NSString stringWithFormat:@"Last level should be level %@ not level %lu", levels[levels.count - 1], levels.count]));
    NSAssert(levels.count == self.registry.count, ([NSString stringWithFormat:@"Read %lu level files, but registered %lu levels", levels.count, _registry.count]));
    
    // Load all of the files
    for(NSNumber *levelNumber in levels) {
        NSString *path = levelToPath[levelNumber];
        DSLevel *level = [self.registry levelForIndex:levelNumber.intValue];
        [self.levelFileParser parseFile:path forLevel:level];
    }
}

- (void)loadSceneInfos {
    NSString *sceneInfoPath = [self.resourceController pathForConfigFileWithName:@"images/images.json"];
    [self.transitionSceneInfoFileParser parseFile:sceneInfoPath forTransitionInfo:self.sceneInfos];
    NSAssert((self.registry.count + 1) == self.sceneInfos.count, ([NSString stringWithFormat:@"%@ contains %lu entries but was expecting %lu because there must be an entry for the initial screen plus %lu entries for the game levels", sceneInfoPath, self.registry.count, (self.registry.count + 1), self.sceneInfos.count]));
}

@end
