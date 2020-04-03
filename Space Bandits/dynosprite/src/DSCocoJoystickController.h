//
//  DSCocCJoystickController.h
//  Space Bandits
//
//  Created by Jamie Cho on 8/10/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DSCoCoJoystickProtocol.h"
#import "DSCoCoKeyboardJoystick.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSCoCoJoystickController : NSObject {
    NSObject<DSCoCoJoystickProtocol> *_joystick;
    DSCoCoKeyboardJoystick *_keyboardJoystick;
    Class _hardwareJoystickClass;
}

- (instancetype)init;
- (instancetype)initWithKeyboardJoystick:(DSCoCoKeyboardJoystick *)keyboardJoystick hardwareJoystickClass:hardwareJoystickClass;

/**
 * Whether or not to use a joystick instead of keyboard. Returns YES if
 * in keyboard mode and NO otherwise.
 */
- (BOOL)setUseHardwareJoystick:(BOOL)val;

/** Whether or not we are currently using a hardware joystick */
- (BOOL)useHardwareJoystick;

/** Currently selected joystick */
- (NSObject<DSCoCoJoystickProtocol> *)joystick;

/** Must be called to handle keyboard events */
- (void)handleKeyDown:(NSEvent *)event;

/** Must be called to handle keyboard events */
- (void)handleKeyUp:(NSEvent *)event;

/** Must be called periodically */
- (void)sample;

@end

NS_ASSUME_NONNULL_END
