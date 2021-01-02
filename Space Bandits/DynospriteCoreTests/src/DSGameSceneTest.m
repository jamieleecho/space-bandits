//
//  DSGameSceneTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 5/5/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "DSCoCoJoystickController.h"
#import "DSGameScene.h"
#import "DSTestUtils.h"

@interface DSGameSceneTest : XCTestCase {
    DSGameScene *_target;
    DSLevel *_levelObj;
    id _resourceController;
    DSTileInfo *_tileInfo;
    id _tileMapMaker;
    id _bundle;
    id _joystickController;
    id _objectCoordinator;
    DynospriteCOB _cobs[5];
    DSTextureManager *_textureManager;
    SKNode *_node;
}

@end


static int initLevelCount = 0;
static void initLevel() {
    initLevelCount++;
}
static int backgroundNewXYCount = 0;
static byte backgroundNewXY() {
    return backgroundNewXYCount++;
}


@implementation DSGameSceneTest

- (void)setUp {
    _levelObj = [[DSLevel alloc] initWithInitLevel:initLevel backgroundNewXY:backgroundNewXY];
    _resourceController = OCMClassMock(DSResourceController.class);
    _tileInfo = [[DSTileInfo alloc] init];
    _tileMapMaker = OCMClassMock(DSTileMapMaker.class);
    _bundle = OCMClassMock(NSBundle.class);
    _joystickController = OCMClassMock(DSCoCoJoystickController.class);
    _objectCoordinator = OCMClassMock(DSObjectCoordinator.class);
    _textureManager = [[DSTextureManager alloc] init];
    _target = [[DSGameScene alloc] initWithLevel:_levelObj andResourceController:_resourceController andTileInfo:_tileInfo andTileMapMaker:_tileMapMaker andBundle:_bundle andObjectCoordinator:_objectCoordinator andTextureManager:_textureManager];
    _target.joystickController = _joystickController;
    _node = [[SKNode alloc] init];
    
    backgroundNewXYCount = 0;
    initLevelCount = 0;
    
    memset(DynospriteDirectPageGlobalsPtr, 0xff, sizeof(*DynospriteDirectPageGlobalsPtr));
}

- (void)commonInit {
    _levelObj.tilemapImagePath = @"../../tiles/mytile.png";
    _levelObj.tilemapSize = DSPointMake(160, 64);
    _levelObj.tilemapStart = DSPointMake(3, 7);
    _levelObj.tilesetIndex = 4;
    
    OCMStub([_resourceController imageWithName:@"tiles/mytile.png"]).andReturn(@"hires/tiles/mytile.png");
    NSString *imagePath = [[NSBundle bundleForClass:self.class] pathForImageResource:@"forest"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
    OCMStub([_bundle pathForResource:@"hires/tiles/mytile" ofType:@"png"]).andReturn(imagePath);
    NSRect tileRect = NSMakeRect(3, 7, 160, 64);
    
    _tileInfo.imagePath = @"tiles/mytile.png";
    _tileInfo.tileSetStart = DSPointMake(3, 7);
    _tileInfo.tileSetSize = DSPointMake(160, 64);
    _tileInfo.imagePath = @"tiles/mytile.png";
    OCMStub([_tileMapMaker nodeFromImage:OCMArg.any withRect:tileRect usingTileImage:OCMArg.any withTileRect:tileRect]).andDo(^(NSInvocation *invocation) {
        NSImage *loadedImage;
        [invocation getArgument:(void *)&loadedImage atIndex:2];
        XCTAssertTrue([DSTestUtils image:loadedImage isSameAsImage:image]);
    }).andReturn(_node);
    
    OCMStub([_objectCoordinator cobs]).andReturn((DynospriteCOB *)_cobs);
}

- (void)testInit {
    XCTAssertTrue(CGSizeEqualToSize(_target.size, CGSizeMake(320, 200)));
    XCTAssertTrue(CGPointEqualToPoint(_target.anchorPoint, CGPointMake(0, 1)));
    XCTAssertEqual(_target.levelObj, _levelObj);
    XCTAssertEqual(_target.resourceController, _resourceController);
    XCTAssertEqual(_target.tileInfo, _tileInfo);
    XCTAssertEqual(_target.tileMapMaker, _tileMapMaker);
    XCTAssertEqual(_target.bundle, _bundle);
    XCTAssertEqual(_target.objectCoordinator, _objectCoordinator);
    XCTAssertEqual(_target.textureManager, _textureManager);
}

- (void)testInitializeLevel {
    [self commonInit];
    OCMStub([_joystickController useHardwareJoystick]).andReturn(YES);
    
    [_target initializeLevel];
    
    XCTAssertEqual(_target.children.firstObject, _node);
    XCTAssertEqual(initLevelCount, 1);
    XCTAssertEqual(backgroundNewXYCount, 0);
    
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr, [_objectCoordinator cobs]);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_Buttons, 0);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_JoystickX, 0);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_JoystickY, 0);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Obj_MotionFactor, 0);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_UseKeyboard, 0);
    
    OCMVerify([_objectCoordinator initializeObjects]);
}

- (void)testInitializeLevelWithJoystick {
    [self commonInit];
    OCMStub([_joystickController useHardwareJoystick]).andReturn(NO);
    [_target initializeLevel];
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_UseKeyboard, 1);
}

- (void)testInitializeWithBadInputs {
    DSLevel *levelObj = [[DSLevel alloc] initWithInitLevel:initLevel backgroundNewXY:backgroundNewXY];
    levelObj.tilemapImagePath = @"../../tiles/mytile.png";
    levelObj.tilemapSize = DSPointMake(161, 64);
    levelObj.tilemapStart = DSPointMake(3, 7);
    
    OCMStub([_resourceController imageWithName:@"tiles/mytile.png"]).andReturn(@"hires/tiles/mytile.png");
    NSString *imagePath = [[NSBundle bundleForClass:self.class] pathForImageResource:@"forest"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
    OCMStub([_bundle pathForResource:@"hires/tiles/mytile" ofType:@"png"]).andReturn(imagePath);
    NSRect tileMapRect = NSMakeRect(3, 7, 160, 64);
    SKNode *node = [[SKNode alloc] init];
    OCMStub([_tileMapMaker nodeFromImage:OCMArg.any withRect:tileMapRect usingTileImage:OCMArg.any withTileRect:tileMapRect]).andDo(^(NSInvocation *invocation) {
        NSImage *loadedImage;
        [invocation getArgument:(void *)&loadedImage atIndex:2];
        XCTAssertTrue([DSTestUtils image:loadedImage isSameAsImage:image]);
    }).andReturn(node);
    
    XCTAssertThrows([_target initializeLevel]);
    XCTAssertEqual(initLevelCount, 1);
    XCTAssertEqual(backgroundNewXYCount, 0);
}

@end
