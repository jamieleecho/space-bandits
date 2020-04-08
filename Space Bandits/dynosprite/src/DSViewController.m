//
//  DSViewController.m
//  dynosprite
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import "DSViewController.h"
#import "DSInitScene.h"

@implementation DSViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SKScene *scene = [self.transitionSceneController transitionSceneForLevel:0];
    
    // Present the scene
    [self.skView presentScene:scene];
}

@end
