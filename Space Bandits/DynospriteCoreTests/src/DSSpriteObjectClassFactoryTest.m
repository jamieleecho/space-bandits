//
//  DSSpriteObjectClassFactoryTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSSpriteObjectClassFactory.h"

@interface DSSpriteObjectClassFactoryTest : XCTestCase {
    DSSpriteObjectClassFactory *_target;
}

@end

@implementation DSSpriteObjectClassFactoryTest

- (void)setUp {
    _target = [[DSSpriteObjectClassFactory alloc] init];
}

- (void)testaddObjectClassForNumber {
    [_target addSpriteObjectClass:[[DSSpriteObjectClass alloc] init] forNumber:@4];
}

@end
