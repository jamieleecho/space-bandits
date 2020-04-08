//
//  DSTransitionSceneTest.m
//  DynospriteUITests
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "DSCoCoJoystickController.h"
#import "DSTransitionScene.h"
#import "DSResourceController.h"


@interface DSTransitionSceneTest : XCTestCase {
}
@end

@implementation DSTransitionSceneTest

- (void)setUp {
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
}

@end
