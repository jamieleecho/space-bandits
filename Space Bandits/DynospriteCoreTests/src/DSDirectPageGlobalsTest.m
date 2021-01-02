//
//  DSDirectPageGlobalsTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/3/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSDirectPageGlobals.h"

@interface DSDirectPageGlobalsTest : XCTestCase {
    DSDirectPageGlobals *_target;
    DynospriteDirectPageGlobals _globals;
}

@end

extern DynospriteDirectPageGlobals *DynospriteDirectPageGlobalsPtr;

@implementation DSDirectPageGlobalsTest

- (void)setUp {
    _target = [[DSDirectPageGlobals alloc] initWithGlobals:&_globals];
}

- (void)testReturnsGlobals {
    XCTAssertEqual(&_globals, _target.globals);
}

- (void)testSimpleInit {
    DSDirectPageGlobals *target = [[DSDirectPageGlobals alloc] init];
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr, target.globals);
}


- (void)testSharedInstance {
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr, DSDirectPageGlobals.sharedInstance.globals);
    XCTAssertEqual(DSDirectPageGlobals.sharedInstance, DSDirectPageGlobals.sharedInstance);
}

@end
