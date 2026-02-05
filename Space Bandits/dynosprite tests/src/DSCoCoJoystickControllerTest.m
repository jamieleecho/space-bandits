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
    _target = [[DSCoCoJoystickController alloc] initWithKeyboardJoystick:_mockKeyboardJoystick hardwareJoystickClass:_mockJoystickClass];
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
    availableJoysticks = @[_mockJoystick1];
    OCMStub([(DSCoCoJoystick *)_mockJoystick1 open]).andReturn(YES);
    _target.useHardwareJoystick = YES;
    XCTAssertTrue(_target.useHardwareJoystick);
    XCTAssertEqualObjects(_target.joystick, _mockJoystick1);
    availableJoysticks = @[_mockJoystick2];
    _target.useHardwareJoystick = YES;
    XCTAssertTrue(_target.useHardwareJoystick);
    XCTAssertEqualObjects(_target.joystick, _mockJoystick1);
}

- (void)testSwitchesJoystickMultipleAvailableJoysticks {
    availableJoysticks = @[_mockJoystick1, _mockJoystick2];
    OCMStub([(DSCoCoJoystick *)_mockJoystick1 open]).andReturn(YES);
    OCMStub([(DSCoCoJoystick *)_mockJoystick2 open]).andReturn(YES);
    _target.useHardwareJoystick = YES;
    XCTAssertTrue(_target.useHardwareJoystick);
    XCTAssertEqualObjects(_target.joystick, _mockJoystick1);
}

- (void)testSwitchesJoystickMultipleJoysticksOnlyOneAvailable {
    availableJoysticks = @[_mockJoystick1, _mockJoystick2];
    OCMStub([(DSCoCoJoystick *)_mockJoystick1 open]).andReturn(NO);
    OCMStub([(DSCoCoJoystick *)_mockJoystick2 open]).andReturn(YES);
    _target.useHardwareJoystick = YES;
    XCTAssertTrue(_target.useHardwareJoystick);
    XCTAssertEqualObjects(_target.joystick, _mockJoystick2);
}

- (void)testClosesJoystickWhenSwitchingToKeyboard {
    availableJoysticks = @[_mockJoystick1];
    OCMStub([(DSCoCoJoystick *)_mockJoystick1 open]).andReturn(YES);
    _target.useHardwareJoystick = YES;
    _target.useHardwareJoystick = NO;
    OCMVerify([_mockJoystick1 close]);
}
- (void)testPassesKeyboardKeys {
    NSSet<UIPress *> *presses = [[NSSet alloc] init];
    UIPressesEvent *event = [[UIPressesEvent alloc] init];
    [_target pressesEnded:presses withEvent:event];
    OCMVerify([_mockKeyboardJoystick pressesEnded:presses withEvent:event]);
    [_target pressesBegan:presses withEvent:event];
    OCMVerify([_mockKeyboardJoystick pressesBegan:presses withEvent:event]);
}

- (void)testPassesKeyboardKeysEvenWithHardwareJoystick {
    _target.useHardwareJoystick = YES;
    NSSet<UIPress *> *presses = [[NSSet alloc] init];
    UIPressesEvent *event = [[UIPressesEvent alloc] init];
    [_target pressesEnded:presses withEvent:event];
    OCMVerify([_mockKeyboardJoystick pressesEnded:presses withEvent:event]);
    [_target pressesBegan:presses withEvent:event];
    OCMVerify([_mockKeyboardJoystick pressesBegan:presses withEvent:event]);
}
@end
