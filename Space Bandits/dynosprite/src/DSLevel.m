//
//  DSLevel.m
//  dynosprite
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import "DSLevel.h"

@implementation DSLevel

- (id)initWithInitLevel:(DSLevelInit)initLevel backgroundNewXY:(DSLevelBackgroundNewXY)backgroundNewXY {
    self = [super init];
    
    if (self) {
        _initLevel = initLevel;
        _backgroundNewXY = backgroundNewXY;

        self.name = @"";
        self.levelDescription = @"";
        self.objectGroupIndices = @[];
        self.tilemapImagePath = @"";
        self.tilemapStart = DSPointMake(0, 0);
        self.tilemapSize = DSPointMake(0, 0);
        self.objects = @[];
    }
    
    return self;
}

- (DSLevelInit)initLevel {
    return _initLevel;
}

- (DSLevelBackgroundNewXY)backgroundNewXY {
    return _backgroundNewXY;
}

@end
