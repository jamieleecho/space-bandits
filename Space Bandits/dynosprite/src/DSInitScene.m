//
//  InitScene.m
//  Space Bandits
//
//  Created by Jamie Cho on 1/6/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSInitScene.h"


static NSString *MenuControlJoystick = @"Joystick";
static NSString *MenuControlKeyboard = @"Keyboard";
static NSString *MenuResolutionHigh = @"High";
static NSString *MenuResolutionLow = @"Low";
static NSString *MenuSoundHigh = @"HiFi";
static NSString *MenuSoundLow = @"LoFi";


@implementation DSInitScene {
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    if (self.labels.count < 1) {
        self.backgroundImageName = @"Images/00-mainmenu.png";
        [self addLabelWithText:@"[R]esolution:" atPosition:CGPointMake(3, 120)];
        self->_resolutionLabelNode = [self addLabelWithText:@"" atPosition:CGPointMake(120, 120)];
        [self addLabelWithText:@"[C]ontrol:" atPosition:CGPointMake(3, 136)];
        self->_controlLabelNode = [self addLabelWithText:@"" atPosition:CGPointMake(120, 136)];
        [self addLabelWithText:@"[S]ound:" atPosition:CGPointMake(3, 152)];
        self->_soundLabelNode = [self addLabelWithText:@"" atPosition:CGPointMake(120, 152)];
        [self addLabelWithText:@"[Space] or joystick button to start" atPosition:CGPointMake(10, 184)];
        
        self->_resolution = DSInitSceneResolutionLow;
        self->_control = DSInitSceneControlKeyboard;
        self->_sound = DSInitSceneSoundLow;
        
        [self refreshScreen];
    }
    
    self.joystickController.useHardwareJoystick = YES;
}

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
    self.joystickController.useHardwareJoystick = self->_control == DSInitSceneControlJoystick;
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
            case 'r':
                [self toggleResolution];
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

- (NSString *)textFromResolution:(DSInitSceneResolution)resolution {
    return resolution == DSInitSceneResolutionHigh ? MenuResolutionHigh : MenuResolutionLow;
}

- (NSString *)textFromControl:(DSInitSceneControl)control {
    return control == DSInitSceneControlJoystick ? MenuControlJoystick : MenuControlKeyboard;
}

- (NSString *)textFromSound:(DSInitSceneSound)sound {
    return sound == DSInitSceneSoundHigh ? MenuSoundHigh : MenuSoundLow;
}

- (void)refreshScreen {
    self->_resolutionLabelNode.text = [self textFromResolution:self->_resolution];
    self->_controlLabelNode.text = [self textFromControl:self->_control];
    self->_soundLabelNode.text = [self textFromSound:self->_sound];
}

- (void)transitionToNextScreen {
    SKTransition *transition = [SKTransition crossFadeWithDuration:1.0];
    SKScene *newScene = [SKScene nodeWithFileNamed:@"DSGameScene"];
    [self.scene.view presentScene: newScene transition: transition];
}

- (void)toggleResolution {
    self->_resolution = (self->_resolution >= DSInitSceneResolutionHigh) ? DSInitSceneResolutionLow : self->_resolution + 1;
    [self refreshScreen];
}

- (void)toggleControl {
    self->_control = (self->_control >= DSInitSceneControlJoystick) ? DSInitSceneControlKeyboard : self->_control + 1;
    [self refreshScreen];
}

- (void)toggleSound {
    self->_sound = (self->_sound >= DSInitSceneSoundHigh) ? DSInitSceneSoundLow : self->_sound + 1;
    [self refreshScreen];
}

- (void)poll {
    if (self.joystickController.joystick.button0Pressed) {
        [self transitionToNextScreen];
    }
}

@end
