//
//  DSTransitionImageLoader.m
//  Space Bandits
//
//  Created by Jamie Cho on 4/26/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSTransitionImageLoader.h"

@implementation DSTransitionImageLoader

- (id)init {
    if (self = [super init]) {
        self.bundle = NSBundle.mainBundle;
    }
    return self;
}

- (void)loadImagesForTransitionInfo:(NSMutableArray <DSTransitionSceneInfo *>*)info {
    NSError *error;
    NSRegularExpression *levelFilenameRegex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d\\d)\\-.*\\.png$" options:NSRegularExpressionCaseInsensitive error:&error];
    
    // Make sure the files in paths specify valid filenames
    NSArray<NSString *> *paths = [self.bundle pathsForResourcesOfType:@"png" inDirectory:@"images"];
    NSMutableDictionary<NSNumber *, NSString *> *levelToPath = [NSMutableDictionary dictionary];
    for(NSString *path in paths) {
        // Make sure the paths are in the right format
        NSCAssert([levelFilenameRegex numberOfMatchesInString:path.lastPathComponent options:0 range:NSMakeRange(0, path.lastPathComponent.length)] == 1, ([NSString stringWithFormat:@"Unexpected image filename %@", path.lastPathComponent]));
        NSTextCheckingResult *result = [levelFilenameRegex firstMatchInString:path.lastPathComponent options:0 range:NSMakeRange(0, path.lastPathComponent.length)];

        // Make sure there are no duplicates
        int level = [[path.lastPathComponent substringWithRange:[result rangeAtIndex:1]] intValue];
        NSCAssert([levelToPath objectForKey:[NSNumber numberWithInt:level]] == nil, ([NSString stringWithFormat:@"Multiple images files found for level %d", level]));
        levelToPath[[NSNumber numberWithInt:level]] = path;
    }

    // Make sure there are no missing files
    NSArray<NSNumber *> *levels = [levelToPath.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSCAssert(levels.count >= 1, @"No image files found.");
    NSCAssert([levels[0] isEqualToNumber:@0], ([NSString stringWithFormat:@"First image starts at level %@ not level 0", levels[0]]));
    NSCAssert([levels[levels.count - 1] isEqualToNumber:[NSNumber numberWithUnsignedLong:levels.count - 1]], ([NSString stringWithFormat:@"Last image should be for level %lu not level %@", levels.count, levels[levels.count - 1]]));
    NSCAssert(levels.count == info.count, ([NSString stringWithFormat:@"Found %lu image files, but expecting %lu level images", levels.count, info.count]));
    
    // Load all of the files
    for(NSNumber *levelNumber in levels) {
        NSArray<NSString *> *pathComponents = levelToPath[levelNumber].pathComponents;
        info[levelNumber.intValue].backgroundImageName = [NSString pathWithComponents:[pathComponents subarrayWithRange:NSMakeRange(pathComponents.count - 2, 2)]];
    }
}

@end
