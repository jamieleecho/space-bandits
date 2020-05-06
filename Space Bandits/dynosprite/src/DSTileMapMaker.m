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
    NSAssert(rect.origin.x >= 0, @"SubImage X origin must be >= 0");
    NSAssert(rect.origin.y >= 0, @"SubImage Y origin must be >= 0");
    float y = image.size.height - rect.origin.y - rect.size.height;
    NSImage *outputImage = [[NSImage alloc] initWithSize:rect.size];
    [outputImage lockFocus];
    [image drawInRect:NSMakeRect(0, 0, rect.size.width, rect.size.height) fromRect:NSMakeRect(rect.origin.x, y, rect.size.width, rect.size.height) operation:NSCompositingOperationSourceOver fraction:1];
    [outputImage unlockFocus];
    return outputImage;
}

- (NSImage *)subImageForMap:(NSImage *)image withRect:(NSRect)rect {
    NSAssert((((int)rect.size.width / DSTileSize) * DSTileSize) == rect.size.width, @"TilemapSize width must be a multiple of 16");
    NSAssert((((int)rect.size.height / DSTileSize) * DSTileSize) == rect.size.height, @"TilemapSize height must be a multiple of 16");
    NSAssert(rect.origin.x + rect.size.width <= image.size.width, @"Tilemap X origin and width larger than the image width");
    NSAssert(rect.origin.y + rect.size.height <= image.size.height, @"Tilemap Y origin and height larger than the image height");
    return [self subImage:image withRect:rect];
}

- (NSImage *)tileForImage:(NSImage *)image atPoint:(NSPoint)p0 {
    return [self subImageForMap:image withRect:NSMakeRect(p0.x, p0.y, DSTileSize, DSTileSize)];
}

- (NSString *)hashForImage:(NSImage *)image {
    return image.TIFFRepresentation.MD5;
}

- (BOOL)image:(NSImage *)image1 isEqualTo:(NSImage *)image2 {
    return [image1.TIFFRepresentation isEqualToData:image2.TIFFRepresentation];
}

- (NSDictionary<NSString *, NSImage *> *)imageTileDictionaryFromImage:(NSImage *)image {
    NSAssert((((int)image.size.width / DSTileSize) * DSTileSize) == image.size.width, @"TilemapSize width must be a multiple of 16");
    NSAssert((((int)image.size.height / DSTileSize) * DSTileSize) == image.size.height, @"TilemapSize height must be a multiple of 16");
    
    NSMutableDictionary *hashToImage = [NSMutableDictionary dictionary];
    for(int yy = 0; yy < image.size.height; yy += DSTileSize) {
        for(int xx = 0; xx < image.size.width; xx += DSTileSize) {
            NSImage *tile = [self tileForImage:image atPoint:NSMakePoint(xx, yy)];
            NSString *hash = [self hashForImage:tile];
            if (hashToImage[hash] == nil) {
                hashToImage[hash] = tile;
            }
        }
    }
    
    return hashToImage;
}

- (SKTextureAtlas *)atlasFromTileDictionary:(NSDictionary<NSString *, NSImage *> *)tileDictionary {
    return [SKTextureAtlas atlasWithDictionary:tileDictionary];
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

- (SKTileMapNode *)nodeFromImage:(NSImage *)image withRect:(NSRect)rect {
    NSImage *imageForMap = [self subImageForMap:image withRect:rect];
    NSDictionary<NSString *, NSImage *> *map = [self imageTileDictionaryFromImage:imageForMap];
    SKTextureAtlas *atlas = [self atlasFromTileDictionary:map];
    SKTileSet *tileSet = [self tileSetFromTextureAtlas:atlas];
    SKTileMapNode *tileMapNode = [SKTileMapNode tileMapNodeWithTileSet:tileSet columns:rect.size.width / DSTileSize rows:rect.size.height / DSTileSize tileSize:CGSizeMake(DSTileSize, DSTileSize)];
    tileMapNode.tileSize = CGSizeMake(DSTileSize * NSScreen.mainScreen.backingScaleFactor, DSTileSize * NSScreen.mainScreen.backingScaleFactor);

    NSMutableDictionary<NSString *, SKTileGroup *> *hashToTileGroup = [NSMutableDictionary dictionary];
    for(SKTileGroup *group in tileSet.tileGroups) {
        hashToTileGroup[group.name] = group;
    }
    
    for(int jj = 0; jj < tileMapNode.numberOfRows; jj++) {
        for(int ii = 0; ii < tileMapNode.numberOfColumns; ii++) {
            NSImage *tileImage = [self tileForImage:imageForMap atPoint:NSMakePoint(ii * DSTileSize, jj * DSTileSize)];
            NSString *hash = [self hashForImage:tileImage];
            SKTileGroup *group = hashToTileGroup[hash];
            NSAssert(group != nil, ([NSString stringWithFormat:@"Could not locate background tile with hash %@.", hash]));
            [tileMapNode setTileGroup:group forColumn:ii row:tileMapNode.numberOfRows-jj];
        }
    }
    tileMapNode.xScale = tileMapNode.yScale = 1 / NSScreen.mainScreen.backingScaleFactor;
    tileMapNode.anchorPoint = CGPointMake(0, 1);

    return tileMapNode;
}

@end
