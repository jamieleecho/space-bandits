//
//  DSObjectClassFileParserTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DSObjectClass.h"
#import "DSObjectClassFileParser.h"


@interface DSObjectClassFileParserTest : XCTestCase {
    DSObjectClassFileParser *_target;
    DSObjectClass *_objectClass;
}
@end

@implementation DSObjectClassFileParserTest

- (void)setUp {
    _target = [[DSObjectClassFileParser alloc] init];
    _objectClass = [[DSObjectClass alloc] init];
}

- (void)testParseColorFromArray {
    NSArray *arr1 = @[@0, @127, @255];
    XCTAssertEqualObjects([NSColor colorWithRed:0 green:127.0f/255.0f blue:1.0f alpha:1.0f], [DSObjectClassFileParser parseColorFromArray:arr1]);
    NSArray *arr2 = @[@4.5f, @50.25f, @254.75f];
    XCTAssertEqualObjects([NSColor colorWithRed:4.0f/255.0f green:50.0f/255.0f blue:254.0f/255.0f alpha:1.0f], [DSObjectClassFileParser parseColorFromArray:arr2]);
    
    XCTAssertThrows([DSObjectClassFileParser parseColorFromArray:(NSArray *)@""]);
    XCTAssertThrows(([DSObjectClassFileParser parseColorFromArray:@[@0, @127, @255, @255]]));
    XCTAssertThrows(([DSObjectClassFileParser parseColorFromArray:@[@0, @127]]));
    XCTAssertThrows(([DSObjectClassFileParser parseColorFromArray:@[@0, @127, @"127"]]));
    XCTAssertThrows(([DSObjectClassFileParser parseColorFromArray:@[@0, @127, @256]]));
    XCTAssertThrows(([DSObjectClassFileParser parseColorFromArray:@[@-1, @127, @255]]));
}

- (void)testSpriteInfoFromDictionary {
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Ship1", @"Name", @[@137, @433], @"Location", @YES, @"SinglePixelPosition", nil];
    DSSpriteInfo *spriteInfo1 = [DSObjectClassFileParser spriteInfoFromDictionary:dict1];
    XCTAssertEqual(spriteInfo1.name, @"Ship1");
    XCTAssertTrue(DSPointEqual(spriteInfo1.location, DSPointMake(137, 433)));
    XCTAssertTrue(spriteInfo1.singlePixelPosition);

    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Ship2", @"Name", @[@1370, @4330], @"Location", @NO, @"SinglePixelPosition", nil];
    DSSpriteInfo *spriteInfo2 = [DSObjectClassFileParser spriteInfoFromDictionary:dict2];
    XCTAssertEqual(spriteInfo2.name, @"Ship2");
    XCTAssertTrue(DSPointEqual(spriteInfo2.location, DSPointMake(1370, 4330)));
    XCTAssertFalse(spriteInfo2.singlePixelPosition);
    
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Ship2", @"Name", @[@1370, @"4330"], @"Location", @NO, @"SinglePixelPosition", nil];
    XCTAssertThrows([DSObjectClassFileParser spriteInfoFromDictionary:dict3]);
    XCTAssertThrows([DSObjectClassFileParser spriteInfoFromDictionary:(NSDictionary *)@[]]);
}

- (void)testParseFileForObjectClass {
    NSString *objectClassFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"04-ship" ofType:@"json"];
    [_target parseFile:objectClassFilePath forObjectClass:_objectClass];
    
    XCTAssertEqual(_objectClass.groupID, 4);
    XCTAssertEqualObjects(_objectClass.imagePath, @"../tiles/01-moon.gif");
    XCTAssertEqualObjects(_objectClass.transparentColor, [NSColor colorWithRed:254/255.0f green:1/255.0f blue:252/255.0f alpha:1.0f]);
    XCTAssertEqual(_objectClass.palette, 1);

    XCTAssertEqual(_objectClass.sprites.count, 3);
    XCTAssertEqualObjects(_objectClass.sprites[0].name, @"Ship1");
    XCTAssertTrue(DSPointEqual(_objectClass.sprites[1].location, DSPointMake(137, 433)));
    XCTAssertTrue(_objectClass.sprites[2].singlePixelPosition);
}

- (void)testParseFileForObjectClassWithBadFileThrows {
    NSString *objectClassFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"JSONBad" ofType:@"json"];
    XCTAssertThrows([_target parseFile:objectClassFilePath forObjectClass:_objectClass]);
}

- (void)testParseFileForLevelWithFileMissingDataThrows {
    NSString *objectClassFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"JSONList" ofType:@"json"];
    XCTAssertThrows([_target parseFile:objectClassFilePath forObjectClass:_objectClass]);
}

@end
