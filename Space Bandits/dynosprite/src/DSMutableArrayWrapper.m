//
//  DSMutableArrayWrapper.m
//  Space Bandits
//
//  Created by Jamie Cho on 10/9/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//

#import "DSMutableArrayWrapper.h"

@implementation DSMutableArrayWrapper

- (id)init {
    if (self = [super init]) {
        _array = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableArray *)array {
    return _array;
}

@end
