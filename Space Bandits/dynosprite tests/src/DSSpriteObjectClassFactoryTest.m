//
//  DSSpriteObjectClassFactoryTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "DSSpriteObjectClassFactory.h"

@interface DSSpriteObjectClassFactoryTest : XCTestCase {
    DSSpriteObjectClassFactory *_target;
    id _textureManager;
}

@end

@implementation DSSpriteObjectClassFactoryTest

- (void)setUp {
    _target = [[DSSpriteObjectClassFactory alloc] init];
    _textureManager = OCMClassMock(DSTextureManager.class);
    XCTAssertNil(_target.textureManager);
    _target.textureManager = _textureManager;
}

- (void)testInit {
    XCTAssertEqual(_target.textureManager, _textureManager);
}

- (void)testaddObjectClassForNumber {
    DSSpriteObjectClass *spriteClassObj = [[DSSpriteObjectClass alloc] init];
    spriteClassObj.groupID = 3;
    [_target addSpriteObjectClass:spriteClassObj forNumber:@4];
    OCMVerify([_textureManager addSpriteObjectClass:spriteClassObj]);
}

@end
