//
//  DSCoCoJoystick.mm
//  dynosprite
//
//  Created by Jamie Cho on 8/9/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <SDL2/SDL.h>
#import "DSCoCoJoystick.h"


@implementation DSCoCoJoystick

NSMutableArray<DSCoCoJoystick *> *_availableJoysticks;
@synthesize name = _name;

/** default joystick position when readings are not valid */
const static unsigned char JOYSTICK_AXIS_DEFAULT_POSITION = 31;

/** default joystick button*/
const static BOOL JOYSTICK_BUTTON_DEFAULT_PRESSED = NO;

+ (void)initialize {
    _availableJoysticks = [[NSMutableArray alloc] init];

    // Initialize SDL
    if (SDL_Init(SDL_INIT_JOYSTICK)) {
        NSLog(@"SDL_Init failed to initialize joysticks. Running without joystick support");
        return;
    }
    
    // Disable joystick events
    SDL_JoystickEventState(SDL_DISABLE);
    
    // Iterate through all of the joysticks and build up availableJoysticks
    const int numJoysticks = SDL_NumJoysticks();
    for(int ii=0; ii<numJoysticks; ii++) {
        DSCoCoJoystick *joystick = [[DSCoCoJoystick alloc] initWithJoystickIndex:ii];
        if (joystick) {
            [_availableJoysticks addObject:joystick];
        }
    }
}

+ (NSArray *)availableJoysticks {
    return _availableJoysticks;
}

+ (void)sample {
    SDL_JoystickUpdate();
}

- (instancetype)initWithJoystickIndex:(int)index {
    if (self = [super init]) {
        _joystick_index = index;
        const char *name = SDL_JoystickNameForIndex(index);
        _name = name ? [NSString stringWithUTF8String:SDL_JoystickNameForIndex(index)] : @"Unknown joystick";
    }
    return self;
}

- (NSString *)toString {
    return self.name;
}

static BOOL readJoystickButton(SDL_Joystick *joystick, int button) {
    return SDL_JoystickGetButton(joystick, 0) != 0;
}

- (BOOL)open {
    if (_joystick) {
        return YES;
    }
    _readingsAreValid = NO;
    _joystick = SDL_JoystickOpen(_joystick_index);
    
    // Get the initial state of the joystick
    if (_joystick) {
        SDL_JoystickGetAxisInitialState(_joystick, 0, &_initialXAxisPosition);
        SDL_JoystickGetAxisInitialState(_joystick, 1, &_initialYAxisPosition);
        _initialButton0Pressed = readJoystickButton(_joystick, 0);
        _initialButton0Pressed = readJoystickButton(_joystick, 1);
    }
    
    return _joystick != NULL;
}

- (void)reset {
}

- (void)close {
    if (_joystick) {
        SDL_JoystickClose(_joystick);
        _joystick = NULL;
    }
}

static inline unsigned char convertAxisReadingToCoCo(int val) {
    return (unsigned char)((val + 0x8000) >> 10);
}

- (unsigned char)xaxisPosition {
    return [self readJoystickAxis:0 withInitialPosition:_initialXAxisPosition];
}

- (unsigned char)yaxisPosition {
    return [self readJoystickAxis:1 withInitialPosition:_initialYAxisPosition];
}

- (BOOL)button0Pressed {
    return [self readJoystickButton:0 withInitialPressed:_initialButton0Pressed];
}

- (BOOL)button1Pressed {
    return [self readJoystickButton:1 withInitialPressed:_initialButton1Pressed];
}

template<class T1, class T2>
static unsigned char readJoystickWithDefault(BOOL (^getReadingsAreValid)(void), void (^setReadingsAreValid)(BOOL), T1 (^reader)(void), T1 initialValue, unsigned char defaultValue, T2 (^transformer)(T1)) {
    T1 value = reader();
    if (getReadingsAreValid()) {
        return transformer(value);
    }
    if (value != initialValue) {
        setReadingsAreValid(YES);
        return transformer(value);
    }
    return defaultValue;
}

- (unsigned char)readJoystickAxis:(int)axis withInitialPosition:(SInt16)initialPosition {
    return readJoystickWithDefault<SInt16, unsigned char>(^{return self->_readingsAreValid;}, ^(BOOL value){self->_readingsAreValid = value;}, ^{return SDL_JoystickGetAxis(self->_joystick, axis);}, initialPosition, JOYSTICK_AXIS_DEFAULT_POSITION, ^(SInt16 value){return convertAxisReadingToCoCo(value);});
}

- (unsigned char)readJoystickButton:(int)button withInitialPressed:(BOOL)initialPressed {
    return readJoystickWithDefault<BOOL, BOOL>(^{return self->_readingsAreValid;}, ^(BOOL value){self->_readingsAreValid = value;}, ^{return readJoystickButton(self->_joystick, button);}, initialPressed, JOYSTICK_BUTTON_DEFAULT_PRESSED, ^(BOOL value){return value;});
}

@end
