//
//  DSTransitionScene.h
//  Space Bandits
//
//  Created by Jamie Cho on 1/14/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DSCoCoJoystickController.h"
#import "DSResourceController.h"

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
    @private
    NSMapTable <SKLabelNode *, NSValue *> *_labelToPoint;
    @private
    NSMapTable <SKLabelNode *, NSNumber *> *_labelToCentered;
}

@property (strong, nonatomic) NSString *backgroundImageName;
@property (strong, nonatomic) NSColor *foregroundColor;
@property (strong, nonatomic) NSColor *progressBarColor;
@property (strong, readonly) NSArray<SKLabelNode *> *labels;
@property (strong, nonatomic) DSResourceController *resourceController;
@property (strong, nonatomic) DSCoCoJoystickController *joystickController;
@property (nonatomic) BOOL isDone;

- (id)init;
- (SKLabelNode *)addLabelWithText:(NSString *)labelText atPosition:(CGPoint)position;

- (void)didMoveToView:(SKView *)view;
- (void)willMoveFromView:(SKView *)view;

- (void)keyDown:(NSEvent *)theEvent;
- (void)keyUp:(NSEvent *)theEvent;

- (void)poll;

@end

NS_ASSUME_NONNULL_END
