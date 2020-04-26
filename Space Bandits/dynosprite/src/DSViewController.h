//
//  DSViewController.h
//  dynosprite
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

#import "DSSharedTransitionSceneController.h"


@interface DSViewController : NSViewController

@property (nonatomic, nonnull) IBOutlet SKView *skView;
@property (nonatomic, nonnull) IBOutlet NSObject <DSTransitionSceneControllerProtocol> *transitionSceneController;

@end

