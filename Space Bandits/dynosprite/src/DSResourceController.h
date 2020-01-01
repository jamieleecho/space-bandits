//
//  DSResourceController.h
//  Space Bandits
//
//  Created by Jamie Cho on 1/1/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSResourceController : NSObject

@property (nonatomic) BOOL hiresMode;
@property (nonatomic) BOOL hifiMode;

- (NSString *)fontForDisplay;
- (NSString *)imageWithName:(NSString *)name;
- (NSString *)soundWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END