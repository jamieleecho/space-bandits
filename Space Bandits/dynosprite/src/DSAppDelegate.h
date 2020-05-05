//
//  AppDelegate.h
//  dynosprite
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DSConfigFileParser.h"
#import "DSLevelFileParser.h"
#import "DSAssetLoader.h"
#import "DSSceneController.h"

@interface DSAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, nonnull) IBOutlet DSConfigFileParser *configFileParser;
@property (nonatomic, nonnull) IBOutlet DSAssetLoader *levelLoader;
@property (nonatomic, nonnull) IBOutlet DSSceneController *sceneController;


- (void)awakeFromNib;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *_Null_unspecified)sender;

@end
