//
//  DSGameScene.h
//  Space Bandits
//
//  Created by Jamie Cho on 5/3/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSScene.h"
#import "DSTileMapMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSGameScene : DSScene {
    SKTileMapNode *_tileMapNode;
}

- (id)initWithTileMapNode:(SKTileMapNode *)tileMapNode;

@end

NS_ASSUME_NONNULL_END
