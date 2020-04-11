//
//  DSWindowControllerTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/10/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DSWindowController.h"


@interface DSWindowControllerTest : XCTestCase {
    DSWindowController *_target;
    NSWindow *_window;
}
@end


@implementation DSWindowControllerTest

- (void)setUp {
    _target = [[DSWindowController alloc] init];
    _window = [[NSWindow alloc] init];
    _target.window = _window;
}

- (void)testExample {
    [_target windowDidLoad];
    XCTAssertTrue(NSEqualSizes([_window contentAspectRatio], ((NSSize)[[_window contentView] frame].size)));
    XCTAssertTrue(NSEqualSizes([_window contentMinSize], NSMakeSize(320, 200)));
}

@end
