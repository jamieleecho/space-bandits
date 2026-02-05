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
    [super awakeFromNib];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(UIApplication *)sender {
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindowScene *windowScene = nil;
    for (UIScene *scene in application.connectedScenes) {
        if ([scene isKindOfClass:UIWindowScene.class]) {
            windowScene = (UIWindowScene *)scene;
            break;
        }
    }
    
#if TARGET_OS_MACCATALYST
    windowScene.sizeRestrictions.minimumSize = CGSizeMake(320, 200);
    windowScene.titlebar.titleVisibility = UITitlebarTitleVisibilityHidden;
#endif

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

@end
