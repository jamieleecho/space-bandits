//
//  DSSharedTransitionSceneControllerTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/10/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "DSAppDelegate.h"
#import "DSSharedTransitionSceneController.h"


@interface DSSharedTransitionSceneControllerTest : XCTestCase {
    DSSharedTransitionSceneController *_target;
    id _transitionSceneController;
}
@end


@implementation DSSharedTransitionSceneControllerTest

- (void)setUp {
    _transitionSceneController = OCMClassMock(DSTransitionSceneController.class);
    _target = [[DSSharedTransitionSceneController alloc] initWithTransitionSceneController:_transitionSceneController];
}

- (void)testInitInitializesWithSharedTransitionController {
    DSSharedTransitionSceneController *target = [[DSSharedTransitionSceneController alloc] init];
    XCTAssertEqual(target.transitionSceneController, ((DSAppDelegate *)(NSApplication.sharedApplication.delegate)).transitionSceneController);
}

- (void)testInit {
    XCTAssertEqual(_target.transitionSceneController, _transitionSceneController);
}

- (void)testImages {
    XCTAssertEqual(_target.images, (NSArray *)[_transitionSceneController images]);
}

- (void)testTransitionSceneForLevel {
    DSTransitionScene *scene = [[DSTransitionScene alloc] init];
    OCMStub([_transitionSceneController transitionSceneForLevel:5]).andReturn(scene);
    XCTAssertEqual([_target transitionSceneForLevel:5], scene);
    OCMVerify([_transitionSceneController transitionSceneForLevel:5]);
}
@end
