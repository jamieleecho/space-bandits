//
//  DSDefaultsConfigLoader.m
//  Space Bandits
//
//  Created by Jamie Cho on 10/1/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//

#import "DSDefaultsConfigLoader.h"

@implementation DSDefaultsConfigLoader

- (id)init {
    if (self = [super init]) {
        self.bundle = NSBundle.mainBundle;
        self.defaultsConfig = [[DSDefaultsConfig alloc] init];
    }
    return self;
}

- (void)loadDefaultsConfig {
    NSString *defaultsConfigPath = [self.bundle pathForResource:@"defaults-config" ofType:@"json"];
    NSCAssert(defaultsConfigPath != nil, @"Could not find defaults-config.json resource.");
    
    NSInputStream *inStream = [[NSInputStream alloc] initWithFileAtPath:defaultsConfigPath];
    NSDictionary *defaultsConfigJson;
    @try {
        NSCAssert(defaultsConfigPath != nil, @"Could not open defaults-config.json resource.");
        NSError *err;
        id result = [NSJSONSerialization JSONObjectWithStream:inStream options:0 error:&err];
        if (!result || ![result isKindOfClass:NSDictionary.class]) {
            return;
        }
        defaultsConfigJson = (NSDictionary *)result;
        
        DSDefaultsConfig *defaultsConfig = [[DSDefaultsConfig alloc] init];
        NSArray *properties = @[
            @"FirstLevel", NSStringFromSelector(@selector(setFirstLevel:)), @YES,
            @"UseKeyboard", NSStringFromSelector(@selector(setUseKeyboard:)), @NO,
            @"HiresMode", NSStringFromSelector(@selector(setHiresMode:)), @NO,
            @"HifiMode", NSStringFromSelector(@selector(setHifiMode:)), @NO,
            @"EnableSound", NSStringFromSelector(@selector(setEnableSound:)), @NO
        ];
        
        for(size_t ii=0; ii<properties.count; ii += 3) {
            id value = defaultsConfigJson[properties[ii]];
            if (value && ([value isKindOfClass:NSNumber.class])) {
                SEL selector = NSSelectorFromString(properties[ii + 1]);
                IMP imp = [defaultsConfig methodForSelector:selector];
                void (*func)(id, SEL, id) = (void *)imp;
                func(defaultsConfig, selector, value);
            }
        }
        
    } @finally {
        [inStream close];
    }
}

@end
