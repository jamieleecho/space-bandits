//
//  DSImageController.m
//  dynosprite
//
//  Created by Jamie Cho on 1/27/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSInitScene.h"
#import "DSLevelLoadingScene.h"
#import "DSTransitionSceneController.h"
#import "DSTransitionSceneInfoFileParser.h"


@implementation DSTransitionSceneController

- (id)init {
    if (self = [super init]) {
        self.sceneInfos = @[];
        self.levelRegistry = DSLevelRegistry.sharedInstance;
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
    
    if (level == 0) {
        DSInitScene *initScene = (DSInitScene *)transitionScene;
        initScene.transitionSceneController = self;
    } else {
        DSLevelLoadingScene *levelLoadingScene = (DSLevelLoadingScene *)transitionScene;
        levelLoadingScene.levelName = [self.levelRegistry levelForIndex:level].name;
        levelLoadingScene.levelDescription = [self.levelRegistry levelForIndex:level].levelDescription;
    }
    
    return transitionScene;
}

@end
