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
    XCTAssertFalse(_target.isPaused);
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

- (void)testKeyDown {
    NSEvent *keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:@"" charactersIgnoringModifiers:@"p" isARepeat:NO keyCode:123];
    [_target keyDown:keyEvent];
    OCMVerify([_joystickController handleKeyDown:keyEvent]);
    XCTAssertFalse(_target.isPaused);
}

- (void)testKeyUp {
    NSEvent *keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:@"" charactersIgnoringModifiers:@"p" isARepeat:NO keyCode:123];
    [_target keyUp:keyEvent];
    OCMVerify([_joystickController handleKeyUp:keyEvent]);
    XCTAssertTrue(_target.isPaused);

    [_target keyUp:keyEvent];
    OCMVerify([_joystickController handleKeyUp:keyEvent]);
    XCTAssertFalse(_target.isPaused);
}

@end
