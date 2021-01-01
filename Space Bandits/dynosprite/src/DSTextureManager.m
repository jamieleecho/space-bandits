//
//  DSTextureManager.m
//  Space Bandits
//
//  Created by Jamie Cho on 12/31/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DSImageUtil.h"
#import "DSTextureManager.h"


@implementation DSTextureManager 

- (id)init {
    if (self = [super init]) {
        _groupIdToTextures = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addSpriteObjectClass:(DSSpriteObjectClass *)spriteObjectClass {
    // Get pixels in a format that is easy to manipulate
    NSString *path = [self.resourceController spriteImageWithName:spriteObjectClass.imagePath];
    NSImage *spriteNSImage = [[NSImage alloc] initWithContentsOfFile:path];
    NSCAssert(spriteNSImage != nil, @"Could not open %@ for sprite group %d.", spriteObjectClass.imagePath, spriteObjectClass.groupID);
    CGImageRef spriteCGImage = [spriteNSImage CGImageForProposedRect:NULL context:NULL hints:NULL];
    SKTexture *mainTexture = [SKTexture textureWithCGImage:spriteCGImage];
    
    NSMutableArray<DSTexture *> *textures = [NSMutableArray arrayWithCapacity:spriteObjectClass.sprites.count];
    for(DSSpriteInfo *spriteInfo in spriteObjectClass.sprites) {
        DSImageUtilImageInfo imageInfo = DSImageUtilGetImagePixelData(spriteCGImage);
        CGRect rect = DSImageUtilFindSpritePixels(imageInfo, spriteInfo.name, CGPointMake(spriteInfo.location.x, spriteInfo.location.y));
        CGRect convertedRect = CGRectMake(rect.origin.x / imageInfo.width, rect.origin.y / imageInfo.height, rect.size.width / imageInfo.width, rect.size.height / imageInfo.height);
        SKTexture *spriteTexture = [SKTexture textureWithRect:convertedRect inTexture:mainTexture];
        CGFloat offsetX = (rect.origin.x + rect.size.width - spriteInfo.location.x) / rect.size.width;
        CGFloat offsetY = (rect.origin.y + rect.size.height - spriteInfo.location.y) / rect.size.height;
        DSTexture *texture = [[DSTexture alloc] initWithTexture:spriteTexture andPoint:CGPointMake(offsetX, offsetY)];
        [textures addObject:texture];
    }
    _groupIdToTextures[[NSNumber numberWithInt:spriteObjectClass.groupID]] = textures;
}

- (void)configureSprite:(SKSpriteNode *)node forCob:(DynospriteCOB *)cob {
    DSTexture *texture = _groupIdToTextures[[NSNumber numberWithInt:cob->groupIdx]][cob->statePtr[0]];
    node.hidden = !((cob->active & 1) == 1);
    node.size = texture.texture.size;
    node.texture = texture.texture;
    node.anchorPoint = texture.point;
    node.position = CGPointMake(cob->globalX, cob->globalY);
}

@end
