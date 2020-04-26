//
//  DSTransitionSceneInfoFileParserTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/25/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSTransitionSceneInfoFileParser.h"

@interface DSTransitionSceneInfoFileParserTest : XCTestCase

@end

@implementation DSTransitionSceneInfoFileParserTest

- (void)setUp {
}

- (void)testCreatesColors {
    XCTAssertEqualObjects([DSTransitionSceneInfoFileParser colorFromRGBString:@"f3Ab24"],
                          [NSColor colorWithCalibratedRed:0xf3/255.0f green:0xab/255.0f blue:0x24/255.0f alpha:1]);
    XCTAssertThrows([DSTransitionSceneInfoFileParser colorFromRGBString:@"#f3Ab24"]);
    XCTAssertThrows([DSTransitionSceneInfoFileParser colorFromRGBString:@"f3Ab24aa"]);
}

@end
