//
//  DSResourceControllerTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/11/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "DSResourceController.h"


@interface DSResourceControllerTest : XCTestCase {
    DSResourceController *_target;
    id _bundle;
}
@end


@implementation DSResourceControllerTest

- (void)setUp {
    _target = [[DSResourceController alloc] init];
    _bundle = OCMClassMock(NSBundle.class);
}

- (void)testInit {
    XCTAssertFalse(_target.hiresMode);
    XCTAssertFalse(_target.hifiMode);
    XCTAssertEqual(_target.bundle, NSBundle.mainBundle);
}

- (void)testSelectsRightFont {
    XCTAssertEqual(_target.fontForDisplay, @"pcgfont");
    _target.hiresMode = YES;
    XCTAssertEqual(_target.fontForDisplay, @"Monaco");
}

- (void)testSelectsRightImage {
    OCMStub([_bundle pathForResource:@"forest" ofType:@"png" inDirectory:@"hires/resources/foo"]).andReturn(@"resources/foo/hires/forest.png");
    _target.bundle = _bundle;
    XCTAssertEqualObjects([_target imageWithName:@"resources/foo/forest.png"], @"resources/foo/forest.png");
    
    _target.hiresMode = YES;
    XCTAssertEqualObjects([_target imageWithName:@"resources/foo/forest.png"], @"hires/resources/foo/forest.png");
}

- (void)testSelectsRightSound {
    OCMStub([_bundle pathForResource:@"ping" ofType:@"wav" inDirectory:@"hires/resources/foo"]).andReturn(@"resources/foo/hires/ping.wav");
    _target.bundle = _bundle;
    XCTAssertEqualObjects([_target soundWithName:@"resources/foo/ping.wav"], @"resources/foo/ping.wav");
    
    _target.hifiMode = YES;
    XCTAssertEqualObjects([_target soundWithName:@"resources/foo/ping.wav"], @"hires/resources/foo/ping.wav");
}

@end
