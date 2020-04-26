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
static NSString *MenuSoundHigh = @"HiFi";
static NSString *MenuSoundLow = @"LoFi";


@implementation DSInitScene {
}

+ (NSString *)textFromResolution:(DSInitSceneDisplay)resolution {
    return resolution == DSInitSceneDisplayHigh ? MenuDisplayHigh : MenuDisplayLow;
}

+ (NSString *)textFromControl:(DSInitSceneControl)control {
    return control == DSInitSceneControlJoystick ? MenuControlJoystick : MenuControlKeyboard;
}

+ (NSString *)textFromSound:(DSInitSceneSound)sound {
    return sound == DSInitSceneSoundHigh ? MenuSoundHigh : MenuSoundLow;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    self.isDone = NO;
    if (self.labels.count < 1) {
        [self addLabelWithText:@"[D]isplay:" atPosition:CGPointMake(3, 120)];
        _resolutionLabelNode = [self addLabelWithText:@"" atPosition:CGPointMake(120, 120)];
        [self addLabelWithText:@"[C]ontrol:" atPosition:CGPointMake(3, 136)];
        _controlLabelNode = [self addLabelWithText:@"" atPosition:CGPointMake(120, 136)];
        [self addLabelWithText:@"[S]ound:" atPosition:CGPointMake(3, 152)];
        _soundLabelNode = [self addLabelWithText:@"" atPosition:CGPointMake(120, 152)];
        [self addLabelWithText:@"[Space] or joystick button to start" atPosition:CGPointMake(20, 184)];
        
        _resolution = DSInitSceneDisplayLow;
        _control = DSInitSceneControlKeyboard;
        _sound = DSInitSceneSoundLow;
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
    SKTransition *transition = [SKTransition crossFadeWithDuration:1.0];
    SKScene *newScene = [SKScene nodeWithFileNamed:@"DSGameScene"];
    [self.view presentScene:newScene transition:transition];
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
    _sound = (_sound >= DSInitSceneSoundHigh) ? DSInitSceneSoundLow : _sound + 1;
    [self refreshState];
}

- (DSInitSceneSound)sound {
    return _sound;
}

- (void)poll {
    if (self.joystickController.joystick.button0Pressed) {
        [self transitionToNextScreen];
    }
}

- (void)refreshState {
    _resolutionLabelNode.text = [DSInitScene textFromResolution:_resolution];
    _controlLabelNode.text = [DSInitScene textFromControl:_control];
    _soundLabelNode.text = [DSInitScene textFromSound:_sound];
    self.joystickController.useHardwareJoystick = (_control == DSInitSceneControlJoystick);
    self.resourceController.hifiMode = (_sound == DSInitSceneDisplayHigh);
    self.resourceController.hiresMode = (_resolution == DSInitSceneDisplayHigh);
}

@end
