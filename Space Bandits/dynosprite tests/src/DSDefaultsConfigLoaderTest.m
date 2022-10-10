//
//  DSDefaultsConfigLoaderTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 10/2/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "DSDefaultsConfigLoader.h"

@interface DSDefaultsConfigLoaderTest : XCTestCase {
    DSDefaultsConfigLoader *_target;
    NSBundle *_mockBundle;
}

@end

@implementation DSDefaultsConfigLoaderTest

- (void)setUp {
    _target = [[DSDefaultsConfigLoader alloc] init];
    _mockBundle = OCMClassMock(NSBundle.class);
}

- (void)testInit {
    XCTAssertNotNil(_target.defaultsConfig);
    XCTAssertEqualObjects(_target.defaultsConfig, [[DSDefaultsConfig alloc] init]);
    XCTAssertEqual(_target.bundle, NSBundle.mainBundle);
}

- (void)testLoadsValidDefaults {
    id originalDefaultsConfig = _target.defaultsConfig;
    _target.bundle = [NSBundle bundleForClass:self.class];
    [_target loadDefaultsConfig];
    XCTAssertNotEqual(_target.defaultsConfig, originalDefaultsConfig);
    XCTAssertEqual(_target.defaultsConfig.firstLevel, 32);
    XCTAssertFalse(_target.defaultsConfig.useKeyboard);
    XCTAssertTrue(_target.defaultsConfig.hiresMode);
    XCTAssertFalse(_target.defaultsConfig.enableSound);
    XCTAssertTrue(_target.defaultsConfig.hifiMode);
}

- (void)testLoadsEmptyDefaults {
    _target.bundle = _mockBundle;
    NSString *emptyJsonPath = [[NSBundle bundleForClass:self.class] pathForResource:@"empty" ofType:@"json"];
    OCMStub([_mockBundle pathForResource:@"defaults-config" ofType:@"json"]).andReturn(emptyJsonPath);
    id originalDefaultsConfig = _target.defaultsConfig;
    [_target loadDefaultsConfig];
    XCTAssertNotEqual(_target.defaultsConfig, originalDefaultsConfig);
    XCTAssertEqualObjects(_target.defaultsConfig, [[DSDefaultsConfig alloc] init]);
}

@end
