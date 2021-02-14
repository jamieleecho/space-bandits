//
//  DSPointTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DSPoint.h"

@interface DSPointTest : XCTestCase

@end

@implementation DSPointTest

- (void)testDSPointMake {
    DSPoint target = DSPointMake(32, -20);
    XCTAssertEqual(target.x, 32);
    XCTAssertEqual(target.y, -20);
}

- (void)testDSPointAdd {
    DSPoint p1 = DSPointMake(32, -20);
    DSPoint p2 = DSPointMake(132, -200);
    DSPoint target = DSPointAdd(p1, p2);
    XCTAssertEqual(target.x, 164);
    XCTAssertEqual(target.y, -220);
}

- (void)testDSPointSub {
    DSPoint p1 = DSPointMake(32, -20);
    DSPoint p2 = DSPointMake(132, -200);
    DSPoint target = DSPointSub(p1, p2);
    XCTAssertEqual(target.x, -100);
    XCTAssertEqual(target.y, 180);
}

- (void)testDSPointEqual {
    DSPoint p1 = DSPointMake(32, -20);
    DSPoint p2 = DSPointMake(132, -20);
    DSPoint p3 = DSPointMake(32, -200);
    XCTAssertTrue(DSPointEqual(p1, p1));
    XCTAssertTrue(DSPointEqual(p2, p2));
    XCTAssertFalse(DSPointEqual(p1, p2));
    XCTAssertFalse(DSPointEqual(p1, p3));
    XCTAssertFalse(DSPointEqual(p2, p3));
}


@end
