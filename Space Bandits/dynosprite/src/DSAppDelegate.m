//
//  AppDelegate.m
//  Space Bandits
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import "DSAppDelegate.h"
#import "DSConfigFileParser.h"

@implementation DSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    DSConfigFileParser *parser = [[DSConfigFileParser alloc] init];
    NSDictionary *configs = [parser parseResourceNamed:@"images/images"];
    NSArray *images = [configs objectForKey:@"images"];
    self.transitionSceneController.images = images;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
