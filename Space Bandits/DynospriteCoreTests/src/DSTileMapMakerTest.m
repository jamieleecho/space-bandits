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
    NSImage *_forestSubImage;
    NSImage *_forestTileImage;
}

- (void)setUp {
    _target = [[DSTileMapMaker alloc] init];
    _forestImage = [[NSBundle bundleForClass:self.class] imageForResource:@"forest"];
    _forestSubImage = [[NSBundle bundleForClass:self.class] imageForResource:@"forest-subimage"];
    _forestTileImage = [[NSBundle bundleForClass:self.class] imageForResource:@"forest-tile"];
}

- (void)testSubImage {
    NSImage *image = [_target subImage:_forestImage withRect:NSMakeRect(13, 20, 53, 21)];
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
    XCTAssertEqualObjects([_target hashForImage:_forestImage], @"7d19093f6755ba855f2642e33bb458be");
    XCTAssertEqualObjects([_target hashForImage:_forestTileImage], @"11e4d77b77a021049f2dd93733dfa576");
}

- (void)testImageIsEqualTo {
    XCTAssertTrue([_target image:_forestImage isEqualTo:_forestImage]);
    XCTAssertFalse([_target image:_forestImage isEqualTo:_forestTileImage]);
    NSImage *copyImage = [_target tileForImage:_forestTileImage atPoint:NSMakePoint(0, 0)];
    XCTAssertTrue([_target image:_forestTileImage isEqualTo:copyImage]);
}

- (void)testImageTileDictionaryFromImage {
    NSDictionary<NSString *, NSImage *> *hashToImage = [_target imageTileDictionaryFromImage:_forestImage];
    XCTAssertEqual(hashToImage.count, 211);
    NSImage *blueTile = [_target tileForImage:_forestImage atPoint:NSMakePoint(160, 0)];
    NSImage *blueTileImage = hashToImage[[_target hashForImage:blueTile]];
    XCTAssertTrue([DSTestUtils image:blueTile isSameAsImage:blueTileImage]);
    
    XCTAssertThrows([_target imageTileDictionaryFromImage:[_target subImage:_forestImage withRect:NSMakeRect(0, 0, 319, 191)]]);
}

- (void)testAtlasFromTileDictionary {
    NSDictionary<NSString *, NSImage *> *hashToImage = [_target imageTileDictionaryFromImage:_forestImage];
    NSImage *blueTile = [_target tileForImage:_forestImage atPoint:NSMakePoint(160, 0)];
    SKTextureAtlas *atlas = [_target atlasFromTileDictionary:hashToImage];
    XCTAssertEqual(atlas.textureNames.count, 211);
    SKTexture *blueTileTexture = [atlas textureNamed:[_target hashForImage:blueTile]];
    XCTAssertTrue([DSTestUtils image:[DSTestUtils convertToNSImage:blueTileTexture.CGImage withSize:blueTile.size] isSameAsImage:blueTile]);
}

- (void)testTileSetFromTextureAtlas {
    NSDictionary<NSString *, NSImage *> *hashToImage = [_target imageTileDictionaryFromImage:_forestImage];
    SKTextureAtlas *atlas = [_target atlasFromTileDictionary:hashToImage];
    SKTileSet *tileSet = [_target tileSetFromTextureAtlas:atlas];
    XCTAssertTrue(CGSizeEqualToSize(tileSet.defaultTileSize, CGSizeMake(16 * NSScreen.mainScreen.backingScaleFactor, 16 * NSScreen.mainScreen.backingScaleFactor)));
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
    XCTAssertTrue([DSTestUtils image:[DSTestUtils convertToNSImage:blueTileTexture.CGImage withSize:blueTile.size] isSameAsImage:blueTile]);
    XCTAssertTrue(CGSizeEqualToSize(blueTileTexture.size, CGSizeMake(16 * NSScreen.mainScreen.backingScaleFactor, 16 * NSScreen.mainScreen.backingScaleFactor)));
}

- (void)testNodeFromImageWithRect {
    SKTileMapNode *tileMapNode = [_target nodeFromImage:_forestImage withRect:NSMakeRect(21, 10, 192, 160)];
    XCTAssertEqual(tileMapNode.tileSet.tileGroups.count, 108);
    XCTAssertEqual(tileMapNode.numberOfColumns, 12);
    XCTAssertEqual(tileMapNode.numberOfRows, 10);
    XCTAssertEqual(tileMapNode.xScale, 1 / NSScreen.mainScreen.backingScaleFactor);
    XCTAssertEqual(tileMapNode.yScale, 1 / NSScreen.mainScreen.backingScaleFactor);
    XCTAssertTrue(CGSizeEqualToSize(tileMapNode.tileSize, CGSizeMake(16 * NSScreen.mainScreen.backingScaleFactor, 16 * NSScreen.mainScreen.backingScaleFactor)));
    XCTAssertEqualObjects([tileMapNode tileGroupAtColumn:5 row:3].name, @"bc40f63d14b195421c8ce2b058986de6");
    XCTAssertTrue(CGSizeEqualToSize(tileMapNode.mapSize, CGSizeMake(12 * 16 * NSScreen.mainScreen.backingScaleFactor, 10 * 16 * NSScreen.mainScreen.backingScaleFactor)));
    XCTAssertTrue(CGPointEqualToPoint(tileMapNode.anchorPoint, CGPointMake(0, 1)));
}

- (void)testNodeFromImageWithRectThrowsWithBadInputs {
    XCTAssertThrows([_target nodeFromImage:_forestImage withRect:NSMakeRect(21, 10, 192, 161)]);
    XCTAssertThrows([_target nodeFromImage:_forestImage withRect:NSMakeRect(21, 10, 193, 160)]);
}

@end
