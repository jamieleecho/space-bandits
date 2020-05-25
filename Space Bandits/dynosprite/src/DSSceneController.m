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
    DSLevel *levelObj = [self.levelRegistry levelForIndex:level];
    DSTileInfo *tileInfo = [self.tileInfoRegistry tileInfoForNumber:levelObj.tilesetIndex];    
    NSString *tileMapImagePath = tileInfo.imagePath;
    while([tileMapImagePath hasPrefix:@"../"]) {
        tileMapImagePath = [tileMapImagePath substringWithRange:NSMakeRange(3, tileMapImagePath.length - 3)];
    }
    tileMapImagePath = [self.resourceController imageWithName:tileMapImagePath];
    NSImage *tileMapImage = [[NSImage alloc] initWithContentsOfFile:[self.bundle pathForResource:tileMapImagePath.stringByDeletingPathExtension ofType:tileMapImagePath.pathExtension]];
    NSRect tileMapRect = NSMakeRect(levelObj.tilemapStart.x, levelObj.tilemapStart.y, levelObj.tilemapSize.x, levelObj.tilemapSize.y);
    SKTileMapNode *tileMapNode = [self.tileMapMaker nodeFromTileImage:tileMapImage withTileRect:tileMapRect];
    DSGameScene *gameScene = [[DSGameScene alloc] initWithTileMapNode:tileMapNode];
    gameScene.joystickController = self.joystickController;
    gameScene.levelNumber = level;
    
    return gameScene;
}

@end
