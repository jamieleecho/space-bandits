//
//  DSLevelLoaderTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/25/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "DSLevelLoader.h"


@interface DSLevelLoaderTest : XCTestCase {
    DSLevelLoader *_target;
    id _levelRegistry;
    id _levelParser;
    id _bundle;
}

@end

@implementation DSLevelLoaderTest

- (void)setUp {
    _target = [[DSLevelLoader alloc] init];
    XCTAssertEqual(_target.bundle, NSBundle.mainBundle);
    XCTAssertEqual(_target.registry, DSLevelRegistry.sharedInstance);
    XCTAssertNil(_target.fileParser);
    _levelRegistry = OCMClassMock(DSLevelRegistry.class);
    _levelParser = OCMClassMock(DSLevelFileParser.class);
    _bundle = OCMClassMock(NSBundle.class);
    _target.registry = _levelRegistry;
    _target.fileParser = _levelParser;
    _target.bundle = _bundle;
}

- (void)testInit {
    XCTAssertEqual(_target.registry, _levelRegistry);
    XCTAssertEqual(_target.fileParser, _levelParser);
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
    [_target load];

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
    XCTAssertThrows([_target load]);
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
    XCTAssertThrows([_target load]);
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
    XCTAssertThrows([_target load]);
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
    XCTAssertThrows([_target load]);
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
    XCTAssertThrows([_target load]);
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
    XCTAssertThrows([_target load]);
}

@end
