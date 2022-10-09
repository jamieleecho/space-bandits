//
//  DSMutableArrayWrapperTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 10/9/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DSMutableArrayWrapper.h"


@interface DSMutableArrayWrapperTest : XCTestCase {
    DSMutableArrayWrapper *_target;
}

@end


@implementation DSMutableArrayWrapperTest

- (void)setUp {
    _target = [[DSMutableArrayWrapper alloc] init];
}

- (void)testInit {
    XCTAssertTrue([_target.array isKindOfClass:NSMutableArray.class]);
    XCTAssertEqual(_target.array.count, 0);
    DSMutableArrayWrapper *wrapper = [[DSMutableArrayWrapper alloc] init];
    XCTAssertNotEqual(_target.array, wrapper.array);
}

@end
