//
//  DSWindowController.m
//  Space Bandits
//
//  Created by Jamie Cho on 5/12/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSWindowController.h"

@interface DSWindowController ()

@end

@implementation DSWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.contentAspectRatio = self.window.contentView.frame.size;
    self.window.contentMinSize = NSMakeSize(320, 200);
}

@end
