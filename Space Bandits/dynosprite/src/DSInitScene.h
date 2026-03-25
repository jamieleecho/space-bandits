//
//  InitScene.h
//  dynosprite
//
//  Created by Jamie Cho on 1/6/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSTransitionScene.h"
#import "DSSceneControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum DSInitSceneDisplay {
    DSInitSceneDisplayLow,
    DSInitSceneDisplayHigh
} DSInitSceneDisplay;

typedef enum DSInitSceneControl {
    DSInitSceneControlKeyboard,
    DSInitSceneControlJoystick
} DSInitSceneControl;

typedef enum DSInitSceneSound {
    DSInitSceneSoundNone = -1,
    DSInitSceneSoundLow,
    DSInitSceneSoundHigh
} DSInitSceneSound;

@interface DSInitScene : DSTransitionScene {
    SKLabelNode *_resolutionLabelNode;
    SKLabelNode *_controlLabelNode;
    SKLabelNode *_soundLabelNode;
    SKLabelNode *_musicLabelNode;

    DSInitSceneDisplay _resolution;
    DSInitSceneControl _control;
    DSInitSceneSound _sound;
    bool _musicEnabled;
    
    bool _alwaysPressed;
    bool _isTransitioning;
}
+ (NSString *)textFromResolution:(DSInitSceneDisplay)resolution;
+ (NSString *)textFromControl:(DSInitSceneControl)control;
+ (NSString *)textFromSound:(DSInitSceneSound)sound;

@property (nonatomic) NSInteger firstLevel;

- (void)didMoveToView:(SKView *)view;
- (void)willMoveFromView:(SKView *)view;

- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event;

- (void)transitionToNextScreen;

- (void)toggleDisplay;
- (DSInitSceneDisplay)display;

- (void)toggleControl;
- (DSInitSceneControl)control;

- (void)toggleSound;
- (DSInitSceneSound)sound;

- (void)toggleMusic;
- (bool)musicEnabled;

- (void)poll;

@end

NS_ASSUME_NONNULL_END
