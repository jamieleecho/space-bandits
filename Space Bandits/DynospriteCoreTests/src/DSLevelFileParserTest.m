//
//  DSLevelFileParserTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/18/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DSLevelFileParser.h"


@interface DSLevelFileParserTest : XCTestCase {
    DSLevelFileParser *_target;
    DSLevel *_level;
}
@end


@implementation DSLevelFileParserTest

- (void)setUp {
    _target = [[DSLevelFileParser alloc] init];
    _level = [[DSLevel alloc] init];
}

- (void)testIntTupleFromArray {
    NSArray *inputArray1 = @[@320, @200];
    DSPoint point = [DSLevelFileParser pointFromArray:inputArray1];
    XCTAssertEqual(point.x, 320);
    XCTAssertEqual(point.y, 200);

    NSArray *arr1 = @[@"320", @200];
    NSArray *arr2 = @[@320, @"200"];
    NSArray *arr3 = @[@320, @200, @100];
    NSArray *arr4 = @[@320];
    NSArray *arr5 = @[];
    XCTAssertThrows([DSLevelFileParser pointFromArray:arr1]);
    XCTAssertThrows([DSLevelFileParser pointFromArray:arr2]);
    XCTAssertThrows([DSLevelFileParser pointFromArray:arr3]);
    XCTAssertThrows([DSLevelFileParser pointFromArray:arr4]);
    XCTAssertThrows([DSLevelFileParser pointFromArray:arr5]);
}

- (void)testIntArrayFromArray {
    NSArray *inputArray1 = @[@320, @200];
    NSArray<NSNumber *> *tuple = [DSLevelFileParser intArrayFromArray:inputArray1];
    XCTAssertEqualObjects(tuple, inputArray1);
    XCTAssertNotEqual(tuple, inputArray1);

    NSArray *arr1 = @[@"320", @200];
    NSArray *arr2 = @[@320, @"200"];
    NSArray *arr3 = @[@320, @200, @100];
    NSArray *arr4 = @[@320];
    NSArray *arr5 = @[];
    XCTAssertThrows([DSLevelFileParser intArrayFromArray:arr1]);
    XCTAssertThrows([DSLevelFileParser intArrayFromArray:arr2]);
    XCTAssertEqualObjects([DSLevelFileParser intArrayFromArray:arr3], arr3);
    XCTAssertEqualObjects([DSLevelFileParser intArrayFromArray:arr4], arr4);
    XCTAssertEqualObjects([DSLevelFileParser intArrayFromArray:arr5], arr5);
}

- (void)testParseFileForLevel {
    NSString *levelFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"01-test-level" ofType:@"json"];
    [_target parseFile:levelFilePath forLevel:_level];
    
    XCTAssertEqualObjects(_level.name, @"Omicron Persei 8 Invades");
    XCTAssertEqualObjects(_level.levelDescription, @"Drop Down and Increase Speed!");
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:5];
    for(int ii=3; ii<8; ii++) {
        [arr addObject:[NSNumber numberWithInt:ii]];
    }
    XCTAssertEqualObjects(_level.objectGroupIndices, arr);
    XCTAssertEqual(_level.maxObjectTableSize, 64);
    XCTAssertEqual(_level.tilesetIndex, 1);
    XCTAssertEqualObjects(_level.tilemapImagePath, @"../tiles/01-moon.gif");
    XCTAssertEqual(_level.tilemapStart.x, 8);
    XCTAssertEqual(_level.tilemapStart.y, 16);
    XCTAssertEqual(_level.tilemapSize.x, 320);
    XCTAssertEqual(_level.tilemapSize.y, 208);
    XCTAssertEqual(_level.bkgrndStartX, 40);
    XCTAssertEqual(_level.bkgrndStartY, 12);
    
    XCTAssertEqual(_level.objects.count, 63);
    for(DSObject *obj in _level.objects) {
        XCTAssertEqual(obj.class, DSObject.class);
    }
    DSObject *obj0 = _level.objects[0];
    XCTAssertEqual(obj0.groupID, 4);
    XCTAssertEqual(obj0.objectID, 0);
    XCTAssertEqual(obj0.initialActive, 3);
    XCTAssertEqual(obj0.initialGlobalX, 170);
    XCTAssertEqual(obj0.initialGlobalY, 175);
    XCTAssertEqualObjects(obj0.initialData, @[@0]);
    DSObject *obj62 = _level.objects[62];
    XCTAssertEqual(obj62.groupID, 6);
    XCTAssertEqual(obj62.objectID, 21);
    XCTAssertEqual(obj62.initialActive, 0);
    XCTAssertEqual(obj62.initialGlobalX, 160);
    XCTAssertEqual(obj62.initialGlobalY, 90);
    XCTAssertEqualObjects(obj62.initialData, (@[@2, @3]));
}

- (void)testParseFileForLevelWithBadFileThrows {
    NSString *levelFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"JSONBad" ofType:@"json"];
    XCTAssertThrows([_target parseFile:levelFilePath forLevel:_level]);
}

- (void)testParseFileForLevelWithFileMissingDataThrows {
    NSString *levelFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"JSONList" ofType:@"json"];
    XCTAssertThrows([_target parseFile:levelFilePath forLevel:_level]);
}

@end
