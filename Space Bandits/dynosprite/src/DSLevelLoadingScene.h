//
//  DSLevelLoadingScene.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/26/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DSTransitionScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSLevelLoadingScene : DSTransitionScene

@property (nonatomic, nonnull) NSBundle *bundle;
@property (nonatomic, nonnull) NSString *levelDescription;
@property (nonatomic, nonnull) NSString *levelName;

- (id)init;
- (void)didMoveToView:(SKView *)view;

@end

NS_ASSUME_NONNULL_END
