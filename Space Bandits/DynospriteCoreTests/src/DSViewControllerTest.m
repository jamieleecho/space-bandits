//
//  DSViewControllerTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/10/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <SpriteKit/SpriteKit.h>
#import <XCTest/XCTest.h>

#import "DSTransitionSceneController.h"
#import "DSViewController.h"


@interface DSViewControllerTest : XCTestCase {
    DSViewController *_target;
    id _skView;
    id _transitionSceneController;
}
@end


@implementation DSViewControllerTest

- (void)setUp {
    _skView = OCMClassMock(SKView.class);
    _transitionSceneController = OCMClassMock(DSTransitionSceneController.class);
    _target = [[DSViewController alloc] init];
    _target.transitionSceneController = _transitionSceneController;
    _target.skView = _skView;
}

- (void)testViewDidLoad {
    SKScene *scene = [[SKScene alloc] init];
    OCMStub([_transitionSceneController transitionSceneForLevel:0]).andReturn(scene);
    [_target viewDidLoad];
    OCMVerify([_transitionSceneController transitionSceneForLevel:0]);
    OCMVerify([_skView presentScene:scene]);
}

@end
