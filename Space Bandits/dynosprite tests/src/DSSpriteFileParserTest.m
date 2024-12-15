//
//  DSObjectClassFileParserTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DSSpriteObjectClass.h"
#import "DSSpriteFileParser.h"


@interface DSSpriteFileParserTest : XCTestCase {
    DSSpriteFileParser *_target;
    DSSpriteObjectClass *_objectClass;
}
@end

@implementation DSSpriteFileParserTest

- (void)setUp {
    _target = [[DSSpriteFileParser alloc] init];
    _objectClass = [[DSSpriteObjectClass alloc] init];
}

- (void)testParseColorFromArray {
    NSArray *arr1 = @[@0, @127, @255];
    XCTAssertEqualObjects([UIColor colorWithRed:0 green:127.0f/255.0f blue:1.0f alpha:1.0f], [DSSpriteFileParser parseColorFromArray:arr1]);
    NSArray *arr2 = @[@4.5f, @50.25f, @254.75f];
    XCTAssertEqualObjects([UIColor colorWithRed:4.0f/255.0f green:50.0f/255.0f blue:254.0f/255.0f alpha:1.0f], [DSSpriteFileParser parseColorFromArray:arr2]);
    
    XCTAssertThrows([DSSpriteFileParser parseColorFromArray:(NSArray *)@""]);
    XCTAssertThrows(([DSSpriteFileParser parseColorFromArray:@[@0, @127, @255, @255]]));
    XCTAssertThrows(([DSSpriteFileParser parseColorFromArray:@[@0, @127]]));
    XCTAssertThrows(([DSSpriteFileParser parseColorFromArray:@[@0, @127, @"127"]]));
    XCTAssertThrows(([DSSpriteFileParser parseColorFromArray:@[@0, @127, @256]]));
    XCTAssertThrows(([DSSpriteFileParser parseColorFromArray:@[@-1, @127, @255]]));
}

- (void)testSpriteInfoFromDictionary {
    NSDictionary *dict1 = @{
        @"Name": @"Ship1",
        @"Location": @[@137, @433],
        @"SinglePixelPosition": @YES
    };
    DSSpriteInfo *spriteInfo1 = [DSSpriteFileParser spriteInfoFromDictionary:dict1];
    XCTAssertEqual(spriteInfo1.name, @"Ship1");
    XCTAssertTrue(DSPointEqual(spriteInfo1.location, DSPointMake(137, 433)));
    XCTAssertFalse(spriteInfo1.hasRectangle);
    XCTAssertTrue(spriteInfo1.singlePixelPosition);

    NSDictionary *dict2 = @{
        @"Name": @"Ship2",
        @"Location": @[@1370, @4330],
        @"SinglePixelPosition": @NO
    };
    DSSpriteInfo *spriteInfo2 = [DSSpriteFileParser spriteInfoFromDictionary:dict2];
    XCTAssertEqual(spriteInfo2.name, @"Ship2");
    XCTAssertTrue(DSPointEqual(spriteInfo2.location, DSPointMake(1370, 4330)));
    XCTAssertFalse(spriteInfo2.hasRectangle);
    XCTAssertFalse(spriteInfo2.singlePixelPosition);
    
    NSDictionary *dict3 = @{
        @"Name": @"Ship2",
        @"Location": @[@1370, @"4330"],
        @"SinglePixelPosition": @NO
    };
    XCTAssertThrows([DSSpriteFileParser spriteInfoFromDictionary:dict3]);
    XCTAssertThrows([DSSpriteFileParser spriteInfoFromDictionary:(NSDictionary *)@[]]);

    NSDictionary *dict4 = @{
        @"Name": @"Ship4",
        @"Location": @[@1370, @4330],
        @"Rectangle": @[@20, @21, @22, @23],
        @"SinglePixelPosition": @YES
    };
    DSSpriteInfo *spriteInfo4 = [DSSpriteFileParser spriteInfoFromDictionary:dict4];
    XCTAssertEqual(spriteInfo4.name, @"Ship4");
    XCTAssertTrue(DSPointEqual(spriteInfo4.location, DSPointMake(1370, 4330)));
    XCTAssertTrue(spriteInfo4.hasRectangle);
    XCTAssertTrue(CGRectEqualToRect(spriteInfo4.rectangle, CGRectMake(20, 21, 22, 23)));
    XCTAssertTrue(spriteInfo4.singlePixelPosition);

    NSDictionary *dict5 = @{
        @"Name": @"Ship2",
        @"Location": @[@1370, @4330],
        @"Rectangle": @[@20, @21, @22, @"23.2"],
        @"SinglePixelPosition": @YES
    };
    XCTAssertThrows([DSSpriteFileParser spriteInfoFromDictionary:dict5]);

    NSDictionary *dict6 = @{
        @"Name": @"Ship2",
        @"Location": @[@1370, @4330],
        @"Rectangle": @[@20, @21, @22],
        @"SinglePixelPosition": @YES
    };
    XCTAssertThrows([DSSpriteFileParser spriteInfoFromDictionary:dict6]);

    NSDictionary *dict7 = @{
        @"Name": @"Ship2",
        @"Location": @[@1370, @4330],
        @"Rectangle": @22,
        @"SinglePixelPosition": @YES
    };
    XCTAssertThrows([DSSpriteFileParser spriteInfoFromDictionary:dict7]);
}

- (void)testParseFileForObjectClass {
    NSString *objectClassFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"04-ship" ofType:@"json"];
    [_target parseFile:objectClassFilePath forObjectClass:_objectClass];
    
    XCTAssertEqual(_objectClass.groupID, 4);

    XCTAssertEqualObjects(_objectClass.imagePath, @"../tiles/01-moon.gif");
    XCTAssertEqualObjects(_objectClass.transparentColor, [UIColor colorWithRed:254/255.0f green:1/255.0f blue:252/255.0f alpha:1.0f]);
    XCTAssertEqual(_objectClass.palette, 1);

    XCTAssertEqual(_objectClass.sprites.count, 3);
    XCTAssertEqualObjects(_objectClass.sprites[0].name, @"Ship1");
    XCTAssertTrue(DSPointEqual(_objectClass.sprites[1].location, DSPointMake(137, 433)));
    XCTAssertTrue(_objectClass.sprites[2].singlePixelPosition);

    XCTAssertTrue(_objectClass.sprites[0].saveBackground);
    XCTAssertTrue(_objectClass.sprites[1].saveBackground);
    XCTAssertFalse(_objectClass.sprites[2].saveBackground);
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
