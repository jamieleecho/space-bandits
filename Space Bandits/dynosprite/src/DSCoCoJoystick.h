//
//  DSCoCoJoystick.h
//  dynosprite
//
//  Created by Jamie Cho on 8/9/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameController/GameController.h>
#import "DSCoCoJoystickProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A DSCoCoJoystick is a representation of a Color Computer joystick which consists of
 * two analog axes (X and Y) and two buttons (0 and 1). The analog axes have levels
 * between 0 and 63 where 0 means left and top and 63 means right and bottom. YES means
 * pressed and NO means not pressed for the buttons.
 */
@interface DSCoCoJoystick : NSObject<DSCoCoJoystickProtocol> {
    @private
    /** Joystick opaque type */
    GCController *_controller;
}

/** NSArray with all of the joysticks available to the program */
+ (NSArray<DSCoCoJoystick *> *)availableJoysticks;

/** Human readable name of the joystick */
- (NSString *)toString;

- (BOOL)open;

- (void)reset;

- (void)close;

- (unsigned char)xaxisPosition;

- (unsigned char)yaxisPosition;

- (BOOL)button0Pressed;

- (BOOL)button1Pressed;

/* Private methods */

/** Initialize ths joystick from the GCController */
- (instancetype)initWithController:(nonnull GCController *)controller;

/** Human readable name of the joystick */
@property (nonatomic, assign, readonly) NSString *name;

@end

NS_ASSUME_NONNULL_END
