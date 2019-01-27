//
//  InitScene.m
//  Space Bandits
//
//  Created by Jamie Cho on 1/6/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSInitScene.h"

@implementation DSInitScene {
}

- (void)didMoveToView:(SKView *)view {
    if (self.labels.count < 1) {
        self.backgroundImageName = @"Images/00-mainmenu.png";
        [self addLabelWithText:@"[M]onitor sadasdfsfasfasdf" atPosition:CGPointMake(20, 10)];
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    SKTransition *transition = [SKTransition doorsOpenVerticalWithDuration:1.0];
    SKScene *newScene = [SKScene nodeWithFileNamed:@"GameScene"];
    [self.scene.view presentScene: newScene transition: transition];
}

@end