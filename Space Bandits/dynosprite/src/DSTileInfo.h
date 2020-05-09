//
//  DSTileInfo.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DSPoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSTileInfo : NSObject

@property (nonatomic, nonnull) NSString *imagePath;
@property (nonatomic) DSPoint tileSetStart;
@property (nonatomic) DSPoint tileSetSize;

@property (nonatomic, nonnull) NSMutableDictionary<NSString *, NSImage *> *hashToImage;
@property (nonatomic, nonnull) NSMutableDictionary<NSNumber *, NSString *> *numberToHash;
@property (nonatomic, nonnull) SKTextureAtlas *atlas;

- (id)init;

@end

NS_ASSUME_NONNULL_END
