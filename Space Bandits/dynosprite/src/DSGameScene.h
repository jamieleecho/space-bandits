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
#import "DSTileMapMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSGameScene : DSScene {
    DSLevel *_level;
    DSObjectCoordinator *_coordinator;
    SKTileMapNode *_tileMapNode;
    DSTextureManager *_textureManager;
    
}

- (id)initWithLevel:(DSLevel *)level andObjectCoordinator:(DSObjectCoordinator *)coordinator andTileMapNode:(SKTileMapNode *)tileMapNode andTextureManager:(DSTextureManager *)textureManager;

@end

NS_ASSUME_NONNULL_END
