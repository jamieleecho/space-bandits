//
//  DSCocoJoystickController.m
//  Space Bandits
//
//  Created by Jamie Cho on 8/10/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSCocoJoystickController.h"
#import "DSCoCoJoystick.h"


@implementation DSCocoJoystickController

- (instancetype)init {
    return [self initWithKeyboardJoystick:[[DSCoCoKeyboardJoystick alloc] init] hardwareJoystickClass:[DSCoCoJoystick class]];
}

- (instancetype)initWithKeyboardJoystick:(DSCoCoKeyboardJoystick *)keyboardJoystick hardwareJoystickClass:(Class)hardwareJoystickClass {
    if (self = [super init]) {
        _hardwareJoystickClass = hardwareJoystickClass;
        _joystick =_keyboardJoystick = keyboardJoystick;
        NSAssert([_joystick open] == YES, @"Failed to open DSCoCoKeyboardJoystick");
    }
    return self;
}

- (BOOL)setUseHardwareJoystick:(BOOL)val {
    /* already in this state? */
    if (val == self.useHardwareJoystick){
        return val;
    } else if (val) {
        for(DSCoCoJoystick *joystick in [_hardwareJoystickClass availableJoysticks]) {
            if ([joystick open]) {
                _joystick = joystick;
            }
        }
    } else {
        [_joystick close];
        _joystick = _keyboardJoystick;
    }
    return self.useHardwareJoystick;
}

- (BOOL)useHardwareJoystick {
    return _joystick != _keyboardJoystick;
}

- (NSObject<DSCoCoJoystickProtocol> *)joystick {
    return _joystick;
}

- (void)handleKeyDown:(NSEvent *)event {
    [_keyboardJoystick handleKeyDown:event];
}

- (void)handleKeyUp:(NSEvent *)event {
    [_keyboardJoystick handleKeyDown:event];
}

- (void)sample {
    [_hardwareJoystickClass sample];
}

@end

