//
//  InitScene.m
//  Space Bandits
//
//  Created by Jamie Cho on 1/6/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "InitScene.h"

@implementation InitScene {
    SKSpriteNode *_backgroundNode;
}

- (void)didMoveToView:(SKView *)view {
    if (_backgroundNode == nil) {
        _backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"Images/00-mainmenu.png"];
        [self addChild:_backgroundNode];
        self.size = CGSizeMake(1024, 640);
        self.scaleMode = SKSceneScaleModeAspectFit;
        _backgroundNode.position = CGPointMake(0, 0);
        _backgroundNode.anchorPoint = CGPointMake(0, 0);
        _backgroundNode.size = CGSizeMake(1024, 640);
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    SKTransition *transition = [SKTransition doorsOpenVerticalWithDuration:1.0];
    SKScene *newScene = [SKScene nodeWithFileNamed:@"GameScene"];
    [self.scene.view presentScene: newScene transition: transition];
}

@end
