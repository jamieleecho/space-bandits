//
//  DSTransitionScene.h
//  dynosprite
//
//  Created by Jamie Cho on 1/14/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DSCoCoJoystickController.h"
#import "DSResourceController.h"
#import "DSScene.h"
#import "DSSceneControllerProtocol.h"
#import "DSSoundManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSTransitionScene : DSScene {
    @private
    NSString *_backgroundImageName;
    @private
    SKSpriteNode *_backgroundImage;
    @private
    NSMutableArray<SKLabelNode *> *_labels;
    @private
    NSMapTable <SKLabelNode *, NSValue *> *_labelToPoint;
    @private
    NSMapTable <SKLabelNode *, NSNumber *> *_labelToCentered;
}

@property (strong, nonatomic) NSString *backgroundImageName;
@property (strong, readonly) SKSpriteNode *backgroundImage;
@property (strong, nonatomic) NSColor *foregroundColor;
@property (strong, nonatomic) NSColor *progressBarColor;
@property (strong, readonly) NSArray<SKLabelNode *> *labels;
@property (strong, nonatomic) DSResourceController *resourceController;
@property (strong, nonatomic) DSSoundManager *soundManager;
@property (nonatomic) id<DSSceneControllerProtocol> sceneController;

- (id)init;
- (SKLabelNode *)addLabelWithText:(NSString *)labelText atPosition:(CGPoint)position;

@end

NS_ASSUME_NONNULL_END
