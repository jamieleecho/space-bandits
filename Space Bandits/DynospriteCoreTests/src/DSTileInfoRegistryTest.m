//
//  DSTileInfoRegistryTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 5/9/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "DSTileInfoRegistry.h"


@interface DSTileInfoRegistryTest : XCTestCase {
    DSTileInfoRegistry *_target;
    id _tileFileParser;
}

@end

@implementation DSTileInfoRegistryTest

- (void)setUp {
    _target = [[DSTileInfoRegistry alloc] init];
    XCTAssertEqual(_target.tileFileParser.class, DSTileFileParser.class);
    _tileFileParser = OCMClassMock(DSTileFileParser.class);
    _target.tileFileParser = _tileFileParser;
}

- (void)testInit {
    XCTAssertEqual(_target.count, 0);
}

- (void)testProperties {
    XCTAssertEqual(_target.tileFileParser, _tileFileParser);
}

- (void)testGettingMissingTileInfos {
    XCTAssertNil([_target tileInfoForNumber:10]);
}

- (void)testAddsTileForNumber {
    __block DSTileInfo *tileInfo = nil;
    NSString *path = @"foo/bar/test.json";
    OCMStub([_tileFileParser parseFile:[OCMArg any] forTileInfo:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        NSString *invokedPath;
        [invocation getArgument:(void *)&invokedPath atIndex:2];
        XCTAssertEqual(invokedPath, path);
        [invocation getArgument:(void *)&tileInfo atIndex:3];
    });
    [_target addTileInfoFromFile:path forNumber:3];
    XCTAssertEqual([_target tileInfoForNumber:3], tileInfo);
    XCTAssertEqual(_target.count, 1);
}

- (void)testAddsTileForNumberThrowsWithBadInput {
    NSString *path = @"foo/bar/test.json";
    OCMStub([_tileFileParser parseFile:[OCMArg any] forTileInfo:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        @throw [NSException exceptionWithName:@"Oops" reason:@"testing stuff" userInfo:nil];
    });
    XCTAssertThrows([_target addTileInfoFromFile:path forNumber:3]);
}

- (void)testClear {
    NSString *path = @"foo/bar/test.json";
    OCMStub([_tileFileParser parseFile:[OCMArg any] forTileInfo:[OCMArg any]]);
    [_target addTileInfoFromFile:path forNumber:3];
    XCTAssertEqual(_target.count, 1);
    [_target clear];
    XCTAssertEqual(_target.count, 0);
}

@end
