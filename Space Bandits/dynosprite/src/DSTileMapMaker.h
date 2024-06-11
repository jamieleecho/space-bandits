//
//  DSTileMapMaker.h
//  Space Bandits
//
//  Created by Jamie Cho on 5/2/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

#import "DSCons.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSTileMapMaker : NSObject

- (UIImage *)subImage:(UIImage *)image withRect:(CGRect)rect;
- (UIImage *)subImageForMap:(UIImage *)image withRect:(CGRect)rect;
- (UIImage *)tileForImage:(UIImage *)image atPoint:(CGPoint)p0;
- (NSString *)hashForImage:(UIImage *)image;
- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2;
- (NSDictionary<NSString *, DSCons<UIImage *, NSNumber *> *> *)imageTileDictionaryFromImage:(UIImage *)image;
- (SKTextureAtlas *)atlasFromTileDictionary:(NSDictionary<NSString *, DSCons<UIImage *, NSNumber *> *> *)tileDictionary;
- (NSDictionary<NSNumber *, NSString *> *)tileIndexToTileHashFromTileDictionary:(NSDictionary<NSString *, DSCons<UIImage *, NSNumber *> *> *)tileDictionary;
- (SKTileSet *)tileSetFromTextureAtlas:(SKTextureAtlas *)textureAtlas;
- (SKTileMapNode *)nodeFromImage:(UIImage *)image withRect:(CGRect)rect usingTileImage:(UIImage *)tileImage withTileRect:(CGRect)tileRect;

@end

NS_ASSUME_NONNULL_END
