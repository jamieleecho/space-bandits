//
//  DSLevelLoadingScene.m
//  Space Bandits
//
//  Created by Jamie Cho on 4/26/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSLevelLoadingScene.h"

@implementation DSLevelLoadingScene

- (id)init {
    if (self = [super init]) {
        self.bundle = NSBundle.mainBundle;
        self.levelDescription = @"";
        self.levelName = @"";
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    self.isDone = NO;
    if (self.labels.count == 0) {
        NSImage *backgroundImage = [[NSImage alloc] initWithContentsOfFile:[self.bundle pathForResource:@"images/01-level1" ofType:@"png"]];
        
        const float y0 = ((((200 - 64) - backgroundImage.size.height) / 3) / 2);
        const float y1 = y0 + backgroundImage.size.height;
        const float y2 = y1 + 16;
        const float y3 = y2 + 18;
        const float y4 = y3 + 14;
        
        self.backgroundImage.size = backgroundImage.size;
        self.backgroundImage.position = CGPointMake(159 - backgroundImage.size.width / 2.0f, -y0);
        
        SKLabelNode *levelNameLabel = [self addLabelWithText:self.levelName atPosition:CGPointMake(0, y1)];
        levelNameLabel.parent.position = CGPointMake(159 - (levelNameLabel.parent.frame.size.width / 2.0f), levelNameLabel.parent.frame.origin.y);

        SKLabelNode *levelDescriptionLabel = [self addLabelWithText:self.levelDescription atPosition:CGPointMake(0, y2)];
        levelDescriptionLabel.parent.position = CGPointMake(159 - (levelDescriptionLabel.parent.frame.size.width / 2.0f), levelDescriptionLabel.parent.frame.origin.y);

        SKLabelNode *levelLoadingLabel = [self addLabelWithText:@"Loading..." atPosition:CGPointMake(0, y4)];
        levelLoadingLabel.parent.position = CGPointMake(159 - (levelLoadingLabel.parent.frame.size.width / 2.0f), levelLoadingLabel.parent.frame.origin.y);
        
        SKShapeNode *progressBarOutline = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 68, 11)];
        progressBarOutline.position = CGPointMake(160 - 34, -(y3 + 26));
        progressBarOutline.strokeColor = self.foregroundColor;
        progressBarOutline.lineWidth = 2;
        [self addChild:progressBarOutline];
        SKSpriteNode *progressBar = [[SKSpriteNode alloc] initWithColor:self.progressBarColor size:CGSizeMake(0, 9)];
        progressBar.anchorPoint = CGPointMake(0, 0);
        progressBar.position = CGPointMake(1, 1);
        [progressBarOutline addChild:progressBar];
        SKAction *loadingAction = [SKAction resizeToWidth:66 duration:1.0f];
        [progressBar runAction:loadingAction completion:^{
            NSBeep();
        }];
        [SKAction repeatAction:loadingAction count:1];
    }
}

@end
