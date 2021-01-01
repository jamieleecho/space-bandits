//
//  DSSceneController.h
//  dynosprite
//
//  Created by Jamie Cho on 1/27/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSCoCoJoystickController.h"
#import "DSGameScene.h"
#import "DSLevelRegistry.h"
#import "DSObjectCoordinator.h"
#import "DSResourceController.h"
#import "DSSceneControllerProtocol.h"
#import "DSTextureManager.h"
#import "DSTileInfoRegistry.h"
#import "DSTransitionSceneInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSSceneController : NSObject <DSSceneControllerProtocol>

@property (nonatomic, nonnull) IBOutlet NSBundle *bundle;
@property (nonatomic, nonnull) IBOutlet DSCoCoJoystickController *joystickController;
@property (nonatomic, nonnull) IBOutlet DSLevelRegistry *levelRegistry;
@property (nonatomic, nonnull) IBOutlet DSResourceController *resourceController;
@property (nonatomic, nonnull) IBOutlet NSArray<DSTransitionSceneInfo *> *sceneInfos;
@property (nonatomic, nonnull) IBOutlet DSTileInfoRegistry *tileInfoRegistry;
@property (nonatomic, nonnull) IBOutlet DSTileMapMaker *tileMapMaker;
@property (nonatomic, nonnull) IBOutlet DSObjectCoordinator *objectCoordinator;
@property (nonatomic, nonnull) IBOutlet DSTextureManager *textureManager;

- (id)init;
- (DSTransitionScene *)transitionSceneForLevel:(int)level;
- (DSGameScene *)gameSceneForLevel:(int)level;

@end

NS_ASSUME_NONNULL_END
