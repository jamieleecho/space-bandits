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
    NSArray *inputArray1 = [NSArray arrayWithObjects:[NSNumber numberWithInt:320], [NSNumber numberWithInt:200], nil];
    NSArray<NSNumber *> *tuple = [DSLevelFileParser intTupleFromArray:inputArray1];
    XCTAssertEqualObjects(tuple, inputArray1);
    XCTAssertNotEqual(tuple, inputArray1);

    NSArray *arr1 = [NSArray arrayWithObjects:@"320", [NSNumber numberWithInt:200], nil];
    NSArray *arr2 = [NSArray arrayWithObjects:[NSNumber numberWithInt:320], @"200", nil];
    NSArray *arr3 = [NSArray arrayWithObjects:[NSNumber numberWithInt:320], [NSNumber numberWithInt:200], [NSNumber numberWithInt:100], nil];
    NSArray *arr4 = [NSArray arrayWithObjects:[NSNumber numberWithInt:320], nil];
    NSArray *arr5 = [[NSArray alloc] init];
    XCTAssertThrows([DSLevelFileParser intTupleFromArray:arr1]);
    XCTAssertThrows([DSLevelFileParser intTupleFromArray:arr2]);
    XCTAssertThrows([DSLevelFileParser intTupleFromArray:arr3]);
    XCTAssertThrows([DSLevelFileParser intTupleFromArray:arr4]);
    XCTAssertThrows([DSLevelFileParser intTupleFromArray:arr5]);
}

- (void)testIntArrayFromArray {
    NSArray *inputArray1 = [NSArray arrayWithObjects:[NSNumber numberWithInt:320], [NSNumber numberWithInt:200], nil];
    NSArray<NSNumber *> *tuple = [DSLevelFileParser intArrayFromArray:inputArray1];
    XCTAssertEqualObjects(tuple, inputArray1);
    XCTAssertNotEqual(tuple, inputArray1);

    NSArray *arr1 = [NSArray arrayWithObjects:@"320", [NSNumber numberWithInt:200], nil];
    NSArray *arr2 = [NSArray arrayWithObjects:[NSNumber numberWithInt:320], @"200", nil];
    NSArray *arr3 = [NSArray arrayWithObjects:[NSNumber numberWithInt:320], [NSNumber numberWithInt:200], [NSNumber numberWithInt:100], nil];
    NSArray *arr4 = [NSArray arrayWithObjects:[NSNumber numberWithInt:320], nil];
    NSArray *arr5 = [[NSArray alloc] init];
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
    NSArray *arr1 = [NSArray arrayWithObjects:[NSNumber numberWithInt:8], [NSNumber numberWithInt:16], nil];
    XCTAssertEqualObjects(_level.tilemapStart, arr1);
    NSArray *arr2 = [NSArray arrayWithObjects:[NSNumber numberWithInt:320], [NSNumber numberWithInt:208], nil];
    XCTAssertEqualObjects(_level.tilemapSize, arr2);
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
    XCTAssertEqualObjects(obj0.initialData, [NSArray arrayWithObject:[NSNumber numberWithInt:0]]);
    DSObject *obj62 = _level.objects[62];
    XCTAssertEqual(obj62.groupID, 6);
    XCTAssertEqual(obj62.objectID, 21);
    XCTAssertEqual(obj62.initialActive, 0);
    XCTAssertEqual(obj62.initialGlobalX, 160);
    XCTAssertEqual(obj62.initialGlobalY, 90);
    XCTAssertEqualObjects(obj62.initialData, ([NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil]));
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
