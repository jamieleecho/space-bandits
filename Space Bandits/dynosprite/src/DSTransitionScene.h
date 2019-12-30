//
//  DSTransitionScene.h
//  Space Bandits
//
//  Created by Jamie Cho on 1/14/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DSCocoJoystickController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSTransitionScene : SKScene {
    @private
    NSString *_backgroundImageName;
    @private
    SKSpriteNode *_backgroundImage;
    @private
    NSMutableArray<SKLabelNode *> *_labels;
    @private
    SKAction *_pollAction;
}

@property (strong, nonatomic) NSString *backgroundImageName;
@property (strong, nonatomic) NSColor *foregroundColor;
@property (strong, nonatomic) NSColor *progressBarColor;
@property (strong, readonly) NSArray<SKLabelNode *> *labels;
@property (strong, nonatomic) DSCocoJoystickController *joystickController;

- (id)init;
- (SKLabelNode *)addLabelWithText:(NSString *)labelText atPosition:(CGPoint)position;

- (void)didMoveToView:(SKView *)view;
- (void)willMoveFromView:(SKView *)view;

- (void)keyDown:(NSEvent *)theEvent;
- (void)keyUp:(NSEvent *)theEvent;

- (void)poll;

@end

NS_ASSUME_NONNULL_END
