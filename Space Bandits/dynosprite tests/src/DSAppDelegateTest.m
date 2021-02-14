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
    id _configFileParser;
    id _sceneController;
    id _assetLoader;
    id _soundManager;
}
@end


@implementation DSAppDelegateTest

- (void)setUp {
    _target = [[DSAppDelegate alloc] init];
    _configFileParser = OCMClassMock(DSConfigFileParser.class);
    _target.configFileParser = _configFileParser;
    _sceneController = OCMClassMock(DSSceneController.class);
    _target.sceneController = _sceneController;
    _assetLoader = OCMClassMock(DSAssetLoader.class);
    _target.assetLoader = _assetLoader;
    _soundManager = OCMClassMock(DSSoundManager.class);
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
