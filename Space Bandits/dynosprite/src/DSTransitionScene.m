//
//  DSTransitionScene.m
//  Space Bandits
//
//  Created by Jamie Cho on 1/14/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSTransitionScene.h"


const float DefaultFontSize = 12.0f;

@interface DSTransitionScene() {
}
- (void)configureLabel:(SKLabelNode *)label;
- (void)configureBackgroundImage:(SKSpriteNode *)image;
@end


@implementation DSTransitionScene

+ (NSString *)fontForDisplay:(BOOL)hiresMode {
    return hiresMode ? @"Monaco" : @"pcgfont";
}

+ (NSString *)imageWithName:(NSString *)name forDisplay:(BOOL)hiresMode {
    NSString *dirPath = name.stringByDeletingLastPathComponent;
    NSString *resourceName = name.lastPathComponent.stringByDeletingPathExtension;
    NSString *extension = name.lastPathComponent.pathExtension;
    NSString *hiresDirectory = [@"hires" stringByAppendingPathComponent:dirPath];
    
    NSString *path = [NSBundle.mainBundle pathForResource:resourceName ofType:extension inDirectory:hiresDirectory];
    
    return hiresMode && (path != nil) ? [hiresDirectory stringByAppendingPathComponent:name.lastPathComponent] : name;
}

+ (void)adjustLabel:(SKLabelNode *)label forPosition:(CGPoint)position {
    // Determine the font scaling factor that should let the label text fit in the given rectangle.
    label.fontSize = DefaultFontSize;
    NSRect rect = CGRectMake(position.x, position.y, label.text.length * 8, 8);
    float scalingFactor = rect.size.width / label.frame.size.width;

    // Change the fontSize.
    label.fontSize *= scalingFactor;
}

- (NSString *)backgroundImageName {
    return _backgroundImageName;
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName {
    _backgroundImageName = backgroundImageName;
    _backgroundImage.texture = [SKTexture textureWithImageNamed:[DSTransitionScene imageWithName:backgroundImageName forDisplay:_hiresMode]];
}

- (id)init {
    if (self = [super init]) {
        _foregroundColor = NSColor.blackColor;
        _progressBarColor = NSColor.greenColor;
        _labels = [[NSMutableArray alloc] init];

        self.size = CGSizeMake(320, 200);
        self.anchorPoint = CGPointMake(0, 1);
        self.yScale = -1;
        self.scaleMode = SKSceneScaleModeAspectFit;
        
        _backgroundImageName = @"";
        _backgroundImage = [SKSpriteNode spriteNodeWithColor:self.backgroundColor size:self.size];
        [self configureBackgroundImage:_backgroundImage];
        [self addChild:_backgroundImage];
        
        [self addObserver:self forKeyPath:@"hiresMode" options:NSKeyValueObservingOptionNew context:nil];
        _labelToPoint = [[NSMapTable alloc] init];
    }
    return self;
}

- (SKLabelNode *)addLabelWithText:(NSString *)labelText atPosition:(CGPoint)position {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:[DSTransitionScene fontForDisplay:self.hiresMode]];
    label.text = labelText;
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    label.position = CGPointMake(0, 0);
    label.fontSize = DefaultFontSize;
    label.fontColor = self.foregroundColor;
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:self.backgroundColor size:label.frame.size];
    [background addChild:label];
    position.y = -position.y - (label.fontSize / 10.0f);
    background.position = position;
    background.anchorPoint = CGPointMake(0, 1);

    [self addChild:background];
    [_labelToPoint setObject:[NSValue valueWithPoint:position] forKey:label];
    [_labels addObject:label];
    [DSTransitionScene adjustLabel:label forPosition:position];
    return label;
}

- (void)configureLabel:(SKLabelNode *)label {
    label.fontColor = self.foregroundColor;
    ((SKSpriteNode *)label.parent).color = self.backgroundColor;
}

- (void)configureBackgroundImage:(SKSpriteNode *)image {
    _backgroundImage.anchorPoint = CGPointMake(0, 1);
    _backgroundImage.size = self.size;
    _backgroundImage.position = CGPointMake(0, 0);
}

- (void)didMoveToView:(SKView *)view {
    id sampleJoystick = ^{
        [self.joystickController sample];
        [self poll];
    };
    if (!_pollAction) {
        _pollAction = [SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:[SKAction runBlock:sampleJoystick], [SKAction waitForDuration:1.0f / view.preferredFramesPerSecond], nil]]];
        [self runAction:_pollAction withKey:@"pollAction"];
    }
}

- (void)willMoveFromView:(SKView *)view {
    [self removeActionForKey:@"pollAction"];
    _pollAction = nil;
}

- (void)keyDown:(NSEvent *)theEvent {
    [self.joystickController handleKeyDown:theEvent];
}

- (void)keyUp:(NSEvent *)theEvent {
    [self.joystickController handleKeyUp:theEvent];
}

- (void)poll {    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ((object == self) && [keyPath isEqualToString:@"hiresMode"]) {
        [self updateDisplayForResolutionChange];
    }
}

- (void)updateDisplayForResolutionChange {
    for (SKLabelNode *label in _labels) {
        label.fontName = [DSTransitionScene fontForDisplay:self.hiresMode];
        [DSTransitionScene adjustLabel:label forPosition:[_labelToPoint objectForKey:label].pointValue];
    }
    if (_backgroundImageName != nil) {
        [self setBackgroundImageName:_backgroundImageName];
    }
}

@end
