//
//  DSTransitionSceneInfoFileParserTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/25/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSTransitionSceneInfoFileParser.h"

@interface DSTransitionSceneInfoFileParserTest : XCTestCase

@end

@implementation DSTransitionSceneInfoFileParserTest {
    DSTransitionSceneInfoFileParser *_target;
    NSMutableArray <DSTransitionSceneInfo *> *_infos;
}

- (void)setUp {
    _target = [[DSTransitionSceneInfoFileParser alloc] init];
    _infos = [NSMutableArray array];
    [_infos addObject:[[DSTransitionSceneInfo alloc] init]];
}

- (void)testCreatesColors {
    XCTAssertEqualObjects([DSTransitionSceneInfoFileParser colorFromRGBString:@"f3Ab24"],
                          [NSColor colorWithCalibratedRed:0xf3/255.0f green:0xab/255.0f blue:0x24/255.0f alpha:1]);
    XCTAssertThrows([DSTransitionSceneInfoFileParser colorFromRGBString:@"#f3Ab24"]);
    XCTAssertThrows([DSTransitionSceneInfoFileParser colorFromRGBString:@"f3Ab24aa"]);
}

- (void)testParsesFiles {
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"images" ofType:@"json"];
    [_target parseFile:path forTransitionInfo:_infos];
    XCTAssertEqual(_infos.count, 2);
    XCTAssertEqualObjects(_infos[0].backgroundColor, [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.0f]);
    XCTAssertEqualObjects(_infos[0].foregroundColor, [NSColor colorWithCalibratedRed:0x1b/255.0f green:0xb4/255.0f blue:0x3a/255.0f alpha:1.0f]);
    XCTAssertEqualObjects(_infos[0].progressColor, [NSColor colorWithCalibratedRed:0x1b/255.0f green:0xb4/255.0f blue:0x3a/255.0f alpha:1.0f]);
    
    XCTAssertEqualObjects(_infos[1].backgroundColor, [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.0f]);
    XCTAssertEqualObjects(_infos[1].foregroundColor, [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:1.0f]);
    XCTAssertEqualObjects(_infos[1].progressColor, [NSColor colorWithCalibratedRed:0x67/255.0f green:0xfb/255.0f blue:0x79/255.0f alpha:1.0f]);
}

- (void)testThrowsOnBadFiles {
    NSString *path1 = [[NSBundle bundleForClass:self.class] pathForResource:@"images-bad-1.json" ofType:@"json"];
    XCTAssertThrows([_target parseFile:path1 forTransitionInfo:_infos]);
    NSString *path2 = [[NSBundle bundleForClass:self.class] pathForResource:@"JSONBad" ofType:@""];
    XCTAssertThrows([_target parseFile:path2 forTransitionInfo:_infos]);
    NSString *path3 = [[NSBundle bundleForClass:self.class] pathForResource:@"JSONBad" ofType:@""];
    XCTAssertThrows([_target parseFile:path3 forTransitionInfo:_infos]);
}

@end
