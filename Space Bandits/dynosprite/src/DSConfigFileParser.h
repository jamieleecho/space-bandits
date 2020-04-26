//
//  DSConfigFileParser.h
//  dynosprite
//
//  Created by Jamie Cho on 1/6/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSConfigFileParser : NSObject

- (NSDictionary *)parseFile:(NSString *)file;

@end

NS_ASSUME_NONNULL_END
