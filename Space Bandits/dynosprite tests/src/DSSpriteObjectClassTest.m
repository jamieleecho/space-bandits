//
//  DSSpriteObjectClassTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSSpriteObjectClass.h"


@interface DSSpriteObjectClassTest : XCTestCase {
    DSSpriteObjectClass *_target;
}

@end

@implementation DSSpriteObjectClassTest

- (void)setUp {
    _target = [[DSSpriteObjectClass alloc] init];
}

- (void)testInit {
    XCTAssertEqual(_target.groupID, 0);
    XCTAssertEqualObjects(_target.imagePath, @"");
    XCTAssertEqualObjects(_target.transparentColor, [NSColor colorNamed:@"black"]);
    XCTAssertEqual(_target.palette, 0);
    XCTAssertTrue([_target.sprites isKindOfClass:NSArray.class]);
    XCTAssertEqual(_target.sprites.count, 0);
}

- (void)testProperties {
    _target.groupID = 2;
    _target.imagePath = @"/foo/bar/baz.png";
    NSColor *color = [NSColor colorNamed:@"green"];
    _target.transparentColor = color;
    _target.palette = 3;
    NSArray *array = [NSMutableArray array];
    _target.sprites = array;

    XCTAssertEqual(_target.groupID, 2);
    XCTAssertEqualObjects(_target.imagePath, @"/foo/bar/baz.png");
    XCTAssertEqualObjects(_target.transparentColor, color);
    XCTAssertEqual(_target.palette, 3);
    XCTAssertEqual(_target.sprites, array);
}

@end
