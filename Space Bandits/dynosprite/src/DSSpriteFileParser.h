//
//  DSSpriteFileParser.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DSConfigFileParser.h"
#import "DSSpriteObjectClass.h"
#import "DSSpriteInfo.h"


NS_ASSUME_NONNULL_BEGIN

@interface DSSpriteFileParser : NSObject

+ (NSColor *)parseColorFromArray:(NSArray *)colorData;
+ (DSSpriteInfo *)spriteInfoFromDictionary:(NSDictionary *)spriteInfoData;

- (void)parseFile:(NSString *)path forObjectClass:(DSSpriteObjectClass *)objectClass;

@end

NS_ASSUME_NONNULL_END
