//
//  DSObjectClassFileParser.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DSConfigFileParser.h"
#import "DSObjectClass.h"
#import "DSSpriteInfo.h"


NS_ASSUME_NONNULL_BEGIN

@interface DSObjectClassFileParser : NSObject

+ (NSColor *)parseColorFromArray:(NSArray *)colorData;
+ (DSSpriteInfo *)spriteInfoFromDictionary:(NSDictionary *)spriteInfoData;

- (void)parseFile:(NSString *)path forObjectClass:(DSObjectClass *)objectClass;

@end

NS_ASSUME_NONNULL_END
