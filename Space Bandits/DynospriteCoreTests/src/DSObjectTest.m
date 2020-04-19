//
//  DSObjectTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/18/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DSObject.h"


@interface DSObjectTest : XCTestCase {
    DSObject *_target;
}

@end

@implementation DSObjectTest

- (void)setUp {
    _target = [[DSObject alloc] init];
}

- (void)testInit {
    XCTAssertEqual(_target.groupID, 0);
    XCTAssertEqual(_target.objectID, 0);
    XCTAssertEqual(_target.initialActive, 0);
    XCTAssertEqual(_target.initialGlobalX, 0);
    XCTAssertEqual(_target.initialGlobalY, 0);
    XCTAssertEqual(_target.initialData.count, 0);
}

- (void)testProperties {
    _target.groupID = 1;
    _target.objectID = 2;
    _target.initialActive = 3;
    _target.initialGlobalX = 4;
    _target.initialGlobalY = 5;
    NSArray<NSNumber *> *arr = [NSArray arrayWithObjects:[NSNumber numberWithInt:6], nil];
    _target.initialData = arr;
    
    XCTAssertEqual(_target.groupID, 1);
    XCTAssertEqual(_target.objectID, 2);
    XCTAssertEqual(_target.initialActive, 3);
    XCTAssertEqual(_target.initialGlobalX, 4);
    XCTAssertEqual(_target.initialGlobalY, 5);
    XCTAssertEqual(_target.initialData, arr);
}

@end
