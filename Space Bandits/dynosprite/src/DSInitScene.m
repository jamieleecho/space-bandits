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

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    self.isDone = NO;
    if (self.labels.count < 1) {
        self.backgroundImageName = @"Images/00-mainmenu.png";
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
        
        [self refreshScreen];
    }
    
    self.joystickController.useHardwareJoystick = YES;
}

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
    self.joystickController.useHardwareJoystick = _control == DSInitSceneControlJoystick;
}

- (void)mouseUp:(NSEvent *)theEvent {
    [self transitionToNextScreen];
}

- (void)keyUp:(NSEvent *)theEvent {
    [super keyUp:theEvent];
    
    // Now check the rest of the keyboard
    NSString *characters = [theEvent characters];
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

- (NSString *)textFromResolution:(DSInitSceneDisplay)resolution {
    return resolution == DSInitSceneDisplayHigh ? MenuDisplayHigh : MenuDisplayLow;
}

- (NSString *)textFromControl:(DSInitSceneControl)control {
    return control == DSInitSceneControlJoystick ? MenuControlJoystick : MenuControlKeyboard;
}

- (NSString *)textFromSound:(DSInitSceneSound)sound {
    return sound == DSInitSceneSoundHigh ? MenuSoundHigh : MenuSoundLow;
}

- (void)refreshScreen {
    _resolutionLabelNode.text = [self textFromResolution:_resolution];
    _controlLabelNode.text = [self textFromControl:_control];
    _soundLabelNode.text = [self textFromSound:_sound];
}

- (void)transitionToNextScreen {
    SKTransition *transition = [SKTransition crossFadeWithDuration:1.0];
    SKScene *newScene = [SKScene nodeWithFileNamed:@"DSGameScene"];
    [self.scene.view presentScene: newScene transition: transition];
    self.isDone = YES;
}

- (void)toggleDisplay {
    _resolution = (_resolution >= DSInitSceneDisplayHigh) ? DSInitSceneDisplayLow : _resolution + 1;
    self.resourceController.hiresMode = _resolution == DSInitSceneDisplayHigh;
    [self refreshScreen];
}

- (void)toggleControl {
    _control = (_control >= DSInitSceneControlJoystick) ? DSInitSceneControlKeyboard : _control + 1;
    [self refreshScreen];
}

- (void)toggleSound {
    _sound = (_sound >= DSInitSceneSoundHigh) ? DSInitSceneSoundLow : _sound + 1;
    self.resourceController.hifiMode = _sound == DSInitSceneSoundHigh;
    [self refreshScreen];
}

- (void)poll {
    if (self.joystickController.joystick.button0Pressed) {
        [self transitionToNextScreen];
    }
}

@end
