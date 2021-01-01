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
    id _bundle;
    id _imageLoader;
    id _levelRegistry;
    id _levelParser;
    id _spriteClassObjectFactory;
    id _objectParser;
    id _resourceController;
    id _tileInfoRegistry;
    id _transitionSceneInfoParser;
}

@end

@implementation DSAssetLoaderTest

- (void)setUp {
    _target = [[DSAssetLoader alloc] init];
    XCTAssertEqual(_target.registry, DSLevelRegistry.sharedInstance);
    XCTAssertTrue([_target.sceneInfos isKindOfClass:NSMutableArray.class]);

    XCTAssertEqual(_target.bundle, NSBundle.mainBundle);
    XCTAssertNil(_target.levelFileParser);
    XCTAssertNil(_target.imageLoader);
    XCTAssertNil(_target.spriteObjectClassFactory);
    XCTAssertNil(_target.objectParser);
    XCTAssertNil(_target.resourceController);
    XCTAssertNil(_target.tileInfoRegistry);

    _bundle = OCMClassMock(NSBundle.class);
    _imageLoader = OCMClassMock(DSTransitionImageLoader.class);
    _levelParser = OCMClassMock(DSLevelFileParser.class);
    _levelRegistry = OCMClassMock(DSLevelRegistry.class);
    _spriteClassObjectFactory = OCMClassMock(DSSpriteObjectClassFactory.class);
    _objectParser = OCMClassMock(DSSpriteFileParser.class);
    _sceneInfos = [NSMutableArray array];
    _resourceController = OCMClassMock(DSResourceController.class);
    _tileInfoRegistry = OCMClassMock(DSTileInfoRegistry.class);
    _transitionSceneInfoParser = OCMClassMock(DSTransitionSceneInfoFileParser.class);

    _target.bundle = _bundle;
    _target.imageLoader = _imageLoader;
    _target.levelFileParser = _levelParser;
    _target.spriteObjectClassFactory = _spriteClassObjectFactory;
    _target.objectParser = _objectParser;
    _target.registry = _levelRegistry;
    _target.resourceController = _resourceController;
    _target.sceneInfos = _sceneInfos;
    _target.tileInfoRegistry = _tileInfoRegistry;
    _target.transitionSceneInfoFileParser = _transitionSceneInfoParser;
}

- (void)testInit {
    XCTAssertEqual(_target.bundle, _bundle);
    XCTAssertEqual(_target.imageLoader, _imageLoader);
    XCTAssertEqual(_target.levelFileParser, _levelParser);
    XCTAssertEqual(_target.spriteObjectClassFactory, _spriteClassObjectFactory);
    XCTAssertEqual(_target.objectParser, _objectParser);
    XCTAssertEqual(_target.registry, _levelRegistry);
    XCTAssertEqual(_target.resourceController, _resourceController);
    XCTAssertEqual(_target.sceneInfos, _sceneInfos);
    XCTAssertEqual(_target.transitionSceneInfoFileParser, _transitionSceneInfoParser);
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

- (void)testLoadLevelsThrowsWhenNoLevels {
    NSArray<DSLevel *> *levels = @[
    ];
    
    NSArray<NSString *> *paths = @[
    ];

    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"levels"]).andReturn(paths);
    OCMStub([_levelRegistry count]).andReturn(levels.count);
    XCTAssertThrows([_target loadLevels]);
}

- (void)testLoadLevelsThrowsWhenLevelCountsDontMatch {
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

- (void)testLoadLevelsThrowsIfBadFilename {
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

- (void)testLoadLevelsThrowsIfMissingLevelsFilename {
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

- (void)testLoadLevelsThrowsIfSameLevelTwice {
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

- (void)testLoadLevelsThrowsIfParseFails {
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

- (void)testLoadTileSets {
    NSArray<NSString *> *paths = @[
        @"Resources/levels/02-bar.json",
        @"Resources/levels/01-foo.jpeg",
        @"Resources/levels/01-foo.json",
        @"Resources/levels/03-baz.json"
    ];

    __block NSMutableSet *set = [NSMutableSet set];
    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"tiles"]).andReturn(paths);
    OCMStub([_tileInfoRegistry addTileInfoFromFile:paths[0] forNumber:2]).andDo(^(NSInvocation *invocation) { [set addObject:paths[0]]; });
    OCMStub([_tileInfoRegistry addTileInfoFromFile:paths[2] forNumber:1]).andDo(^(NSInvocation *invocation) { [set addObject:paths[2]]; });
    OCMStub([_tileInfoRegistry addTileInfoFromFile:paths[3] forNumber:3]).andDo(^(NSInvocation *invocation) { [set addObject:paths[3]]; });
    
    [_target loadTileSets];
    XCTAssertEqual(set.count, 3);
}

- (void)testLoadTileSetsThrowsWhenDuplicateLevels {
    NSArray<NSString *> *paths = @[
        @"Resources/levels/02-bar.json",
        @"Resources/levels/01-foo.json",
        @"Resources/levels/01-foo.json",
        @"Resources/levels/03-baz.json"
    ];
    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"tiles"]).andReturn(paths);
    XCTAssertThrows([_target loadTileSets]);
}

- (void)testLoadTileSetsThrowsWhenNoLevels {
    NSArray<NSString *> *paths = @[
    ];
    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"tiles"]).andReturn(paths);
    XCTAssertThrows([_target loadTileSets]);
}

- (void)testLoadTileSetsThrowsWhenMissingLevels {
    NSArray<NSString *> *paths = @[
        @"Resources/levels/02-bar.json",
        @"Resources/levels/01-foo.json",
        @"Resources/levels/01-foo.json",
        @"Resources/levels/04-baz.json"
    ];
    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"tiles"]).andReturn(paths);
    XCTAssertThrows([_target loadTileSets]);
}

- (void)testLoadTileSetsThrowsWhenBadFiles {
    NSArray<NSString *> *paths = @[
        @"Resources/levels/02-bar.json",
        @"Resources/levels/blah01-foo.json",
        @"Resources/levels/01-foo.json",
        @"Resources/levels/03-baz.json"
    ];
    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"tiles"]).andReturn(paths);
    XCTAssertThrows([_target loadTileSets]);
}

- (void)testLoadTileSetsThrowsWhenJsonBad {
    NSArray<NSString *> *paths = @[
        @"Resources/levels/02-bar.json",
        @"Resources/levels/01-foo.json",
        @"Resources/levels/03-baz.json"
    ];
    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"tiles"]).andReturn(paths);
    OCMStub([_tileInfoRegistry addTileInfoFromFile:paths[0] forNumber:2]).andDo(^(NSInvocation *invocation) { @throw [NSException exceptionWithName:@"oops" reason:nil userInfo:nil]; });
    XCTAssertThrows([_target loadTileSets]);
}

- (void)testLoadSceneInfos {
    OCMStub([_resourceController pathForConfigFileWithName:@"images/images.json"]).andReturn(@"/foo.app/Contents/Resources/images/images.json");
    OCMStub([(DSTransitionSceneInfoFileParser *)_transitionSceneInfoParser parseFile:@"/foo.app/Contents/Resources/images/images.json" forTransitionInfo:_sceneInfos]).andDo(^(NSInvocation *invocation) {
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
    OCMStub([(DSTransitionSceneInfoFileParser *)_transitionSceneInfoParser parseFile:@"/foo.app/Contents/Resources/images/images.json" forTransitionInfo:_sceneInfos]).andDo(^(NSInvocation *invocation) {
        [self->_sceneInfos addObject:[[DSTransitionSceneInfo alloc] init]];
        [self->_sceneInfos addObject:[[DSTransitionSceneInfo alloc] init]];
        [self->_sceneInfos addObject:[[DSTransitionSceneInfo alloc] init]];
    });
    OCMStub([_levelRegistry count]).andReturn(3);
    XCTAssertThrows([_target loadSceneInfos]);
}

- (void)testLoadsObjectClasses {
    NSArray<NSString *> *paths = @[
        @"Resources/levels/04-goodguy.json",
        @"Resources/levels/03-badguys.json",
        @"Resources/levels/05-saucer.json"
    ];

    NSMutableArray<NSNumber *> *indices = [NSMutableArray arrayWithArray:@[@5, @4, @3]];
    NSMutableArray<DSSpriteObjectClass *> *objectClasses = NSMutableArray.array;
    void (^invoker)(NSInvocation *invocation) = ^(NSInvocation *invocation) {
        DSSpriteObjectClass *objectClass;
        NSNumber *num;
        [invocation getArgument:&objectClass atIndex:2];
        [invocation getArgument:&num atIndex:3];
        [objectClasses addObject:objectClass];
        XCTAssertEqual(num, indices.lastObject);
        [indices removeLastObject];
    };
     
    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"sprites"]).andReturn(paths);
    OCMStub([_spriteClassObjectFactory addSpriteObjectClass:OCMArg.any forNumber:@3]).andDo(invoker);
    OCMStub([_spriteClassObjectFactory addSpriteObjectClass:OCMArg.any forNumber:@4]).andDo(invoker);
    OCMStub([_spriteClassObjectFactory addSpriteObjectClass:OCMArg.any forNumber:@5]).andDo(invoker);
    
    [_target loadSprites];
    
    OCMVerify([_spriteClassObjectFactory addSpriteObjectClass:OCMArg.any forNumber:@3]);
    OCMVerify([_spriteClassObjectFactory addSpriteObjectClass:OCMArg.any forNumber:@4]);
    OCMVerify([_spriteClassObjectFactory addSpriteObjectClass:OCMArg.any forNumber:@5]);
    OCMVerify([_objectParser parseFile:paths[1] forObjectClass:objectClasses[0]]);
    OCMVerify([_objectParser parseFile:paths[0] forObjectClass:objectClasses[1]]);
    OCMVerify([_objectParser parseFile:paths[2] forObjectClass:objectClasses[2]]);

    OCMVerifyAll(_spriteClassObjectFactory);
}

- (void)testErrorsWhenLoadingDuplicateObjectClasses {
    NSArray<NSString *> *paths = @[
        @"Resources/levels/04-goodguy.json",
        @"Resources/levels/03-badguys.json",
        @"Resources/levels/03-saucer.json"
    ];
    OCMStub([_bundle pathsForResourcesOfType:@"json" inDirectory:@"sprites"]).andReturn(paths);
    XCTAssertThrows([_target loadSprites]);
}

@end
