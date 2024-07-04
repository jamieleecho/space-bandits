//
//  DSTransitionSceneInfo.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/25/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSTransitionSceneInfo : NSObject

@property (nonatomic, nonnull) UIColor *backgroundColor;
@property (nonatomic, nonnull) UIColor *foregroundColor;
@property (nonatomic, nonnull) UIColor *progressColor;
@property (nonatomic, nonnull) NSString *backgroundImageName;

- (id)init;

@end

NS_ASSUME_NONNULL_END
