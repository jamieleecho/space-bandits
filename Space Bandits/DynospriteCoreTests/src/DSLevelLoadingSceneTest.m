//
//  DSLevelLoadingSceneTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/28/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import <math.h>
#import "DSLevelLoadingScene.h"


@interface DSLevelLoadingSceneTest : XCTestCase {
    DSLevelLoadingScene *_target;
    id _resourceController;
    id _bundle;
}

@end

@implementation DSLevelLoadingSceneTest

- (void)setUp {
    _target = [[DSLevelLoadingScene alloc] init];
    _bundle = OCMClassMock(NSBundle.class);
    _resourceController = OCMClassMock(DSResourceController.class);
}

- (void)testInit {
    XCTAssertEqual(_target.bundle, NSBundle.mainBundle);
    XCTAssertEqualObjects(_target.levelName, @"");
    XCTAssertEqualObjects(_target.levelDescription, @"");
    XCTAssertFalse(_target.isDone);
}

- (void)testProperties {
    [self initTarget];
    XCTAssertEqual(_target.bundle, _bundle);
    XCTAssertEqualObjects(_target.levelName, @"Level 1");
    XCTAssertEqualObjects(_target.levelDescription, @"My Level Description");
}

- (void)testDidMoveToView {
    [self initTarget];
    SKView *view = [[SKView alloc] init];
    _target.isDone = YES;
    [_target didMoveToView:view];
    XCTAssertFalse(_target.isDone);
    XCTAssertEqual(_target.labels.count, 3);
    XCTAssertEqualObjects(_target.labels[0].text, @"Level 1");
    XCTAssertTrue([self isPoint:_target.labels[0].parent.position aboutEqualToPoint:CGPointMake(133, -34.86)]);
    XCTAssertEqualObjects(_target.labels[1].text, @"My Level Description");
    XCTAssertTrue([self isPoint:_target.labels[1].parent.position aboutEqualToPoint:CGPointMake(86, -53.86)]);
    XCTAssertEqualObjects(_target.labels[2].text, @"Loading...");
    XCTAssertTrue([self isPoint:_target.labels[2].parent.position aboutEqualToPoint:CGPointMake(123, -85.86)]);
    SKShapeNode *progressBarOutline = (SKShapeNode *)_target.children.lastObject;
    XCTAssertTrue([progressBarOutline isKindOfClass:SKShapeNode.class]);
    XCTAssertTrue([self isPoint:progressBarOutline.position aboutEqualToPoint:CGPointMake(126, -82.66)]);
    XCTAssertEqual(progressBarOutline.lineWidth, 2);
    SKSpriteNode *progressBar = (SKSpriteNode *)progressBarOutline.children.firstObject;
    XCTAssertTrue([progressBar isKindOfClass:SKSpriteNode.class]);
    XCTAssertTrue(CGPointEqualToPoint(progressBar.position, CGPointMake(1, 1)));
    XCTAssertTrue(CGSizeEqualToSize(progressBar.size, CGSizeMake(0, 9)));
    
    // Cheap hack to verify colors since SK framework changes them:
    //   get the color, set object colors to what we think they should be and compare
    NSColor *progressBarOutlineStrokeColor = progressBarOutline.strokeColor;
    progressBarOutline.strokeColor = NSColor.lightGrayColor;
    NSColor *progressBarOutlineFillColor = progressBarOutline.fillColor;
    progressBarOutline.fillColor = [NSColor colorWithWhite:0 alpha:0];
    NSColor *progressBarColor = progressBar.color;
    progressBar.color = NSColor.blueColor;
    XCTAssertEqualObjects(progressBarOutline.strokeColor, progressBarOutlineStrokeColor);
    XCTAssertEqualObjects(progressBarOutline.fillColor, progressBarOutlineFillColor);
    XCTAssertEqualObjects(progressBar.color, progressBarColor);
    XCTAssertTrue(progressBar.hasActions);
    
    // Running it again should not add new elements
    _target.isDone = YES;
    [_target didMoveToView:view];
}

- (void)initTarget {
    _target.bundle = _bundle;
    _target.levelName = @"Level 1";
    _target.levelDescription = @"My Level Description";
    _target.backgroundColor = NSColor.purpleColor;
    _target.foregroundColor = NSColor.lightGrayColor;
    _target.progressBarColor = NSColor.blueColor;
    _target.resourceController = _resourceController;
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Courier");
}

- (BOOL)isPoint:(CGPoint)p1 aboutEqualToPoint:(CGPoint)p2 {
    CGPoint p3 = CGPointMake(p1.x - p2.x, p1.y - p2.y);
    return sqrt((p3.x * p3.x) + (p3.y * p3.y)) < 1e-2;
}

@end
