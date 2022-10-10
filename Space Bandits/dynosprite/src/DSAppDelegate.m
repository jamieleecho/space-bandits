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
    self.sceneController.classRegistry = DSObjectClassDataRegistry.sharedInstance;
    self.assetLoader.registry = DSLevelRegistry.sharedInstance;
    DSSoundManager.sharedInstance = self.soundManager;

    [self.defaultsConfigLoader loadDefaultsConfig];
    _soundManager.enabled = self.defaultsConfigLoader.defaultsConfig.enableSound;
    self.resourceController.hifiMode = self.defaultsConfigLoader.defaultsConfig.hifiMode;
    self.resourceController.hiresMode = self.defaultsConfigLoader.defaultsConfig.hiresMode;
    self.sceneController.firstLevel = self.defaultsConfigLoader.defaultsConfig.firstLevel;
    self.joystickController.useHardwareJoystick = !self.defaultsConfigLoader.defaultsConfig.useKeyboard;
    
    [self.assetLoader loadLevels];
    [self.assetLoader loadSceneInfos];
    [self.assetLoader loadTransitionSceneImages];
    [self.assetLoader loadTileSets];
    [self.assetLoader loadSprites];
    [self.assetLoader loadSounds];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
