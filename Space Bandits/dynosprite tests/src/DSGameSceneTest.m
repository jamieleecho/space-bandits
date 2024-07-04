//
//  DSGameSceneTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 5/5/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import "DSKeyEventBaseTest.h"
#import "DSCoCoJoystickController.h"
#import "DSInitScene.h"
#import "DSGameScene.h"
#import "DSSceneController.h"
#import "DSTestUtils.h"


@interface DSGameSceneTest : DSKeyEventBaseTest<DSGameScene *> {
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
static void initLevel(void) {
    initLevelCount++;
}
static int backgroundNewXYCount = 0;
static byte backgroundNewXY(void) {
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
    self.target = [[DSGameScene alloc] initWithLevel:_levelObj andResourceController:_resourceController andTileInfo:_tileInfo andTileMapMaker:_tileMapMaker andBundle:_bundle andObjectCoordinator:_objectCoordinator andTextureManager:_textureManager andSceneController:_sceneController];
    self.target.joystickController = _joystickController;
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
    _levelObj.bkgrndStartX = 101;
    _levelObj.bkgrndStartY = 237;

    OCMStub([_resourceController imageWithName:@"tiles/mytile.png"]).andReturn(@"forest.png");
    NSString *imagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"forest" ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    CGRect tileRect = CGRectMake(3, 7, 160, 64);
    
    _tileInfo.imagePath = @"tiles/mytile.png";
    _tileInfo.tileSetStart = DSPointMake(3, 7);
    _tileInfo.tileSetSize = DSPointMake(160, 64);
    _tileInfo.imagePath = @"tiles/mytile.png";
    OCMStub([_tileMapMaker nodeFromImage:OCMArg.any withRect:tileRect usingTileImage:OCMArg.any withTileRect:tileRect]).andDo(^(NSInvocation *invocation) {
        UIImage *loadedImage;
        [invocation getArgument:(void *)&loadedImage atIndex:2];
        XCTAssertTrue([DSTestUtils image:loadedImage isSameAsImage:image]);
    }).andReturn(_node);
    
    OCMStub([_objectCoordinator cobs]).andReturn((DynospriteCOB *)_cobs);
    OCMStub([_objectCoordinator count]).andReturn(3);
}

- (void)testInit {
    XCTAssertEqual(_target.backgroundColor.alphaComponent, 0.0f);
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
    XCTAssertEqual(_target.backgroundColor.alphaComponent, 0.0f);
    OCMStub([_joystickController useHardwareJoystick]).andReturn(YES);
    id joystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    OCMStub([_joystickController joystick]).andReturn(joystick);
    OCMStub([joystick xaxisPosition]).andReturn(25);
    OCMStub([joystick yaxisPosition]).andReturn(52);
    [self.target initializeLevel];
    
    XCTAssertEqual(self.target.children.firstObject, _node);
    XCTAssertEqual(initLevelCount, 1);
    XCTAssertEqual(backgroundNewXYCount, 0);
    
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr, [_objectCoordinator cobs]);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Obj_NumCurrent, 3);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_Buttons, Joy1Button1 | Joy1Button2 | Joy2Button1 | Joy2Button2);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_JoystickX, 25);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_JoystickY, 52);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Obj_MotionFactor, -1);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_UseKeyboard, 0);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_KeyMatrix[0], 0xff);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_KeyMatrix[1], 0xff);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_KeyMatrix[2], 0xff);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_KeyMatrix[3], 0xff);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_KeyMatrix[4], 0xff);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_KeyMatrix[5], 0xff);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_KeyMatrix[6], 0xff);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_KeyMatrix[7], 0xff);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastX, 101);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastY, 237);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX, 101);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY, 237);

    OCMVerify([_objectCoordinator initializeObjects]);
    
    XCTAssertEqual(_target.children.count, 7);
    XCTAssertEqual(_target.sprites.count, 3);
    OCMVerify([_textureManager configureSprite:_target.sprites[0] forCob:_cobs + 0 andScene:_target andCamera:_target.camera includeBackgroundSavers:YES]);
    OCMVerify([_textureManager configureSprite:_target.sprites[1] forCob:_cobs + 1 andScene:_target andCamera:_target.camera includeBackgroundSavers:YES]);
    OCMVerify([_textureManager configureSprite:_target.sprites[2] forCob:_cobs + 2 andScene:_target andCamera:_target.camera includeBackgroundSavers:YES]);

    // Does the background start at the right point?
    XCTAssertTrue(CGPointEqualToPoint(_target.camera.position, CGPointMake(362, -337)));
}

- (void)testInitializeLevelWithJoystick {
    [self commonInit];
    OCMStub([_joystickController useHardwareJoystick]).andReturn(NO);
    [self.target initializeLevel];
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_UseKeyboard, 1);
}

- (void)testInitializeWithBadInputs {
    DSLevel *levelObj = [[DSLevel alloc] initWithInitLevel:initLevel backgroundNewXY:backgroundNewXY];
    levelObj.tilemapImagePath = @"../../tiles/mytile.png";
    levelObj.tilemapSize = DSPointMake(161, 64);
    levelObj.tilemapStart = DSPointMake(3, 7);
    
    OCMStub([_resourceController imageWithName:@"tiles/mytile.png"]).andReturn(@"hires/tiles/mytile.png");
    NSString *imagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"forest" ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    OCMStub([_bundle pathForResource:@"hires/tiles/mytile" ofType:@"png"]).andReturn(imagePath);
    CGRect tileMapRect = CGRectMake(3, 7, 160, 64);
    SKNode *node = [[SKNode alloc] init];
    OCMStub([_tileMapMaker nodeFromImage:OCMArg.any withRect:tileMapRect usingTileImage:OCMArg.any withTileRect:tileMapRect]).andDo(^(NSInvocation *invocation) {
        UIImage *loadedImage;
        [invocation getArgument:(void *)&loadedImage atIndex:2];
        XCTAssertTrue([DSTestUtils image:loadedImage isSameAsImage:image]);
    }).andReturn(node);
    
    XCTAssertThrows([self.target initializeLevel]);
    XCTAssertEqual(initLevelCount, 0);
    XCTAssertEqual(backgroundNewXYCount, 0);
}

- (void) testRunOneGameLoop {
    [self commonInit];
    OCMStub([_joystickController useHardwareJoystick]).andReturn(YES);
    id joystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    [self.target initializeLevel];
    
    _levelObj.bkgrndStartX = 50;
    _levelObj.bkgrndStartY = 100;
    DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = 27;
    DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY = 101;
    OCMStub([_objectCoordinator updateOrReactivateObjects]).andReturn(0);
    OCMStub([_joystickController joystick]).andReturn(joystick);
    OCMStub([joystick xaxisPosition]).andReturn(20);
    OCMStub([joystick yaxisPosition]).andReturn(41);
    OCMStub([joystick button0Pressed]).andReturn(NO);
    OCMStub([joystick button1Pressed]).andReturn(NO);

    [self.target runOneGameLoop];
    OCMVerify([_objectCoordinator updateOrReactivateObjects]);
    XCTAssertEqual(self.target.camera.position.x, 214);
    XCTAssertEqual(self.target.camera.position.y, -201);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_JoystickX, 20);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_JoystickY, 41);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_Buttons, Joy1Button1 | Joy1Button2 | Joy2Button1 | Joy2Button2);
    for(size_t ii=0; ii<3; ii++) {
        OCMVerify( [_textureManager configureSprite:_target.sprites[ii] forCob:_cobs + ii andScene:_target andCamera:_target.camera includeBackgroundSavers:NO]);
        OCMVerify( [_textureManager configureSprite:_target.sprites[ii] forCob:_cobs + ii andScene:_target andCamera:_target.camera includeBackgroundSavers:YES]);
    }
    
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastX, 27);
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastY, 101);
    XCTAssertEqual(backgroundNewXYCount, 1);
}

- (void) testRunOneGameLoopTransitionToInit {
    [self commonInit];
    [self.target initializeLevel];
    SKScene *scene = [[SKScene alloc] init];
    OCMStub([_sceneController transitionSceneForLevel:0]).andReturn(scene);
    OCMStub([_objectCoordinator updateOrReactivateObjects]).andReturn(255);
    [self.target runOneGameLoop];
    OCMVerify([_sceneController transitionSceneForLevel:0]);
    XCTAssertTrue(self.target.isDone);
}

- (void) testRunOneGameLoopTransitionToNewScene {
    [self commonInit];
    [self.target initializeLevel];
    SKScene *scene = [[SKScene alloc] init];
    OCMStub([_sceneController transitionSceneForLevel:3]).andReturn(scene);
    OCMStub([_objectCoordinator updateOrReactivateObjects]).andReturn(3);
    [self.target runOneGameLoop];
    OCMVerify([_sceneController transitionSceneForLevel:3]);
    XCTAssertTrue(self.target.isDone);
}

- (void)testRunOneGameLoopButton0Pressed {
    [self commonInit];
    OCMStub([_joystickController useHardwareJoystick]).andReturn(YES);
    id joystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    [self.target initializeLevel];
    
    OCMStub([_joystickController joystick]).andReturn(joystick);
    OCMStub([joystick button0Pressed]).andReturn(YES);
    OCMStub([joystick button1Pressed]).andReturn(NO);
    [self.target runOneGameLoop];
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_Buttons, Joy1Button2 | Joy2Button1 | Joy2Button2);
}

- (void)testRunOneGameLoopButton1Pressed {
    [self commonInit];
    OCMStub([_joystickController useHardwareJoystick]).andReturn(YES);
    id joystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    [self.target initializeLevel];
    
    OCMStub([_joystickController joystick]).andReturn(joystick);
    OCMStub([joystick button0Pressed]).andReturn(NO);
    OCMStub([joystick button1Pressed]).andReturn(YES);
    [self.target runOneGameLoop];
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_Buttons, Joy1Button1 | Joy2Button1 | Joy2Button2);
}

- (void)testUpdate {
    [self commonInit];
    OCMStub([_joystickController useHardwareJoystick]).andReturn(YES);
    id joystick = OCMClassMock(DSCoCoKeyboardJoystick.class);
    [self.target initializeLevel];
    
    OCMStub([_joystickController joystick]).andReturn(joystick);
    OCMStub([joystick button0Pressed]).andReturn(YES);
    OCMStub([joystick button1Pressed]).andReturn(NO);
    [self.target update:1];
    XCTAssertEqual(DynospriteDirectPageGlobalsPtr->Input_Buttons, Joy1Button2 | Joy2Button1 | Joy2Button2);
}

- (void)testRunOneGameLoopTransfersButtonPresses {
    [self commonInit];
    [self.target initializeLevel];
    byte *matrix = DynospriteDirectPageGlobalsPtr->Input_KeyMatrix;
    memset(matrix, 0, sizeof(DynospriteDirectPageGlobalsPtr->Input_KeyMatrix));
    
    [self pressKey:@"p" modifiedChars:@""];
    [self pressKey:UIKeyInputEscape modifiedChars:@""];
    [self pressKey:@"y" modifiedChars:@""];
    [self pressKey:@"n" modifiedChars:@""];
    [self.target runOneGameLoop];
    XCTAssertEqual(matrix[0], 0xff & ~0x04);
    XCTAssertEqual(matrix[2], 0xff & ~0x40);
    XCTAssertEqual(matrix[1], 0xff & ~0x08);
    XCTAssertEqual(matrix[6], 0xff & ~0x02);
    [self unpressKey:@"p" modifiedChars:@""];
    [self unpressKey:UIKeyInputEscape modifiedChars:@""];
    [self unpressKey:@"y" modifiedChars:@""];
    [self unpressKey:@"n" modifiedChars:@""];
    [self.target runOneGameLoop];
    XCTAssertEqual(matrix[0], 0xff);
    XCTAssertEqual(matrix[2], 0xff);
    XCTAssertEqual(matrix[1], 0xff);
    XCTAssertEqual(matrix[6], 0xff);
}
@end
