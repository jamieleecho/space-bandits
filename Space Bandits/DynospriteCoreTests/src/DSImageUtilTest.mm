//
//  DSImageUtilTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 6/23/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSImageUtil.h"

@interface DSImageUtilTest : XCTestCase {
    CGImageRef _forestImage;
    CGImageRef _moonImage;
}
@end

@implementation DSImageUtilTest

- (void)setUp {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSImage *forestImage = [bundle imageForResource:@"forest"];
    NSImage *moonImage = [bundle imageForResource:@"moon"];
    _forestImage = [forestImage CGImageForProposedRect:NULL context:NULL hints:NULL];
    _moonImage = [moonImage CGImageForProposedRect:NULL context:NULL hints:NULL];
}

- (void)testGetsImageContents {
    DSImageUtilImageInfo info = DSImageUtilGetImagePixelData(self->_forestImage);
    XCTAssertEqual(info.width, 320);
    XCTAssertEqual(info.height, 192);
    
    // Check the top left corner
    XCTAssertEqual(info.imageData[0].a, 255);
    XCTAssertEqual(info.imageData[0].r, 255);
    XCTAssertEqual(info.imageData[0].g, 255);
    XCTAssertEqual(info.imageData[0].b, 11);

    // Check the top right corner
    XCTAssertEqual(info.imageData[319].a, 255);
    XCTAssertEqual(info.imageData[319].r, 18);
    XCTAssertEqual(info.imageData[319].g, 151);
    XCTAssertEqual(info.imageData[319].b, 255);

    // Check the bottom left corner
    XCTAssertEqual(info.imageData[320 * 191].a, 255);
    XCTAssertEqual(info.imageData[320 * 191].r, 18);
    XCTAssertEqual(info.imageData[320 * 191].g, 151);
    XCTAssertEqual(info.imageData[320 * 191].b, 255);

    // Check the bottom right corner
    XCTAssertEqual(info.imageData[320 * 191 + 319].a, 255);
    XCTAssertEqual(info.imageData[320 * 191 + 319].r, 65);
    XCTAssertEqual(info.imageData[320 * 191 + 319].g, 0);
    XCTAssertEqual(info.imageData[320 * 191 + 319].b, 255);
}

- (void)testDSImageUtilARGB8Constrctor {
    DSImageUtilARGB8 target0;
    XCTAssertEqual(target0.a, 0);
    XCTAssertEqual(target0.r, 0);
    XCTAssertEqual(target0.g, 0);
    XCTAssertEqual(target0.b, 0);

    DSImageUtilARGB8 target1(1, 2, 127, 255);
    XCTAssertEqual(target1.a, 1);
    XCTAssertEqual(target1.r, 2);
    XCTAssertEqual(target1.g, 127);
    XCTAssertEqual(target1.b, 255);
}

- (void)testDSImageUtilIsTransparent {
    DSImageUtilARGB8 target0;
    XCTAssertTrue(target0.isTransparent());

    DSImageUtilARGB8 target1(1, 2, 127, 255);
    XCTAssertFalse(target1.isTransparent());
    
    DSImageUtilARGB8 target2(0, 2, 127, 255);
    XCTAssertTrue(target2.isTransparent());
}

- (void)testDSImageUtilTransparentColor {
    XCTAssertTrue(DSImageUtilARGB8::transparentColor.isTransparent());
}

- (void)testDSImageUtilEqual {
    XCTAssertTrue(DSImageUtilARGB8::transparentColor == DSImageUtilARGB8::transparentColor);
    DSImageUtilARGB8 target0;
    XCTAssertTrue(target0 == DSImageUtilARGB8::transparentColor);

    DSImageUtilARGB8 target1(0, 2, 127, 255);
    DSImageUtilARGB8 target2(1, 2, 127, 255);
    DSImageUtilARGB8 target3(0, 3, 127, 255);
    DSImageUtilARGB8 target4(0, 2, 128, 255);
    DSImageUtilARGB8 target5(0, 2, 127, 254);
    DSImageUtilARGB8 target6(0, 2, 127, 255);
    XCTAssertFalse(target1 == target2);
    XCTAssertFalse(target1 == target2);
    XCTAssertFalse(target1 == target3);
    XCTAssertFalse(target1 == target4);
    XCTAssertFalse(target1 == target5);
    XCTAssertTrue(target1 == target6);
}

- (void)testDSImageUtilNotEqual {
    XCTAssertFalse(DSImageUtilARGB8::transparentColor != DSImageUtilARGB8::transparentColor);
    DSImageUtilARGB8 target0;
    XCTAssertFalse(target0 != DSImageUtilARGB8::transparentColor);

    DSImageUtilARGB8 target1(0, 2, 127, 255);
    DSImageUtilARGB8 target2(1, 2, 127, 255);
    DSImageUtilARGB8 target3(0, 3, 127, 255);
    DSImageUtilARGB8 target4(0, 2, 128, 255);
    DSImageUtilARGB8 target5(0, 2, 127, 254);
    DSImageUtilARGB8 target6(0, 2, 127, 255);
    XCTAssertTrue(target1 != target2);
    XCTAssertTrue(target1 != target2);
    XCTAssertTrue(target1 != target3);
    XCTAssertTrue(target1 != target4);
    XCTAssertTrue(target1 != target5);
    XCTAssertFalse(target1 != target6);
}

- (void)testDSImageUtilReplaceColor {
    DSImageUtilImageInfo info = DSImageUtilGetImagePixelData(self->_forestImage);
    DSImageWrapper<DSImageUtilARGB8> image(info.imageData, info.width, info.height);

    DSImageUtilReplaceColor(info, DSImageUtilARGB8(255, 255, 255, 11), DSImageUtilARGB8::transparentColor);
    XCTAssertEqual(image(0, 0), DSImageUtilARGB8::transparentColor);
    XCTAssertEqual(image(19, 25), DSImageUtilARGB8::transparentColor);
}

- (void)testDSImageWrapper {
    DSImageUtilImageInfo info = DSImageUtilGetImagePixelData(self->_forestImage);
    DSImageWrapper<DSImageUtilARGB8> target(info.imageData, info.width, info.height);

    XCTAssertEqual(target.data(), info.imageData);
    XCTAssertEqual(target.width(), info.width);
    XCTAssertEqual(target.height(), info.height);
    
    // Check the top left corner
    XCTAssertEqual(target(0, 0), DSImageUtilARGB8(255, 255, 255, 11));

    // Check the top right corner
    XCTAssertEqual(target(319, 0), DSImageUtilARGB8(255, 18, 151, 255));

    // Check the bottom left corner
    XCTAssertEqual(target(0, 191), DSImageUtilARGB8(255, 18, 151, 255));

    // Check the bottom right corner
    XCTAssertEqual(target(319, 191), DSImageUtilARGB8(255, 65, 0, 255));
    
    // Verify writing works
    target(19, 25) = DSImageUtilARGB8::transparentColor;
    XCTAssertEqual(target(19, 25), DSImageUtilARGB8::transparentColor);
    
    // Verify going out of bounds throws
    XCTAssertThrows(target(320, 0));
    XCTAssertThrows(target(0, 192));
    XCTAssertThrows(target(-1, 0));
    XCTAssertThrows(target(0, -1));
}

- (void)testDSImageUtilMakeCGImage {
    DSImageUtilImageInfo info = DSImageUtilGetImagePixelData(self->_forestImage);
    CGImageRef target = DSImageUtilMakeCGImage(info);
    DSImageUtilImageInfo targetInfo = DSImageUtilGetImagePixelData(target);
    CGImageRelease(target);
    XCTAssertEqual(info.width, targetInfo.width);
    XCTAssertEqual(info.height, targetInfo.height);
    DSImageWrapper<DSImageUtilARGB8> wrapper(info.imageData, info.width, info.height);
    DSImageWrapper<DSImageUtilARGB8> targetWrapper(targetInfo.imageData, targetInfo.width, targetInfo.height);

    XCTAssertEqual(targetWrapper(0, 0), wrapper(0, 0));
    XCTAssertEqual(targetWrapper(319, 0), wrapper(319, 0));
    XCTAssertEqual(targetWrapper(0, 191), wrapper(0, 191));
    XCTAssertEqual(targetWrapper(319, 191), wrapper(319, 191));
}

- (void) testDSImageUtilFindSpritePixels {
    DSImageUtilImageInfo info = DSImageUtilGetImagePixelData(self->_moonImage);
    DSImageUtilReplaceColor(info, DSImageUtilARGB8(255, 250, 0, 254), DSImageUtilARGB8::transparentColor);
    NSRect explosion1 = DSImageUtilFindSpritePixels(info, @"explosion1", NSMakePoint(231, 283));
    XCTAssertTrue(NSEqualRects(explosion1, NSMakeRect(222, 272, 18, 20)));
    NSRect explosion2 = DSImageUtilFindSpritePixels(info, @"explosion2", NSMakePoint(254, 283));
    XCTAssertTrue(NSEqualRects(explosion2, NSMakeRect(245, 272, 20, 21)));
}

@end
