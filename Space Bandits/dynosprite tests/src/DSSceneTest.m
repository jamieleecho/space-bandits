//
//  DSSceneTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 5/7/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import "DSKeyEventBaseTest.h"
#import "DSScene.h"

@interface DSSceneTest : DSKeyEventBaseTest<DSScene *> {
    DSCoCoJoystickController *_joystickController;
}

@end

@implementation DSSceneTest

- (void)setUp {
    self.target = [[DSScene alloc] init];
    XCTAssertNil(self.target.joystickController);
    _joystickController = OCMClassMock(DSCoCoJoystickController.class);
    self.target.joystickController = _joystickController;
    XCTAssertEqual(self.target.levelNumber, 0);
    XCTAssertFalse(self.target.isDone);
}

- (void)testInit {
    XCTAssertEqual(self.target.debouncedKeys[0], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[1], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[2], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[3], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[4], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[5], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[6], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[7], 0xff);
    
    [self.target updateDebouncedKeys];
    XCTAssertEqual(self.target.debouncedKeys[0], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[1], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[2], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[3], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[4], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[5], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[6], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[7], 0xff);
}

- (void)testIsDone {
    self.target.isDone = NO;
    XCTAssertFalse(self.target.isDone);
    self.target.isDone = YES;
    XCTAssertTrue(self.target.isDone);
}

- (void)testSetJoystickControler {
    XCTAssertEqualObjects(self.target.joystickController, _joystickController);
}

- (void)testLevelNumber {
    self.target.levelNumber = 4;
    XCTAssertEqual(self.target.levelNumber, 4);
}

- (void)testKeyDown {
    NSSet<UIPress *> *presses1 = [self pressKey:@"p" modifiedChars:@""];
    OCMVerify([_joystickController pressesBegan:presses1 withEvent:OCMArg.any]);
    NSSet<UIPress *> *presses2 = [self pressKey:@"p" modifiedChars:@""];
    OCMVerify([_joystickController pressesBegan:presses2 withEvent:OCMArg.any]);
}

- (void)testKeyUp {
    NSSet<UIPress *> *presses1 = [self unpressKey:@"p" modifiedChars:@""];
    OCMVerify([_joystickController pressesEnded:presses1 withEvent:OCMArg.any]);
    NSSet<UIPress *> *presses2 = [self unpressKey:@"p" modifiedChars:@""];
    OCMVerify([_joystickController pressesEnded:presses2 withEvent:OCMArg.any]);
}

- (void)testUpdatesKeyMatrix {
    // Test p
    [self pressKey:@"p" modifiedChars:@""];
    XCTAssertEqual(self.target.debouncedKeys[0], 0xff & ~0x04);
    [self unpressKey:@"p" modifiedChars:@""];
    XCTAssertEqual(self.target.debouncedKeys[0], 0xff);

    // Test esc
    [self pressKey:UIKeyInputEscape modifiedChars:@""];
    XCTAssertEqual(self.target.debouncedKeys[2], 0xff & ~0x40);
    [self unpressKey:UIKeyInputEscape modifiedChars:@""];
    XCTAssertEqual(self.target.debouncedKeys[2], 0xff);

    // y
    [self pressKey:@"y" modifiedChars:@""];
    XCTAssertEqual(self.target.debouncedKeys[1], 0xff & ~0x08);
    [self unpressKey:@"y" modifiedChars:@""];
    XCTAssertEqual(self.target.debouncedKeys[1], 0xff);

    // n
    [self pressKey:@"n" modifiedChars:@""];
    XCTAssertEqual(self.target.debouncedKeys[6], 0xff & ~0x02);
    [self unpressKey:@"n" modifiedChars:@""];
    XCTAssertEqual(self.target.debouncedKeys[6], 0xff);

    // p esc yn
    [self pressKey:@"p" modifiedChars:@""];
    [self pressKey:UIKeyInputEscape modifiedChars:@""];
    [self pressKey:@"y" modifiedChars:@""];
    [self pressKey:@"n" modifiedChars:@""];
    XCTAssertEqual(self.target.debouncedKeys[0], 0xff & ~0x04);
    XCTAssertEqual(self.target.debouncedKeys[2], 0xff & ~0x40);
    XCTAssertEqual(self.target.debouncedKeys[1], 0xff & ~0x08);
    XCTAssertEqual(self.target.debouncedKeys[6], 0xff & ~0x02);
    [self unpressKey:@"p" modifiedChars:@""];
    [self unpressKey:UIKeyInputEscape modifiedChars:@""];
    [self unpressKey:@"y" modifiedChars:@""];
    [self unpressKey:@"n" modifiedChars:@""];
    XCTAssertEqual(self.target.debouncedKeys[0], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[2], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[1], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[6], 0xff);
}

#ifdef __TODO__

- (void)testClearsMatrixWhenMovedFromView {
    NSEvent *keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:CGPointMake(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:@"" charactersIgnoringModifiers:@"p\x1byn" isARepeat:NO keyCode:0];
    [self.target keyDown:keyEvent];
    [self.target willMoveFromView:[[SKView alloc] init]];
    XCTAssertEqual(self.target.debouncedKeys[0], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[2], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[1], 0xff);
    XCTAssertEqual(self.target.debouncedKeys[6], 0xff);
}
#endif
@end
