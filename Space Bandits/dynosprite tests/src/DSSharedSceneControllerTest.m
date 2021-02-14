//
//  DSSharedSceneControllerTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/10/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "DSAppDelegate.h"
#import "DSSharedSceneController.h"
#import "DSTransitionScene.h"


@interface DSSharedSceneControllerTest : XCTestCase {
    DSSharedSceneController *_target;
    id _sceneController;
}
@end


@implementation DSSharedSceneControllerTest

- (void)setUp {
    _sceneController = OCMClassMock(DSSceneController.class);
    _target = [[DSSharedSceneController alloc] initWithSceneController:_sceneController];
}

- (void)testInitInitializesWithSharedTransitionController {
    DSSharedSceneController *target = [[DSSharedSceneController alloc] init];
    XCTAssertEqual(target.sceneController, ((DSAppDelegate *)(NSApplication.sharedApplication.delegate)).sceneController);
}

- (void)testInit {
    XCTAssertEqual(_target.sceneController, _sceneController);
}

- (void)testImages {
    XCTAssertEqual(_target.sceneInfos, [_sceneController sceneInfos]);
}

- (void)testTransitionSceneForLevel {
    DSTransitionScene *scene = [[DSTransitionScene alloc] init];
    OCMStub([_sceneController transitionSceneForLevel:5]).andReturn(scene);
    XCTAssertEqual([_target transitionSceneForLevel:5], scene);
    OCMVerify([_sceneController transitionSceneForLevel:5]);
}

- (void)testGameSceneForLevel {
    XCTAssertNil([_target gameSceneForLevel:1]);
}

@end
