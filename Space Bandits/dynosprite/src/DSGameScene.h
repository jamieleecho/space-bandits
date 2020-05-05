//
//  DSGameScene.h
//  Space Bandits
//
//  Created by Jamie Cho on 5/3/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DSTileMapMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSGameScene : SKScene {
    SKTileMapNode *_tileMapNode;
}

- (id)initWithTileMapNode:(SKTileMapNode *)tileMapNode;

@end

NS_ASSUME_NONNULL_END
