//
//  AppDelegate.m
//  dynosprite
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import "DSAppDelegate.h"
#import "DSConfigFileParser.h"

@implementation DSAppDelegate

- (void)awakeFromNib {    
    [self.assetLoader loadLevels];
    [self.assetLoader loadSceneInfos];
    [self.assetLoader loadTransitionSceneImages];
    [self.assetLoader loadTileSets];
    [self.assetLoader loadSprites];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
