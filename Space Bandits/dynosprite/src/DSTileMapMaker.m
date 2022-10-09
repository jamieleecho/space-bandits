//
//  DSTileMapMaker.m
//  Space Bandits
//
//  Created by Jamie Cho on 5/2/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import "DSNSDataMD5Extensions.h"
#import "DSTileMapMaker.h"

#define DSTileSize (16)

@implementation DSTileMapMaker

- (NSImage *)subImage:(NSImage *)image withRect:(NSRect)rect; {
    NSCAssert(rect.origin.x >= 0, @"SubImage X origin must be >= 0");
    NSCAssert(rect.origin.y >= 0, @"SubImage Y origin must be >= 0");
    NSCAssert(rect.size.width >= 0, @"SubImage width must be >= 0");
    NSCAssert(rect.size.height >= 0, @"SubImage height origin must be >= 0");
    NSCAssert(rect.origin.x + rect.size.width <= image.size.width, @"SubImage X origin and width larger than the image width");
    NSCAssert(rect.origin.y + rect.size.height <= image.size.height, @"SubImage Y origin and height larger than the image height");

    // Get the conversions we need for the CGImageRef
    CGImageRef imageRef = [image CGImageForProposedRect:nil context:nil hints:nil];
    CGImageRef cutImageRef = CGImageCreateWithImageInRect(imageRef, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height));
    
    NSImage *cutImage = [[NSImage alloc] initWithCGImage:cutImageRef size:NSZeroSize];
    CGImageRelease(cutImageRef);
    return cutImage;
}

- (NSImage *)subImageForMap:(NSImage *)image withRect:(NSRect)rect {
    NSCAssert((((int)rect.size.width / DSTileSize) * DSTileSize) == rect.size.width, @"TilemapSize width must be a multiple of 16");
    NSCAssert((((int)rect.size.height / DSTileSize) * DSTileSize) == rect.size.height, @"TilemapSize height must be a multiple of 16");
    NSCAssert(rect.origin.x + rect.size.width <= image.size.width, @"Tilemap X origin and width larger than the image width");
    NSCAssert(rect.origin.y + rect.size.height <= image.size.height, @"Tilemap Y origin and height larger than the image height");
    return [self subImage:image withRect:rect];
}

- (NSImage *)tileForImage:(NSImage *)image atPoint:(NSPoint)p0 {
    return [self subImageForMap:image withRect:NSMakeRect(p0.x, p0.y, DSTileSize, DSTileSize)];
}

- (NSString *)hashForImage:(NSImage *)image {
    return image.TIFFRepresentation.SHA256;
}

- (BOOL)image:(NSImage *)image1 isEqualTo:(NSImage *)image2 {
    return [image1.TIFFRepresentation isEqualToData:image2.TIFFRepresentation];
}

- (NSDictionary<NSString *, NSImage *> *)imageTileDictionaryFromImage:(NSImage *)image {
    NSCAssert((((int)image.size.width / DSTileSize) * DSTileSize) == image.size.width, @"TilemapSize width must be a multiple of 16");
    NSCAssert((((int)image.size.height / DSTileSize) * DSTileSize) == image.size.height, @"TilemapSize height must be a multiple of 16");
    
    NSMutableDictionary *hashToImage = [NSMutableDictionary dictionary];
    for(int yy = 0; yy < image.size.height; yy += DSTileSize) {
        for(int xx = 0; xx < image.size.width; xx += DSTileSize) {
            NSImage *tile = [self tileForImage:image atPoint:NSMakePoint(xx, yy)];
            NSString *hash = [self hashForImage:tile];
            if (hashToImage[hash] == nil) {
                hashToImage[hash] = [[DSCons alloc] initWithCar:tile andCdr:[NSNumber numberWithUnsignedLong:hashToImage.count]];
            }
        }
    }
    
    return hashToImage;
}

- (SKTextureAtlas *)atlasFromTileDictionary:(NSDictionary<NSString *, DSCons<NSImage *, NSNumber *> *> *)tileDictionary {
    NSMutableDictionary<NSString *, NSImage *> *hashToImage = [NSMutableDictionary dictionary];
    for(NSString *key in tileDictionary.allKeys) {
        DSCons<NSImage *, NSNumber *> *imageIndexPair = tileDictionary[key];
        hashToImage[key] = imageIndexPair.car;
    }
    return [SKTextureAtlas atlasWithDictionary:hashToImage];
}

- (NSDictionary<NSNumber *, NSString *> *)tileIndexToTileHashFromTileDictionary:(NSDictionary<NSString *, DSCons<NSImage *, NSNumber *> *> *)tileDictionary {
    NSMutableDictionary<NSNumber *, NSString *> *tileIndexToTileHash = [NSMutableDictionary dictionary];
    for(NSString *key in tileDictionary.allKeys) {
        DSCons<NSImage *, NSNumber *> *imageIndexPair = tileDictionary[key];
        tileIndexToTileHash[imageIndexPair.cdr] = key;
    }
    return tileIndexToTileHash;
}

- (SKTileSet *)tileSetFromTextureAtlas:(SKTextureAtlas *)textureAtlas {
    NSMutableArray<SKTileGroup *> *tileGroups = [NSMutableArray array];
    for(NSString *textureName in textureAtlas.textureNames) {
        SKTexture *texture = [textureAtlas textureNamed:textureName];
        SKTileDefinition *tileDefinition = [SKTileDefinition tileDefinitionWithTexture:texture];
        SKTileGroup *tileGroup = [SKTileGroup tileGroupWithTileDefinition:tileDefinition];
        tileGroup.name = textureName;
        [tileGroups addObject:tileGroup];
    }
    return [SKTileSet tileSetWithTileGroups:tileGroups];
}

- (SKTileMapNode *)nodeFromImage:(NSImage *)image withRect:(NSRect)rect usingTileImage:(NSImage *)tileImage withTileRect:(NSRect)tileRect {
    NSImage *imageForTiles = [self subImageForMap:tileImage withRect:tileRect];
    NSDictionary<NSString *, DSCons<NSImage *, NSNumber *> *> *map = [self imageTileDictionaryFromImage:imageForTiles];
    SKTextureAtlas *atlas = [self atlasFromTileDictionary:map];
    SKTileSet *tileSet = [self tileSetFromTextureAtlas:atlas];

    SKTileMapNode *tileMapNode = [SKTileMapNode tileMapNodeWithTileSet:tileSet columns:rect.size.width / DSTileSize rows:rect.size.height / DSTileSize tileSize:CGSizeMake(DSTileSize, DSTileSize)];
    tileMapNode.tileSize = CGSizeMake(DSTileSize, DSTileSize);
    NSMutableDictionary<NSString *, SKTileGroup *> *hashToTileGroup = [NSMutableDictionary dictionary];
    for(SKTileGroup *group in tileSet.tileGroups) {
        hashToTileGroup[group.name] = group;
    }
    
    NSImage *mapImage = [self subImageForMap:image withRect:rect];
    for(int jj = 0; jj < tileMapNode.numberOfRows; jj++) {
        for(int ii = 0; ii < tileMapNode.numberOfColumns; ii++) {
            NSImage *tileImage = [self tileForImage:mapImage atPoint:NSMakePoint(ii * DSTileSize, jj * DSTileSize)];
            NSString *hash = [self hashForImage:tileImage];
            SKTileGroup *group = hashToTileGroup[hash];
            NSCAssert(group != nil, ([NSString stringWithFormat:@"Could not locate background tile with hash %@ at tile map location (%d, %d)", hash, ii, jj]));
            [tileMapNode setTileGroup:group forColumn:ii row:tileMapNode.numberOfRows - jj - 1];
        }
    }
    tileMapNode.xScale = tileMapNode.yScale = 1;
    tileMapNode.anchorPoint = CGPointMake(0, 1);

    return tileMapNode;
}

@end
