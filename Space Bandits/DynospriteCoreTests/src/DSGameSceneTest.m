//
//  DSGameSceneTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 5/5/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSGameScene.h"

@interface DSGameSceneTest : XCTestCase {
    DSGameScene *_target;
    DSLevel *_level;
    DSObjectCoordinator *_objectCoordinator;
    DSTextureManager *_textureManager;
    SKTileMapNode *_tileMapNode;
}

@end

@implementation DSGameSceneTest

- (void)setUp {
    _level = [[DSLevel alloc] init];
    _objectCoordinator = [[DSObjectCoordinator alloc] init];
    _tileMapNode = [[SKTileMapNode alloc] init];
    _textureManager = [[DSTextureManager alloc] init];
    _target = [[DSGameScene alloc] initWithLevel:_level andObjectCoordinator:_objectCoordinator andTileMapNode:_tileMapNode andTextureManager:_textureManager];
}

- (void)testInit {
    XCTAssertEqual(_target.children.firstObject, _tileMapNode);
    XCTAssertTrue(CGSizeEqualToSize(_target.size, CGSizeMake(320, 200)));
    XCTAssertTrue(CGPointEqualToPoint(_target.anchorPoint, CGPointMake(0, 1)));
}

@end
