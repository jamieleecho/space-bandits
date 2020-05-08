//
//  DSScene.h
//  Space Bandits
//
//  Created by Jamie Cho on 5/7/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>
#import "DSCoCoJoystickController.h"


NS_ASSUME_NONNULL_BEGIN

@interface DSScene : SKScene {
    @private
    SKAction *_pollAction;
}

@property (strong, nonatomic) DSCoCoJoystickController *joystickController;
@property (nonatomic) BOOL isDone;
@property (nonatomic) int levelNumber;

- (void)keyDown:(NSEvent *)theEvent;
- (void)keyUp:(NSEvent *)theEvent;

- (void)didMoveToView:(SKView *)view;
- (void)willMoveFromView:(SKView *)view;

- (void)poll;

@end

NS_ASSUME_NONNULL_END
