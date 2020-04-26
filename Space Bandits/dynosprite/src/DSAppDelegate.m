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
    [self.levelLoader loadLevels];
    [self.levelLoader loadSceneInfos];
    [self.levelLoader loadTransitionSceneImages];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
