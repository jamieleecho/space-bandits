//
//  DSTransitionSceneTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "DSCoCoJoystickController.h"
#import "DSTestUtils.h"
#import "DSTransitionScene.h"
#import "DSResourceController.h"
#import "DSSceneController.h"


@interface DSTransitionSceneTest : XCTestCase {
    DSTransitionScene *_target;
    DSCoCoJoystickController *_joystickController;
    DSResourceController *_resourceController;
    DSSceneController *_sceneController;
}
@end

@implementation DSTransitionSceneTest

- (void)setUp {
    _target = [[DSTransitionScene alloc] init];
    _joystickController = OCMClassMock(DSCoCoJoystickController.class);
    _resourceController = OCMClassMock(DSResourceController.class);
    _sceneController = OCMClassMock(DSSceneController.class);
    XCTAssertNil(_target.resourceController);
    XCTAssertNil(_target.joystickController);
    XCTAssertNil(_target.sceneController);
    _target.resourceController = _resourceController;
    _target.sceneController = _sceneController;
}

- (void)testInit {
    XCTAssertEqualObjects(_target.backgroundColor, [[NSColor colorWithRed:.15f green:.15f blue:.15f alpha:1] colorUsingColorSpace:NSColorSpace.deviceRGBColorSpace]);
    XCTAssertEqualObjects(_target.foregroundColor, NSColor.blackColor);
    XCTAssertEqualObjects(_target.progressBarColor, NSColor.greenColor);
    XCTAssertTrue([_target.labels isKindOfClass:NSArray.class]);
    XCTAssertEqual(_target.labels.count, 0);
    XCTAssertTrue(CGSizeEqualToSize(_target.size, CGSizeMake(320, 200)));
    XCTAssertTrue(CGPointEqualToPoint(_target.anchorPoint, CGPointMake(0, 1)));
    XCTAssertEqual(_target.scaleMode, SKSceneScaleModeAspectFit);
    XCTAssertEqualObjects(_target.backgroundImageName, @"");
    XCTAssertEqual(_target.yScale, 1);
    XCTAssertEqualObjects(((SKSpriteNode *)(_target.children[0])).color, _target.backgroundColor);
    
    XCTAssertEqual(_target.resourceController, _resourceController);
    XCTAssertEqual(_target.sceneController, _sceneController);
}

- (void)testAddsLabels {
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Courier");
    SKLabelNode *label = [_target addLabelWithText:@"Hello World" atPosition:CGPointMake(100, 50)];
    XCTAssertEqualObjects(label.text, @"Hello World");
    XCTAssert(label.fontName, @"Courier");
    XCTAssertEqual(label.horizontalAlignmentMode, SKLabelHorizontalAlignmentModeLeft);
    XCTAssertEqual(label.verticalAlignmentMode, SKLabelVerticalAlignmentModeTop);
    XCTAssertTrue(CGPointEqualToPoint(label.position, NSMakePoint(0, 0)));
    XCTAssertEqual(label.fontSize, 13.037036895751953f);
    XCTAssertEqualObjects(label.fontColor, [_target.foregroundColor colorUsingColorSpace:NSColorSpace.sRGBColorSpace]);
    SKSpriteNode *background = (SKSpriteNode *)label.parent;
    XCTAssertEqualObjects(background.parent, _target);
    XCTAssertEqual(_target.labels.count, 1);
    XCTAssertTrue(CGPointEqualToPoint(background.position, CGPointMake(100.0f, -51.2f)));
    XCTAssertTrue(CGPointEqualToPoint(background.anchorPoint, CGPointMake(0, 1)));
}

- (void)testSetBackgroundImageName {
    NSString *backgroundImageName = @"forest";
    NSString *resourceImagePath = [[NSBundle bundleForClass:self.class] pathForImageResource:backgroundImageName];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:resourceImagePath];
    
    OCMStub([_resourceController imageWithName:backgroundImageName]).andReturn(resourceImagePath);
    _target.backgroundImageName = backgroundImageName;
    XCTAssertEqual(_target.backgroundImage, (SKSpriteNode *)(_target.children[0]));
    CGImageRef backgroundCGImage = ((SKSpriteNode *)(_target.children[0])).texture.CGImage;
    NSImage *backgroundImage = [DSTestUtils convertToNSImage:backgroundCGImage];
    XCTAssertTrue([DSTestUtils image:image isSameAsImage:backgroundImage]);
    XCTAssertEqual(_target.backgroundImageName, backgroundImageName);
}

- (void)testForegroundColor {
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Courier");
    _target.foregroundColor = NSColor.purpleColor;
    [_target addLabelWithText:@"Test" atPosition:CGPointMake(100, 200)];
    XCTAssertTrue([DSTestUtils color:_target.foregroundColor isSameAs:NSColor.purpleColor]);
    XCTAssertTrue([DSTestUtils color:_target.foregroundColor isSameAs:_target.labels[0].fontColor]);
    _target.foregroundColor = NSColor.brownColor;
    XCTAssertTrue([DSTestUtils color:_target.foregroundColor isSameAs:NSColor.brownColor]);
    XCTAssertTrue([DSTestUtils color:_target.foregroundColor isSameAs:_target.labels[0].fontColor]);
}

- (void)testBackgroundColor {
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Courier");
    _target.backgroundColor = NSColor.purpleColor;
    [_target addLabelWithText:@"Test" atPosition:CGPointMake(100, 200)];
    XCTAssertTrue([DSTestUtils color:_target.backgroundColor isSameAs:NSColor.purpleColor]);
    XCTAssertTrue([DSTestUtils color:_target.backgroundColor isSameAs:((SKSpriteNode *)(_target.labels[0].parent)).color]);
    _target.backgroundColor = NSColor.brownColor;
    XCTAssertTrue([DSTestUtils color:_target.backgroundColor isSameAs:NSColor.brownColor]);
    XCTAssertTrue([DSTestUtils color:_target.backgroundColor isSameAs:((SKSpriteNode *)(_target.labels[0].parent)).color]);
}

- (void)testLabels {
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Courier");
    SKLabelNode *label1 = [_target addLabelWithText:@"Test1" atPosition:CGPointMake(100, 200)];
    SKLabelNode *label2 = [_target addLabelWithText:@"Test2" atPosition:CGPointMake(100, 200)];
    XCTAssertEqual(_target.labels.count, 2);
    XCTAssertEqual(_target.labels[0], label1);
    XCTAssertEqual(_target.labels[1], label2);
}

- (void)testUpdatingResourceControllerUpdatesGetter {
    id newResourceController = OCMClassMock(DSResourceController.class);
    _target.resourceController = newResourceController;
    XCTAssertEqual(_target.resourceController, newResourceController);
}

- (void)testUpdatingResourceControllerUpdatesObservers {
    id newResourceController = OCMClassMock(DSResourceController.class);
    _target.resourceController = newResourceController;
    OCMVerify([_resourceController removeObserver:_target forKeyPath:@"hiresMode"]);
    OCMVerify([newResourceController addObserver:_target forKeyPath:@"hiresMode" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil]);
}

- (void)testUpdatingResourceControllerUpdatesDisplay {
    // Setup a basic display
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Courier");
    _target.foregroundColor = NSColor.purpleColor;
    SKLabelNode *label = [_target addLabelWithText:@"Test" atPosition:CGPointMake(100, 200)];
    NSString *backgroundImageName = @"forest";
    NSString *resourceImagePath = [[NSBundle bundleForClass:self.class] pathForImageResource:backgroundImageName];
    OCMStub([_resourceController imageWithName:backgroundImageName]).andReturn(resourceImagePath);
    _target.backgroundImageName = backgroundImageName;

    // Update the resource controller
    id newResourceController = OCMClassMock(DSResourceController.class);
    NSString *hiresBackgroundImageName = @"forest-hires";
    OCMStub([newResourceController fontForDisplay]).andReturn(@"Monaco");
    NSString *hiresResourceImagePath = [[NSBundle bundleForClass:self.class] pathForImageResource:hiresBackgroundImageName];
    OCMStub([newResourceController imageWithName:backgroundImageName]).andReturn(hiresResourceImagePath);
    _target.resourceController = newResourceController;
    
    // Verify that the background was updated
    CGImageRef hiresBackgroundCGImage = ((SKSpriteNode *)(_target.children[0])).texture.CGImage;
    NSImage *hiresBackgroundImage = [DSTestUtils convertToNSImage:hiresBackgroundCGImage];
    NSImage *hiresImage = [[NSImage alloc] initWithContentsOfFile:hiresResourceImagePath];
    XCTAssertTrue([DSTestUtils image:hiresImage isSameAsImage:hiresBackgroundImage]);
    
    // Verify that the font was updated
    XCTAssertEqual(label.fontSize, 12.80000114440918);
    SKSpriteNode *background = (SKSpriteNode *)label.parent;
    XCTAssert(label.fontName, @"Monaco");
    XCTAssertTrue(CGPointEqualToPoint(background.position, CGPointMake(100.0f, -201.19999694824219)));
}

- (void)testResourceControllerUpdatingHiresModeUpdatesDisplay {
    __block int numFontForDisplayCalls = 0;
    __block NSString *courierFont = @"Courier";
    __block NSString *monacoFont = @"Monaco";
    // Setup a basic display
    OCMStub([_resourceController fontForDisplay]).andDo(^(NSInvocation *invocation) {
        [invocation setReturnValue:(numFontForDisplayCalls++ < 1) ? &courierFont : &monacoFont];
    });
    _target.foregroundColor = NSColor.purpleColor;
    SKLabelNode *label = [_target addLabelWithText:@"Test" atPosition:CGPointMake(100, 200)];
    NSString *backgroundImageName = @"forest";
    NSString *resourceImagePath = [[NSBundle bundleForClass:self.class] pathForImageResource:backgroundImageName];
    OCMStub([_resourceController imageWithName:backgroundImageName]).andReturn(resourceImagePath);
    _target.backgroundImageName = backgroundImageName;

    // Fake a change to hiresMode
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Monaco");
    NSString *hiresBackgroundImageName = @"forest-hires";
    NSString *hiresResourceImagePath = [[NSBundle bundleForClass:self.class] pathForImageResource:hiresBackgroundImageName];
    OCMStub([_resourceController imageWithName:backgroundImageName]).andReturn(hiresResourceImagePath);
    _resourceController.hiresMode = YES;
    [_target observeValueForKeyPath:@"hiresMode" ofObject:_resourceController change:nil context:nil];

    // Verify that the font was updated
    XCTAssertEqual(label.fontSize, 12.80000114440918);
    SKSpriteNode *background = (SKSpriteNode *)label.parent;
    XCTAssert(label.fontName, @"Monaco");
    XCTAssertTrue(CGPointEqualToPoint(background.position, CGPointMake(100.0f, -201.19999694824219)));
}

@end
