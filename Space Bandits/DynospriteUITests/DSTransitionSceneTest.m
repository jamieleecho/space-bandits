//
//  DSTransitionSceneTest.m
//  Space BanditsUITests
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
    DSTransitionScene *_target;
    DSResourceController *_resourceController;
    DSCoCoJoystickController *_joystickController;
}
@end

@implementation DSTransitionSceneTest
+ (BOOL)color:(NSColor *)color1 isSameAs:(NSColor *)color2 {
    return [[color1 colorUsingColorSpace:NSColorSpace.sRGBColorSpace] isEqual:[color2 colorUsingColorSpace:NSColorSpace.sRGBColorSpace]];
}

/**
 * Converts NSImage equivalent to cgImage.
 */
+ (NSImage *)convertToNSImage:(CGImageRef)cgImage {
    NSSize imageSize = CGSizeMake(CGImageGetWidth(cgImage), CGImageGetHeight(cgImage));
    return [[NSImage alloc] initWithCGImage:cgImage size:imageSize];
}

/**
 * Converts nsImage to an 8x4 Color NSBitmapImageRep.
 */
+ (NSBitmapImageRep *)convertTo8x4ImageRep:(NSImage *)nsImage {
    NSBitmapImageRep *nsImageRep = [[NSBitmapImageRep alloc]                                     initWithBitmapDataPlanes:NULL pixelsWide:nsImage.size.width pixelsHigh:nsImage.size.height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:nsImage.size.width * 4 bitsPerPixel:32];
    [NSGraphicsContext saveGraphicsState];
    NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep: nsImageRep];
    [NSGraphicsContext setCurrentContext: ctx];
    [nsImage drawInRect:NSMakeRect(0, 0, nsImage.size.width, nsImage.size.height)];
    [ctx flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    return nsImageRep;
}

/**
 * Returns YES IFF image1 renders identically to image2 as an 8*3 BitmapImageRep.
 */
+ (BOOL)image:(NSImage *)image1 isSameAsImage:(NSImage *)image2 {
    NSBitmapImageRep *imageRep1 = [DSTransitionSceneTest convertTo8x4ImageRep:image1];
    NSBitmapImageRep *imageRep2 = [DSTransitionSceneTest convertTo8x4ImageRep:image2];
    return [imageRep1.TIFFRepresentation isEqual:imageRep2.TIFFRepresentation];
}

- (void)setUp {
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    _target = [[DSTransitionScene alloc] init];
    _resourceController = OCMClassMock(DSResourceController.class);
    _joystickController = OCMClassMock(DSCoCoJoystickController.class);
    XCTAssertNil(_target.resourceController);
    XCTAssertNil(_target.joystickController);
    _target.resourceController = _resourceController;
    _target.joystickController = _joystickController;
}

- (void)tearDown {
}

- (void)testInit {
    XCTAssertEqualObjects(_target.backgroundColor, [[NSColor colorWithRed:.15f green:.15f blue:.15f alpha:1] colorUsingColorSpace:NSColorSpace.deviceRGBColorSpace]);
    XCTAssertEqualObjects(_target.foregroundColor, NSColor.blackColor);
    XCTAssertEqualObjects(_target.progressBarColor, NSColor.greenColor);
    XCTAssertEqual(_target.labels.count, 0);
    XCTAssertTrue(CGSizeEqualToSize(_target.size, CGSizeMake(320, 200)));
    XCTAssertTrue(CGPointEqualToPoint(_target.anchorPoint, CGPointMake(0, 1)));
    XCTAssertEqual(_target.scaleMode, SKSceneScaleModeAspectFit);
    XCTAssertEqual(_target.backgroundImageName, @"");
    XCTAssertEqual(_target.yScale, 1);
    XCTAssertEqualObjects(((SKSpriteNode *)(_target.children[0])).color, _target.backgroundColor);    
}

- (void)testAddsLabels {
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Courier");
    SKLabelNode *label = [_target addLabelWithText:@"Hello World" atPosition:CGPointMake(100, 50)];
    XCTAssertEqualObjects(label.text, @"Hello World");
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
    CGImageRef backgroundCGImage = ((SKSpriteNode *)(_target.children[0])).texture.CGImage;
    NSImage *backgroundImage = [DSTransitionSceneTest convertToNSImage:backgroundCGImage];

    XCTAssertTrue([DSTransitionSceneTest image:image isSameAsImage:backgroundImage]);
    XCTAssertEqual(_target.backgroundImageName, backgroundImageName);
}

- (void)testIsDone {
    _target.isDone = NO;
    XCTAssertFalse(_target.isDone);
    _target.isDone = YES;
    XCTAssertTrue(_target.isDone);

    //@property (strong, nonatomic) NSColor *foregroundColor;
    //@property (strong, nonatomic) NSColor *progressBarColor;
    //@property (strong, readonly) NSArray<SKLabelNode *> *labels;
    //@property (strong, nonatomic) DSResourceController *resourceController;
}

- (void)testSetJoystickControler {
    XCTAssertEqualObjects(_target.joystickController, _joystickController);
}

- (void)testForegroundColor {
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Courier");
    _target.foregroundColor = NSColor.purpleColor;
    [_target addLabelWithText:@"Test" atPosition:CGPointMake(100, 200)];
    XCTAssertTrue([DSTransitionSceneTest color:_target.foregroundColor isSameAs:NSColor.purpleColor]);
    XCTAssertTrue([DSTransitionSceneTest color:_target.foregroundColor isSameAs:_target.labels[0].fontColor]);
    _target.foregroundColor = NSColor.brownColor;
    XCTAssertTrue([DSTransitionSceneTest color:_target.foregroundColor isSameAs:NSColor.brownColor]);
    XCTAssertTrue([DSTransitionSceneTest color:_target.foregroundColor isSameAs:_target.labels[0].fontColor]);
}

- (void)testBackgroundColor {
    OCMStub([_resourceController fontForDisplay]).andReturn(@"Courier");
    _target.backgroundColor = NSColor.purpleColor;
    [_target addLabelWithText:@"Test" atPosition:CGPointMake(100, 200)];
    XCTAssertTrue([DSTransitionSceneTest color:_target.backgroundColor isSameAs:NSColor.purpleColor]);
    XCTAssertTrue([DSTransitionSceneTest color:_target.backgroundColor isSameAs:((SKSpriteNode *)(_target.labels[0].parent)).color]);
    _target.backgroundColor = NSColor.brownColor;
    XCTAssertTrue([DSTransitionSceneTest color:_target.backgroundColor isSameAs:NSColor.brownColor]);
    XCTAssertTrue([DSTransitionSceneTest color:_target.backgroundColor isSameAs:((SKSpriteNode *)(_target.labels[0].parent)).color]);
}

@end
