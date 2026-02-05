//
//  DSCoCoKeyboardJoystickTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/1/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSCoCoKeyboardJoystick.h"
#import "DSKeyEventBaseTest.h"

@interface DSCoCoKeyboardJoystickTest : DSKeyEventBaseTest<DSCoCoKeyboardJoystick *> {
}
@end

@implementation DSCoCoKeyboardJoystickTest

- (void)setUp {
    self.target = [[DSCoCoKeyboardJoystick alloc] init];
    XCTAssertTrue([self.target open]);
}

- (void)tearDown {
    [self.target close];
}

- (void)testInitialState {
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
}

- (void)testButton0 {
    [self pressKey:@" " modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertTrue(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self unpressKey:@" " modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
}

- (void)testButton1 {
    [self pressKey:@"x" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertTrue(self.target.button1Pressed);
    [self unpressKey:@"x" modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
}

- (void)testXAxis {
    [self pressKey:UIKeyInputLeftArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(0, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self pressKey:UIKeyInputRightArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(63, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self unpressKey:UIKeyInputRightArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(0, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self unpressKey:UIKeyInputRightArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(0, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self unpressKey:UIKeyInputLeftArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    
    [self pressKey:UIKeyInputRightArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(63, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self pressKey:UIKeyInputLeftArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(0, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self unpressKey:UIKeyInputLeftArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(63, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self unpressKey:UIKeyInputLeftArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(63, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self unpressKey:UIKeyInputRightArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
}

- (void)testYAxis {
    [self pressKey:UIKeyInputUpArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(0, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self pressKey:UIKeyInputDownArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(63, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self unpressKey:UIKeyInputDownArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(0, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self unpressKey:UIKeyInputDownArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(0, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self unpressKey:UIKeyInputUpArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    
    [self pressKey:UIKeyInputDownArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(63, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self pressKey:UIKeyInputUpArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(0, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self unpressKey:UIKeyInputUpArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(63, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self unpressKey:UIKeyInputUpArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(63, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
    [self unpressKey:UIKeyInputDownArrow modifiedChars:@"sadfadsfdsafasdf"];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
}

- (void)testReset {
    [self pressKey:@" " modifiedChars:@" "];
    [self pressKey:@"x" modifiedChars:@"x"];
    [self pressKey:@"\uf703" modifiedChars:@"\uf703"];
    [self pressKey:@"\uf701" modifiedChars:@"\uf701"];
    [self.target reset];
    XCTAssertEqual(31, self.target.xaxisPosition);
    XCTAssertEqual(31, self.target.yaxisPosition);
    XCTAssertFalse(self.target.button0Pressed);
    XCTAssertFalse(self.target.button1Pressed);
}

@end
