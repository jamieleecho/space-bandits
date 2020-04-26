//
//  DSTransitionImageInfoTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/25/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Cocoa/Cocoa.h>
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
    XCTAssertEqual(_target.backgroundColor, NSColor.whiteColor);
    XCTAssertEqual(_target.foregroundColor, NSColor.blackColor);
    XCTAssertEqual(_target.progressColor, NSColor.greenColor);
}

- (void)testProperties {
    _target.backgroundColor = NSColor.brownColor;
    _target.foregroundColor = NSColor.blueColor;
    _target.progressColor = NSColor.redColor;
    XCTAssertEqual(_target.backgroundColor, NSColor.brownColor);
    XCTAssertEqual(_target.foregroundColor, NSColor.blueColor);
    XCTAssertEqual(_target.progressColor, NSColor.redColor);
}

@end
