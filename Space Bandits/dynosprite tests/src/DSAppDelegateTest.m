//
//  DSAppDelegateTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/9/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "DSAppDelegate.h"


@interface DSAppDelegateTest : XCTestCase {
    DSAppDelegate *_target;
    DSDefaultsConfig *_defaultsConfig;
    id _assetLoader;
    id _configFileParser;
    id _defaultsConfigLoader;
    id _joystickController;
    id _sceneController;
    id _soundManager;
    id _resourceController;
}
@end


@implementation DSAppDelegateTest

- (void)setUp {
    _target = [[DSAppDelegate alloc] init];
    _defaultsConfig = [[DSDefaultsConfig alloc] init];
    _assetLoader = OCMClassMock(DSAssetLoader.class);
    _configFileParser = OCMClassMock(DSConfigFileParser.class);
    _defaultsConfigLoader = OCMClassMock(DSDefaultsConfigLoader.class);
    _joystickController = OCMClassMock(DSCoCoJoystickController.class);
    _resourceController = OCMClassMock(DSResourceController.class);
    _sceneController = OCMClassMock(DSSceneController.class);
    _soundManager = OCMClassMock(DSSoundManager.class);

    _defaultsConfig.enableSound = YES;
    _defaultsConfig.firstLevel = 32;
    _defaultsConfig.hifiMode = YES;
    _defaultsConfig.hiresMode = YES;
    _defaultsConfig.useKeyboard = NO;
    
    OCMStub([_defaultsConfigLoader defaultsConfig]).andReturn(_defaultsConfig);
    
    _target.assetLoader = _assetLoader;
    _target.configFileParser = _configFileParser;
    _target.defaultsConfigLoader = _defaultsConfigLoader;
    _target.joystickController = _joystickController;
    _target.resourceController = _resourceController;
    _target.sceneController = _sceneController;
    _target.soundManager = _soundManager;
}

- (void)testConfigFileParser {
    XCTAssertEqual(_target.configFileParser, _configFileParser);
}

- (void)testTransitionSceneController {
    XCTAssertEqual(_target.sceneController, _sceneController);
}

- (void)testAwakeFromNib {
    [_target awakeFromNib];
    OCMVerify([_sceneController setClassRegistry:DSObjectClassDataRegistry.sharedInstance]);
    OCMVerify([_assetLoader setRegistry:DSLevelRegistry.sharedInstance]);
    
    OCMVerify([_defaultsConfigLoader loadDefaultsConfig]);
    OCMVerify([_soundManager setEnabled:_defaultsConfig.enableSound]);
    OCMVerify([_resourceController setHiresMode:_defaultsConfig.hiresMode]);
    OCMVerify([_resourceController setHifiMode:_defaultsConfig.hifiMode]);
    OCMVerify([_sceneController setFirstLevel:_defaultsConfig.firstLevel]);

    OCMVerify([_joystickController setUseHardwareJoystick:!_defaultsConfig.useKeyboard]);

    OCMVerify([(DSAssetLoader *)_assetLoader loadLevels]);
    OCMVerify([(DSAssetLoader *)_assetLoader loadSceneInfos]);
    OCMVerify([(DSAssetLoader *)_assetLoader loadTransitionSceneImages]);
    OCMVerify([(DSAssetLoader *)_assetLoader loadTileSets]);
    OCMVerify([(DSAssetLoader *)_assetLoader loadSprites]);
    OCMVerify([(DSAssetLoader *)_assetLoader loadSounds]);
    OCMVerifyAll(_assetLoader);
    
    XCTAssertEqual(DSSoundManager.sharedInstance, _soundManager);
}

- (void)testApplicationShouldTerminateAfterLastWindowClosed {
    XCTAssertTrue([_target applicationShouldTerminateAfterLastWindowClosed:nil]);
}

@end
