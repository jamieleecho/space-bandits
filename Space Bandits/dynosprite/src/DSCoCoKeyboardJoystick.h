//
//  DSCoCoKeyboardJoystick.h
//  dynosprite
//
//  Created by Jamie Cho on 8/10/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <UIKit/UIApplication.h>
#import <UIKit/UIResponder.h>
#import <UIKit/UIKey.h>
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
- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event;

/** Must be called to handle keyboard events */
- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event;

@end

NS_ASSUME_NONNULL_END
