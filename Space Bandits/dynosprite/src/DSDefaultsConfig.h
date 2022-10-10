//
//  DSDefaultsConfig.h
//  Space Bandits
//
//  Created by Jamie Cho on 9/11/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSDefaultsConfig : NSObject

@property (nonatomic) NSInteger firstLevel;
@property (nonatomic) BOOL useKeyboard;
@property (nonatomic) BOOL hiresMode;
@property (nonatomic) BOOL hifiMode;
@property (nonatomic) BOOL enableSound;

@end

NS_ASSUME_NONNULL_END
