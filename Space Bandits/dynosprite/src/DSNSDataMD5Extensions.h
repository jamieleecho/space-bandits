//
//  DSNSDataMD5Extensions.h
//  Space Bandits
//
//  Created by Jamie Cho on 5/3/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData(SHA256)
 
- (NSString *)SHA256;
 
@end

NS_ASSUME_NONNULL_END
