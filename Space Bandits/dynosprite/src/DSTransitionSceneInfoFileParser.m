//
//  DSTransitionSceneInfoFileParser.m
//  Space Bandits
//
//  Created by Jamie Cho on 4/25/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSTransitionSceneInfoFileParser.h"
#import "DSConfigFileParser.h"

@implementation DSTransitionSceneInfoFileParser

+ (NSColor *)colorFromRGBString:(NSString *)color {
    NSError *err;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"^[0-9a-f]{6}$" options:NSRegularExpressionCaseInsensitive error:&err];
    NSAssert(err == nil, @"Failed to create NSRegularExpression.");
    NSArray *matches = [regex matchesInString:color options:0 range:NSMakeRange(0, color.length)];
    if (matches.count < 1) {
        @throw [NSException exceptionWithName:@"Failed to parse color" reason:@"invalid hex" userInfo:nil];
    }
    NSScanner *scanner = [NSScanner scannerWithString:color];
    unsigned int rgb, r, g, b;
    [scanner scanHexInt:&rgb];
    r = rgb >> 16;
    g = (rgb >> 8) & 0xff;
    b = rgb & 0xff;
    return [NSColor colorWithCalibratedRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
}

- (void)parseFile:(NSString *)path forTransitionInfo:(NSMutableArray <DSTransitionSceneInfo *>*)info {
    DSConfigFileParser *parser = [[DSConfigFileParser alloc] init];
    NSArray *configInfos = [parser parseFile:path][@"images"];
    NSAssert([configInfos isKindOfClass:NSArray.class], ([NSString stringWithFormat:@"%@ does not define a valid images array", path]));
    
    NSMutableArray<DSTransitionSceneInfo *> *infos = [NSMutableArray array];
    for(NSDictionary *info in configInfos) {
        DSTransitionSceneInfo *infoObj = [[DSTransitionSceneInfo alloc] init];
        infoObj.backgroundColor = [DSTransitionSceneInfoFileParser colorFromRGBString:info[@"BackgroundColor"]];
        infoObj.foregroundColor = [DSTransitionSceneInfoFileParser colorFromRGBString:info[@"ForegroundColor"]];
        infoObj.progressColor = [DSTransitionSceneInfoFileParser colorFromRGBString:info[@"ProgressColor"]];
        [infos addObject:infoObj];
    }
    
    [info removeAllObjects];
    for(DSTransitionSceneInfo *infoObjs in infos) {
        [infos addObject:infoObjs];
    }
}

@end
