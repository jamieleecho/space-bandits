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

- (void)testInit {
    XCTAssertEqual(_target.debouncedKeys[0], 0);
    XCTAssertEqual(_target.debouncedKeys[1], 0);
    XCTAssertEqual(_target.debouncedKeys[2], 0);
    XCTAssertEqual(_target.debouncedKeys[3], 0);
    XCTAssertEqual(_target.debouncedKeys[4], 0);
    XCTAssertEqual(_target.debouncedKeys[5], 0);
    XCTAssertEqual(_target.debouncedKeys[6], 0);
    XCTAssertEqual(_target.debouncedKeys[7], 0);
    
    [_target updateDebouncedKeys];
    XCTAssertEqual(_target.debouncedKeys[0], 0);
    XCTAssertEqual(_target.debouncedKeys[1], 0);
    XCTAssertEqual(_target.debouncedKeys[2], 0);
    XCTAssertEqual(_target.debouncedKeys[3], 0);
    XCTAssertEqual(_target.debouncedKeys[4], 0);
    XCTAssertEqual(_target.debouncedKeys[5], 0);
    XCTAssertEqual(_target.debouncedKeys[6], 0);
    XCTAssertEqual(_target.debouncedKeys[7], 0);
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
}

- (void)testKeyUp {
    NSEvent *keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:@"" charactersIgnoringModifiers:@"p" isARepeat:NO keyCode:123];
    [_target keyUp:keyEvent];
    OCMVerify([_joystickController handleKeyUp:keyEvent]);

    [_target keyUp:keyEvent];
    OCMVerify([_joystickController handleKeyUp:keyEvent]);
}

- (void)testUpdatesKeyMatrix {
    // Test p
    NSEvent *keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:@"" charactersIgnoringModifiers:@"p" isARepeat:NO keyCode:0];
    [_target keyDown:keyEvent];
    XCTAssertEqual(_target.debouncedKeys[0], 0x04);
    [_target keyUp:keyEvent];
    XCTAssertEqual(_target.debouncedKeys[0], 0x00);

    // Test esc
    keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:@"" charactersIgnoringModifiers:@"\x1b" isARepeat:NO keyCode:0];
    [_target keyDown:keyEvent];
    XCTAssertEqual(_target.debouncedKeys[2], 0x40);
    [_target keyUp:keyEvent];
    XCTAssertEqual(_target.debouncedKeys[2], 0x00);

    // y
    keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:@"" charactersIgnoringModifiers:@"y" isARepeat:NO keyCode:0];
    [_target keyDown:keyEvent];
    XCTAssertEqual(_target.debouncedKeys[1], 0x08);
    [_target keyUp:keyEvent];
    XCTAssertEqual(_target.debouncedKeys[1], 0x00);

    // n
    keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:@"" charactersIgnoringModifiers:@"n" isARepeat:NO keyCode:0];
    [_target keyDown:keyEvent];
    XCTAssertEqual(_target.debouncedKeys[6], 0x02);
    [_target keyUp:keyEvent];
    XCTAssertEqual(_target.debouncedKeys[6], 0x00);

    // p esc yn
    keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:@"" charactersIgnoringModifiers:@"p\x1byn" isARepeat:NO keyCode:0];
    [_target keyDown:keyEvent];
    XCTAssertEqual(_target.debouncedKeys[0], 0x04);
    XCTAssertEqual(_target.debouncedKeys[2], 0x40);
    XCTAssertEqual(_target.debouncedKeys[1], 0x08);
    XCTAssertEqual(_target.debouncedKeys[6], 0x02);
    [_target keyUp:keyEvent];
    XCTAssertEqual(_target.debouncedKeys[0], 0x00);
    XCTAssertEqual(_target.debouncedKeys[2], 0x00);
    XCTAssertEqual(_target.debouncedKeys[1], 0x00);
    XCTAssertEqual(_target.debouncedKeys[6], 0x00);
}

- (void)testClearsMatrixWhenMovedFromView {
    NSEvent *keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:@"" charactersIgnoringModifiers:@"p\x1byn" isARepeat:NO keyCode:0];
    [_target keyDown:keyEvent];
    [_target willMoveFromView:[[SKView alloc] init]];
    XCTAssertEqual(_target.debouncedKeys[0], 0x00);
    XCTAssertEqual(_target.debouncedKeys[2], 0x00);
    XCTAssertEqual(_target.debouncedKeys[1], 0x00);
    XCTAssertEqual(_target.debouncedKeys[6], 0x00);
}

@end
