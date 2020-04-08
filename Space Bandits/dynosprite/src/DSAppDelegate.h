//
//  AppDelegate.h
//  dynosprite
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DSTransitionSceneController.h"

@interface DSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet DSTransitionSceneController *transitionSceneController;
- (void) awakeFromNib;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender;

@end
