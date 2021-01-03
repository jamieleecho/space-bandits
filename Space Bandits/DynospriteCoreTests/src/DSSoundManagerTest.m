//
//  DSSoundControllerTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/10/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSSoundManager.h"


@interface DSSoundManagerTest : XCTestCase {
    DSSoundManager *_target;
}
@end


@implementation DSSoundManagerTest

- (void)setUp {
    DSSoundManager.sharedInstance = nil;
    _target = [[DSSoundManager alloc] init];
}

- (void)testSharedInstance {
    XCTAssertNil(DSSoundManager.sharedInstance);
    DSSoundManager.sharedInstance = _target;
    XCTAssertEqual(DSSoundManager.sharedInstance, _target);
}

- (void)testPlaySound {
    void PlaySound(int);
    PlaySound(5);
}
@end
