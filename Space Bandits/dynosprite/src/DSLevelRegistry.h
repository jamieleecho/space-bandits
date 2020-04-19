//
//  DSLevelRegistry.h
//  dynosprite
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSLevel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSLevelRegistry : NSObject {
    @private
    NSMutableDictionary<NSNumber *, DSLevel *> *_indexToLevel;
}

+ (DSLevelRegistry *)sharedInstance;
+ (int)indexFromFilename:(NSString *)file;
- (id)init;
- (void)addLevel:(DSLevel *)level fromFile:(NSString *)file;
- (void)clear;
- (DSLevel *)levelForIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
