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

- (void) awakeFromNib {
    DSConfigFileParser *parser = [[DSConfigFileParser alloc] init];
    NSDictionary *configs = [parser parseResourceNamed:@"images/images"];
    NSArray *images = [configs objectForKey:@"images"];
    self.transitionSceneController.images = images;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
