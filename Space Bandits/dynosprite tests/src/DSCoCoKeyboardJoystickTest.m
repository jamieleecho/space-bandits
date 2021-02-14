//
//  DSCoCoKeyboardJoystickTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/1/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSCoCoKeyboardJoystick.h"

@interface DSCoCoKeyboardJoystickTest : XCTestCase {
    DSCoCoKeyboardJoystick *_target;
}
@end

@implementation DSCoCoKeyboardJoystickTest

- (void)setUp {
    _target = [[DSCoCoKeyboardJoystick alloc] init];
   XCTAssertTrue([_target open]);
}

- (void)tearDown {
    [_target close];
}

- (void)pressKey:(NSString *)unmodifiedChars modifiedChars:(NSString *)modifiedChars {
    NSEvent *keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyDown location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:modifiedChars charactersIgnoringModifiers:unmodifiedChars isARepeat:NO keyCode:123];
    [_target handleKeyDown:keyEvent];
}

- (void)unpressKey:(NSString *)unmodifiedChars modifiedChars:(NSString *)modifiedChars {
    NSEvent *keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:modifiedChars charactersIgnoringModifiers:unmodifiedChars isARepeat:NO keyCode:123];
    [_target handleKeyUp:keyEvent];
}

- (void)testInitialState {
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
}

- (void)testButton0 {
    [self pressKey:@"sdsd sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertTrue(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self unpressKey:@"sdsd sdsdsd" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
}

- (void)testButton1 {
    [self pressKey:@"sdsdxsdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertTrue(_target.button1Pressed);
    [self unpressKey:@"sdsdxsdsdsd" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
}

- (void)testXAxis {
    [self pressKey:@"sdsd\uf702sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(0, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self pressKey:@"sdsd\uf703sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(63, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self unpressKey:@"sdsd\uf703sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(0, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self unpressKey:@"sdsd\uf703sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(0, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self unpressKey:@"sdsd\uf702sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    
    [self pressKey:@"sdsd\uf703sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(63, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self pressKey:@"sdsd\uf702sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(0, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self unpressKey:@"sdsd\uf702sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(63, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self unpressKey:@"sdsd\uf702sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(63, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self unpressKey:@"sdsd\uf703sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
}

- (void)testYAxis {
    [self pressKey:@"sdsd\uf700sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(0, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self pressKey:@"sdsd\uf701sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(63, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self unpressKey:@"sdsd\uf701sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(0, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self unpressKey:@"sdsd\uf701sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(0, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self unpressKey:@"sdsd\uf700sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    
    [self pressKey:@"sdsd\uf701sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(63, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self pressKey:@"sdsd\uf700sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(0, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self unpressKey:@"sdsd\uf700sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(63, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self unpressKey:@"sdsd\uf700sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(63, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
    [self unpressKey:@"sdsd\uf701sdsds" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
}

- (void)testReset {
    [self pressKey:@" " modifiedChars:@" "];
    [self pressKey:@"x" modifiedChars:@"x"];
    [self pressKey:@"\uf703" modifiedChars:@"\uf703"];
    [self pressKey:@"\uf701" modifiedChars:@"\uf701"];
    [_target reset];
    XCTAssertEqual(31, _target.xaxisPosition);
    XCTAssertEqual(31, _target.yaxisPosition);
    XCTAssertFalse(_target.button0Pressed);
    XCTAssertFalse(_target.button1Pressed);
}

@end
