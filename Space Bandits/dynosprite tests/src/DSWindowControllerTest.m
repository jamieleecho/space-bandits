//
//  DSWindowControllerTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/10/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "DSWindowController.h"


@interface DSWindowControllerTest : XCTestCase {
    DSWindowController *_target;
    id _view;
}
@end


@implementation DSWindowControllerTest

- (void)setUp {
#if TARGET_OS_MACCATALYST == 1
    _target = [[DSWindowController alloc] init];
    _view = OCMClassMock(UIView.class);
    _target.view = _view;
#endif
}

#if TARGET_OS_MACCATALYST == 1
- (void)testSetsUpWindow {
    [_target viewDidLoad];
    OCMVerify([_view sizeToFit]);
}
#endif

@end
