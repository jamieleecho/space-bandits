//
//  DSCoCoJoystickControllerTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/2/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "DSCoCoJoystick.h"
#import "DSCoCoJoystickController.h"
#import "DSCoCoKeyboardJoystick.h"

static NSArray *availableJoysticks;
static int numSampleCalls;

@interface DSMockJoystick : NSObject {
}
+ (NSArray *)availableJoysticks;
+ (void)sample;
@end

@implementation DSMockJoystick
+ (NSArray *)availableJoysticks {
    return availableJoysticks;
}
+ (void)sample {
    numSampleCalls = numSampleCalls + 1;
}
@end

@interface DSCoCoJoystickControllerTest : XCTestCase {
    DSCoCoJoystickController *_target;
    id _mockJoystickClass;
    id _mockKeyboardJoystick;
    id _mockJoystick1;
    id _mockJoystick2;
}

@end

@implementation DSCoCoJoystickControllerTest

- (void)setUp {
    _mockJoystickClass = DSMockJoystick.class;
    _mockKeyboardJoystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    _mockJoystick1 = OCMClassMock(DSCoCoJoystick.class);
    _mockJoystick2 = OCMClassMock(DSCoCoJoystick.class);
    availableJoysticks = @[];
    numSampleCalls = 0;
    OCMStub([(DSCoCoKeyboardJoystick *)_mockKeyboardJoystick open]).andReturn(YES);
    _target = [[DSCoCoJoystickController alloc] initWithKeyboardJoystick:self->_mockKeyboardJoystick hardwareJoystickClass:self->_mockJoystickClass];
}

- (void)testDefaultsToKeyboardJoystick {
    XCTAssertFalse(_target.useHardwareJoystick);
    XCTAssertEqualObjects(_target.joystick, _mockKeyboardJoystick);
    XCTAssertFalse(_target.useHardwareJoystick);
    XCTAssertEqualObjects(_target.joystick, _mockKeyboardJoystick);
}

- (void)testSwitchesJoystickNoAvailableJoysticks {
    _target.useHardwareJoystick = YES;
    XCTAssertFalse(_target.useHardwareJoystick);
    XCTAssertEqualObjects(_target.joystick, _mockKeyboardJoystick);
}

- (void)testSwitchesJoystickOneAvailableJoystick {
    availableJoysticks = @[self->_mockJoystick1];
    OCMStub([(DSCoCoJoystick *)_mockJoystick1 open]).andReturn(YES);
    _target.useHardwareJoystick = YES;
    XCTAssertTrue(_target.useHardwareJoystick);
    XCTAssertEqualObjects(_target.joystick, _mockJoystick1);
    availableJoysticks = @[self->_mockJoystick2];
    _target.useHardwareJoystick = YES;
    XCTAssertTrue(_target.useHardwareJoystick);
    XCTAssertEqualObjects(_target.joystick, _mockJoystick1);
}

- (void)testSwitchesJoystickMultipleAvailableJoysticks {
    availableJoysticks = @[self->_mockJoystick1, self->_mockJoystick2];
    OCMStub([(DSCoCoJoystick *)_mockJoystick1 open]).andReturn(YES);
    OCMStub([(DSCoCoJoystick *)_mockJoystick2 open]).andReturn(YES);
    _target.useHardwareJoystick = YES;
    XCTAssertTrue(_target.useHardwareJoystick);
    XCTAssertEqualObjects(_target.joystick, _mockJoystick1);
}

- (void)testSwitchesJoystickMultipleJoysticksOnlyOneAvailable {
    availableJoysticks = @[self->_mockJoystick1, self->_mockJoystick2];
    OCMStub([(DSCoCoJoystick *)_mockJoystick1 open]).andReturn(NO);
    OCMStub([(DSCoCoJoystick *)_mockJoystick2 open]).andReturn(YES);
    _target.useHardwareJoystick = YES;
    XCTAssertTrue(_target.useHardwareJoystick);
    XCTAssertEqualObjects(_target.joystick, _mockJoystick2);
}

- (void)testClosesJoystickWhenSwitchingToKeyboard {
    availableJoysticks = @[self->_mockJoystick1];
    OCMStub([(DSCoCoJoystick *)_mockJoystick1 open]).andReturn(YES);
    _target.useHardwareJoystick = YES;
    _target.useHardwareJoystick = NO;
    OCMVerify([_mockJoystick1 close]);
}

- (void)testSample {
    [_target sample];
    XCTAssertEqual(numSampleCalls, 1);
    availableJoysticks = @[self->_mockJoystick1];
    _target.useHardwareJoystick = YES;
    [_target sample];
    XCTAssertEqual(numSampleCalls, 2);
}

- (void)testPassesKeyboardKeys {
    NSEvent *event = [[NSEvent alloc] init];
    [_target handleKeyUp:event];
    OCMVerify([_mockKeyboardJoystick handleKeyUp:event]);
    [_target handleKeyDown:event];
    OCMVerify([_mockKeyboardJoystick handleKeyDown:event]);
}

- (void)testPassesKeyboardKeysEvenWithHardwareJoystick {
    availableJoysticks = @[self->_mockJoystick1];
    _target.useHardwareJoystick = YES;
    NSEvent *event = [[NSEvent alloc] init];
    [_target handleKeyUp:event];
    OCMVerify([_mockKeyboardJoystick handleKeyUp:event]);
    [_target handleKeyDown:event];
    OCMVerify([_mockKeyboardJoystick handleKeyDown:event]);
}

@end
