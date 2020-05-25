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
#import "DSResourceController.h"
#import "DSSceneControllerProtocol.h"
#import "DSTileInfoRegistry.h"
#import "DSTransitionSceneInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSSceneController : NSObject <DSSceneControllerProtocol>

@property (nonatomic, nonnull) IBOutlet NSBundle *bundle;
@property (nonnull, nonatomic) IBOutlet DSCoCoJoystickController *joystickController;
@property (nonnull, nonatomic) IBOutlet DSLevelRegistry *levelRegistry;
@property (nonatomic, nonnull) IBOutlet DSResourceController *resourceController;
@property (nonnull, nonatomic) IBOutlet NSArray<DSTransitionSceneInfo *> *sceneInfos;
@property (nonnull, nonatomic) IBOutlet DSTileInfoRegistry *tileInfoRegistry;
@property (nonatomic, nonnull) IBOutlet DSTileMapMaker *tileMapMaker;

- (id)init;
- (DSTransitionScene *)transitionSceneForLevel:(int)level;
- (DSGameScene *)gameSceneForLevel:(int)level;

@end

NS_ASSUME_NONNULL_END
