//
//  DSTransitionImageInfoTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/25/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSTransitionSceneInfo.h"


@interface DSTransitionSceneInfoTest : XCTestCase {
    DSTransitionSceneInfo *_target;
}

@end

@implementation DSTransitionSceneInfoTest

- (void)setUp {
    _target = [[DSTransitionSceneInfo alloc] init];
}

- (void)testInit {
    XCTAssertEqual(_target.backgroundColor, UIColor.whiteColor);
    XCTAssertEqual(_target.foregroundColor, UIColor.blackColor);
    XCTAssertEqual(_target.progressColor, UIColor.greenColor);
    XCTAssertEqualObjects(_target.backgroundImageName, @"");
}

- (void)testProperties {
    _target.backgroundColor = UIColor.brownColor;
    _target.foregroundColor = UIColor.blueColor;
    _target.progressColor = UIColor.redColor;
    _target.backgroundImageName = @"/foo/bar/baz";
    XCTAssertEqual(_target.backgroundColor, UIColor.brownColor);
    XCTAssertEqual(_target.foregroundColor, UIColor.blueColor);
    XCTAssertEqual(_target.progressColor, UIColor.redColor);
    XCTAssertEqualObjects(_target.backgroundImageName, @"/foo/bar/baz");
}

@end
