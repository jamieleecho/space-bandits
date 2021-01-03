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
#import "DSInitScene.h"
#import "DSGameScene.h"
#import "DSSceneController.h"
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
    id _textureManager;
    id _sceneController;
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
    _textureManager = OCMClassMock(DSTextureManager.class);
    _sceneController = OCMClassMock(DSSceneController.class);
    _target = [[DSGameScene alloc] initWithLevel:_levelObj andResourceController:_resourceController andTileInfo:_tileInfo andTileMapMaker:_tileMapMaker andBundle:_bundle andObjectCoordinator:_objectCoordinator andTextureManager:_textureManager andSceneController:_sceneController];
    _target.joystickController = _joystickController;
    _node = [[SKNode alloc] init];
    
    backgroundNewXYCount = 0;
    initLevelCount = 0;
    
    memset(DynospriteDirectPageGlobalsPtr, 0xff, sizeof(*DynospriteDirectPageGlobalsPtr));
    
    OCMStub([_bundle resourcePath]).andReturn([[NSBundle bundleForClass:[self class]] resourcePath]);
}

- (void)commonInit {
    _levelObj.tilemapImagePath = @"../../tiles/mytile.png";
    _levelObj.tilemapSize = DSPointMake(160, 64);
    _levelObj.tilemapStart = DSPointMake(3, 7);
    _levelObj.tilesetIndex = 4;
    _levelObj.bkgrndStartX = 100;
    _levelObj.bkgrndStartY = 237;

    OCMStub([_resourceController imageWithName:@"tiles/mytile.png"]).andReturn(@"forest.png");
    NSString *imagePath = [[NSBundle bundleForClass:self.class] pathForImageResource:@"forest"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
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
    OCMStub([_objectCoordinator count]).andReturn(3);
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
    XCTAssertNotNil(_target.sprites);
    XCTAssertEqual(_target.sprites.count, 0);
}

- (void)testInitializeLevel {
    [self commonInit];
    OCMStub([_joystickController useHardwareJoystick]).andReturn(YES);
    
    [_target initializeLevel];
    
    XCTAssertEqual(_target.children.firstObject, _node);
    XCTAssertEqual(initLevelCount, 1);
    XCTAssertEqual(backgroundNewXYCount, 0);
    
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr, [_objectCoordinator cobs]);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Obj_NumCurrent, 3);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_Buttons, Joy1Button1 | Joy1Button2 | Joy2Button1 | Joy2Button2);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_JoystickX, 0);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_JoystickY, 0);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Obj_MotionFactor, 0);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_UseKeyboard, 0);
    
    OCMVerify([_objectCoordinator initializeObjects]);
    
    XCTAssertEqual(_target.children.count, 5);
    XCTAssertEqual(_target.sprites.count, 3);
    OCMVerify([_textureManager configureSprite:_target.sprites[0] forCob:_cobs + 0]);
    OCMVerify([_textureManager configureSprite:_target.sprites[1] forCob:_cobs + 1]);
    OCMVerify([_textureManager configureSprite:_target.sprites[2] forCob:_cobs + 2]);

    // Does the background start at the right point?
    XCTAssertTrue(CGPointEqualToPoint(_target.camera.position, CGPointMake(260, -337)));
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

- (void) testRunOneGameLoop {
    [self commonInit];
    OCMStub([_joystickController useHardwareJoystick]).andReturn(YES);
    id joystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    [_target initializeLevel];
    
    _levelObj.bkgrndStartX = 50;
    _levelObj.bkgrndStartY = 100;
    OCMStub([_objectCoordinator updateOrReactivateObjects]).andReturn(0);
    OCMStub([_joystickController joystick]).andReturn(joystick);
    OCMStub([joystick xaxisPosition]).andReturn(20);
    OCMStub([joystick yaxisPosition]).andReturn(41);
    OCMStub([joystick button0Pressed]).andReturn(NO);
    OCMStub([joystick button1Pressed]).andReturn(NO);

    [_target runOneGameLoop];
    OCMVerify([_objectCoordinator updateOrReactivateObjects]);
    XCTAssertEqual(_target.camera.position.x, 210);
    XCTAssertEqual(_target.camera.position.y, -200);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_JoystickX, 20);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_JoystickY, 41);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_Buttons, Joy1Button1 | Joy1Button2 | Joy2Button1 | Joy2Button2);
    for(size_t ii=0; ii<3; ii++) {
        OCMVerify( [_textureManager configureSprite:_target.sprites[ii] forCob:_cobs + ii]);
    }
}

- (void) testRunOneGameLoopTransitionToInit {
    [self commonInit];
    [_target initializeLevel];
    SKScene *scene = [[SKScene alloc] init];
    OCMStub([_sceneController transitionSceneForLevel:0]).andReturn(scene);
    OCMStub([_objectCoordinator updateOrReactivateObjects]).andReturn(255);
    [_target runOneGameLoop];
    OCMVerify([_sceneController transitionSceneForLevel:0]);
    XCTAssertTrue(_target.isDone);
}

- (void) testRunOneGameLoopTransitionToNewScene {
    [self commonInit];
    [_target initializeLevel];
    SKScene *scene = [[SKScene alloc] init];
    OCMStub([_sceneController transitionSceneForLevel:3]).andReturn(scene);
    OCMStub([_objectCoordinator updateOrReactivateObjects]).andReturn(3);
    [_target runOneGameLoop];
    OCMVerify([_sceneController transitionSceneForLevel:3]);
    XCTAssertTrue(_target.isDone);
}

- (void)testRunOneGameLoopButton0Pressed {
    [self commonInit];
    OCMStub([_joystickController useHardwareJoystick]).andReturn(YES);
    id joystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    [_target initializeLevel];
    
    OCMStub([_joystickController joystick]).andReturn(joystick);
    OCMStub([joystick button0Pressed]).andReturn(YES);
    OCMStub([joystick button1Pressed]).andReturn(NO);
    [_target runOneGameLoop];
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_Buttons, Joy1Button2 | Joy2Button1 | Joy2Button2);
}

- (void)testRunOneGameLoopButton1Pressed {
    [self commonInit];
    OCMStub([_joystickController useHardwareJoystick]).andReturn(YES);
    id joystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    [_target initializeLevel];
    
    OCMStub([_joystickController joystick]).andReturn(joystick);
    OCMStub([joystick button0Pressed]).andReturn(NO);
    OCMStub([joystick button1Pressed]).andReturn(YES);
    [_target runOneGameLoop];
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_Buttons, Joy1Button1 | Joy2Button1 | Joy2Button2);
}

- (void)testUpdate {
    [self commonInit];
    OCMStub([_joystickController useHardwareJoystick]).andReturn(YES);
    id joystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    [_target initializeLevel];
    
    OCMStub([_joystickController joystick]).andReturn(joystick);
    OCMStub([joystick button0Pressed]).andReturn(YES);
    OCMStub([joystick button1Pressed]).andReturn(NO);
    [_target update:1];
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_Buttons, Joy1Button2 | Joy2Button1 | Joy2Button2);
}

- (void)testUpdateWhenPaused {
    [self commonInit];
    OCMStub([_joystickController useHardwareJoystick]).andReturn(YES);
    id joystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    [_target initializeLevel];
    
    _target.isPaused = YES;
    OCMStub([_joystickController joystick]).andReturn(joystick);
    OCMStub([joystick button0Pressed]).andReturn(YES);
    OCMStub([joystick button1Pressed]).andReturn(NO);
    [_target update:1];
    XCTAssertNotEqual(DynospriteDirectPageGlobalsPtr->Input_Buttons, Joy1Button2 | Joy2Button1 | Joy2Button2);
}

@end
