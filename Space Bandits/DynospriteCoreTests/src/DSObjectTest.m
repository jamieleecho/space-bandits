//
//  DSObjectTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/10/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSObject.h"


@interface DSObjectTest : XCTestCase {
    DSObject *_target;
}
@end


@implementation DSObjectTest

- (void)setUp {
    _target = [[DSObject alloc] init];
}

@end
