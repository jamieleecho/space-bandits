//
//  DSObjectRegistry.h
//  Space Bandits
//
//  Created by Jamie Cho on 3/29/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSObjectRegistry  : NSObject {
    @private
    NSMutableDictionary<NSNumber *, DSObject *> *_indexToObject;
}

+ (DSObjectRegistry *)sharedInstance;
- (id)init;
- (void)addObject:(DSObject *)object forIndex:(int)index;
- (void)clear;
- (DSObject *)objectForIndex:(int)index;
@end

NS_ASSUME_NONNULL_END
