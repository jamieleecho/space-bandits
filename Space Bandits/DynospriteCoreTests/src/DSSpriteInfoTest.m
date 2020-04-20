//
//  DSSpriteInfoTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSSpriteInfo.h"


@interface DSSpriteInfoTest : XCTestCase {
    DSSpriteInfo *_target;
}

@end

@implementation DSSpriteInfoTest

- (void)setUp {
    _target = [[DSSpriteInfo alloc] init];
}

- (void)testInit {
    XCTAssertEqualObjects(_target.name, @"");
    XCTAssertTrue(DSPointEqual(_target.location, DSPointMake(0, 0)));
    XCTAssertFalse(_target.singlePixelPosition);
}

- (void)testProperties {
    _target.name = @"ship";
    _target.location = DSPointMake(32, 74);
    _target.singlePixelPosition = YES;
    
    XCTAssertEqualObjects(_target.name, @"ship");
    XCTAssertTrue(DSPointEqual(_target.location, DSPointMake(32, 74)));
    XCTAssertTrue(_target.singlePixelPosition);
}

@end
