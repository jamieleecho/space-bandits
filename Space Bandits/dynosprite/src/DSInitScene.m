//
//  InitScene.m
//  dynosprite
//
//  Created by Jamie Cho on 1/6/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSInitScene.h"


static NSString *MenuControlJoystick = @"Joystick";
static NSString *MenuControlKeyboard = @"Keyboard";
static NSString *MenuDisplayHigh = @"High";
static NSString *MenuDisplayLow = @"Low";
static NSString *MenuSoundNone = @"No Sound";
static NSString *MenuSoundLow = @"LoFi";
static NSString *MenuSoundHigh = @"HiFi";


@implementation DSInitScene {
}

+ (NSString *)textFromResolution:(DSInitSceneDisplay)resolution {
    return resolution == DSInitSceneDisplayHigh ? MenuDisplayHigh : MenuDisplayLow;
}

+ (NSString *)textFromControl:(DSInitSceneControl)control {
    return control == DSInitSceneControlJoystick ? MenuControlJoystick : MenuControlKeyboard;
}

+ (NSString *)textFromSound:(DSInitSceneSound)sound {
    return sound == DSInitSceneSoundHigh ? MenuSoundHigh : (sound == DSInitSceneSoundNone ? MenuSoundNone : MenuSoundLow);
}

- (id)init {
    if (self = [super init]) {
        self.firstLevel = 1;
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    _alwaysPressed = YES;
    self.isDone = NO;
    if (self.labels.count < 1) {
        [self addLabelWithText:@"[D]isplay:" atPosition:CGPointMake(3, 120)];
        _resolutionLabelNode = [self addLabelWithText:@"" atPosition:CGPointMake(120, 120)];
        [self addLabelWithText:@"[C]ontrol:" atPosition:CGPointMake(3, 136)];
        _controlLabelNode = [self addLabelWithText:@"" atPosition:CGPointMake(120, 136)];
        [self addLabelWithText:@"[S]ound:" atPosition:CGPointMake(3, 152)];
        _soundLabelNode = [self addLabelWithText:@"" atPosition:CGPointMake(120, 152)];
        [self addLabelWithText:@"[Space] or joystick button to start" atPosition:CGPointMake(20, 184)];
        
        _resolution = self.resourceController.hiresMode ? DSInitSceneDisplayHigh : DSInitSceneDisplayLow;
        _control = self.joystickController.useHardwareJoystick ? DSInitSceneControlJoystick : DSInitSceneControlKeyboard;
        _sound = self.soundManager.enabled ? (self.resourceController.hifiMode ? DSInitSceneSoundHigh : DSInitSceneSoundLow) : DSInitSceneSoundNone;
    }

    [self refreshState];
}

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
    [self refreshState];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [self transitionToNextScreen];
}

- (void)keyUp:(NSEvent *)theEvent {
    [super keyUp:theEvent];
    
    // Now check the rest of the keyboard
    NSString *characters = theEvent.charactersIgnoringModifiers;
    for (int s = 0; s<[characters length]; s++) {
        unichar character = [characters characterAtIndex:s];
        switch (character) {
            case 'd':
                [self toggleDisplay];
                break;

            case 'c':
                [self toggleControl];
                break;

            case 's':
                [self toggleSound];
                break;
                
            case ' ':
                [self transitionToNextScreen];
                break;
        }
    }

}

- (void)transitionToNextScreen {
    SKTransition *transition = [SKTransition doorwayWithDuration:1.0];
    DSTransitionScene *transitionScene = [self.sceneController transitionSceneForLevel:(int)self.firstLevel];
    [self.view presentScene:transitionScene transition:transition];
    [self.soundManager loadCache];
    self.soundManager.maxNumSounds = (self.resourceController.hifiMode) ? 10 : 2;
    DynospriteGlobalsPtr->UserGlobals_Init = NO;
    self.isDone = YES;
}

- (void)toggleDisplay {
    _resolution = (_resolution >= DSInitSceneDisplayHigh) ? DSInitSceneDisplayLow : _resolution + 1;
    [self refreshState];
}

- (DSInitSceneDisplay)display {
    return _resolution;
}

- (void)toggleControl {
    _control = (_control >= DSInitSceneControlJoystick) ? DSInitSceneControlKeyboard : _control + 1;
    [self refreshState];
}

- (DSInitSceneControl)control {
    return _control;
}

- (void)toggleSound {
    _sound = (_sound >= DSInitSceneSoundHigh) ? DSInitSceneSoundNone : _sound + 1;
    [self refreshState];
}

- (DSInitSceneSound)sound {
    return _sound;
}

- (void)poll {
    if (self.joystickController.joystick.button0Pressed) {
        if (!_alwaysPressed) {
            [self transitionToNextScreen];
        }
    } else {
        _alwaysPressed = NO;
    }
}

- (void)refreshState {
    _resolutionLabelNode.text = [DSInitScene textFromResolution:_resolution];
    _controlLabelNode.text = [DSInitScene textFromControl:_control];
    _soundLabelNode.text = [DSInitScene textFromSound:_sound];

    self.joystickController.useHardwareJoystick = (_control == DSInitSceneControlJoystick);
    self.soundManager.enabled = (_sound != DSInitSceneSoundNone);
    self.resourceController.hifiMode = (_sound == DSInitSceneSoundHigh);
    self.resourceController.hiresMode = (_resolution == DSInitSceneDisplayHigh);
}

@end
