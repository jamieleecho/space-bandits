//
//  DSInitSceneTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/8/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import "DSKeyEventBaseTest.h"

#import "DSCoCoJoystickController.h"
#import "DSInitScene.h"
#import "DSResourceController.h"
#import "DSSceneController.h"
#import "DSSpriteObjectClassFactory.h"


enum DSInitSceneLabelIndices : short {
    DSInitSceneLabelIndicesDisplay = 0,
    DSInitSceneLabelIndicesDisplayValue,
    DSInitSceneLabelIndicesControl,
    DSInitSceneLabelIndicesControlValue,
    DSInitSceneLabelIndicesSound,
    DSInitSceneLabelIndicesSoundValue,
    DSInitSceneLabelIndicesMusic,
    DSInitSceneLabelIndicesMusicValue,
    DSInitSceneLabelIndicesStart
};

@interface DSInitSceneTest : DSKeyEventBaseTest<DSInitScene *> {
    SKView *_view;
    id _joystickController;
    id _resourceController;
    id _soundManager;
    id _spriteObjectClassFactory;
    id _sceneController;
}
@end

@implementation DSInitSceneTest

- (void)setUp {
    self.target = [[DSInitScene alloc] init];
    _joystickController = OCMClassMock(DSCoCoJoystickController.class);
    _resourceController = OCMClassMock(DSResourceController.class);
    _soundManager = OCMClassMock(DSSoundManager.class);
    _spriteObjectClassFactory = OCMClassMock(DSSpriteObjectClassFactory.class);
    self.target.resourceController = _resourceController;
    self.target.joystickController = _joystickController;
    _sceneController = OCMClassMock(DSSceneController.class);
    _view = OCMClassMock(SKView.class);
    
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Courier");
    NSString *resourceImagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"forest" ofType:@"png"];
    OCMStub([_resourceController imageWithName:@"Images/00-mainmenu.png"]).andReturn(resourceImagePath);
    OCMStub([_soundManager enabled]).andReturn(YES);
    OCMStub([_resourceController hiresMode]).andReturn(YES);
    OCMStub([_joystickController useHardwareJoystick]).andReturn(YES);
    
    self.target.soundManager = _soundManager;
    self.target.spriteObjectClassFactory = _spriteObjectClassFactory;
    [self.target didMoveToView:_view];
}

- (void)testInit {
    XCTAssertEqual(self.target.firstLevel, 1);
}

- (void)testFirstLevel {
    self.target.firstLevel = 10;
    XCTAssertEqual(self.target.firstLevel, 10);
}

- (void)testTextFromResolution {
    XCTAssertEqualObjects([DSInitScene textFromResolution:DSInitSceneDisplayLow], @"Low");
    XCTAssertEqualObjects([DSInitScene textFromResolution:DSInitSceneDisplayHigh], @"High");
}

- (void)testTextFromControl {
    XCTAssertEqualObjects([DSInitScene textFromControl:DSInitSceneControlJoystick], @"Joystick");
    XCTAssertEqualObjects([DSInitScene textFromControl:DSInitSceneControlKeyboard], @"Keyboard");
}

- (void)testTextFromSound {
    XCTAssertEqualObjects([DSInitScene textFromSound:DSInitSceneSoundLow], @"LoFi");
    XCTAssertEqualObjects([DSInitScene textFromSound:DSInitSceneSoundHigh], @"HiFi");
}

- (void)testDidMoveToView {
    XCTAssertEqual(self.target.labels.count, 9);
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesDisplay].text, @"[D]isplay:");
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesDisplayValue].text, @"High");
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesControl].text, @"[C]ontrol:");
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesControlValue].text, @"Joystick");
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesSound].text, @"[S]ound:");
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesSoundValue].text, @"LoFi");
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesMusic].text, @"M[u]sic:");
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesMusicValue].text, @"Yes");
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesStart].text, @"[Space] or joystick button to start");

    XCTAssertEqual(self.target.display, DSInitSceneDisplayHigh);
    XCTAssertEqual(self.target.control, DSInitSceneControlJoystick);
    XCTAssertEqual(self.target.sound, DSInitSceneSoundLow);
    XCTAssertTrue(self.target.musicEnabled);
    XCTAssertFalse(self.target.isDone);

    OCMVerify([_joystickController setUseHardwareJoystick:YES]);
    OCMVerify([_resourceController setHiresMode:YES]);
}

- (void)testDidMoveToViewAgain {
    __block int hiresModeCount = 0, useHardwareJoystickCount = 0, hifiModeCount = 0;
    OCMStub([_resourceController setHiresMode:YES]).andDo(^(NSInvocation *invocation) {
        hiresModeCount++;
    });
    OCMStub([_joystickController setUseHardwareJoystick:YES]).andDo(^(NSInvocation *invocation) {
        useHardwareJoystickCount++;
    });
    OCMStub([_resourceController setHifiMode:NO]).andDo(^(NSInvocation *invocation) {
        hifiModeCount++;
    });
    [self.target didMoveToView:_view];
    XCTAssertEqual(self.target.labels.count, 9);
    XCTAssertEqual(hiresModeCount, 1);
    XCTAssertEqual(useHardwareJoystickCount, 1);
    XCTAssertEqual(hifiModeCount, 1);
}

- (void)testWillMoveFromView {
    [self.target toggleDisplay];
    [self.target toggleControl];
    [self.target toggleSound];
    __block int hiresModeCount = 0, useHardwareJoystickCount = 0, hifiModeCount = 0;
    OCMStub([_resourceController setHiresMode:NO]).andDo(^(NSInvocation *invocation) {
        hiresModeCount++;
    });
    OCMStub([_joystickController setUseHardwareJoystick:NO]).andDo(^(NSInvocation *invocation) {
        useHardwareJoystickCount++;
    });
    OCMStub([_resourceController setHifiMode:YES]).andDo(^(NSInvocation *invocation) {
        hifiModeCount++;
    });
    [self.target willMoveFromView:_view];
    XCTAssertEqual(hiresModeCount, 1);
    XCTAssertEqual(useHardwareJoystickCount, 1);
    XCTAssertEqual(hifiModeCount, 1);
}

- (void)testKeyUpUnknownKey {
    [self unpressKey:@"x" modifiedChars:@""];
    XCTAssertEqual(self.target.display, DSInitSceneDisplayHigh);
    XCTAssertEqual(self.target.control, DSInitSceneControlJoystick);
    XCTAssertEqual(self.target.sound, DSInitSceneSoundLow);
}

- (void)testKeyUpToggleDisplay {
    // This one is a little tricky to test because we have to verify that the labels get updated before we set the resolution
    self.target.labels[DSInitSceneLabelIndicesDisplayValue].text = @"";
    self.target.labels[DSInitSceneLabelIndicesControlValue].text = @"";
    self.target.labels[DSInitSceneLabelIndicesSoundValue].text = @"";
    
    OCMStub([_resourceController setHiresMode:YES]).andDo(^(NSInvocation *invocation) {
        XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesDisplayValue].text, @"High");
        XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesControlValue].text, @"Keyboard");
        XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesSoundValue].text, @"LoFi");
    });
    
    [self unpressKey:@"d" modifiedChars:@""];
    
    XCTAssertEqual(self.target.display, DSInitSceneDisplayLow);
    XCTAssertEqual(self.target.control, DSInitSceneControlJoystick);
    XCTAssertEqual(self.target.sound, DSInitSceneSoundLow);
}

- (void)testKeyUpToggleKeyboard {
    [self unpressKey:@"c" modifiedChars:@""];
    XCTAssertEqual(self.target.display, DSInitSceneDisplayHigh);
    XCTAssertEqual(self.target.control, DSInitSceneControlKeyboard);
    XCTAssertEqual(self.target.sound, DSInitSceneSoundLow);
}

- (void)testKeyUpToggleSound {
    [self unpressKey:@"s" modifiedChars:@""];
    XCTAssertEqual(self.target.display, DSInitSceneDisplayHigh);
    XCTAssertEqual(self.target.control, DSInitSceneControlJoystick);
    XCTAssertEqual(self.target.sound, DSInitSceneSoundHigh);
}

- (void)testTransitionToNextScene {
    self.target.sceneController = _sceneController;
    OCMStub([_resourceController hifiMode]).andReturn(YES);
    DynospriteGlobalsPtr->UserGlobals_Init = YES;
    [self.target toggleSound];
    [self.target transitionToNextScreen];
    OCMVerify(times(1), [_soundManager loadCache]);
    OCMVerify(times(1), [_spriteObjectClassFactory loadCache]);
    XCTAssertTrue(self.target.isDone);
    XCTAssertFalse(DynospriteGlobalsPtr->UserGlobals_Init);
    OCMVerify([_soundManager setMaxNumSounds:10]);
    OCMVerify([_sceneController transitionSceneForLevel:1]);
}

- (void)testTransitionToDifferentScene {
    self.target.sceneController = _sceneController;
    self.target.firstLevel = 5;
    OCMStub([_resourceController hifiMode]).andReturn(YES);
    DynospriteGlobalsPtr->UserGlobals_Init = YES;
    [self.target toggleSound];
    [self.target transitionToNextScreen];
    OCMVerify(times(1), [_soundManager loadCache]);
    OCMVerify(times(1), [_spriteObjectClassFactory loadCache]);
    XCTAssertTrue(self.target.isDone);
    XCTAssertFalse(DynospriteGlobalsPtr->UserGlobals_Init);
    OCMVerify([_soundManager setMaxNumSounds:10]);
    OCMVerify([_sceneController transitionSceneForLevel:5]);
}

- (void)testPollJoystickButtonNotPressed {
    id joystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    OCMStub([_joystickController joystick]).andReturn(joystick);
    OCMStub([joystick button0Pressed]).andReturn(NO);
    OCMStub([joystick button1Pressed]).andReturn(YES);
    [self.target poll];
    XCTAssertFalse(self.target.isDone);
}

- (void)testPollJoystickButtonPressed {
    id joystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    OCMStub([_joystickController joystick]).andReturn(joystick);
    
    // Ignore if pressed from start
    const BOOL yesValue = YES, noValue = NO;
    __block int returnValuesIndex = 0;
    OCMStub([joystick button0Pressed]).andDo((^(NSInvocation *invocation) {
        NSLog(@"here");
        const BOOL *returnValues[] = {
            &yesValue, &noValue, &yesValue
        };
        [invocation setReturnValue: (void *)returnValues[returnValuesIndex]];
        returnValuesIndex++;
    }));
    OCMStub([joystick button1Pressed]).andReturn(NO);
    [self.target poll];
    XCTAssertFalse(self.target.isDone);
    
    // Ignore if unpressed
    [self.target poll];
    XCTAssertFalse(self.target.isDone);
    
    // Ack if pressed
    [self.target poll];
    XCTAssertTrue(self.target.isDone);
}

- (void)testMouseDown {
    [self.target transitionToNextScreen];
    XCTAssertTrue(self.target.isDone);
}

- (void)testToggleDisplay {
    [self.target toggleDisplay];
    XCTAssertEqual(self.target.display, DSInitSceneDisplayLow);
    OCMVerify([_resourceController setHiresMode:YES]);
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesDisplayValue].text, @"Low");
    [self.target toggleDisplay];
    OCMVerify([_resourceController setHiresMode:NO]);
    XCTAssertTrue([_resourceController hiresMode]);
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesDisplayValue].text, @"High");
}

- (void)testToggleControl {
    [self.target toggleControl];
    XCTAssertEqual(self.target.control, DSInitSceneControlKeyboard);
    OCMVerify([_joystickController setUseHardwareJoystick:NO]);
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesControlValue].text, @"Keyboard");
    [self.target toggleControl];
    XCTAssertEqual(self.target.control, DSInitSceneControlJoystick);
    OCMVerify([_joystickController setUseHardwareJoystick:YES]);
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesControlValue].text, @"Joystick");
}

- (void)testToggleMusic {
    XCTAssertTrue(self.target.musicEnabled);
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesMusicValue].text, @"Yes");
    [self.target toggleMusic];
    XCTAssertFalse(self.target.musicEnabled);
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesMusicValue].text, @"No");
    [self.target toggleMusic];
    XCTAssertTrue(self.target.musicEnabled);
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesMusicValue].text, @"Yes");
}

- (void)testToggleMusicDisabledWhenSoundOff {
    /* Toggle sound off */
    [self.target toggleSound];  /* HiFi */
    [self.target toggleSound];  /* No Sound */
    XCTAssertEqual(self.target.sound, DSInitSceneSoundNone);
    XCTAssertFalse(self.target.musicEnabled);
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesMusicValue].text, @"No");
    /* Toggling music should have no effect when sound is off */
    [self.target toggleMusic];
    XCTAssertFalse(self.target.musicEnabled);
}

- (void)testKeyUpToggleMusic {
    [self unpressKey:@"u" modifiedChars:@""];
    XCTAssertFalse(self.target.musicEnabled);
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesMusicValue].text, @"No");
}

- (void)testToggleSound {
    [self.target toggleSound];
    XCTAssertEqual(self.target.sound, DSInitSceneSoundHigh);
    OCMVerify([_resourceController setHifiMode:YES]);
    OCMVerify([_soundManager setEnabled:YES]);
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesSoundValue].text, @"HiFi");
    [self.target toggleSound];
    XCTAssertEqual(self.target.sound, DSInitSceneSoundNone);
    OCMVerify([_resourceController setHifiMode:NO]);
    OCMVerify([_soundManager setEnabled:NO]);
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesSoundValue].text, @"No Sound");
    [self.target toggleSound];
    XCTAssertEqual(self.target.sound, DSInitSceneSoundLow);
    OCMVerify([_resourceController setHifiMode:NO]);
    OCMVerify([_soundManager setEnabled:YES]);
    XCTAssertEqualObjects(self.target.labels[DSInitSceneLabelIndicesSoundValue].text, @"LoFi");
}

@end
