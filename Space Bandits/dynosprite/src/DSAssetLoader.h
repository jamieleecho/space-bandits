//
//  DSAssetLoader.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/24/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSLevelFileParser.h"
#import "DSMutableArrayWrapper.h"
#import "DSResourceController.h"
#import "DSSoundManager.h"
#import "DSSpriteObjectClassFactory.h"
#import "DSSpriteFileParser.h"
#import "DSTileInfoRegistry.h"
#import "DSTransitionImageLoader.h"
#import "DSTransitionSceneInfoFileParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSAssetLoader : NSObject

@property (nonatomic, nonnull) IBOutlet DSLevelFileParser *levelFileParser;
@property (nonatomic, nonnull) IBOutlet DSTransitionSceneInfoFileParser *transitionSceneInfoFileParser;
@property (nonatomic, nonnull) DSLevelRegistry *registry;
@property (nonatomic, nonnull) IBOutlet DSMutableArrayWrapper *sceneInfos;
@property (nonatomic, nonnull) IBOutlet DSSoundManager *soundManager;
@property (nonatomic, nonnull) IBOutlet DSSpriteObjectClassFactory *spriteObjectClassFactory;
@property (nonatomic, nonnull) IBOutlet DSSpriteFileParser *objectParser;
@property (nonatomic, nonnull) IBOutlet DSResourceController *resourceController;
@property (nonatomic, nonnull) IBOutlet DSTileInfoRegistry *tileInfoRegistry;
@property (nonatomic, nonnull) IBOutlet DSTransitionImageLoader *imageLoader;
@property (nonatomic, nonnull) NSBundle *bundle;

- (id)init;
- (void)loadLevels;
- (void)loadSounds;
- (void)loadSprites;
- (void)loadSceneInfos;
- (void)loadTransitionSceneImages;
- (void)loadTileSets;

@end

NS_ASSUME_NONNULL_END
