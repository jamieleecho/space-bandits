//
//  DSCoCoKeyboardJoystick.m
//  dynosprite
//
//  Created by Jamie Cho on 8/10/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <Cocoa/Cocoa.h>
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

- (void)handleKeyDown:(NSEvent *)event {
    NSString *theArrow = [event charactersIgnoringModifiers];
    for(NSUInteger ii=0; ii != theArrow.length; ii++) {
        const unichar keyChar = [theArrow characterAtIndex:ii];
        switch (keyChar) {
            case NSUpArrowFunctionKey:
                _yAxisPosition = JOYSTICK_AXIS_MIN_POSITION;
                _upKeyIsPressed = YES;
                break;
            case NSLeftArrowFunctionKey:
                _xAxisPosition = JOYSTICK_AXIS_MIN_POSITION;
                _leftKeyIsPressed = YES;
                break;
            case NSRightArrowFunctionKey:
                _xAxisPosition = JOYSTICK_AXIS_MAX_POSITION;
                _rightKeyIsPressed = YES;
                break;
            case NSDownArrowFunctionKey:
                _yAxisPosition = JOYSTICK_AXIS_MAX_POSITION;
                _downKeyIsPressed = YES;
                break;
            case ' ':
                _button0Pressed = YES;
                break;
            case 'x':
                _button1Pressed = YES;
                break;
        }
    };
}

- (void)handleKeyUp:(NSEvent *)event {
    NSString *theArrow = [event charactersIgnoringModifiers];
    for(NSUInteger ii=0; ii != theArrow.length; ii++) {
        const unichar keyChar = [theArrow characterAtIndex:ii];
        switch (keyChar) {
            case NSUpArrowFunctionKey:
                _yAxisPosition = _downKeyIsPressed ? JOYSTICK_AXIS_MAX_POSITION : JOYSTICK_AXIS_DEFAULT_POSITION;
                _upKeyIsPressed = NO;
                break;
            case NSLeftArrowFunctionKey:
                _xAxisPosition = _rightKeyIsPressed ? JOYSTICK_AXIS_MAX_POSITION : JOYSTICK_AXIS_DEFAULT_POSITION;
                _leftKeyIsPressed = NO;
                break;
            case NSRightArrowFunctionKey:
                _xAxisPosition = _leftKeyIsPressed ? JOYSTICK_AXIS_MIN_POSITION : JOYSTICK_AXIS_DEFAULT_POSITION;
                _rightKeyIsPressed = NO;
                break;
            case NSDownArrowFunctionKey:
                _yAxisPosition = _upKeyIsPressed ? JOYSTICK_AXIS_MIN_POSITION : JOYSTICK_AXIS_DEFAULT_POSITION;
                _downKeyIsPressed = NO;
                break;
            case ' ':
                _button0Pressed = NO;
                break;
            case 'x':
                _button1Pressed = NO;
                break;
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
