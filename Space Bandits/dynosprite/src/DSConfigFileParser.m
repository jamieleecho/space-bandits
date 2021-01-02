//
//  DSConfigFileParser.m
//  dynosprite
//
//  Created by Jamie Cho on 1/6/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSConfigFileParser.h"

@implementation DSConfigFileParser

- (NSDictionary *)parseFile:(NSString *)file {
    NSInputStream *inStream = [NSInputStream inputStreamWithURL:[NSURL fileURLWithPath:file]];
    [inStream open];
    @try {
        NSError *err;
        id result = [NSJSONSerialization JSONObjectWithStream:inStream options:0 error:&err];
        if (err) {
            @throw [NSException exceptionWithName:@"IO error parsing configuration file" reason:[err localizedDescription] userInfo:nil];
        }
        if (![result isKindOfClass:[NSDictionary class]]) {
            @throw [NSException exceptionWithName:@"Unexpected format" reason:@"JSON file is not a dictionary" userInfo:nil];
        }
        
        return result;
    } @finally {
        [inStream close];
    }
}

- (NSDictionary *)parseResourceNamed:(NSString *)name {
    NSBundle *main = NSBundle.mainBundle;
    NSString *resourcePath = [main pathForResource:name ofType:@"json"];
    return [self parseFile:resourcePath];
}

@end
