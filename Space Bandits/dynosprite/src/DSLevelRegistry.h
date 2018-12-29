//
//  DSLevelRegistry.h
//  Space Bandits
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSLevel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSLevelRegistry : NSObject {
    @private
    NSDictionary<NSNumber *, DSLevelRegistry *> *_indexToLevel;
}

+ (DSLevelRegistry *)sharedInstance;
- (id)init;
- (void)addLevel:(DSLevel *)level fromFile:(NSString *)file;
- (DSLevel *)getLevel:(int)index;

@end

NS_ASSUME_NONNULL_END
