//
//  DSGameScene.m
//  Space Bandits
//
//  Created by Jamie Cho on 5/3/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSGameScene.h"

@implementation DSGameScene

- (id)initWithLevel:(DSLevel *)level andObjectCoordinator:(DSObjectCoordinator *)coordinator andTileMapNode:(SKTileMapNode *)tileMapNode andTextureManager:(DSTextureManager *)textureManager {
    if (self = [super init]) {
        self.size = CGSizeMake(320, 200);
        self.anchorPoint = CGPointMake(0, 1);
        _tileMapNode = tileMapNode;
        [self addChild:tileMapNode];
    }
    
    return self;
}


@end
