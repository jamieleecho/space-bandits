//
//  DSDefaultsConfigLoader.h
//  Space Bandits
//
//  Created by Jamie Cho on 10/1/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSDefaultsConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSDefaultsConfigLoader : NSObject

@property (nonnull, nonatomic) NSBundle *bundle;
@property (nonnull, nonatomic) DSDefaultsConfig *defaultsConfig;

- (void)loadDefaultsConfig;

@end

NS_ASSUME_NONNULL_END
