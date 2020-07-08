//
//  DSGameLoop.h
//  Space Bandits
//
//  Created by Jamie Cho on 7/7/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "coco.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSGameLoop : NSObject

/**
 * Initializes the current level
 */
- (void)initLevel;


/**
 * Updates the game state by one tick
 */
- (void)updateLevel;

/**
 * Returns 0 if there should be no level change. Otherwise returns the desired next level.
 */
- (byte)targetLevel;

@end

NS_ASSUME_NONNULL_END
