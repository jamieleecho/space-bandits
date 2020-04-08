//
//  DSLevelRegistryTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSLevelRegistry.h"

@interface DSLevelRegistryTest : XCTestCase {
    DSLevelRegistry *_target;
    DSLevel *_level1;
    DSLevel *_level2;
}

@end


static void myLevel1Init(void) { }
static byte myLevel1BackgroundNewXY(void) { return 0; }
static void myLevel2Init(void) { }
static byte myLevel2BackgroundNewXY(void) { return 0; }


@implementation DSLevelRegistryTest

- (void)setUp {
    _target = [[DSLevelRegistry alloc] init];
    _level1 = [[DSLevel alloc] initWithInitLevel:myLevel1Init backgroundNewXY:myLevel1BackgroundNewXY];
    _level2 = [[DSLevel alloc] initWithInitLevel:myLevel2Init backgroundNewXY:myLevel2BackgroundNewXY];
}

- (void)tearDown {
    [[DSLevelRegistry sharedInstance] clear];
}

- (void)testSharedInstance {
    XCTAssertNotEqual(_target, [DSLevelRegistry sharedInstance]);
    [[DSLevelRegistry sharedInstance] addLevel:_level1 fromFile:@"01-foo.c"];
    XCTAssertEqual([[DSLevelRegistry sharedInstance] levelForIndex:1], _level1);
}

- (void)testAddingAndRetrieving {
    XCTAssertNil([_target levelForIndex:5]);
    [_target addLevel:_level2 fromFile:@"/bar/23/baz/volumes /05-foo.c"];
    XCTAssertEqual([_target levelForIndex:5], _level2);
}

- (void)testClearing {
    [_target addLevel:_level2 fromFile:@"05-foo.c"];
    [_target clear];
    XCTAssertNil([_target levelForIndex:5]);
}

@end
