//
//  DSDefaultsConfigTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 9/24/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSDefaultsConfig.h"

@interface DSDefaultsConfigTest : XCTestCase {
    DSDefaultsConfig *_target;
}
@end

@implementation DSDefaultsConfigTest

- (void)setUp {
    _target = [[DSDefaultsConfig alloc] init];
}

- (void)testInit {
    XCTAssertEqual(_target.firstLevel, 1);
    XCTAssertTrue(_target.useKeyboard);
    XCTAssertFalse(_target.hiresMode);
    XCTAssertTrue(_target.enableSound);
    XCTAssertFalse(_target.hifiMode);
}

- (void)testUpdatesFirstLevel {
    _target.firstLevel = 5;
    XCTAssertEqual(_target.firstLevel, 5);
}

- (void)testUpdatesUseKeyboard {
    _target.useKeyboard = NO;
    XCTAssertFalse(_target.useKeyboard);
}

- (void)testUpdatesHiresMode {
    _target.hiresMode = YES;
    XCTAssertTrue(_target.hiresMode);
}

- (void)testUpdatesEnableSound {
    _target.enableSound = NO;
    XCTAssertFalse(_target.enableSound);
}

- (void)testUpdatesHifiMode {
    _target.hifiMode = YES;
    XCTAssertTrue(_target.hifiMode);
}

@end
