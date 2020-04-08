//
//  DSResourceController.m
//  dynosprite
//
//  Created by Jamie Cho on 1/1/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSResourceController.h"

@implementation DSResourceController

+ (NSString *)resourceWithName:(NSString *)name preferHiresVersion:(BOOL)hires {
    NSString *dirPath = name.stringByDeletingLastPathComponent;
    NSString *resourceName = name.lastPathComponent.stringByDeletingPathExtension;
    NSString *extension = name.lastPathComponent.pathExtension;
    NSString *hiresDirectory = [@"hires" stringByAppendingPathComponent:dirPath];

    NSString *path = [NSBundle.mainBundle pathForResource:resourceName ofType:extension inDirectory:hiresDirectory];

    return hires && (path != nil) ? [hiresDirectory stringByAppendingPathComponent:name.lastPathComponent] : name;
}

- (NSString *)fontForDisplay {
    return self.hiresMode ? @"Monaco" : @"pcgfont";
}

- (NSString *)imageWithName:(NSString *)name {
    return [DSResourceController resourceWithName:name preferHiresVersion:self.hiresMode];
}

- (NSString *)soundWithName:(NSString *)name {
    return [DSResourceController resourceWithName:name preferHiresVersion:self.hifiMode];
}

@end
