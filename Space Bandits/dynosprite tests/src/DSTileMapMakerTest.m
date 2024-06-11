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
    UIImage *_forestImage;
    UIImage *_forestHackImage;
    UIImage *_forestSubImage;
    UIImage *_forestTileImage;
}

- (void)setUp {
    _target = [[DSTileMapMaker alloc] init];
    _forestImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"forest" ofType:@"png"]];
    _forestHackImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"forest-hack" ofType:@"png"]];
    _forestSubImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"forest-subimage" ofType:@"tiff"]];
    _forestTileImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"forest-tile" ofType:@"tiff"]];
}

- (void)testSubImage {
    UIImage *image = [_target subImage:_forestImage withRect:CGRectMake(13, 20, 47, 53)];
    XCTAssertTrue([DSTestUtils image:image isSameAsImage:_forestSubImage]);
    XCTAssertFalse([DSTestUtils image:image isSameAsImage:_forestTileImage]);
    [_target subImage:_forestImage withRect:CGRectMake(0, 0, 53, 21)];
    XCTAssertThrows([_target subImage:_forestImage withRect:CGRectMake(0, -1, 53, 21)]);
    XCTAssertThrows([_target subImage:_forestImage withRect:CGRectMake(-1, 0, 53, 21)]);
    XCTAssertThrows([_target subImage:_forestImage withRect:CGRectMake(100, 200, -53, 21)]);
    XCTAssertThrows([_target subImage:_forestImage withRect:CGRectMake(100, 200, 53, -21)]);
}

- (void)testSubImageForMap {
    UIImage *image = [_target subImageForMap:_forestImage withRect:CGRectMake(76, 154, 16, 16)];
    XCTAssertTrue([DSTestUtils image:image isSameAsImage:_forestTileImage]);

    UIImage *image0 = [_target subImage:_forestImage withRect:CGRectMake(13, 20, 32, 48)];
    UIImage *image1 = [_target subImageForMap:_forestImage withRect:CGRectMake(13, 20, 32, 48)];
    XCTAssertTrue([DSTestUtils image:image0 isSameAsImage:image1]);

    XCTAssertThrows([_target subImageForMap:_forestImage withRect:CGRectMake(13, 20, 53, 21)]);
    XCTAssertThrows([_target subImageForMap:_forestImage withRect:CGRectMake(0, -1, 16, 16)]);
    XCTAssertThrows([_target subImageForMap:_forestImage withRect:CGRectMake(-1, 0, 16, 16)]);
    XCTAssertThrows([_target subImageForMap:_forestImage withRect:CGRectMake(100, 200, -16, 16)]);
    XCTAssertThrows([_target subImageForMap:_forestImage withRect:CGRectMake(100, 200, 16, -16)]);
}

- (void)testTileImage {
    UIImage *image = [_target tileForImage:_forestImage atPoint:CGPointMake(76, 154)];
    XCTAssertTrue([DSTestUtils image:image isSameAsImage:_forestTileImage]);
    
    XCTAssertThrows([_target tileForImage:_forestImage atPoint:CGPointMake(305, 176)]);
    XCTAssertThrows([_target tileForImage:_forestImage atPoint:CGPointMake(304, 177)]);
    XCTAssertThrows([_target tileForImage:_forestImage atPoint:CGPointMake(-1, 0)]);
    XCTAssertThrows([_target tileForImage:_forestImage atPoint:CGPointMake(0, -1)]);
}

- (void)testHashForImage {
#if TARGET_OS_MACCATALYST
    XCTAssertEqualObjects([_target hashForImage:_forestImage], @"07c91d5e8b0f3da3507868c4383d794332c6cb1dd1c0e32f181af6fce41572e7");
    XCTAssertEqualObjects([_target hashForImage:_forestTileImage], @"8b7587bae2e7d652c79a77ea36c4b01ca1788e7d92733168d8c57847cbae821e");
#else
    XCTAssertEqualObjects([_target hashForImage:_forestImage], @"3034b750f220c3ab409a086c1dd3a21775c2b9a382841eda3319060ad31a9843");
    XCTAssertEqualObjects([_target hashForImage:_forestTileImage], @"8b7587bae2e7d652c79a77ea36c4b01ca1788e7d92733168d8c57847cbae821e");
#endif
}

- (void)testImageIsEqualTo {
    XCTAssertTrue([_target image:_forestImage isEqualTo:_forestImage]);
    XCTAssertFalse([_target image:_forestImage isEqualTo:_forestTileImage]);
    UIImage *copyImage = [_target tileForImage:_forestTileImage atPoint:CGPointMake(0, 0)];
    XCTAssertTrue([_target image:_forestTileImage isEqualTo:copyImage]);
}

- (void)testImageTileDictionaryFromImage {
    NSDictionary<NSString *, DSCons<UIImage *, NSNumber *> *> *hashToImageAndIndex = [_target imageTileDictionaryFromImage:_forestImage];
    XCTAssertEqual(hashToImageAndIndex.count, 209);
    UIImage *blueTile = [_target tileForImage:_forestImage atPoint:CGPointMake(160, 0)];
    UIImage *blueTileImage = hashToImageAndIndex[[_target hashForImage:blueTile]].car;
    XCTAssertEqualObjects(@6, [hashToImageAndIndex[[_target hashForImage:blueTile]] cdr]);
    XCTAssertTrue([DSTestUtils image:blueTile isSameAsImage:blueTileImage]);
    
    XCTAssertThrows([_target imageTileDictionaryFromImage:[_target subImage:_forestImage withRect:CGRectMake(0, 0, 319, 191)]]);
}

- (void)testAtlasFromTileDictionary {
    NSDictionary<NSString *, DSCons<UIImage *, NSNumber *> *> *hashToImage = [_target imageTileDictionaryFromImage:_forestImage];
    SKTextureAtlas *atlas = [_target atlasFromTileDictionary:hashToImage];
    XCTAssertEqual(atlas.textureNames.count, 209);
}

- (void)testTileSetFromTextureAtlas {
    NSDictionary<NSString *, DSCons<UIImage *, NSNumber *> *> *hashToImage = [_target imageTileDictionaryFromImage:_forestImage];
    SKTextureAtlas *atlas = [_target atlasFromTileDictionary:hashToImage];
    SKTileSet *tileSet = [_target tileSetFromTextureAtlas:atlas];
    XCTAssertTrue(CGSizeEqualToSize(tileSet.defaultTileSize, CGSizeMake(16, 16)));
    NSMutableSet<NSString *> *groupNames = [NSMutableSet setWithCapacity:hashToImage.count];
    UIImage *blueTile = [_target tileForImage:_forestImage atPoint:CGPointMake(160, 0)];
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
    XCTAssertTrue(CGSizeEqualToSize(blueTileTexture.size, CGSizeMake(16, 16)));
}

- (void)testNodeFromImageWithRectUsingTileImageWithTileRect {
    SKTileMapNode *tileMapNode = [_target nodeFromImage:_forestImage withRect:CGRectMake(21, 10, 192, 160) usingTileImage:_forestImage withTileRect:CGRectMake(21, 10, 192, 160)];
    XCTAssertEqual(tileMapNode.tileSet.tileGroups.count, 107);
    XCTAssertEqual(tileMapNode.numberOfColumns, 12);
    XCTAssertEqual(tileMapNode.numberOfRows, 10);
    XCTAssertEqual(tileMapNode.xScale, 1);
    XCTAssertEqual(tileMapNode.yScale, 1);
    XCTAssertTrue(CGSizeEqualToSize(tileMapNode.tileSize, CGSizeMake(16, 16)));
#if TARGET_OS_MACCATALYST == 1
    XCTAssertEqualObjects([tileMapNode tileGroupAtColumn:5 row:2].name, @"ad1b99eb69862956599425a4779d3744d47230d6f1b387db37e2b8ea09f499e0");
#else
    XCTAssertEqualObjects([tileMapNode tileGroupAtColumn:5 row:2].name, @"7b4ed952385dc5e5ca3b63f30d541f73add7863c0896ffdec61869c29b7e94eb");
#endif
    XCTAssertTrue(CGSizeEqualToSize(tileMapNode.mapSize, CGSizeMake(12 * 16, 10 * 16)));
    XCTAssertTrue(CGPointEqualToPoint(tileMapNode.anchorPoint, CGPointMake(0, 1)));
}

- (void)testNodeFromImageWithRectUsingTileImageWithTileRect2 {
    SKTileMapNode *tileMapNode = [_target nodeFromImage:_forestHackImage withRect:CGRectMake(0, 0, 320, 192) usingTileImage:_forestImage withTileRect:CGRectMake(0, 0, 320, 192)];
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
    XCTAssertThrows([_target nodeFromImage:_forestImage withRect:CGRectMake(21, 10, 192, 161) usingTileImage:_forestImage withTileRect:CGRectMake(21, 10, 192, 160)]);
    XCTAssertThrows([_target nodeFromImage:_forestImage withRect:CGRectMake(21, 10, 193, 160) usingTileImage:_forestImage withTileRect:CGRectMake(21, 10, 192, 160)]);
    XCTAssertThrows([_target nodeFromImage:_forestImage withRect:CGRectMake(21, 10, 192, 160) usingTileImage:_forestImage withTileRect:CGRectMake(21, 10, 192, 161)]);
    XCTAssertThrows([_target nodeFromImage:_forestImage withRect:CGRectMake(21, 10, 192, 160) usingTileImage:_forestImage withTileRect:CGRectMake(21, 10, 193, 160)]);
}

@end
