//
//  DSLevelFileParser.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/11/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DSConfigFileParser.h"
#import "DSLevel.h"
#import "DSLevelRegistry.h"
#import "DSPoint.h"


NS_ASSUME_NONNULL_BEGIN

@interface DSLevelFileParser : NSObject {
    DSConfigFileParser *_parser;
}

+ (DSPoint)pointFromArray:(NSArray *)array;
+ (NSArray<NSNumber *> *)intArrayFromArray:(NSArray *)array;

- (void)parseFile:(NSString *)path forLevel:(DSLevel *)level;

@end

NS_ASSUME_NONNULL_END
