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

@interface DSLevelTest : XCTestCase {
    DSLevel *_target;
}
@end

@implementation DSLevelTest

- (void)setUp {
    _target = [[DSLevel alloc] initWithInitLevel:myLevelInit backgroundNewXY:myLevelBackgroundNewXY];
}

- (void)testInitialization {
    XCTAssertEqual((void *)_target.initLevel, (void *)myLevelInit);
    XCTAssertEqual((void *)_target.backgroundNewXY, (void *)myLevelBackgroundNewXY);

    XCTAssertTrue([_target.objectGroupIndices isKindOfClass:NSArray.class]);
    XCTAssertEqual(_target.objectGroupIndices.count, 0);
    XCTAssertEqual(_target.maxObjectTableSize, 0);
    XCTAssertEqual(_target.tilesetIndex, 0);
    XCTAssertEqual(_target.tilemapImagePath, @"");
    XCTAssertEqual(_target.tilemapStart.x, 0);
    XCTAssertEqual(_target.tilemapStart.y, 0);
    XCTAssertEqual(_target.tilemapSize.x, 0);
    XCTAssertEqual(_target.tilemapSize.y, 0);
    XCTAssertEqual(_target.bkgrndStartX, 0);
    XCTAssertEqual(_target.bkgrndStartX, 0);
    XCTAssertTrue([_target.objects isKindOfClass:NSArray.class]);
    XCTAssertEqual(_target.objects.count, 0);
}

- (void)testProperties {
    NSArray *arr1 = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], nil];
    _target.name = @"My Name";
    _target.levelDescription = @"My Description";
    _target.objectGroupIndices = arr1;
    _target.maxObjectTableSize = 64;
    _target.tilesetIndex = 5;
    _target.tilemapImagePath = @"/foo/bar/foo.png";
    _target.tilemapStart = DSPointMake(1, 2);
    _target.tilemapSize = DSPointMake(2, 3);
    _target.bkgrndStartX = 10;
    _target.bkgrndStartY = 20;
    
    XCTAssertEqualObjects(_target.name, @"My Name");
    XCTAssertEqualObjects(_target.levelDescription, @"My Description");
    XCTAssertEqual(_target.objectGroupIndices, arr1);
    XCTAssertEqual(_target.maxObjectTableSize, 64);
    XCTAssertEqual(_target.tilesetIndex, 5);
    XCTAssertEqual(_target.tilemapImagePath, @"/foo/bar/foo.png");
    XCTAssertEqual(_target.tilemapStart.x, 1);
    XCTAssertEqual(_target.tilemapStart.y, 2);
    XCTAssertEqual(_target.tilemapSize.x, 2);
    XCTAssertEqual(_target.tilemapSize.y, 3);
    XCTAssertEqual(_target.bkgrndStartX, 10);
    XCTAssertEqual(_target.bkgrndStartY, 20);
    NSArray<DSObject *> *objects = [[NSArray alloc] init];
    XCTAssertEqual(_target.objects, objects);
}

@end
