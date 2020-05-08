//
//  DSSceneTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 5/7/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "DSScene.h"

@interface DSSceneTest : XCTestCase {
    DSScene *_target;
    DSCoCoJoystickController *_joystickController;
}

@end

@implementation DSSceneTest

- (void)setUp {
    _target = [[DSScene alloc] init];
    XCTAssertNil(_target.joystickController);
    _joystickController = OCMClassMock(DSCoCoJoystickController.class);
    _target.joystickController = _joystickController;
    XCTAssertEqual(_target.levelNumber, 0);
    XCTAssertFalse(_target.isDone);
}

- (void)testIsDone {
    _target.isDone = NO;
    XCTAssertFalse(_target.isDone);
    _target.isDone = YES;
    XCTAssertTrue(_target.isDone);
}

- (void)testSetJoystickControler {
    XCTAssertEqualObjects(_target.joystickController, _joystickController);
}

- (void)testLevelNumber {
    _target.levelNumber = 4;
    XCTAssertEqual(_target.levelNumber, 4);
}

@end
