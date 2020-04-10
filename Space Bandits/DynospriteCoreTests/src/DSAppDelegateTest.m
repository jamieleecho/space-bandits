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
}
@end


@implementation DSAppDelegateTest

- (void)setUp {
    _target = [[DSAppDelegate alloc] init];
    _configFileParser = OCMClassMock(DSConfigFileParser.class);
    _target.configFileParser = _configFileParser;
    _transitionSceneController = OCMClassMock(DSTransitionSceneController.class);
    _target.transitionSceneController = _transitionSceneController;
}

- (void)testConfigFileParser {
    XCTAssertEqual(_target.configFileParser, _configFileParser);
}

- (void)testTransitionSceneController {
    XCTAssertEqual(_target.transitionSceneController, _transitionSceneController);
}

- (void)testAwakeFromNib {
    NSArray *images = [[NSArray alloc] init];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:images, @"images", nil];
    OCMStub([_configFileParser parseResourceNamed:@"images/images"]).andReturn(dictionary);
    [_target awakeFromNib];
    OCMVerify([_transitionSceneController setImages:images]);
}

- (void)testApplicationShouldTerminateAfterLastWindowClosed {
    XCTAssertTrue([_target applicationShouldTerminateAfterLastWindowClosed:nil]);
}

@end
