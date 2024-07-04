//
//  DSScene.h
//  Space Bandits
//
//  Created by Jamie Cho on 5/7/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "DSCoCoJoystickController.h"


NS_ASSUME_NONNULL_BEGIN

@interface DSScene : SKScene {
    @private
    SKAction *_pollAction;
    NSDictionary<NSString *, NSArray<NSNumber *> *> *_keyCodeToMatrix;
    NSMutableSet<NSString *> *_pressedKeys;
    uint8_t _debouncedKeys[8];
}

@property (strong, nonatomic) DSCoCoJoystickController *joystickController;
@property (nonatomic) BOOL isDone;
@property (nonatomic) int levelNumber;

- (id)init;

- (void)updateDebouncedKeys;
- (uint8_t *)debouncedKeys;

- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event;
- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event;

- (void)didMoveToView:(SKView *)view;
- (void)willMoveFromView:(SKView *)view;

- (void)poll;

@end

NS_ASSUME_NONNULL_END
