//
//  DSTransitionImageLoader.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/26/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSTransitionSceneInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSTransitionImageLoader : NSObject

@property (nonatomic, nonnull) IBOutlet NSBundle *bundle;

- (id)init;
- (void)loadImagesForTransitionInfo:(NSArray <DSTransitionSceneInfo *>*)info;

@end

NS_ASSUME_NONNULL_END
