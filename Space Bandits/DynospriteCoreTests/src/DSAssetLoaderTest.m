//
//  DSAssetLoaderTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/25/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "DSAssetLoader.h"


@interface DSAssetLoaderTest : XCTestCase {
    DSAssetLoader *_target;
    NSMutableArray *_sceneInfos;
    id _levelRegistry;
    id _levelParser;
    id _transitionSceneInfoParser;
    id _resourceController;
    id _imageLoader;
    id _bundle;
}

@end

@implementation DSAssetLoaderTest

- (void)setUp {
    _target = [[DSAssetLoader alloc] init];
    
    XCTAssertEqual(_target.registry, DSLevelRegistry.sharedInstance);
    XCTAssertTrue([_target.sceneInfos isKindOfClass:NSMutableArray.class]);
    XCTAssertNil(_target.levelFileParser);
    XCTAssertNil(_target.transitionSceneInfoFileParser);
    XCTAssertNil(_target.resourceController);
    XCTAssertNil(_target.imageLoader);
    XCTAssertEqual(_target.bundle, NSBundle.mainBundle);

    _sceneInfos = [NSMutableArray array];
    _levelRegistry = OCMClassMock(DSLevelRegistry.class);
    _levelParser = OCMClassMock(DSLevelFileParser.class);
    _transitionSceneInfoParser = OCMClassMock(DSTransitionSceneInfoFileParser.class);
    _resourceController = OCMClassMock(DSResourceController.class);
    _imageLoader = OCMClassMock(DSTransitionImageLoader.class);
    _bundle = OCMClassMock(NSBundle.class);

    _target.sceneInfos = _sceneInfos;
    _target.registry = _levelRegistry;
    _target.levelFileParser = _levelParser;
    _target.transitionSceneInfoFileParser = _transitionSceneInfoParser;
    _target.resourceController = _resourceController;
    _target.imageLoader = _imageLoader;
    _target.bundle = _bundle;
}

- (void)testInit {
    XCTAssertEqual(_target.sceneInfos, _sceneInfos);
    XCTAssertEqual(_target.registry, _levelRegistry);
    XCTAssertEqual(_target.levelFileParser, _levelParser);
    XCTAssertEqual(_target.transitionSceneInfoFileParser, _transitionSceneInfoParser);
    XCTAssertEqual(_target.resourceController, _resourceController);
    XCTAssertEqual(_target.imageLoader, _imageLoader);
    XCTAssertEqual(_target.bundle, _bundle);
}

- (void)testLoadsValidLevels {
    NSArray<DSLevel *> *levels = @[
        [[DSLevel alloc] init],
        [[DSLevel alloc] init],
        [[DSLevel alloc] init],
    ];
    
    NSArray<NSString *> *paths = @[
        @"Resources/levels/02-bar.json",
        @"Resources/levels/01-foo.json",
        @"Resources/levels/03-baz.json"
    ];

    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"levels"]).andReturn(paths);
    OCMStub([_levelRegistry count]).andReturn(levels.count);
    OCMStub([_levelRegistry levelForIndex:2]).andReturn(levels[1]);
    OCMStub([_levelRegistry levelForIndex:1]).andReturn(levels[0]);
    OCMStub([_levelRegistry levelForIndex:3]).andReturn(levels[2]);
    [_target loadLevels];

    NSArray<NSString *> *sortedPaths = [paths sortedArrayUsingSelector:@selector(compare:)];
    for(int ii=0; ii<sortedPaths.count; ii++) {
        OCMVerify([_levelParser parseFile:sortedPaths[ii] forLevel:levels[ii]]);
    }
}

- (void)testThrowsWhenNoLevels {
    NSArray<DSLevel *> *levels = @[
    ];
    
    NSArray<NSString *> *paths = @[
    ];

    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"levels"]).andReturn(paths);
    OCMStub([_levelRegistry count]).andReturn(levels.count);
    XCTAssertThrows([_target loadLevels]);
}

- (void)testThrowsWhenLevelCountsDontMatch {
    NSArray<DSLevel *> *levels = @[
        [[DSLevel alloc] init],
        [[DSLevel alloc] init],
        [[DSLevel alloc] init],
    ];
    
    NSArray<NSString *> *paths = @[
        @"Resources/levels/02-bar.json",
        @"Resources/levels/01-foo.json"
    ];

    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"levels"]).andReturn(paths);
    OCMStub([_levelRegistry count]).andReturn(levels.count);
    OCMStub([_levelRegistry levelForIndex:2]).andReturn(levels[1]);
    OCMStub([_levelRegistry levelForIndex:1]).andReturn(levels[0]);
    XCTAssertThrows([_target loadLevels]);
}

- (void)testThrowsIfBadFilename {
    NSArray<DSLevel *> *levels = @[
        [[DSLevel alloc] init],
        [[DSLevel alloc] init],
        [[DSLevel alloc] init],
    ];
    
    NSArray<NSString *> *paths = @[
        @"Resources/levels/02-bar.json",
        @"Resources/levels/01-foo.json",
        @"Resources/levels/baz.json"
    ];

    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"levels"]).andReturn(paths);
    OCMStub([_levelRegistry count]).andReturn(levels.count);
    OCMStub([_levelRegistry levelForIndex:2]).andReturn(levels[1]);
    OCMStub([_levelRegistry levelForIndex:1]).andReturn(levels[0]);
    OCMStub([_levelRegistry levelForIndex:3]).andReturn(levels[2]);
    XCTAssertThrows([_target loadLevels]);
}

- (void)testThrowsIfMissingLevelsFilename {
    NSArray<DSLevel *> *levels = @[
        [[DSLevel alloc] init],
        [[DSLevel alloc] init],
        [[DSLevel alloc] init],
    ];
    
    NSArray<NSString *> *paths = @[
        @"Resources/levels/02-bar.json",
        @"Resources/levels/01-foo.json",
        @"Resources/levels/04-baz.json"
    ];

    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"levels"]).andReturn(paths);
    OCMStub([_levelRegistry count]).andReturn(levels.count);
    OCMStub([_levelRegistry levelForIndex:2]).andReturn(levels[1]);
    OCMStub([_levelRegistry levelForIndex:1]).andReturn(levels[0]);
    OCMStub([_levelRegistry levelForIndex:4]).andReturn(levels[2]);
    XCTAssertThrows([_target loadLevels]);
}

- (void)testThrowsIfSameLevelTwice {
    NSArray<DSLevel *> *levels = @[
        [[DSLevel alloc] init],
        [[DSLevel alloc] init],
        [[DSLevel alloc] init],
    ];
    
    NSArray<NSString *> *paths = @[
        @"Resources/levels/02-bar.json",
        @"Resources/levels/01-foo.json",
        @"Resources/levels/01-baz.json"
    ];

    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"levels"]).andReturn(paths);
    OCMStub([_levelRegistry count]).andReturn(levels.count);
    OCMStub([_levelRegistry levelForIndex:2]).andReturn(levels[1]);
    OCMStub([_levelRegistry levelForIndex:1]).andReturn(levels[0]);
    OCMStub([_levelRegistry levelForIndex:1]).andReturn(levels[2]);
    XCTAssertThrows([_target loadLevels]);
}

- (void)testThrowsIfParseFails {
    NSArray<DSLevel *> *levels = @[
        [[DSLevel alloc] init],
        [[DSLevel alloc] init],
        [[DSLevel alloc] init],
    ];
    
    NSArray<NSString *> *paths = @[
        @"Resources/levels/02-bar.json",
        @"Resources/levels/01-foo.json",
        @"Resources/levels/03-baz.json"
    ];

    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"levels"]).andReturn(paths);
    OCMStub([_levelRegistry count]).andReturn(levels.count);
    OCMStub([_levelRegistry levelForIndex:2]).andReturn(levels[1]);
    OCMStub([_levelRegistry levelForIndex:1]).andReturn(levels[0]);
    OCMStub([_levelRegistry levelForIndex:3]).andReturn(levels[2]);
    OCMStub([_levelParser parseFile:paths[2] forLevel:levels[2]]).andThrow([NSException exceptionWithName:@"oops" reason:nil userInfo:nil]);
    XCTAssertThrows([_target loadLevels]);
}

- (void)testLoadSceneInfos {
    OCMStub([_resourceController pathForConfigFileWithName:@"images/images.json"]).andReturn(@"/foo.app/Contents/Resources/images/images.json");
    OCMStub([(DSTransitionSceneInfoFileParser *)_transitionSceneInfoParser parseFile:@"/foo.app/Contents/Resources/images/images.json" forTransitionInfo:_sceneInfos]).andDo(^(NSInvocation *invocation){
        [self->_sceneInfos addObject:[[DSTransitionSceneInfo alloc] init]];
        [self->_sceneInfos addObject:[[DSTransitionSceneInfo alloc] init]];
        [self->_sceneInfos addObject:[[DSTransitionSceneInfo alloc] init]];
    });
    OCMStub([_levelRegistry count]).andReturn(2);
    [_target loadSceneInfos];
    OCMVerify([(DSTransitionSceneInfoFileParser *)_transitionSceneInfoParser parseFile:@"/foo.app/Contents/Resources/images/images.json" forTransitionInfo:_sceneInfos]);
}

- (void)testLoadSceneInfosThrowsWhenWrongNumberOfLevels {
    OCMStub([_resourceController pathForConfigFileWithName:@"images/images.json"]).andReturn(@"/foo.app/Contents/Resources/images/images.json");
    OCMStub([(DSTransitionSceneInfoFileParser *)_transitionSceneInfoParser parseFile:@"/foo.app/Contents/Resources/images/images.json" forTransitionInfo:_sceneInfos]).andDo(^(NSInvocation *invocation){
        [self->_sceneInfos addObject:[[DSTransitionSceneInfo alloc] init]];
        [self->_sceneInfos addObject:[[DSTransitionSceneInfo alloc] init]];
        [self->_sceneInfos addObject:[[DSTransitionSceneInfo alloc] init]];
    });
    OCMStub([_levelRegistry count]).andReturn(3);
    XCTAssertThrows([_target loadSceneInfos]);
}

@end
