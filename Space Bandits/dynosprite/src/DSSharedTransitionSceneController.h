//
//  DSSharedTransitionSceneController.h
//  dynosprite
//
//  Created by Jamie Cho on 5/12/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DSTransitionSceneControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSSharedTransitionSceneController : NSObject <DSTransitionSceneControllerProtocol>

@property (assign, readonly) NSObject <DSTransitionSceneControllerProtocol> *transitionSceneController;

- (id)init;
- (id)initWithTransitionSceneController:(NSObject <DSTransitionSceneControllerProtocol> *)transitionController;

@end

NS_ASSUME_NONNULL_END
