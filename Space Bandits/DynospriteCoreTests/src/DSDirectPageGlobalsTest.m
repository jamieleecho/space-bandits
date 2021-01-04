//
//  DSDirectPageGlobalsTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/3/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSDirectPageGlobals.h"
#import "dynosprite.h"

@interface DSDirectPageGlobalsTest : XCTestCase {
    DSDirectPageGlobals *_target;
    DynospriteDirectPageGlobals _directPageGlobals;
    DynospriteGlobals _globals;
}

@end

@implementation DSDirectPageGlobalsTest

- (void)setUp {
    _target = [[DSDirectPageGlobals alloc] initWithDirectPageGlobals:&_directPageGlobals andGlobals:&_globals];
}

- (void)testReturnsGlobals {
    XCTAssertEqual(&_directPageGlobals, _target.directPageGlobals);
    XCTAssertEqual(&_globals, _target.globals);
}

- (void)testSimpleInit {
    DSDirectPageGlobals *target = [[DSDirectPageGlobals alloc] init];
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr, target.directPageGlobals);
    XCTAssertEqual(DynospriteGlobalsPtr, target.globals);
}

- (void)testSharedInstance {
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr, DSDirectPageGlobals.sharedInstance.directPageGlobals);
    XCTAssertEqual(DynospriteGlobalsPtr, DSDirectPageGlobals.sharedInstance.globals);
    XCTAssertEqual(DSDirectPageGlobals.sharedInstance, DSDirectPageGlobals.sharedInstance);
}

@end
