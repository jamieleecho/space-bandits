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
    NSCAssert(inStream != nil, @"Could not open defaults-config.json resource.");
    NSDictionary *defaultsConfigJson;
    @try {
        [inStream open];
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
            id val = defaultsConfigJson[properties[ii]];
            if (val) {
                if (([val isKindOfClass:NSNumber.class])) {
                    NSNumber *value = (NSNumber *)val;
                    SEL selector = NSSelectorFromString(properties[ii + 1]);
                    IMP imp = [defaultsConfig methodForSelector:selector];
                    if ([properties[ii + 2] boolValue]) {
                        void (*func)(id, SEL, int) = (void *)imp;
                        func(defaultsConfig, selector, (int)[value longValue]);
                    } else {
                        void (*func)(id, SEL, bool) = (void *)imp;
                        func(defaultsConfig, selector, [value boolValue]);
                    }
                } else {
                    NSLog(@"Weird value for %@s - value was %@s", properties[ii], val);
                }
            }
        }
        
        self.defaultsConfig = defaultsConfig;
    } @finally {
        [inStream close];
    }
}

@end
