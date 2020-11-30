//
//  DSObjectClassFactory.m
//  Space Bandits
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSObjectClassFactory.h"

@implementation DSObjectClassFactory

- (id)init {
    if (self = [super init]) {
        _levelToObjectClass = NSMutableDictionary.dictionary;
        self.methodRegistry = DSObjectClassDataRegistry.sharedInstance;
        return self;
    }
    return self;
}

- (void)addObjectClass:(DSObjectClass *)objectClass forNumber:(NSNumber *)levelNumber {
    
}

@end
