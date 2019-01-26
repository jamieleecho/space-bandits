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

@implementation DSConfigFileParserTest

- (void)testCanReadValidJSON {
    DSConfigFileParser *parser = [[DSConfigFileParser alloc] init];
    NSDictionary *dict = [parser parseFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"JSONDict" ofType:@"json"]];
    XCTAssertEqual([dict[@"images"] count], 2);
    XCTAssertEqualObjects(dict[@"images"][0][@"BackgroundColor"], @"ffffff");
    XCTAssertEqualObjects(dict[@"images"][1][@"ProgressColor"], @"67fc79");
}

- (void)testCanLoadFromMainBundle {
    DSConfigFileParser *parser = [[DSConfigFileParser alloc] init];
    NSDictionary *dict = [parser parseResourceNamed:@"images/images"];
    XCTAssertEqual([dict[@"images"] count], 2);
    XCTAssertEqualObjects(dict[@"images"][0][@"BackgroundColor"], @"ffffff");
    XCTAssertEqualObjects(dict[@"images"][1][@"ProgressColor"], @"67fb79");
}

- (void)testThrowsWithBadJSONType {
    DSConfigFileParser *parser = [[DSConfigFileParser alloc] init];
    XCTAssertThrows([parser parseFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"JSONList" ofType:@"json"]]);
}

- (void)testThrowsWithMissingJSON {
    DSConfigFileParser *parser = [[DSConfigFileParser alloc] init];
    XCTAssertThrows([parser parseFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"JSONMissing" ofType:@"json"]]);
}

- (void)testThrowsWithBadJSON {
    DSConfigFileParser *parser = [[DSConfigFileParser alloc] init];
    XCTAssertThrows([parser parseFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"JSONBad" ofType:@"json"]]);
}

@end
