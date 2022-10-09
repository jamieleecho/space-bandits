//
//  DSSceneControllerProtocol.h
//  dynosprite
//
//  Created by Jamie Cho on 1/27/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSGameScene.h"
#import "DSMutableArrayWrapper.h"

@class DSGameScene;
@class DSTransitionScene;
@class DSTransitionSceneInfo;

@protocol DSSceneControllerProtocol <NSObject>

- (DSMutableArrayWrapper<DSTransitionSceneInfo *> *)sceneInfos;

- (DSGameScene *)gameSceneForLevel:(int)level;
- (DSTransitionScene *)transitionSceneForLevel:(int)level;

@end
