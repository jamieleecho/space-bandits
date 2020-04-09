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
    DSResourceController *_resourceController;
    DSCoCoJoystickController *_joystickController;
    SKView *_view;
}
@end

@implementation DSInitSceneTest

- (void)setUp {
    _target = [[DSInitScene alloc] init];
    _resourceController = OCMClassMock(DSResourceController.class);
    _joystickController = OCMClassMock(DSCoCoJoystickController.class);
    _target.resourceController = _resourceController;
    _target.joystickController = _joystickController;
    _view = [[SKView alloc] init];
    
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Courier");
    NSString *resourceImagePath = [[NSBundle bundleForClass:self.class] pathForImageResource:@"forest"];
    OCMStub([_resourceController imageWithName:@"Images/00-mainmenu.png"]).andReturn(resourceImagePath);
    [_target didMoveToView:_view];
}

- (void)tearDown {
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
    
    OCMVerify([_joystickController setUseHardwareJoystick:NO]);
}

- (void)testToggleDisplay {
    [_target toggleDisplay];
    XCTAssertEqual(_target.display, DSInitSceneDisplayHigh);
    OCMVerify([_resourceController setHiresMode:YES]);
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesDisplayValue].text, @"High");
    [_target toggleDisplay];
    OCMVerify([_resourceController setHiresMode:NO]);
    XCTAssertFalse(_resourceController.hiresMode);
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
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesSoundValue].text, @"HiFi");
    [_target toggleSound];
    XCTAssertEqual(_target.sound, DSInitSceneSoundLow);
    XCTAssertEqualObjects(_target.labels[DSInitSceneLabelIndicesSoundValue].text, @"LoFi");
}

@end
