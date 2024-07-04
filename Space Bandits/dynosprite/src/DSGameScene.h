//
//  DSGameScene.h
//  Space Bandits
//
//  Created by Jamie Cho on 5/3/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSLevel.h"
#import "DSScene.h"
#import "DSObjectCoordinator.h"
#import "DSTextureManager.h"
#import "DSTileInfo.h"
#import "DSTileMapMaker.h"

NS_ASSUME_NONNULL_BEGIN

@class DSSceneController;

@interface DSGameScene : DSScene {
    DSLevel *_levelObj;
    DSObjectCoordinator *_coordinator;
    DSTextureManager *_textureManager;
    DSResourceController *_resourceController;
    DSTileInfo *_tileInfo;
    DSTileMapMaker *_tileMapMaker;
    NSBundle *_bundle;
    DSObjectCoordinator *_objectCoordinator;
    SKTileMapNode *_tileMapNode;
    NSArray<SKSpriteNode *> *_sprites;
    DSSceneController *_sceneController;
    NSArray<SKSpriteNode *> *_paintedBackgrounds;
    DSPoint _lastOffset;
}

- (DSLevel *)levelObj;
- (DSResourceController *)resourceController;
- (DSTileInfo *)tileInfo;
- (DSTileMapMaker *)tileMapMaker;
- (NSBundle *)bundle;
- (DSObjectCoordinator *)objectCoordinator;
- (DSObjectCoordinator *)coordinator;
- (DSTextureManager *)textureManager;
- (NSArray <SKSpriteNode *> *)sprites;

- (id)initWithLevel:(DSLevel *)level andResourceController:(DSResourceController *)resourceController andTileInfo:(DSTileInfo *)tileInfo andTileMapMaker:(DSTileMapMaker *)tileMapMaker andBundle:(NSBundle *)bundle andObjectCoordinator:(DSObjectCoordinator *)coordinator andTextureManager:(DSTextureManager *)textureManager andSceneController:(DSSceneController *)sceneController;

- (void)initializeLevel;
- (void)runOneGameLoop;

@end

NS_ASSUME_NONNULL_END
