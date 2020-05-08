//
//  DSScene.m
//  Space Bandits
//
//  Created by Jamie Cho on 5/7/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSScene.h"

@implementation DSScene

- (void)keyDown:(NSEvent *)theEvent {
    [self.joystickController handleKeyDown:theEvent];
}

- (void)keyUp:(NSEvent *)theEvent {
    [self.joystickController handleKeyUp:theEvent];
}

- (void)didMoveToView:(SKView *)view {
    id sampleJoystick = ^{
        [self.joystickController sample];
        [self poll];
    };
    if (!_pollAction) {
        _pollAction = [SKAction repeatActionForever:[SKAction sequence:@[[SKAction runBlock:sampleJoystick], [SKAction waitForDuration:1.0f / view.preferredFramesPerSecond]]]];
        [self runAction:_pollAction withKey:@"pollAction"];
    }
}

- (void)willMoveFromView:(SKView *)view {
    [self removeActionForKey:@"pollAction"];
    _pollAction = nil;
}

- (void)poll {
}

@end
