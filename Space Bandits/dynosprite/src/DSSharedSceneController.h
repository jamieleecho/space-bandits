//
//  DSSharedSceneController.h
//  dynosprite
//
//  Created by Jamie Cho on 5/12/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSSceneControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSSharedSceneController : NSObject <DSSceneControllerProtocol>

@property (assign, readonly) NSObject <DSSceneControllerProtocol> *sceneController;

- (id)init;
- (id)initWithSceneController:(NSObject <DSSceneControllerProtocol> *)sController;

@end

NS_ASSUME_NONNULL_END
