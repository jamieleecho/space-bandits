//
//  DSCoCoKeyboardJoystick.m
//  dynosprite
//
//  Created by Jamie Cho on 8/10/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSCoCoKeyboardJoystick.h"

@implementation DSCoCoKeyboardJoystick

/** lowest joystick position */
const static unsigned char JOYSTICK_AXIS_MIN_POSITION = 0;

/** highest joystick position */
const static unsigned char JOYSTICK_AXIS_MAX_POSITION = 63;

/** default joystick position (middle) */
const static unsigned char JOYSTICK_AXIS_DEFAULT_POSITION = 31;

- (instancetype)init {
    if (self = [super init]) {
        _xAxisPosition = _yAxisPosition = JOYSTICK_AXIS_DEFAULT_POSITION;
        _button0Pressed = _button1Pressed = NO;
        _leftKeyIsPressed = _rightKeyIsPressed = _upKeyIsPressed = _downKeyIsPressed = NO;
    }
    return self;
}

- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    for(UIPress *press in presses) {
        NSString *keyChar = press.key.charactersIgnoringModifiers;
        if ([keyChar isEqualToString:UIKeyInputUpArrow]) {
            _yAxisPosition = JOYSTICK_AXIS_MIN_POSITION;
            _upKeyIsPressed = YES;
        } else if ([keyChar isEqualToString:UIKeyInputLeftArrow]) {
            _xAxisPosition = JOYSTICK_AXIS_MIN_POSITION;
            _leftKeyIsPressed = YES;
        } else if ([keyChar isEqualToString:UIKeyInputRightArrow]) {
            _xAxisPosition = JOYSTICK_AXIS_MAX_POSITION;
            _rightKeyIsPressed = YES;
        } else if ([keyChar isEqualToString:UIKeyInputDownArrow]) {
            _yAxisPosition = JOYSTICK_AXIS_MAX_POSITION;
            _downKeyIsPressed = YES;
        } else if ([keyChar isEqualToString:@" "]) {
            _button0Pressed = YES;
        } else if ([keyChar isEqualToString:@"x"]) {
            _button1Pressed = YES;
        }
    }
}

- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    for(UIPress *press in presses) {
        NSString *keyChar = press.key.charactersIgnoringModifiers;
        if ([keyChar isEqualToString:UIKeyInputUpArrow]) {
            _yAxisPosition = _downKeyIsPressed ? JOYSTICK_AXIS_MAX_POSITION : JOYSTICK_AXIS_DEFAULT_POSITION;
            _upKeyIsPressed = NO;
        } else if ([keyChar isEqualToString:UIKeyInputLeftArrow]) {
            _xAxisPosition = _rightKeyIsPressed ? JOYSTICK_AXIS_MAX_POSITION : JOYSTICK_AXIS_DEFAULT_POSITION;
            _leftKeyIsPressed = NO;
        } else if ([keyChar isEqualToString:UIKeyInputRightArrow]) {
            _xAxisPosition = _leftKeyIsPressed ? JOYSTICK_AXIS_MIN_POSITION : JOYSTICK_AXIS_DEFAULT_POSITION;
            _rightKeyIsPressed = NO;
        } else if ([keyChar isEqualToString:UIKeyInputDownArrow]) {
            _yAxisPosition = _upKeyIsPressed ? JOYSTICK_AXIS_MIN_POSITION : JOYSTICK_AXIS_DEFAULT_POSITION;
            _downKeyIsPressed = NO;
        } else if ([keyChar isEqualToString:@" "]) {
            _button0Pressed = NO;
        } else if ([keyChar isEqualToString:@"x"]) {
            _button1Pressed = NO;
        }
    }
}


- (BOOL)button0Pressed {
    return _button0Pressed;
}

- (BOOL)button1Pressed {
    return _button1Pressed;
}

- (BOOL)open {
    return YES;
}

- (void)close {
}

- (void)reset {
    _xAxisPosition = _yAxisPosition = JOYSTICK_AXIS_DEFAULT_POSITION;
    _button0Pressed = _button1Pressed = NO;
    _leftKeyIsPressed = _rightKeyIsPressed = _upKeyIsPressed = _downKeyIsPressed = NO;
}

- (unsigned char)xaxisPosition {
    return _xAxisPosition;
}

- (unsigned char)yaxisPosition {
    return _yAxisPosition;
}

@end
