//
//  DSTileMapMakerTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 5/2/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSTestUtils.h"
#import "DSTileMapMaker.h"

@interface DSTileMapMakerTest : XCTestCase

@end

@implementation DSTileMapMakerTest {
    DSTileMapMaker *_target;
    NSImage *_forestImage;
    NSImage *_forestHackImage;
    NSImage *_forestSubImage;
    NSImage *_forestTileImage;
}

- (void)setUp {
    _target = [[DSTileMapMaker alloc] init];
    _forestImage = [[NSBundle bundleForClass:self.class] imageForResource:@"forest"];
    _forestHackImage = [[NSBundle bundleForClass:self.class] imageForResource:@"forest-hack"];
    _forestSubImage = [[NSBundle bundleForClass:self.class] imageForResource:@"forest-subimage"];
    _forestTileImage = [[NSBundle bundleForClass:self.class] imageForResource:@"forest-tile"];
}

- (void)testSubImage {
    NSImage *image = [_target subImage:_forestImage withRect:NSMakeRect(13, 20, 47, 53)];
    XCTAssertTrue([DSTestUtils image:image isSameAsImage:_forestSubImage]);
    XCTAssertFalse([DSTestUtils image:image isSameAsImage:_forestTileImage]);
    [_target subImage:_forestImage withRect:NSMakeRect(0, 0, 53, 21)];
    XCTAssertThrows([_target subImage:_forestImage withRect:NSMakeRect(0, -1, 53, 21)]);
    XCTAssertThrows([_target subImage:_forestImage withRect:NSMakeRect(-1, 0, 53, 21)]);
    XCTAssertThrows([_target subImage:_forestImage withRect:NSMakeRect(100, 200, -53, 21)]);
    XCTAssertThrows([_target subImage:_forestImage withRect:NSMakeRect(100, 200, 53, -21)]);
}

- (void)testSubImageForMap {
    NSImage *image = [_target subImageForMap:_forestImage withRect:NSMakeRect(76, 154, 16, 16)];
    XCTAssertTrue([DSTestUtils image:image isSameAsImage:_forestTileImage]);

    NSImage *image0 = [_target subImage:_forestImage withRect:NSMakeRect(13, 20, 32, 48)];
    NSImage *image1 = [_target subImageForMap:_forestImage withRect:NSMakeRect(13, 20, 32, 48)];
    XCTAssertTrue([DSTestUtils image:image0 isSameAsImage:image1]);

    XCTAssertThrows([_target subImageForMap:_forestImage withRect:NSMakeRect(13, 20, 53, 21)]);
    XCTAssertThrows([_target subImageForMap:_forestImage withRect:NSMakeRect(0, -1, 16, 16)]);
    XCTAssertThrows([_target subImageForMap:_forestImage withRect:NSMakeRect(-1, 0, 16, 16)]);
    XCTAssertThrows([_target subImageForMap:_forestImage withRect:NSMakeRect(100, 200, -16, 16)]);
    XCTAssertThrows([_target subImageForMap:_forestImage withRect:NSMakeRect(100, 200, 16, -16)]);
}

- (void)testTileImage {
    NSImage *image = [_target tileForImage:_forestImage atPoint:NSMakePoint(76, 154)];
    XCTAssertTrue([DSTestUtils image:image isSameAsImage:_forestTileImage]);
    
    XCTAssertThrows([_target tileForImage:_forestImage atPoint:NSMakePoint(305, 176)]);
    XCTAssertThrows([_target tileForImage:_forestImage atPoint:NSMakePoint(304, 177)]);
    XCTAssertThrows([_target tileForImage:_forestImage atPoint:NSMakePoint(-1, 0)]);
    XCTAssertThrows([_target tileForImage:_forestImage atPoint:NSMakePoint(0, -1)]);
}

- (void)testHashForImage {
    XCTAssertEqualObjects([_target hashForImage:_forestImage], @"db6aa5c40fc53928171d4ed025e9cbd748cf3e57908626fcb9c2ba9b2577c3c4");
    XCTAssertEqualObjects([_target hashForImage:_forestTileImage], @"a0761949865d1b6fa8f3c5b8860034ea2eb8db1f50603e3959a10d557b35105d");
}

- (void)testImageIsEqualTo {
    XCTAssertTrue([_target image:_forestImage isEqualTo:_forestImage]);
    XCTAssertFalse([_target image:_forestImage isEqualTo:_forestTileImage]);
    NSImage *copyImage = [_target tileForImage:_forestTileImage atPoint:NSMakePoint(0, 0)];
    XCTAssertTrue([_target image:_forestTileImage isEqualTo:copyImage]);
}

- (void)testImageTileDictionaryFromImage {
    NSDictionary<NSString *, DSCons<NSImage *, NSNumber *> *> *hashToImageAndIndex = [_target imageTileDictionaryFromImage:_forestImage];
    XCTAssertEqual(hashToImageAndIndex.count, 209);
    NSImage *blueTile = [_target tileForImage:_forestImage atPoint:NSMakePoint(160, 0)];
    NSImage *blueTileImage = hashToImageAndIndex[[_target hashForImage:blueTile]].car;
    XCTAssertEqualObjects(@6, [hashToImageAndIndex[[_target hashForImage:blueTile]] cdr]);
    XCTAssertTrue([DSTestUtils image:blueTile isSameAsImage:blueTileImage]);
    
    XCTAssertThrows([_target imageTileDictionaryFromImage:[_target subImage:_forestImage withRect:NSMakeRect(0, 0, 319, 191)]]);
}

- (void)testAtlasFromTileDictionary {
    NSDictionary<NSString *, DSCons<NSImage *, NSNumber *> *> *hashToImage = [_target imageTileDictionaryFromImage:_forestImage];
    // NSImage *blueTile = [_target tileForImage:_forestImage atPoint:NSMakePoint(160, 0)];
    SKTextureAtlas *atlas = [_target atlasFromTileDictionary:hashToImage];
    XCTAssertEqual(atlas.textureNames.count, 209);
    // TODO: We skip this test because SKTexture.CGImage is broken in macOS Catalina
    //SKTexture *blueTileTexture = [atlas textureNamed:[_target hashForImage:blueTile]];
    // XCTAssertTrue([DSTestUtils image:[DSTestUtils convertToNSImage:blueTileTexture.CGImage withSize:blueTile.size] isSameAsImage:blueTile]);
}

- (void)testTileSetFromTextureAtlas {
    NSDictionary<NSString *, DSCons<NSImage *, NSNumber *> *> *hashToImage = [_target imageTileDictionaryFromImage:_forestImage];
    SKTextureAtlas *atlas = [_target atlasFromTileDictionary:hashToImage];
    SKTileSet *tileSet = [_target tileSetFromTextureAtlas:atlas];
    XCTAssertTrue(CGSizeEqualToSize(tileSet.defaultTileSize, CGSizeMake(16, 16)));
    NSMutableSet<NSString *> *groupNames = [NSMutableSet setWithCapacity:hashToImage.count];
    NSImage *blueTile = [_target tileForImage:_forestImage atPoint:NSMakePoint(160, 0)];
    NSString *blueTileName = [_target hashForImage:blueTile];
    SKTileGroup *blueTileGroup = nil;
    for(SKTileGroup *group in tileSet.tileGroups) {
        [groupNames addObject:group.name];
        XCTAssertNotNil(hashToImage[group.name]);
        if ([group.name isEqualToString:blueTileName]) {
            blueTileGroup = group;
        }
    }
    XCTAssertEqual(groupNames.count, hashToImage.count);
    SKTexture *blueTileTexture = blueTileGroup.rules.firstObject.tileDefinitions.firstObject.textures.firstObject;
    // TODO: We skip this test because SKTexture.CGImage is broken in macOS Catalina
    // XCTAssertTrue([DSTestUtils image:[DSTestUtils convertToNSImage:blueTileTexture.CGImage withSize:blueTile.size] isSameAsImage:blueTile]);
    XCTAssertTrue(CGSizeEqualToSize(blueTileTexture.size, CGSizeMake(16, 16)));
}

- (void)testNodeFromImageWithRectUsingTileImageWithTileRect {
    SKTileMapNode *tileMapNode = [_target nodeFromImage:_forestImage withRect:NSMakeRect(21, 10, 192, 160) usingTileImage:_forestImage withTileRect:NSMakeRect(21, 10, 192, 160)];
    XCTAssertEqual(tileMapNode.tileSet.tileGroups.count, 107);
    XCTAssertEqual(tileMapNode.numberOfColumns, 12);
    XCTAssertEqual(tileMapNode.numberOfRows, 10);
    XCTAssertEqual(tileMapNode.xScale, 1);
    XCTAssertEqual(tileMapNode.yScale, 1);
    XCTAssertTrue(CGSizeEqualToSize(tileMapNode.tileSize, CGSizeMake(16, 16)));
    XCTAssertEqualObjects([tileMapNode tileGroupAtColumn:5 row:2].name, @"f4ff196e2ed5fc498c1a6fce3dea7bf805a5425c88f23f2eb3d140310abc4964");
    XCTAssertTrue(CGSizeEqualToSize(tileMapNode.mapSize, CGSizeMake(12 * 16, 10 * 16)));
    XCTAssertTrue(CGPointEqualToPoint(tileMapNode.anchorPoint, CGPointMake(0, 1)));
}

- (void)testNodeFromImageWithRectUsingTileImageWithTileRect2 {
    SKTileMapNode *tileMapNode = [_target nodeFromImage:_forestHackImage withRect:NSMakeRect(0, 0, 320, 192) usingTileImage:_forestImage withTileRect:NSMakeRect(0, 0, 320, 192)];
    XCTAssertEqual(tileMapNode.tileSet.tileGroups.count, 209);
    XCTAssertEqual(tileMapNode.numberOfColumns, 20);
    XCTAssertEqual(tileMapNode.numberOfRows, 12);
    XCTAssertEqual(tileMapNode.xScale, 1);
    XCTAssertEqual(tileMapNode.yScale, 1);
    XCTAssertTrue(CGSizeEqualToSize(tileMapNode.tileSize, CGSizeMake(16, 16)));
    XCTAssertTrue(CGSizeEqualToSize(tileMapNode.mapSize, CGSizeMake(320, 192)));
    XCTAssertEqualObjects([tileMapNode tileGroupAtColumn:0 row:11].name, [tileMapNode tileGroupAtColumn:1 row:10].name);
    XCTAssertTrue(CGPointEqualToPoint(tileMapNode.anchorPoint, CGPointMake(0, 1)));
}

- (void)testNodeFromImageWithRectThrowsWithBadInputs {
    XCTAssertThrows([_target nodeFromImage:_forestImage withRect:NSMakeRect(21, 10, 192, 161) usingTileImage:_forestImage withTileRect:NSMakeRect(21, 10, 192, 160)]);
    XCTAssertThrows([_target nodeFromImage:_forestImage withRect:NSMakeRect(21, 10, 193, 160) usingTileImage:_forestImage withTileRect:NSMakeRect(21, 10, 192, 160)]);
    XCTAssertThrows([_target nodeFromImage:_forestImage withRect:NSMakeRect(21, 10, 192, 160) usingTileImage:_forestImage withTileRect:NSMakeRect(21, 10, 192, 161)]);
    XCTAssertThrows([_target nodeFromImage:_forestImage withRect:NSMakeRect(21, 10, 192, 160) usingTileImage:_forestImage withTileRect:NSMakeRect(21, 10, 193, 160)]);
}

@end
