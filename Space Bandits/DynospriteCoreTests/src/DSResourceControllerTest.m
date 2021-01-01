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

- (void)testSelectsRightSpriteImage {
    OCMStub([_bundle pathForResource:@"moon" ofType:@"gif" inDirectory:@"sprites"]).andReturn(@"sprites/moon.gif");
    OCMStub([_bundle pathForResource:@"moon" ofType:@"gif" inDirectory:@"tiles"]).andReturn(@"tiles/moon.gif");
    OCMStub([_bundle pathForResource:@"moon" ofType:@"gif" inDirectory:@"hires/sprites"]).andReturn(@"sprites/hires/moon.gif");
    OCMStub([_bundle pathForResource:@"moon" ofType:@"gif" inDirectory:@"hires/tiles"]).andReturn(@"hires/tiles/moon.gif");

    _target.bundle = _bundle;
    XCTAssertEqualObjects([_target spriteImageWithName:@"moon.gif"], @"sprites/moon.gif");
    XCTAssertEqualObjects([_target spriteImageWithName:@"../tiles/moon.gif"], @"tiles/moon.gif");
    _target.hiresMode = YES;
    XCTAssertEqualObjects([_target spriteImageWithName:@"moon.gif"], @"hires/sprites/moon.gif");
    XCTAssertEqualObjects([_target spriteImageWithName:@"../tiles/moon.gif"], @"hires/tiles/moon.gif");
}

- (void)testSelectsRightConfigFile {
    OCMStub([_bundle pathForResource:@"JSONList" ofType:@"json" inDirectory:@"hires/resources/foo"]).andReturn(@"hires/resources/foo/JSONList.json");
    OCMStub([_bundle resourcePath]).andReturn(@"foo.app/Contents/Resources");
    _target.bundle = _bundle;
    XCTAssertEqualObjects([_target pathForConfigFileWithName:@"resources/foo/JSONList.json"], @"foo.app/Contents/Resources/resources/foo/JSONList.json");
    
    _target.hiresMode = YES;
    XCTAssertEqualObjects([_target pathForConfigFileWithName:@"resources/foo/JSONList.json"], @"foo.app/Contents/Resources/hires/resources/foo/JSONList.json");
}

- (void)testSelectsRightSound {
    OCMStub([_bundle pathForResource:@"ping" ofType:@"wav" inDirectory:@"hires/resources/foo"]).andReturn(@"resources/foo/hires/ping.wav");
    _target.bundle = _bundle;
    XCTAssertEqualObjects([_target soundWithName:@"resources/foo/ping.wav"], @"resources/foo/ping.wav");
    
    _target.hifiMode = YES;
    XCTAssertEqualObjects([_target soundWithName:@"resources/foo/ping.wav"], @"hires/resources/foo/ping.wav");
}

@end
