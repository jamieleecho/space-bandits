//
//  DSTileFileParser.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSTileInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSTileFileParser : NSObject

- (void)parseFile:(NSString *)path forTileInfo:(DSTileInfo *)info;

@end

NS_ASSUME_NONNULL_END
