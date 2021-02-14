//
//  DSCoCoJoystickTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 3/31/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSCoCoJoystick.h"

@interface DSCoCoJoystickTest : XCTestCase {
    DSCoCoJoystick *_target;
}

@end

@implementation DSCoCoJoystickTest

- (void)setUp {
    _target = [[DSCoCoJoystick alloc] initWithJoystickIndex:65535];
}

- (void)tearDown {
    [_target close];
    [_target open];
}

- (void)testAvailableJoysticksNotHorriblyBroken {
    NSArray *joysticks = [DSCoCoJoystick availableJoysticks];
    XCTAssertNotNil(joysticks);
    [joysticks count];
}

- (void)testSampleNotHorriblyBroken {
    [DSCoCoJoystick sample];
}

- (void)testName {
    XCTAssertEqualObjects(_target.name, @"Unknown joystick");
}

- (void)testReadAxis {
    XCTAssertEqual(0x1f, _target.xaxisPosition);
    XCTAssertEqual(0x1f, _target.yaxisPosition);
}

- (void)testReadButtons {
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
}

- (void)testReadAxisWithInitialPosition {
    XCTAssertEqual(0x20, [_target readJoystickAxis:0 withInitialPosition:31]);
    XCTAssertEqual(0x20, [_target readJoystickAxis:1 withInitialPosition:31]);
}

- (void)testReadButtonsWithInitialPressed {
    XCTAssertFalse([_target readJoystickButton:0 withInitialPressed:false]);
    XCTAssertFalse([_target readJoystickButton:1 withInitialPressed:false]);
}

- (void)testReset {
    [_target reset];
}

@end
