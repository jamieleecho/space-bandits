//
//  DynospriteTests.m
//  DynospriteTests
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSLevelRegistry.h"
#include "dynosprite.h"

@interface DynospriteCoreTests : XCTestCase

@end

static void myLevel1Init(void) { }
static byte myLevel1BackgroundNewXY(void) { return 0; }

@implementation DynospriteCoreTests

- (void)tearDown {
    [[DSLevelRegistry sharedInstance] clear];
}

- (void)testDSLevelRegistryRegister {
    DSLevelRegistryRegister(myLevel1Init, myLevel1BackgroundNewXY, "/foo/32/bar/32-Awesome.c");
    DSLevel *level = [[DSLevelRegistry sharedInstance] levelForIndex:32];
    XCTAssertEqual((void *)level.initLevel, (void *)myLevel1Init);
    XCTAssertEqual((void *)level.backgroundNewXY, (void *)myLevel1BackgroundNewXY);
}

@end
