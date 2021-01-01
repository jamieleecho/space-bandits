//
//  DSTexture.m
//  Space Bandits
//
//  Created by Jamie Cho on 12/31/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DSTexture.h"

@implementation DSTexture

- (id)initWithTexture:(SKTexture *)texture andPoint:(CGPoint)point {
    if (self = [super init]) {
        _texture = texture;
        _point = point;
    }
    return self;
}

- (SKTexture *)texture {
    return _texture;
}

- (CGPoint)point {
    return _point;
}

@end
