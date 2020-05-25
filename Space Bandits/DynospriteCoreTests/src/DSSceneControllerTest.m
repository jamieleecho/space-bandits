//
//  DSSceneControllerTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 1/27/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "DSInitScene.h"
#import "DSLevelLoadingScene.h"
#import "DSSceneController.h"
#import "DSTestUtils.h"
#import "DSTransitionSceneInfoFileParser.h"


@interface DSSceneControllerTest : XCTestCase {
    DSSceneController *_target;
    NSDictionary *_initImage;
    NSDictionary *_level1Image;
    NSDictionary *_level2Image;
    DSLevel *_level;
    id _bundle;
    id _joystickController;
    id _levelRegistry;
    id _resourceController;
    id _tileInfoRegistry;
    id _tileMapMaker;
    id _transitionSceneController;
}


@end

@implementation DSSceneControllerTest

- (void)setUp {
    _initImage = @{
        @"BackgroundColor": @"ffffff",
        @"ForegroundColor": @"000000",
        @"ProgressColor": @"1bb43a"
    };
    _level1Image = @{
        @"BackgroundColor": @"1fffff",
        @"ForegroundColor": @"100000",
        @"ProgressColor": @"1bb43a"
    };
    _level2Image = @{
        @"BackgroundColor": @"2fffff",
        @"ForegroundColor": @"200000",
        @"ProgressColor": @"3bb43a"
    };

    _target = [[DSSceneController alloc] init];
    XCTAssertTrue([_target.sceneInfos isKindOfClass:NSArray.class]);
    XCTAssertEqual(_target.levelRegistry, DSLevelRegistry.sharedInstance);
    XCTAssertEqual(_target.bundle, NSBundle.mainBundle);
    XCTAssertNil(_target.joystickController);
    XCTAssertNil(_target.resourceController);
    XCTAssertNil(_target.tileInfoRegistry);
    XCTAssertNil(_target.tileMapMaker);
    
    NSArray<DSTransitionSceneInfo *>*sceneInfos = @[
        [[DSTransitionSceneInfo alloc] init],
        [[DSTransitionSceneInfo alloc] init],
        [[DSTransitionSceneInfo alloc] init]
    ];
    sceneInfos[0].backgroundColor = [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    sceneInfos[0].foregroundColor = [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    sceneInfos[0].progressColor = [NSColor colorWithCalibratedRed:0x1b/255.0f green:0xb4/255.0f blue:0x3a/255.0f alpha:1.0f];

    sceneInfos[1].backgroundColor = [NSColor colorWithCalibratedRed:0x1f/255.0f green:1.0f blue:1.0f alpha:1.0f];
    sceneInfos[1].foregroundColor = [NSColor colorWithCalibratedRed:0x10/255.0f green:0.0f blue:0.0f alpha:1.0f];
    sceneInfos[1].progressColor = [NSColor colorWithCalibratedRed:0x1b/255.0f green:0xb4/255.0f blue:0x3a/255.0f alpha:1.0f];

    sceneInfos[2].backgroundColor = [NSColor colorWithCalibratedRed:0x2f/255.0f green:1.0f blue:1.0f alpha:1.0f];
    sceneInfos[2].foregroundColor = [NSColor colorWithCalibratedRed:0x20/255.0f green:0.0f blue:0.0f alpha:1.0f];
    sceneInfos[2].progressColor = [NSColor colorWithCalibratedRed:0x3b/255.0f green:0xb4/255.0f blue:0x3a/255.0f alpha:1.0f];
    _target.sceneInfos = sceneInfos;
    
    _level.name = @"Omicron Persei 8";
    _level.levelDescription = @"Do Something!";
    
    _levelRegistry = OCMClassMock(DSLevelRegistry.class);
    _target.levelRegistry = _levelRegistry;
    
    _bundle = OCMClassMock(NSBundle.class);
    _joystickController = OCMClassMock(DSCoCoJoystickController.class);
    _levelRegistry = OCMClassMock(DSLevelRegistry.class);
    _resourceController = OCMClassMock(DSResourceController.class);
    _tileInfoRegistry = OCMClassMock(DSTileInfoRegistry.class);
    _tileMapMaker = OCMClassMock(DSTileMapMaker.class);
    
    _target.bundle = _bundle;
    _target.joystickController = _joystickController;
    _target.levelRegistry = _levelRegistry;
    _target.resourceController = _resourceController;
    _target.tileInfoRegistry = _tileInfoRegistry;
    _target.tileMapMaker = _tileMapMaker;
    
    XCTAssertEqual(_target.bundle, _bundle);
    XCTAssertEqual(_target.joystickController, _joystickController);
    XCTAssertEqual(_target.levelRegistry, _levelRegistry);
    XCTAssertEqual(_target.resourceController, _resourceController);
    XCTAssertEqual(_target.tileInfoRegistry, _tileInfoRegistry);
    XCTAssertEqual(_target.tileMapMaker, _tileMapMaker);
}

- (void)testCreatesColors {
    XCTAssertEqualObjects([DSTransitionSceneInfoFileParser colorFromRGBString:@"f3Ab24"],
                          [NSColor colorWithCalibratedRed:0xf3/255.0f green:0xab/255.0f blue:0x24/255.0f alpha:1]);
    XCTAssertThrows([DSTransitionSceneInfoFileParser colorFromRGBString:@"#f3Ab24"]);
    XCTAssertThrows([DSTransitionSceneInfoFileParser colorFromRGBString:@"f3Ab24aa"]);
}

- (void)testCreatesLevels {
    DSInitScene *initScene = (DSInitScene *)[_target transitionSceneForLevel:0];
    XCTAssertEqualObjects(initScene.backgroundColor, [[NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.0f] colorUsingColorSpace:initScene.backgroundColor.colorSpace]);
    XCTAssertEqualObjects(initScene.foregroundColor, [NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:1.0f]);
    XCTAssertEqualObjects(initScene.progressBarColor, [NSColor colorWithCalibratedRed:0x1b/255.0f green:0xb4/255.0f blue:0x3a/255.0f alpha:1]);
    XCTAssertEqual(initScene.class, DSInitScene.class);
    XCTAssertEqual(initScene.sceneController, _target);
    
    OCMStub([_levelRegistry levelForIndex:2]).andReturn(_level);
    DSLevelLoadingScene *loadingScene = (DSLevelLoadingScene *)[_target transitionSceneForLevel:2];
    XCTAssertEqual(loadingScene.class, DSLevelLoadingScene.class);
    XCTAssertEqual(loadingScene.joystickController, _joystickController);
    XCTAssertEqual(loadingScene.levelName, _level.name);
    XCTAssertEqual(loadingScene.levelNumber, 2);
    XCTAssertEqual(loadingScene.levelDescription, _level.levelDescription);
    XCTAssertEqual(loadingScene.sceneController, _target);

}

- (void)testCreatesNewLevels {
    DSTransitionScene *scene1 = [_target transitionSceneForLevel:2];
    DSTransitionScene *scene2 = [_target transitionSceneForLevel:2];
    XCTAssertNotEqual(scene1, scene2);
}

- (void)testGameSceneForLevel {
    const int level = 3;
    DSLevel *levelObj = [[DSLevel alloc] init];
    levelObj.tilemapImagePath = @"../../tiles/mytile.png";
    levelObj.tilemapSize = DSPointMake(160, 64);
    levelObj.tilemapStart = DSPointMake(3, 7);
    levelObj.tilesetIndex = 4;
    
    OCMStub([_levelRegistry levelForIndex:level]).andReturn(levelObj);
    OCMStub([_resourceController imageWithName:@"tiles/mytile.png"]).andReturn(@"hires/tiles/mytile.png");
    NSString *imagePath = [[NSBundle bundleForClass:self.class] pathForImageResource:@"forest"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
    OCMStub([_bundle pathForResource:@"hires/tiles/mytile" ofType:@"png"]).andReturn(imagePath);
    NSRect tileMapRect = NSMakeRect(3, 7, 160, 64);
    SKNode *node = [[SKNode alloc] init];
    OCMStub([_tileMapMaker nodeFromTileImage:[OCMArg any] withTileRect:tileMapRect]).andDo(^(NSInvocation *invocation) {
        NSImage *loadedImage;
        [invocation getArgument:(void *)&loadedImage atIndex:2];
        XCTAssertTrue([DSTestUtils image:loadedImage isSameAsImage:image]);
    }).andReturn(node);
    DSTileInfo *tileInfo = [[DSTileInfo alloc] init];
    tileInfo.imagePath = @"tiles/mytile.png";
    OCMStub([_tileInfoRegistry tileInfoForNumber:4]).andReturn(tileInfo);
    
    DSGameScene *gameScene = [_target gameSceneForLevel:level];
    XCTAssertEqual(gameScene.children.firstObject, node);
    XCTAssertEqual(gameScene.levelNumber, level);
    XCTAssertEqual(gameScene.joystickController, _joystickController);
}

- (void)testGameSceneForLevelWithBadInputs {
    const int level = 3;
    DSLevel *levelObj = [[DSLevel alloc] init];
    levelObj.tilemapImagePath = @"../../tiles/mytile.png";
    levelObj.tilemapSize = DSPointMake(161, 64);
    levelObj.tilemapStart = DSPointMake(3, 7);
    
    OCMStub([_levelRegistry levelForIndex:level]).andReturn(levelObj);
    OCMStub([_resourceController imageWithName:@"tiles/mytile.png"]).andReturn(@"hires/tiles/mytile.png");
    NSString *imagePath = [[NSBundle bundleForClass:self.class] pathForImageResource:@"forest"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
    OCMStub([_bundle pathForResource:@"hires/tiles/mytile" ofType:@"png"]).andReturn(imagePath);
    NSRect tileMapRect = NSMakeRect(3, 7, 160, 64);
    SKNode *node = [[SKNode alloc] init];
    OCMStub([_tileMapMaker nodeFromTileImage:[OCMArg any] withTileRect:tileMapRect]).andDo(^(NSInvocation *invocation) {
        NSImage *loadedImage;
        [invocation getArgument:(void *)&loadedImage atIndex:2];
        XCTAssertTrue([DSTestUtils image:loadedImage isSameAsImage:image]);
    }).andReturn(node);
    
    XCTAssertThrows([_target gameSceneForLevel:level]);
}

@end
