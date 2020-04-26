//
//  DSLevelLoadingScene.m
//  Space Bandits
//
//  Created by Jamie Cho on 4/26/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSLevelLoadingScene.h"

@implementation DSLevelLoadingScene

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    self.isDone = NO;
    if (self.labels.count == 0) {
        NSImage *backgroundImage = [NSImage imageNamed:[self.resourceController imageWithName:self.backgroundImageName]];
        
        const float y0 = ((((200 - 64) - backgroundImage.size.height) / 3) / 2);
        const float y1 = y0 + 16;
        const float y2 = y1 + 18;
        const float y3 = y2 + 14;
        
        [self addLabelWithText:self.levelName atPosition:CGPointMake(159, y0)];
        [self addLabelWithText:self.levelDescription atPosition:CGPointMake(159, y1)];
        [self addLabelWithText:@"Loading..." atPosition:CGPointMake(159, y3)];
    }
}

@end
