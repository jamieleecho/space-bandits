//
//  DSCoCoJoystick.mm
//  dynosprite
//
//  Created by Jamie Cho on 8/9/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSCoCoJoystick.h"


@implementation DSCoCoJoystick

NSMutableArray<DSCoCoJoystick *> *_availableJoysticks;
@synthesize name = _name;

+ (void)initialize {
    _availableJoysticks = [[NSMutableArray alloc] init];

    // Iterate through all of the joysticks and build up availableJoysticks
    NSArray<GCController *> *controllers = GCController.controllers;
    for(GCController *controller in controllers) {
        DSCoCoJoystick *joystick = [[DSCoCoJoystick alloc] initWithController:controller];
        if (joystick) {
            [_availableJoysticks addObject:joystick];
        }
    }
}

+ (NSArray *)availableJoysticks {
    return _availableJoysticks;
}

- (instancetype)initWithController:(nonnull GCController *)controller {
    if (self = [super init]) {
        _controller = controller;
        _name = _controller.extendedGamepad.device.vendorName;
    }
    return self;
}

- (NSString *)toString {
    return self.name;
}

- (BOOL)open {
    return _controller.extendedGamepad != NULL;
}

- (void)reset {
}

- (void)close {
}

- (unsigned char)xaxisPosition {
    BOOL left = _controller.extendedGamepad.dpad.left.value != 0;
    BOOL right = _controller.extendedGamepad.dpad.right.value != 0;
    return left ? 0 : (right ? 63 : 31);
}

- (unsigned char)yaxisPosition {
    BOOL up = _controller.extendedGamepad.dpad.up.value != 0;
    BOOL down = _controller.extendedGamepad.dpad.down.value != 0;
    return up ? 0 : (down ? 63 : 31);
}

- (BOOL)button0Pressed {
    return _controller.extendedGamepad.buttonA.value != 0;
}

- (BOOL)button1Pressed {
    return _controller.extendedGamepad.buttonB.value != 0;
}

@end
