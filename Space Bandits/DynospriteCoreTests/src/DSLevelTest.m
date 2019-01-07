//
//  DSLevelTest.m
//  DynospriteTests
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

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInitialization {
    DSLevel *level = [[DSLevel alloc] initWithInitLevel:myLevelInit backgroundNewXY:myLevelBackgroundNewXY];
    XCTAssertEqual((void *)level.initLevel, (void *)myLevelInit);
    XCTAssertEqual((void *)level.backgroundNewXY, (void *)myLevelBackgroundNewXY);
}

@end
