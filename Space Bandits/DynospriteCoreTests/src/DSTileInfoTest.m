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
}

- (void)testProperties {
    _target.imagePath = @"../foo/bar/baz.png";
    _target.tileSetStart = DSPointMake(150, 250);
    _target.tileSetSize = DSPointMake(100, 200);
    
    XCTAssertEqualObjects(_target.imagePath, @"../foo/bar/baz.png");
    XCTAssertTrue(DSPointEqual(_target.tileSetStart, DSPointMake(150, 250)));
    XCTAssertTrue(DSPointEqual(_target.tileSetSize, DSPointMake(100, 200)));
}

@end
