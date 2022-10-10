//
//  AppDelegate.h
//  dynosprite
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DSAssetLoader.h"
#import "DSConfigFileParser.h"
#import "DSDefaultsConfigLoader.h"
#import "DSCoCoJoystickController.h"
#import "DSLevelFileParser.h"
#import "DSSceneController.h"
#import "DSSoundManager.h"


@interface DSAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, nonnull) IBOutlet DSAssetLoader *assetLoader;
@property (nonatomic, nonnull) IBOutlet DSConfigFileParser *configFileParser;
@property (nonatomic, nonnull) IBOutlet DSDefaultsConfigLoader *defaultsConfigLoader;
@property (nonatomic, nonnull) IBOutlet DSCoCoJoystickController *joystickController;
@property (nonatomic, nonnull) IBOutlet DSResourceController *resourceController;
@property (nonatomic, nonnull) IBOutlet DSSceneController *sceneController;
@property (nonatomic, nonnull) IBOutlet DSSoundManager *soundManager;

- (void)awakeFromNib;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *_Null_unspecified)sender;

@end
