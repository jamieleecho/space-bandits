//
//  InitScene.h
//  Space Bandits
//
//  Created by Jamie Cho on 1/6/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSTransitionScene.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum DSInitSceneResolution {
    DSInitSceneResolutionLow,
    DSInitSceneResolutionHigh
} DSInitSceneResolution;

typedef enum DSInitSceneControl {
    DSInitSceneControlKeyboard,
DSInitSceneControlJoystick
} DSInitSceneControl;

typedef enum DSInitSceneSound {
    DSInitSceneSoundLow,
    DSInitSceneSoundHigh
} DSInitSceneSound;

@interface DSInitScene : DSTransitionScene {
    SKLabelNode *_resolutionLabelNode;
    SKLabelNode *_controlLabelNode;
    SKLabelNode *_soundLabelNode;
    
    DSInitSceneResolution _resolution;
    DSInitSceneControl _control;
    DSInitSceneSound _sound;
}

- (void)didMoveToView:(SKView *)view;
- (void)willMoveFromView:(SKView *)view;

- (void)mouseUp:(NSEvent *)theEvent;
- (void)keyUp:(NSEvent *)theEvent;

- (NSString *)textFromResolution:(DSInitSceneResolution)resolution;
- (NSString *)textFromControl:(DSInitSceneControl)control;
- (NSString *)textFromSound:(DSInitSceneSound)sound;

- (void)refreshScreen;
- (void)transitionToNextScreen;

- (void)toggleResolution;
- (void)toggleControl;
- (void)toggleSound;

- (void)poll;

@end

NS_ASSUME_NONNULL_END
