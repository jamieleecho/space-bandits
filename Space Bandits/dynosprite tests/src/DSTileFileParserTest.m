//
//  DSTileFileParserTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSTileFileParser.h"


@interface DSTileFileParserTest : XCTestCase {
    DSTileFileParser *_target;
    DSTileInfo *_tileInfo;
}

@end

@implementation DSTileFileParserTest

- (void)setUp {
    _target = [[DSTileFileParser alloc] init];
    _tileInfo = [[DSTileInfo alloc] init];
}

- (void)testParseFileForTileInfo {
    NSString *tileFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"01-moon" ofType:@"json"];
    [_target parseFile:tileFilePath forTileInfo:_tileInfo];
    XCTAssertEqualObjects(_tileInfo.imagePath, @"tiles/01-moon.gif");
    XCTAssertTrue(DSPointEqual(_tileInfo.tileSetStart, DSPointMake(20, 32)));
    XCTAssertTrue(DSPointEqual(_tileInfo.tileSetSize, DSPointMake(320, 208)));
}

- (void)testParseFileForTileInfoBadJson {
    NSString *badJson = [[NSBundle bundleForClass:self.class] pathForResource:@"JSONBad" ofType:@""];
    XCTAssertThrows([_target parseFile:badJson forTileInfo:_tileInfo]);
    NSString *notDict = [[NSBundle bundleForClass:self.class] pathForResource:@"JSONList" ofType:@"json"];
    XCTAssertThrows([_target parseFile:notDict forTileInfo:_tileInfo]);
}

@end
