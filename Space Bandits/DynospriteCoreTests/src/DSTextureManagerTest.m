//
//  DSTextureManagerTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 12/31/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "DSResourceController.h"
#import "DSSpriteFileParser.h"
#import "DSTextureManager.h"
#import "DSTestUtils.h"


@interface MockSKSpriteNode : NSObject
    @property (nonatomic) BOOL hidden;
    @property (nonatomic) CGSize size;
    @property (nonatomic) SKTexture *texture;
    @property (nonatomic) CGPoint position;
    @property (nonatomic) CGPoint anchorPoint;
@end

@implementation MockSKSpriteNode
@end


@interface DSTextureManagerTest : XCTestCase {
    DSTextureManager *_target;
    id _resourceController;
    DynospriteCOB _cob;
    byte _state;
    id _bundle;
}

@end

@implementation DSTextureManagerTest

- (void)setUp {
    _target = [[DSTextureManager alloc] init];
    XCTAssertEqual(_target.bundle, NSBundle.mainBundle);
    XCTAssertNil(_target.resourceController);
    _resourceController = OCMClassMock(DSResourceController.class);
    _bundle = OCMClassMock(NSBundle.class);
    _target.resourceController = _resourceController;
    _target.bundle = _bundle;
    XCTAssertEqual(_target.resourceController, _resourceController);
    XCTAssertEqual(_target.bundle, _bundle);

    OCMStub([_resourceController spriteImageWithName:@"../tiles/01-moon.gif"]).andReturn(@"moon.gif");
    OCMStub([_bundle resourcePath]).andReturn([[NSBundle bundleForClass:[self class]] resourcePath]);

    DSSpriteFileParser *spriteFileParser = [[DSSpriteFileParser alloc] init];
    DSSpriteObjectClass *spriteObjectClass = [[DSSpriteObjectClass alloc] init];
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"04-ship2" ofType:@"json"];
    [spriteFileParser parseFile:path forObjectClass:spriteObjectClass];
    [_target addSpriteObjectClass:spriteObjectClass];

    spriteObjectClass = [[DSSpriteObjectClass alloc] init];
    OCMStub([_resourceController spriteImageWithName:@"01-moon.gif"]).andReturn(@"moon.gif");
    path = [[NSBundle bundleForClass:[self class]] pathForResource:@"03-badguys" ofType:@"json"];
    [spriteFileParser parseFile:path forObjectClass:spriteObjectClass];
    [_target addSpriteObjectClass:spriteObjectClass];
    
    _cob.statePtr = &_state;
}

- (void)testInit {
    XCTAssertEqual(_target.resourceController, _resourceController);
    MockSKSpriteNode *sprite = [[MockSKSpriteNode alloc] init];
    _cob.groupIdx = 4;
    _cob.statePtr[0] = 1;
    _cob.globalX = 23;
    _cob.globalY = 99;
    _cob.active = 1;
    [_target configureSprite:(id)sprite forCob:&_cob];
    
    XCTAssertEqual(sprite.position.x, _cob.globalX);
    XCTAssertEqual(sprite.position.y, -(float)_cob.globalY);
    XCTAssertEqual(sprite.hidden, NO);
    XCTAssert(fabs(sprite.anchorPoint.x - 0.086956521739130432) < 0.00001);
    XCTAssert(fabs(sprite.anchorPoint.y - 0.39285714285714285) < 0.00001);
    NSImage *spriteImage = [DSTestUtils convertToNSImage:sprite.texture.CGImage];
    NSImage *shipImage = [[NSBundle bundleForClass:self.class] imageForResource:@"ship.tiff"];
    XCTAssertTrue([DSTestUtils image:spriteImage isSameAsImage:shipImage]);
}

@end
