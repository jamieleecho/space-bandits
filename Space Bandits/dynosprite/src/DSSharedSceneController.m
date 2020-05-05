//
//  DSSharedSceneController.m
//  dynosprite
//
//  Created by Jamie Cho on 5/12/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSSharedSceneController.h"
#import "DSAppDelegate.h"

@interface DSSharedSceneController()
@property (assign, readwrite) NSObject <DSSceneControllerProtocol> *sceneController;
@end


@implementation DSSharedSceneController

- (id) init {
    return [self initWithSceneController:((DSAppDelegate *)(NSApplication.sharedApplication.delegate)).sceneController];
}

- (id)initWithSceneController:(NSObject <DSSceneControllerProtocol> *)sceneController {
    if (self = [super init]) {
        self.sceneController = sceneController;
    }
    return self;
}

- (NSArray *)sceneInfos {
    return self.sceneController.sceneInfos;
}

- (DSTransitionScene *)transitionSceneForLevel:(int)level {
    return [self.sceneController transitionSceneForLevel:level];
}

- (DSTransitionScene *)gameSceneForLevel:(int)level {
    return nil;
}

@end
