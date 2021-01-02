//
//  DSCoCoJoystickProtocol.h
//  dynosprite
//
//  Created by Jamie Cho on 8/10/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DSCoCoJoystickProtocol

/** Must be called before using the joystick */
- (BOOL)open;

/** Reset joystick state */
- (void)reset;

/** Clean up */
- (void)close;

/** Current X-Axis position on [0, 63] */
- (unsigned char)xaxisPosition;

/** Current Y-Axis position on [0, 63] */
- (unsigned char)yaxisPosition;

/** Whether or not button 0 is pressed */
- (BOOL)button0Pressed;

/** Whether or not button 1 is pressed */
- (BOOL)button1Pressed;

@end

NS_ASSUME_NONNULL_END
