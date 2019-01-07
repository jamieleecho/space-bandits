//
//  DSConfigFileParser.m
//  Space Bandits
//
//  Created by Jamie Cho on 1/6/19.
//  Copyright © 2019 Jamie Cho. All rights reserved.
//

#import "DSConfigFileParser.h"

@implementation DSConfigFileParser

- (NSDictionary *)parseFile:(NSString *)file {
    NSInputStream *inStream = [NSInputStream inputStreamWithURL:[NSURL fileURLWithPath:file]];
    @try {
        return [self parseStream:inStream];
    } @finally {
        [inStream close];
    }
}

- (NSDictionary *)parseResourceNamed:(NSString *)name {
    NSBundle *main = [NSBundle mainBundle];
    NSString *resourcePath = [main pathForResource:name ofType:@"txt"];
    return [self parseFile:resourcePath];
}

- (NSDictionary *)parseStream:(NSStream *)stream {
    return nil;
}

@end
