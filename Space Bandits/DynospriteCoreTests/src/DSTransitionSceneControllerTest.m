//
//  DSTransitionControllerTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 1/27/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSTransitionSceneController.h"


@interface DSTransitionSceneControllerTest : XCTestCase {
    DSTransitionSceneController *_target;
    NSDictionary *_initImage;
    NSDictionary *_level1Image;
    NSDictionary *_level2Image;
}

@end

@implementation DSTransitionSceneControllerTest

- (void)setUp {
    _initImage = @{
        @"BackgroundColor": @"ffffff",
        @"ForegroundColor": @"000000",
        @"ProgressColor": @"1bb43a"
    };
    _level1Image = @{
        @"BackgroundColor": @"1fffff",
        @"ForegroundColor": @"100000",
        @"ProgressColor": @"1bb43a"
    };
    _level2Image = @{
        @"BackgroundColor": @"2fffff",
        @"ForegroundColor": @"200000",
        @"ProgressColor": @"3bb43a"
    };

    _target = [[DSTransitionSceneController alloc] initWithImageDictionaries:@[_initImage, _level1Image, _level2Image]];
}

- (void)testCreatesColors {
    XCTAssertEqualObjects([DSTransitionSceneController colorFromRGBString:@"f3Ab24"],
                          [NSColor colorWithCalibratedRed:0xf3/255.0f green:0xab/255.0f blue:0x24/255.0f alpha:1]);
    XCTAssertThrows([DSTransitionSceneController colorFromRGBString:@"#f3Ab24"]);
    XCTAssertThrows([DSTransitionSceneController colorFromRGBString:@"f3Ab24aa"]);
}

- (void)testCreatesLevels {
    DSTransitionScene *initScene = [_target transitionSceneForLevel:0];
    XCTAssertEqualObjects(initScene.backgroundColor, [[NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.0f] colorUsingColorSpace:initScene.backgroundColor.colorSpace]);
    XCTAssertEqualObjects(initScene.foregroundColor, [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:1.0f]);
    XCTAssertEqualObjects(initScene.progressBarColor, [NSColor colorWithCalibratedRed:0x1b/255.0f green:0xb4/255.0f blue:0x3a/255.0f alpha:1]);
}

- (void)testCreatesNewLevels {
    DSTransitionScene *scene1 = [_target transitionSceneForLevel:2];
    DSTransitionScene *scene2 = [_target transitionSceneForLevel:2];
    XCTAssertNotEqual(scene1, scene2);
}

@end
