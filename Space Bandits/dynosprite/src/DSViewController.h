//
//  DSViewController.h
//  dynosprite
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

#import "DSSharedSceneController.h"


@interface DSViewController : UIViewController

@property (nonatomic, nonnull) IBOutlet SKView *skView;
@property (nonatomic, nonnull) IBOutlet NSObject <DSSceneControllerProtocol> *sceneController;

@end

