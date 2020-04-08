//
//  DSCoCoJoystick.h
//  dynosprite
//
//  Created by Jamie Cho on 8/9/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDL2/SDL.h>
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
    /** Joystick device index returned by SDL */
    int _joystick_index;
    
    /** Joystick opaque type */
    SDL_Joystick *_joystick;

    /** False until joystick registers a new value */
    BOOL _readingsAreValid;

    /** Initial x axis reading */
    Sint16 _initialXAxisPosition;
    
    /** Initial y axis reading */
    Sint16 _initialYAxisPosition;
    
    /** Whether or not button 0 was initially pressed */
    BOOL _initialButton0Pressed;
    
    /** Whether or not button 1 was initially pressed*/
    BOOL _initialButton1Pressed;
}

/** NSArray with all of the joysticks available to the program */
+ (NSArray<DSCoCoJoystick *> *)availableJoysticks;

/** Periodically call this to sample the state of the joysticks */
+ (void)sample;

/* Private methods */

/** Initialize ths joystick from the SDL joystick index */
- (instancetype)initWithJoystickIndex:(int)index;

/** Human readable name of the joystick */
@property (nonatomic, assign, readonly) NSString *name;

/** Human readable name of the joystick */
- (NSString *)toString;

/**
 * Reads the given joystick axis - 0 is X and 1 is Y.
 */
- (unsigned char)readJoystickAxis:(int)axis withInitialPosition:(SInt16)initialPosition;

/**
 * Reads the given joystick button
 */
- (unsigned char)readJoystickButton:(int)button withInitialPressed:(BOOL)initialPressed;

@end

NS_ASSUME_NONNULL_END
