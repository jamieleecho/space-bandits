//
//  DSTransitionSceneInfoFileParser.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/25/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSTransitionSceneInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSTransitionSceneInfoFileParser : NSObject

+ (NSColor *)colorFromRGBString:(NSString *)color;

- (void)parseFile:(NSString *)path forTransitionInfo:(NSMutableArray <DSTransitionSceneInfo *>*)info;

@end

NS_ASSUME_NONNULL_END
