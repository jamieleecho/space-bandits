//
//  DSConfigFileParserTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 1/26/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSConfigFileParser.h"

@interface DSConfigFileParserTest : XCTestCase

@end

@implementation DSConfigFileParserTest {
    DSConfigFileParser *_target;
}

- (void)setUp {
    _target = [[DSConfigFileParser alloc] init];
}

- (void)testCanReadValidJSON {
    NSDictionary *dict = [_target parseFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"JSONDict" ofType:@"json"]];
    XCTAssertEqual([dict[@"images"] count], 2);
    XCTAssertEqualObjects(dict[@"images"][0][@"BackgroundColor"], @"ffffff");
    XCTAssertEqualObjects(dict[@"images"][1][@"ProgressColor"], @"67fc79");
}

- (void)testThrowsWithBadJSONType {
    XCTAssertThrows([_target parseFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"JSONList" ofType:@"json"]]);
}

- (void)testThrowsWithMissingJSON {
    XCTAssertThrows([_target parseFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"JSONMissing" ofType:@"json"]]);
}

- (void)testThrowsWithBadJSON {
    XCTAssertThrows([_target parseFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"JSONBad" ofType:@"json"]]);
}

@end
