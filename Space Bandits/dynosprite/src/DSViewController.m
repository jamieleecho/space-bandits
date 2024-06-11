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

    SKScene *scene = [self.sceneController transitionSceneForLevel:0];
    scene.userInteractionEnabled = YES;
    self.skView.userInteractionEnabled = YES;
    self.skView.window.userInteractionEnabled = YES;
    
    // Present the scene
    [self.skView presentScene:scene];
}

- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event {
    [self.skView.scene pressesBegan:presses withEvent:event];
}


- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    [self.skView.scene pressesEnded:presses withEvent:event];
}


@end
