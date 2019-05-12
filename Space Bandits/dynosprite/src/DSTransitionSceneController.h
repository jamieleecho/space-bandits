//
//  DSImageController.h
//  Space Bandits
//
//  Created by Jamie Cho on 1/27/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSTransitionSceneControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSTransitionSceneController : NSObject <DSTransitionSceneControllerProtocol>

@property NSArray *images;

+ (NSColor *)colorFromRGBString:(NSString *)color;

- (id)initWithImageDictionaries:(NSArray *)images;
- (DSTransitionScene *)transitionSceneForLevel:(int)level;

@end

NS_ASSUME_NONNULL_END
