//
//  DSTileInfo.m
//  Space Bandits
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSTileInfo.h"

@implementation DSTileInfo

- (id)init {
    if (self = [super init]) {
        self.imagePath = @"";
        self.tileSetStart = DSPointMake(0, 0);
        self.tileSetSize = DSPointMake(0, 0);
        
        self.hashToImage = [NSMutableDictionary dictionary];
        self.numberToHash = [NSMutableDictionary dictionary];
    }
    return self;
}

@end
