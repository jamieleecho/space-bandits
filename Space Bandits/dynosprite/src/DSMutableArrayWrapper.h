//
//  DSMutableArrayWrapper.h
//  Space Bandits
//
//  Created by Jamie Cho on 10/9/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSMutableArrayWrapper<__covariant ObjectType>  : NSObject {
    NSMutableArray<ObjectType> *_array;
}

- (NSMutableArray<ObjectType> *)array;

@end

NS_ASSUME_NONNULL_END
