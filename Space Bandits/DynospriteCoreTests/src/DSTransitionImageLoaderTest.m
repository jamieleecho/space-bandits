//
//  DSTransitionImageLoaderTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/26/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "DSTransitionImageLoader.h"
#import "DSTransitionSceneInfo.h"

@interface DSTransitionImageLoaderTest : XCTestCase {
    DSTransitionImageLoader *_target;
    NSArray<DSTransitionSceneInfo *> *_infos;
    id _bundle;
}

@end

@implementation DSTransitionImageLoaderTest

- (void)setUp {
    _target = [[DSTransitionImageLoader alloc] init];
    _infos = @[[[DSTransitionSceneInfo alloc] init], [[DSTransitionSceneInfo alloc] init], [[DSTransitionSceneInfo alloc] init]];
    XCTAssertEqual(_target.bundle, NSBundle.mainBundle);
    _bundle = OCMClassMock(NSBundle.class);
}

- (void)testLoadImages {
    _target.bundle = _bundle;
    NSArray *imagePaths = @[
        @"/Applications/foo.app/Contents/Resources.app/imagesx/02-image0.png",
        @"/Applications/foo.app/Contents/Resources.app/imagesx/00-image1.png",
        @"/Applications/foo.app/Contents/Resources.app/imagesx/01-image2.png"
    ];
    OCMStub([_bundle pathsForResourcesOfType:@"png" inDirectory:@"images"]).andReturn(imagePaths);
    [_target loadImagesForTransitionInfo:_infos];
    
    XCTAssertEqualObjects(_infos[0].backgroundImageName, @"imagesx/00-image1.png");
    XCTAssertEqualObjects(_infos[1].backgroundImageName, @"imagesx/01-image2.png");
    XCTAssertEqualObjects(_infos[2].backgroundImageName, @"imagesx/02-image0.png");
}

- (void)testLoadImagesNoImagesThrows {
    _target.bundle = _bundle;
    NSArray *imagePaths = @[
    ];
    OCMStub([_bundle pathsForResourcesOfType:@"png" inDirectory:@"images"]).andReturn(imagePaths);
    XCTAssertThrows([_target loadImagesForTransitionInfo:@[]]);
}

- (void)testImagesWrongNumberThrows {
    _target.bundle = _bundle;
    NSArray *imagePaths = @[
        @"/Applications/foo.app/Contents/Resources.app/imagesx/02-image0.png",
        @"/Applications/foo.app/Contents/Resources.app/imagesx/00-image1.png",
        @"/Applications/foo.app/Contents/Resources.app/imagesx/01-image2.png"
    ];
    OCMStub([_bundle pathsForResourcesOfType:@"png" inDirectory:@"images"]).andReturn(imagePaths);
    XCTAssertThrows([_target loadImagesForTransitionInfo:[_infos subarrayWithRange:NSMakeRange(0, 2)]]);
}

- (void)testImagesStartAt1Throws {
    _target.bundle = _bundle;
    NSArray *imagePaths = @[
        @"/Applications/foo.app/Contents/Resources.app/imagesx/02-image0.png",
        @"/Applications/foo.app/Contents/Resources.app/imagesx/03-image1.png",
        @"/Applications/foo.app/Contents/Resources.app/imagesx/01-image2.png"
    ];
    OCMStub([_bundle pathsForResourcesOfType:@"png" inDirectory:@"images"]).andReturn(imagePaths);
    XCTAssertThrows([_target loadImagesForTransitionInfo:_infos]);
}

- (void)testImagesDuplicateIdsThrows {
    _target.bundle = _bundle;
    NSArray *imagePaths = @[
        @"/Applications/foo.app/Contents/Resources.app/imagesx/02-image0.png",
        @"/Applications/foo.app/Contents/Resources.app/imagesx/00-image1.png",
        @"/Applications/foo.app/Contents/Resources.app/imagesx/00-image2.png"
    ];
    OCMStub([_bundle pathsForResourcesOfType:@"png" inDirectory:@"images"]).andReturn(imagePaths);
    XCTAssertThrows([_target loadImagesForTransitionInfo:_infos]);
}

- (void)testImagesBadImagesThrows {
    _target.bundle = _bundle;
    NSArray *imagePaths = @[
        @"/Applications/foo.app/Contents/Resources.app/imagesx/jamie-image0.png",
        @"/Applications/foo.app/Contents/Resources.app/imagesx/02-image0.png",
        @"/Applications/foo.app/Contents/Resources.app/imagesx/00-image1.png",
        @"/Applications/foo.app/Contents/Resources.app/imagesx/01-image2.png"
    ];
    OCMStub([_bundle pathsForResourcesOfType:@"png" inDirectory:@"images"]).andReturn(imagePaths);
    XCTAssertThrows([_target loadImagesForTransitionInfo:_infos]);
}

@end
