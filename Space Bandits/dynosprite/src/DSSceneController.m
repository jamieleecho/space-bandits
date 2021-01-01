//
//  DSSceneController.m
//  dynosprite
//
//  Created by Jamie Cho on 1/27/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSInitScene.h"
#import "DSLevelLoadingScene.h"
#import "DSSceneController.h"
#import "DSTransitionSceneInfoFileParser.h"


@implementation DSSceneController

- (id)init {
    if (self = [super init]) {
        self.bundle = NSBundle.mainBundle;
        self.levelRegistry = DSLevelRegistry.sharedInstance;
        self.sceneInfos = @[];
    }
    return self;
}

- (DSTransitionScene *)transitionSceneForLevel:(int)level {
    if (level < 0) {
        return nil;
    }
    DSTransitionScene *transitionScene = (level == 0) ? [[DSInitScene alloc] init] : [[DSLevelLoadingScene alloc] init];
    transitionScene.resourceController = self.resourceController;
    transitionScene.joystickController = self.joystickController;
    transitionScene.backgroundColor = self.sceneInfos[level].backgroundColor;
    transitionScene.foregroundColor = self.sceneInfos[level].foregroundColor;
    transitionScene.progressBarColor = self.sceneInfos[level].progressColor;
    transitionScene.backgroundImageName = [self.resourceController imageWithName:self.sceneInfos[level].backgroundImageName];
    transitionScene.levelNumber = level;
    
    transitionScene.sceneController = self;
    if (level != 0) {
        DSLevelLoadingScene *levelLoadingScene = (DSLevelLoadingScene *)transitionScene;
        levelLoadingScene.levelName = [self.levelRegistry levelForIndex:level].name;
        levelLoadingScene.levelDescription = [self.levelRegistry levelForIndex:level].levelDescription;
    }
    
    return transitionScene;
}

- (DSGameScene *)gameSceneForLevel:(int)level {
    // Get the level and initialize it
    DSLevel *levelObj = [self.levelRegistry levelForIndex:level];
    levelObj.initLevel();

    // Create the tilesets for the level background
    DSTileInfo *tileInfo = [self.tileInfoRegistry tileInfoForNumber:levelObj.tilesetIndex];
    NSString *tileImagePath = tileInfo.imagePath;
    while([tileImagePath hasPrefix:@"../"]) {
        tileImagePath = [tileImagePath substringWithRange:NSMakeRange(3, tileImagePath.length - 3)];
    }
    tileImagePath = [self.resourceController imageWithName:tileImagePath];
    NSImage *tileImage = [[NSImage alloc] initWithContentsOfFile:[self.bundle pathForResource:tileImagePath.stringByDeletingPathExtension ofType:tileImagePath.pathExtension]];
    NSRect tileImageRect = NSMakeRect(tileInfo.tileSetStart.x, tileInfo.tileSetStart.y, tileInfo.tileSetSize.x, tileInfo.tileSetSize.y);
    
    // Get the image used to create the map (screen)
    NSString *mapImagePath = levelObj.tilemapImagePath;
    while([mapImagePath hasPrefix:@"../"]) {
        mapImagePath = [mapImagePath substringWithRange:NSMakeRange(3, mapImagePath.length - 3)];
    }
    mapImagePath = [self.resourceController imageWithName:mapImagePath];
    NSImage *mapImage = [[NSImage alloc] initWithContentsOfFile:[self.bundle pathForResource:tileImagePath.stringByDeletingPathExtension ofType:mapImagePath.pathExtension]];
    NSRect mapImageRect = NSMakeRect(levelObj.tilemapStart.x, levelObj.tilemapStart.y, levelObj.tilemapSize.x, levelObj.tilemapSize.y);

    // Create the game scene
    SKTileMapNode *tileMapNode = [self.tileMapMaker nodeFromImage:mapImage withRect:mapImageRect usingTileImage:tileImage withTileRect:tileImageRect];
    DSGameScene *gameScene = [[DSGameScene alloc] initWithLevel:levelObj andObjectCoordinator:self.objectCoordinator andTileMapNode:tileMapNode andTextureManager:self.textureManager];
    
    gameScene.joystickController = self.joystickController;
    gameScene.levelNumber = level;
    
    return gameScene;
}

@end
