//
//  DSCoCoKeyboardJoystick.h
//  dynosprite
//
//  Created by Jamie Cho on 8/10/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSCoCoJoystickProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSCoCoKeyboardJoystick : NSObject<DSCoCoJoystickProtocol> {
    unsigned char _xAxisPosition;
    unsigned char _yAxisPosition;
    BOOL _button0Pressed;
    BOOL _button1Pressed;
    
    BOOL _leftKeyIsPressed;
    BOOL _rightKeyIsPressed;
    BOOL _upKeyIsPressed;
    BOOL _downKeyIsPressed;
}

- (instancetype)init;

/** Must be called to handle keyboard events */
- (void)handleKeyDown:(NSEvent *)event;

/** Must be called to handle keyboard events */
- (void)handleKeyUp:(NSEvent *)event;

@end

NS_ASSUME_NONNULL_END
