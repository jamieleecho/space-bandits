//
//  DSSharedTransitionSceneController.m
//  dynosprite
//
//  Created by Jamie Cho on 5/12/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSSharedTransitionSceneController.h"
#import "DSAppDelegate.h"

@interface DSSharedTransitionSceneController()
@property (assign, readwrite) NSObject <DSTransitionSceneControllerProtocol> *transitionSceneController;
@end


@implementation DSSharedTransitionSceneController

- (id) init {
    return [self initWithTransitionSceneController:((DSAppDelegate *)(NSApplication.sharedApplication.delegate)).transitionSceneController];
}

- (id)initWithTransitionSceneController:(NSObject <DSTransitionSceneControllerProtocol> *)transitionSceneController {
    if (self = [super init]) {
        self.transitionSceneController = transitionSceneController;
    }
    return self;
}

- (NSArray *)sceneInfos {
    return self.transitionSceneController.sceneInfos;
}

- (DSTransitionScene *)transitionSceneForLevel:(int)level {
    return [self.transitionSceneController transitionSceneForLevel:level];
}

@end
