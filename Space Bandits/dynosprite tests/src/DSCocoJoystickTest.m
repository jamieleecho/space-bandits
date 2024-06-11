//
//  DSCoCoJoystickTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 3/31/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "DSCoCoJoystick.h"

@interface DSCoCoJoystickTest : XCTestCase {
    DSCoCoJoystick *_target;
}

@end

@implementation DSCoCoJoystickTest
- (void)setUp {
    id controller = OCMClassMock(GCController.class);
    id gamepad = OCMClassMock(GCExtendedGamepad.class);
    id device = OCMProtocolMock(@protocol(GCDevice));
    OCMStub([controller extendedGamepad]).andReturn(gamepad);
    OCMStub([gamepad device]).andReturn(device);
    OCMStub([device vendorName]).andReturn(@"Unknown joystick");
    _target = [[DSCoCoJoystick alloc] initWithController:controller];
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

- (void)testReset {
    [_target reset];
}
@end
