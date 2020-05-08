//
//  DSTransitionScene.m
//  dynosprite
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

- (SKSpriteNode *)backgroundImage {
    return _backgroundImage;
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName {
    _backgroundImageName = backgroundImageName;
    NSString *image = [_resourceController imageWithName:backgroundImageName];
    _backgroundImage.texture = [SKTexture textureWithImageNamed:image];
}

- (id)init {
    if (self = [super init]) {
        _foregroundColor = NSColor.blackColor;
        _progressBarColor = NSColor.greenColor;
        _labels = [[NSMutableArray alloc] init];

        self.size = CGSizeMake(320, 200);
        self.anchorPoint = CGPointMake(0, 1);
        self.scaleMode = SKSceneScaleModeAspectFit;
        
        _backgroundImageName = @"";
        _backgroundImage = [SKSpriteNode spriteNodeWithColor:self.backgroundColor size:self.size];
        [self configureBackgroundImage:_backgroundImage];
        [self addChild:_backgroundImage];
        
        _labelToPoint = [[NSMapTable alloc] init];
        [self addObserver:self forKeyPath:@"resourceController" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"foregroundColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (SKLabelNode *)addLabelWithText:(NSString *)labelText atPosition:(CGPoint)position {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:_resourceController.fontForDisplay];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self) {
        if ([keyPath isEqualToString:@"resourceController"]) {
            DSResourceController *oldController = [change objectForKey:NSKeyValueChangeOldKey];
            DSResourceController *newController = [change objectForKey:NSKeyValueChangeNewKey];
            if (![oldController isEqual:[NSNull null]]) {
                [oldController removeObserver:self forKeyPath:@"hiresMode"];
            }
            if (![newController isEqual:[NSNull null]]) {
                [newController addObserver:self forKeyPath:@"hiresMode" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            }
            [self updateDisplayForResolutionChange];
        } else if ([keyPath isEqualToString:@"backgroundColor"] || [keyPath isEqualToString:@"foregroundColor"]) {
            for(SKLabelNode *label in self.labels) {
                [self configureLabel:label];
            }
        }
    } else if (object == _resourceController) {
        if ([keyPath isEqualToString:@"hiresMode"]) {
            [self updateDisplayForResolutionChange];
        }
    }
}

- (void)updateDisplayForResolutionChange {
    for (SKLabelNode *label in _labels) {
        label.fontName = _resourceController.fontForDisplay;
        [DSTransitionScene adjustLabel:label forPosition:[_labelToPoint objectForKey:label].pointValue];
    }
    if (_backgroundImageName != nil) {
        [self setBackgroundImageName:_backgroundImageName];
    }
}

@end
