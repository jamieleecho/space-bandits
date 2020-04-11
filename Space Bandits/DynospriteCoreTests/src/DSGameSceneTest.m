//
//  DSGameSceneTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/10/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSGameScene.h"


@interface DSGameSceneTest : XCTestCase {
    DSGameScene *_target;
}
@end


@implementation DSGameSceneTest

- (void)setUp {
    _target = [[DSGameScene alloc] init];
}

@end
