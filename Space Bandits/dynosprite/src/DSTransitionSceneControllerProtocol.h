//
//  DSTransitionSceneControllerProtocol.h
//  dynosprite
//
//  Created by Jamie Cho on 1/27/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSTransitionScene.h"

@protocol DSTransitionSceneControllerProtocol <NSObject>

- (NSArray *)images;
- (DSTransitionScene *)transitionSceneForLevel:(int)level;

@end
