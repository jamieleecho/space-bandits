//
//  DSTexture.h
//  Space Bandits
//
//  Created by Jamie Cho on 12/31/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface DSTexture : NSObject {
    SKTexture *_texture;
    CGPoint _point;
}

- (id)initWithTexture:(SKTexture *)texture andPoint:(CGPoint)point;
- (SKTexture *)texture;
- (CGPoint)point;

@end

NS_ASSUME_NONNULL_END
