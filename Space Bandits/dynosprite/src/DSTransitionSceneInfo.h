//
//  DSTransitionSceneInfo.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/25/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSTransitionSceneInfo : NSObject

@property (nonatomic, nonnull) NSColor *backgroundColor;
@property (nonatomic, nonnull) NSColor *foregroundColor;
@property (nonatomic, nonnull) NSColor *progressColor;
@property (nonatomic, nonnull) NSString *backgroundImageName;

- (id)init;

@end

NS_ASSUME_NONNULL_END
