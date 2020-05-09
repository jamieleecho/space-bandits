//
//  DSTileInfoTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSTileInfo.h"


@interface DSTileInfoTest : XCTestCase {
    DSTileInfo *_target;
}

@end

@implementation DSTileInfoTest

- (void)setUp {
    _target = [[DSTileInfo alloc] init];
}

- (void)testInit {
    XCTAssertEqualObjects(_target.imagePath, @"");
    XCTAssertTrue(DSPointEqual(_target.tileSetStart, DSPointMake(0, 0)));
    XCTAssertTrue(DSPointEqual(_target.tileSetSize, DSPointMake(0, 0)));
    XCTAssertNotNil(_target.hashToImage);
    XCTAssertNotNil(_target.numberToHash);
    XCTAssertEqual(_target.hashToImage.count, 0);
    XCTAssertEqual(_target.numberToHash.count, 0);
    XCTAssertNil(_target.atlas);
}

- (void)testProperties {
    _target.imagePath = @"../foo/bar/baz.png";
    _target.tileSetStart = DSPointMake(150, 250);
    _target.tileSetSize = DSPointMake(100, 200);
    NSMutableDictionary *hashToImage = [NSMutableDictionary dictionary];
    _target.hashToImage = hashToImage;
    NSMutableDictionary *numberToHash = [NSMutableDictionary dictionary];
    _target.numberToHash = numberToHash;
    SKTextureAtlas *atlas = [[SKTextureAtlas alloc] init];
    _target.atlas = atlas;

    XCTAssertEqualObjects(_target.imagePath, @"../foo/bar/baz.png");
    XCTAssertTrue(DSPointEqual(_target.tileSetStart, DSPointMake(150, 250)));
    XCTAssertTrue(DSPointEqual(_target.tileSetSize, DSPointMake(100, 200)));
    XCTAssertEqual(_target.hashToImage, hashToImage);
    XCTAssertEqual(_target.numberToHash, numberToHash);
    XCTAssertEqual(_target.atlas, atlas);
}

@end
