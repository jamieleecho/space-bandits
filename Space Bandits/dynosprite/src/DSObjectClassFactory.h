//
//  DSObjectClassFactory.h
//  Space Bandits
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSObjectClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSObjectClassFactory : NSObject

- (void)addObjectClass:(DSObjectClass *)objectClass forNumber:(NSNumber *)levelNumber;

@end

NS_ASSUME_NONNULL_END
