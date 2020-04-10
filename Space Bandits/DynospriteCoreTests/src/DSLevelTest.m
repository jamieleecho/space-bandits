//
//  DSLevelTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSLevel.h"

static void myLevelInit(void) { }
static byte myLevelBackgroundNewXY(void) { return 0; }

@interface DSLevelTest : XCTestCase

@end

@implementation DSLevelTest

- (void)testInitialization {
    DSLevel *level = [[DSLevel alloc] initWithInitLevel:myLevelInit backgroundNewXY:myLevelBackgroundNewXY];
    XCTAssertEqual((void *)level.initLevel, (void *)myLevelInit);
    XCTAssertEqual((void *)level.backgroundNewXY, (void *)myLevelBackgroundNewXY);
}

@end
