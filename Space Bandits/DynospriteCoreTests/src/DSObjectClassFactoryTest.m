//
//  DSObjectClassFactoryTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSObjectClassFactory.h"

@interface DSObjectClassFactoryTest : XCTestCase {
    DSObjectClassFactory *_target;
}

@end

@implementation DSObjectClassFactoryTest

- (void)setUp {
    _target = [[DSObjectClassFactory alloc] init];
}

- (void)testaddObjectClassForNumber {
    [_target addObjectClass:[[DSObjectClass alloc] init] forNumber:@4];
}

@end
