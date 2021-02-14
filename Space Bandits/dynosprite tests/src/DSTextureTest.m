//
//  DSTextureTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 12/31/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSTexture.h"


@interface DSTextureTest : XCTestCase {
    DSTexture *_target;
    SKTexture *_skTexture;
}

@end

@implementation DSTextureTest

- (void)setUp {
    NSString *imagePath = [[NSBundle bundleForClass:self.class] pathForImageResource:@"forest"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
    CGImageRef imageRef = [image CGImageForProposedRect:NULL context:NULL hints:NULL];
    _skTexture = [SKTexture textureWithCGImage:imageRef];
    _target = [[DSTexture alloc] initWithTexture:_skTexture andPoint:CGPointMake(.2f, .3f)];
}

- (void)testInit {
    XCTAssertEqual(_target.texture, _skTexture);
    XCTAssert(_target.point.x == .2f);
    XCTAssert(_target.point.y == .3f);
}

@end
