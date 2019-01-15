//
//  DSTransitionScene.h
//  Space Bandits
//
//  Created by Jamie Cho on 1/14/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSTransitionScene : SKScene {
    @private
    NSString *_backgroundImageName;
    @private
    SKSpriteNode *_backgroundImage;
    @private
    NSColor *_foregroundColor;
    @private
    NSColor *_progressBarColor;
    @private
    NSMutableArray<SKLabelNode *> *_labels;
}

@property (strong, nonatomic) NSString *backgroundImageName;
@property (strong, nonatomic) NSColor *foregroundColor;
@property (strong, nonatomic) NSColor *progressBarColor;
@property (strong, readonly) NSArray<SKLabelNode *> *labels;

- (id)init;
- (void)addLabelWithText:(NSString *)labelText atPosition:(CGPoint)position;

@end

NS_ASSUME_NONNULL_END
