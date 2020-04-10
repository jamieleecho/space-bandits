//
//  DSInitSceneTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/8/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "DSCoCoJoystickController.h"
#import "DSInitScene.h"
#import "DSResourceController.h"


enum DSInitSceneLabelIndices : short {
    DSInitSceneLabelIndicesDisplay = 0,
    DSInitSceneLabelIndicesDisplayValue,
    DSInitSceneLabelIndicesControl,
    DSInitSceneLabelIndicesControlValue,
    DSInitSceneLabelIndicesSound,
    DSInitSceneLabelIndicesSoundValue,
    DSInitSceneLabelIndicesStart
};

@interface DSInitSceneTest : XCTestCase {
    DSInitScene *_target;
    SKView *_view;
    id _resourceController;
    id _joystickController;
}
@end

@implementation DSInitSceneTest

- (void)setUp {
    _target = [[DSInitScene alloc] init];
    _resourceController = OCMClassMock(DSResourceController.class);
    _joystickController = OCMClassMock(DSCoCoJoystickController.class);
    _target.resourceController = _resourceController;
    _target.joystickController = _joystickController;
    _view = OCMClassMock(SKView.class);
    
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Courier");
    NSString *resourceImagePath = [[NSBundle bundleForClass:self.class] pathForImageResource:@"forest"];
    OCMStub([_resourceController imageWithName:@"Images/00-mainmenu.png"]).andReturn(resourceImagePath);
    [_target didMoveToView:_view];
}

- (void)testTextFromResolution {
    XCTAssertEqual([DSInitScene textFromResolution:DSInitSceneDisplayLow], @"Low");
    XCTAssertEqual([DSInitScene textFromResolution:DSInitSceneDisplayHigh], @"High");
}

- (void)testTextFromControl {
    XCTAssertEqual([DSInitScene textFromControl:DSInitSceneControlJoystick], @"Joystick");
    XCTAssertEqual([DSInitScene textFromControl:DSInitSceneControlKeyboard], @"Keyboard");
}

- (void)testTextFromSound {
    XCTAssertEqual([DSInitScene textFromSound:DSInitSceneSoundLow], @"LoFi");
    XCTAssertEqual([DSInitScene textFromSound:DSInitSceneSoundHigh], @"HiFi");
}

- (void)testDidMoveToView {
    XCTAssertEqual(_target.labels.count, 7);
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesDisplay].text, @"[D]isplay:");
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesDisplayValue].text, @"Low");
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesControl].text, @"[C]ontrol:");
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesControlValue].text, @"Keyboard");
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesSound].text, @"[S]ound:");
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesSoundValue].text, @"LoFi");
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesStart].text, @"[Space] or joystick button to start");
    
    XCTAssertEqual(_target.display, DSInitSceneDisplayLow);
    XCTAssertEqual(_target.control, DSInitSceneControlKeyboard);
    XCTAssertEqual(_target.sound, DSInitSceneSoundLow);
    XCTAssertFalse(_target.isDone);
    
    OCMVerify([_joystickController setUseHardwareJoystick:NO]);
    OCMVerify([_resourceController setHiresMode:NO]);
}

- (void)testDidMoveToViewAgain {
    __block int hiresModeCount = 0, useHardwareJoystickCount = 0, hifiModeCount = 0;
    OCMStub([_resourceController setHiresMode:NO]).andDo(^(NSInvocation *invocation) {
        hiresModeCount++;
    });
    OCMStub([_joystickController setUseHardwareJoystick:NO]).andDo(^(NSInvocation *invocation) {
        useHardwareJoystickCount++;
    });
    OCMStub([_resourceController setHifiMode:NO]).andDo(^(NSInvocation *invocation) {
        hifiModeCount++;
    });
    [_target didMoveToView:_view];
    XCTAssertEqual(_target.labels.count, 7);
    XCTAssertEqual(hiresModeCount, 1);
    XCTAssertEqual(useHardwareJoystickCount, 1);
    XCTAssertEqual(hifiModeCount, 1);
}

- (void)testWillMoveFromView {
    [_target toggleDisplay];
    [_target toggleControl];
    [_target toggleSound];
    __block int hiresModeCount = 0, useHardwareJoystickCount = 0, hifiModeCount = 0;
    OCMStub([_resourceController setHiresMode:YES]).andDo(^(NSInvocation *invocation) {
        hiresModeCount++;
    });
    OCMStub([_joystickController setUseHardwareJoystick:YES]).andDo(^(NSInvocation *invocation) {
        useHardwareJoystickCount++;
    });
    OCMStub([_resourceController setHifiMode:YES]).andDo(^(NSInvocation *invocation) {
        hifiModeCount++;
    });
    [_target willMoveFromView:_view];
    XCTAssertEqual(hiresModeCount, 1);
    XCTAssertEqual(useHardwareJoystickCount, 1);
    XCTAssertEqual(hifiModeCount, 1);
}

- (void)testKeyUpUnknownKey {
    NSEvent *keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:@"" charactersIgnoringModifiers:@"x" isARepeat:NO keyCode:123];
    [_target keyUp:keyEvent];
    XCTAssertEqual(_target.display, DSInitSceneDisplayLow);
    XCTAssertEqual(_target.control, DSInitSceneControlKeyboard);
    XCTAssertEqual(_target.sound, DSInitSceneSoundLow);
}

- (void)testKeyUpToggleDisplay {
    // This one is a little tricky to test because we have to verify that the labels get updated before we set the resolution
    _target.labels[DSInitSceneLabelIndicesDisplayValue].text = @"";
    _target.labels[DSInitSceneLabelIndicesControlValue].text = @"";
    _target.labels[DSInitSceneLabelIndicesSoundValue].text = @"";
    
    OCMStub([_resourceController setHiresMode:YES]).andDo(^(NSInvocation *invocation) {
        XCTAssertEqualObjects(self->_target.labels[DSInitSceneLabelIndicesDisplayValue].text, @"High");
        XCTAssertEqualObjects(self->_target.labels[DSInitSceneLabelIndicesControlValue].text, @"Keyboard");
        XCTAssertEqualObjects(self->_target.labels[DSInitSceneLabelIndicesSoundValue].text, @"LoFi");
    });
    
    NSEvent *keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:@"" charactersIgnoringModifiers:@"d" isARepeat:NO keyCode:123];
    [_target keyUp:keyEvent];
    
    XCTAssertEqual(_target.display, DSInitSceneDisplayHigh);
    XCTAssertEqual(_target.control, DSInitSceneControlKeyboard);
    XCTAssertEqual(_target.sound, DSInitSceneSoundLow);
}

- (void)testKeyUpToggleKeyboard {
    NSEvent *keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:@"" charactersIgnoringModifiers:@"c" isARepeat:NO keyCode:123];
    [_target keyUp:keyEvent];
    XCTAssertEqual(_target.display, DSInitSceneDisplayLow);
    XCTAssertEqual(_target.control, DSInitSceneControlJoystick);
    XCTAssertEqual(_target.sound, DSInitSceneSoundLow);
}

- (void)testKeyUpToggleSound {
    NSEvent *keyEvent = [NSEvent keyEventWithType:NSEventTypeKeyUp location:NSMakePoint(0, 0) modifierFlags:NSEventModifierFlagCapsLock timestamp:[NSDate date].timeIntervalSince1970 windowNumber:0 context:nil characters:@"" charactersIgnoringModifiers:@"s" isARepeat:NO keyCode:123];
    [_target keyUp:keyEvent];
    XCTAssertEqual(_target.display, DSInitSceneDisplayLow);
    XCTAssertEqual(_target.control, DSInitSceneControlKeyboard);
    XCTAssertEqual(_target.sound, DSInitSceneSoundHigh);
}

- (void)testTransitionToNextScene {
    [_target transitionToNextScreen];
    XCTAssertTrue(_target.isDone);
}

- (void)testPollJoystickButtonNotPressed {
    id joystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    OCMStub([_joystickController joystick]).andReturn(joystick);
    OCMStub([joystick button0Pressed]).andReturn(NO);
    OCMStub([joystick button1Pressed]).andReturn(YES);
    [_target poll];
    XCTAssertFalse(_target.isDone);
}

- (void)testPollJoystickButtonPressed {
    id joystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    OCMStub([_joystickController joystick]).andReturn(joystick);
    OCMStub([joystick button0Pressed]).andReturn(YES);
    OCMStub([joystick button1Pressed]).andReturn(NO);
    [_target poll];
    XCTAssertTrue(_target.isDone);
}

- (void)testMouseDown {
    [_target transitionToNextScreen];
    XCTAssertTrue(_target.isDone);
}

- (void)testToggleDisplay {
    [_target toggleDisplay];
    XCTAssertEqual(_target.display, DSInitSceneDisplayHigh);
    OCMVerify([_resourceController setHiresMode:YES]);
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesDisplayValue].text, @"High");
    [_target toggleDisplay];
    OCMVerify([_resourceController setHiresMode:NO]);
    XCTAssertFalse([_resourceController hiresMode]);
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesDisplayValue].text, @"Low");
}

- (void)testToggleControl {
    [_target toggleControl];
    XCTAssertEqual(_target.control, DSInitSceneControlJoystick);
    OCMVerify([_joystickController setUseHardwareJoystick:YES]);
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesControlValue].text, @"Joystick");
    [_target toggleControl];
    XCTAssertEqual(_target.control, DSInitSceneControlKeyboard);
    OCMVerify([_joystickController setUseHardwareJoystick:NO]);
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesControlValue].text, @"Keyboard");
}

- (void)testToggleSound {
    [_target toggleSound];
    XCTAssertEqual(_target.sound, DSInitSceneSoundHigh);
    OCMVerify([_resourceController setHifiMode:YES]);
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesSoundValue].text, @"HiFi");
    [_target toggleSound];
    XCTAssertEqual(_target.sound, DSInitSceneSoundLow);
    OCMVerify([_resourceController setHifiMode:NO]);
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesSoundValue].text, @"LoFi");
}

@end