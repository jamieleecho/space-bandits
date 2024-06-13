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
    DSSoundManager *_soundManager;
}
@end

@implementation DSTransitionSceneTest

- (void)setUp {
    _target = [[DSTransitionScene alloc] init];
    _joystickController = OCMClassMock(DSCoCoJoystickController.class);
    _resourceController = OCMClassMock(DSResourceController.class);
    _sceneController = OCMClassMock(DSSceneController.class);
    _soundManager = OCMClassMock(DSSoundManager.class);
    XCTAssertNil(_target.resourceController);
    XCTAssertNil(_target.joystickController);
    XCTAssertNil(_target.sceneController);
    XCTAssertNil(_target.soundManager);
    _target.resourceController = _resourceController;
    _target.sceneController = _sceneController;
    _target.soundManager = _soundManager;
}

- (void)testInit {
    XCTAssertEqualObjects(_target.backgroundColor, [UIColor colorWithRed:.15f green:.15f blue:.15f alpha:1]);
    XCTAssertEqualObjects(_target.foregroundColor, UIColor.blackColor);
    XCTAssertEqualObjects(_target.progressBarColor, UIColor.greenColor);
    XCTAssertTrue([_target.labels isKindOfClass:NSArray.class]);
    XCTAssertEqual(_target.labels.count, 0);
    XCTAssertNil(_target.backgroundImageName);
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
    XCTAssertTrue(CGPointEqualToPoint(label.position, CGPointMake(0, 0)));
    XCTAssertEqual(label.fontSize, 13.037036895751953f);
    XCTAssertTrue([DSTestUtils color:label.fontColor isSameAs:_target.foregroundColor]);
    SKSpriteNode *background = (SKSpriteNode *)label.parent;
    XCTAssertEqualObjects(background.parent, _target);
    XCTAssertEqual(_target.labels.count, 1);
    XCTAssertTrue(CGPointEqualToPoint(background.position, CGPointMake(100.0f, -51.2f)));
    XCTAssertTrue(CGPointEqualToPoint(background.anchorPoint, CGPointMake(0, 1)));
}

- (void)testSetBackgroundImageName {
    NSString *backgroundImageName = @"forest";
    NSString *resourceImagePath = [[NSBundle bundleForClass:self.class] pathForResource:backgroundImageName ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:resourceImagePath];
    
    OCMStub([_resourceController imageWithName:backgroundImageName]).andReturn(resourceImagePath);
    _target.backgroundImageName = backgroundImageName;
    XCTAssertEqual(_target.backgroundImage, (SKSpriteNode *)(_target.children[0]));
    CGImageRef backgroundCGImage = ((SKSpriteNode *)(_target.children[0])).texture.CGImage;
    UIImage *backgroundImage = [DSTestUtils convertToUIImage:backgroundCGImage];
    XCTAssertTrue([DSTestUtils image:image isSameAsImage:backgroundImage]);
    XCTAssertEqual(_target.backgroundImageName, backgroundImageName);
}

- (void)testForegroundColor {
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Courier");
    _target.foregroundColor = UIColor.purpleColor;
    [_target addLabelWithText:@"Test" atPosition:CGPointMake(100, 200)];
    XCTAssertTrue([DSTestUtils color:_target.foregroundColor isSameAs:UIColor.purpleColor]);
    XCTAssertTrue([DSTestUtils color:_target.foregroundColor isSameAs:_target.labels[0].fontColor]);
    _target.foregroundColor = UIColor.brownColor;
    XCTAssertTrue([DSTestUtils color:_target.foregroundColor isSameAs:UIColor.brownColor]);
    XCTAssertTrue([DSTestUtils color:_target.foregroundColor isSameAs:_target.labels[0].fontColor]);
}

- (void)testBackgroundColor {
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Courier");
    _target.backgroundColor = UIColor.purpleColor;
    [_target addLabelWithText:@"Test" atPosition:CGPointMake(100, 200)];
    XCTAssertTrue([DSTestUtils color:_target.backgroundColor isSameAs:UIColor.purpleColor]);
    XCTAssertTrue([DSTestUtils color:_target.backgroundColor isSameAs:((SKSpriteNode *)(_target.labels[0].parent)).color]);
    _target.backgroundColor = UIColor.brownColor;
    XCTAssertTrue([DSTestUtils color:_target.backgroundColor isSameAs:UIColor.brownColor]);
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
    _target.foregroundColor = UIColor.purpleColor;
    SKLabelNode *label = [_target addLabelWithText:@"Test" atPosition:CGPointMake(100, 200)];
    NSString *backgroundImageName = @"forest";
    NSString *resourceImagePath = [[NSBundle bundleForClass:self.class] pathForResource:backgroundImageName ofType:@"png"];
    OCMStub([_resourceController imageWithName:backgroundImageName]).andReturn(resourceImagePath);
    _target.backgroundImageName = backgroundImageName;

    // Update the resource controller
    id newResourceController = OCMClassMock(DSResourceController.class);
    NSString *hiresBackgroundImageName = @"forest-hires";
    OCMStub([newResourceController fontForDisplay]).andReturn(@"Monaco");
    NSString *hiresResourceImagePath = [[NSBundle bundleForClass:self.class] pathForResource:hiresBackgroundImageName ofType:@"png"];
    OCMStub([newResourceController imageWithName:backgroundImageName]).andReturn(hiresResourceImagePath);
    _target.resourceController = newResourceController;
    
    // Verify that the background was updated
    CGImageRef hiresBackgroundCGImage = ((SKSpriteNode *)(_target.children[0])).texture.CGImage;
    UIImage *hiresBackgroundImage = [DSTestUtils convertToUIImage:hiresBackgroundCGImage];
    UIImage *hiresImage = [[UIImage alloc] initWithContentsOfFile:hiresResourceImagePath];
    XCTAssertTrue([DSTestUtils image:hiresImage isSameAsImage:hiresBackgroundImage]);
    
    // Verify that the font was updated
#if TARGET_OS_MACCATALYST
    XCTAssertEqual(label.fontSize, 12.80000114440918);
#else
    XCTAssertEqual(label.fontSize, 16);
#endif
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
    _target.foregroundColor = UIColor.purpleColor;
    SKLabelNode *label = [_target addLabelWithText:@"Test" atPosition:CGPointMake(100, 200)];
    NSString *backgroundImageName = @"forest";
    NSString *resourceImagePath = [[NSBundle bundleForClass:self.class] pathForResource:backgroundImageName ofType:@"png"];
    OCMStub([_resourceController imageWithName:backgroundImageName]).andReturn(resourceImagePath);
    _target.backgroundImageName = backgroundImageName;

    // Fake a change to hiresMode
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Monaco");
    NSString *hiresBackgroundImageName = @"forest-hires";
    NSString *hiresResourceImagePath = [[NSBundle bundleForClass:self.class] pathForResource:hiresBackgroundImageName ofType:@"png"];
    OCMStub([_resourceController imageWithName:backgroundImageName]).andReturn(hiresResourceImagePath);
    _resourceController.hiresMode = YES;
    [_target observeValueForKeyPath:@"hiresMode" ofObject:_resourceController change:nil context:nil];

    // Verify that the font was updated
#if TARGET_OS_MACCATALYST == 1
    XCTAssertEqual(label.fontSize, 12.80000114440918);
#else
    XCTAssertEqual(label.fontSize, 16);
#endif
    SKSpriteNode *background = (SKSpriteNode *)label.parent;
    XCTAssert(label.fontName, @"Monaco");
    XCTAssertTrue(CGPointEqualToPoint(background.position, CGPointMake(100.0f, -201.19999694824219)));
}

@end
