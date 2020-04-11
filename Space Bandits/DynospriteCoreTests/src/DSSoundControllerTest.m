//
//  DSSoundControllerTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/10/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSSoundController.h"


@interface DSSoundControllerTest : XCTestCase {
    DSSoundController *_target;
}
@end


@implementation DSSoundControllerTest

- (void)setUp {
    _target = [[DSSoundController alloc] init];
}

- (void)testPlaySound {
    void PlaySound(int);
    PlaySound(5);
}
@end
