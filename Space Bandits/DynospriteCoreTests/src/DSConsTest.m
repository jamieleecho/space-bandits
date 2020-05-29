//
//  DSConsTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 5/25/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSCons.h"

@interface DSConsTest : XCTestCase {
    DSCons *_target;
}
@end

@implementation DSConsTest

- (void)setUp {
    _target = [[DSCons alloc] initWithCar:@"hello" andCdr:@312];
}

- (void)testInit {
    XCTAssertEqualObjects(_target.car, @"hello");
    XCTAssertEqualObjects(_target.cdr, @312);
    
    _target = [[DSCons alloc] init];
    XCTAssertNil(_target.car);
    XCTAssertNil(_target.cdr);
}

- (void)testProperties {
    _target.car = @"goodbye";
    _target.cdr = @432;
    XCTAssertEqualObjects(_target.car, @"goodbye");
    XCTAssertEqualObjects(_target.cdr, @432);
}

@end
