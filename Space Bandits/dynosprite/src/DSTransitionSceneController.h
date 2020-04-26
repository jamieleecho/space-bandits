//
//  DSImageController.h
//  dynosprite
//
//  Created by Jamie Cho on 1/27/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSCoCoJoystickController.h"
#import "DSResourceController.h"
#import "DSTransitionSceneControllerProtocol.h"
#import "DSTransitionSceneInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSTransitionSceneController : NSObject <DSTransitionSceneControllerProtocol>

@property (nonnull, nonatomic) IBOutlet NSArray<DSTransitionSceneInfo *> *sceneInfos;
@property (nonnull, nonatomic) IBOutlet DSResourceController *resourceController;
@property (nonnull, nonatomic) IBOutlet DSCoCoJoystickController *joystickController;

- (id)init;
- (DSTransitionScene *)transitionSceneForLevel:(int)level;

@end

NS_ASSUME_NONNULL_END
