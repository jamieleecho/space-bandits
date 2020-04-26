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
    id _transitionSceneController;
    id _levelLoader;
}
@end


@implementation DSAppDelegateTest

- (void)setUp {
    _target = [[DSAppDelegate alloc] init];
    _configFileParser = OCMClassMock(DSConfigFileParser.class);
    _target.configFileParser = _configFileParser;
    _transitionSceneController = OCMClassMock(DSTransitionSceneController.class);
    _target.transitionSceneController = _transitionSceneController;
    _levelLoader = OCMClassMock(DSAssetLoader.class);
    _target.levelLoader = _levelLoader;
}

- (void)testConfigFileParser {
    XCTAssertEqual(_target.configFileParser, _configFileParser);
}

- (void)testTransitionSceneController {
    XCTAssertEqual(_target.transitionSceneController, _transitionSceneController);
}

- (void)testAwakeFromNib {
    [_target awakeFromNib];
    OCMVerify([(DSAssetLoader *)_levelLoader loadLevels]);
    OCMVerify([(DSAssetLoader *)_levelLoader loadSceneInfos]);
}

- (void)testApplicationShouldTerminateAfterLastWindowClosed {
    XCTAssertTrue([_target applicationShouldTerminateAfterLastWindowClosed:nil]);
}

@end
