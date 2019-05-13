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
    [super didMoveToView:view];
    if (self.labels.count < 1) {
        self.backgroundImageName = @"Images/00-mainmenu.png";
        [self addLabelWithText:@"[M]onitor:" atPosition:CGPointMake(3, 120)];
        [self addLabelWithText:@"[C]ontrol:" atPosition:CGPointMake(3, 136)];
        [self addLabelWithText:@"[S]ound:" atPosition:CGPointMake(3, 152)];
        [self addLabelWithText:@"[Space] or joystick button to start" atPosition:CGPointMake(10, 184)];
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    SKTransition *transition = [SKTransition doorsOpenVerticalWithDuration:1.0];
    SKScene *newScene = [SKScene nodeWithFileNamed:@"DSGameScene"];
    [self.scene.view presentScene: newScene transition: transition];
}

- (void)configureBackgroundImage:(SKSpriteNode *)image {
    image.size = self.size;
    image.position = CGPointMake(0, 8);
    image.anchorPoint = CGPointMake(0, 1);
}

@end
