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
}
@end

@implementation DSImageUtilTest

- (void)setUp {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSImage *forestImage = [bundle imageForResource:@"forest"];
    _forestImage = [forestImage CGImageForProposedRect:NULL context:NULL hints:NULL];
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

@end
