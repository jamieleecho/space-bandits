//
//  DSTransitionScene.m
//  Space Bandits
//
//  Created by Jamie Cho on 1/14/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSTransitionScene.h"

@interface DSTransitionScene() {
}
- (void)configureLabel:(SKLabelNode *)label;
- (void)configureBackgroundImage:(SKSpriteNode *)image;
@end


@implementation DSTransitionScene

- (NSString *)backgroundImageName {
    return _backgroundImageName;
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName {
    _backgroundImageName = backgroundImageName;
    _backgroundImage.texture = [SKTexture textureWithImageNamed:_backgroundImageName];
}

- (id)init {
    if (self = [super init]) {
        _foregroundColor = NSColor.blackColor;
        _progressBarColor = NSColor.greenColor;
        _labels = [[NSMutableArray alloc] init];

        self.size = CGSizeMake(320, 200);
        self.anchorPoint = CGPointMake(0, 1);
        self.yScale = -1;
        self.scaleMode = SKSceneScaleModeAspectFit;
        
        _backgroundImageName = @"";
        _backgroundImage = [SKSpriteNode spriteNodeWithColor:self.backgroundColor size:self.size];
        [self configureBackgroundImage:_backgroundImage];
        [self addChild:_backgroundImage];
    }
    return self;
}

- (void)addLabelWithText:(NSString *)labelText atPosition:(CGPoint)position {
    NSString *font = @"pcgfont";
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:font];
    label.text = labelText;
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    label.position = CGPointMake(0, 0);
    label.fontSize = 12.75f;
    label.fontColor = self.foregroundColor;
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:self.backgroundColor size:label.frame.size];
    [background addChild:label];
    position.y = -position.y;
    background.position = position;
    background.anchorPoint = CGPointMake(0, 1);

    [self addChild:background];
    [_labels addObject:label];
}

- (void)configureLabel:(SKLabelNode *)label {
    label.fontColor = self.foregroundColor;
    ((SKSpriteNode *)label.parent).color = self.backgroundColor;
}

- (void)configureBackgroundImage:(SKSpriteNode *)image {
    _backgroundImage.anchorPoint = CGPointMake(0, 1);
    _backgroundImage.size = self.size;
    _backgroundImage.position = CGPointMake(0, 0);
}

@end
