//
//  DSTextureManager.m
//  Space Bandits
//
//  Created by Jamie Cho on 12/31/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DSImageUtil.h"
#import "DSTestUtils.h"
#import "DSTextureManager.h"


@implementation DSTextureManager 

- (id)init {
    if (self = [super init]) {
        self.bundle = NSBundle.mainBundle;
        _groupIdToTextures = [[NSMutableDictionary alloc] init];
        _groupIdToSpriteInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addSpriteObjectClass:(DSSpriteObjectClass *)spriteObjectClass {
    // Get pixels in a format that is easy to manipulate
    NSString *path = [NSString pathWithComponents:@[self.bundle.resourcePath, [self.resourceController spriteImageWithName:spriteObjectClass.imagePath]]];
    NSImage *spriteNSImage = [[NSImage alloc] initWithContentsOfFile:path];
    NSCAssert(spriteNSImage != nil, @"Could not open %@ for sprite group %d.", spriteObjectClass.imagePath, spriteObjectClass.groupID);
    CGImageRef spriteCGImage = [spriteNSImage CGImageForProposedRect:NULL context:NULL hints:NULL];
    DSImageUtilImageInfo imageInfo = DSImageUtilGetImagePixelData(spriteCGImage);
    
    // Remove the transparent color
    const DSImageUtilARGB8 transparentColor = {0, 0, 0, 0};
    const NSColor *remapColor = spriteObjectClass.transparentColor;
    const DSImageUtilARGB8 transparentColorToMap = {0xff, (uint8_t)(remapColor.redComponent * 0xff), (uint8_t)(remapColor.greenComponent * 0xff), (uint8_t)(remapColor.blueComponent * 0xff)};
    DSImageUtilReplaceColor(imageInfo, transparentColorToMap, transparentColor);
    CGImageRef filteredImage = DSImageUtilMakeCGImage(imageInfo);
    SKTexture *mainTexture = [SKTexture textureWithCGImage:filteredImage];
    
    NSMutableArray<DSTexture *> *textures = [NSMutableArray arrayWithCapacity:spriteObjectClass.sprites.count];
    for(DSSpriteInfo *spriteInfo in spriteObjectClass.sprites) {
        DSImageUtilImageInfo imageInfo = DSImageUtilGetImagePixelData(filteredImage);
        CGRect rect = DSImageUtilFindSpritePixels(imageInfo, spriteInfo.name, CGPointMake(spriteInfo.location.x, spriteInfo.location.y));
        CGRect convertedRect = CGRectMake(rect.origin.x / imageInfo.width, 1.0f - (rect.origin.y + rect.size.height) / imageInfo.height, rect.size.width / imageInfo.width, rect.size.height / imageInfo.height);
        SKTexture *spriteTexture = [SKTexture textureWithRect:convertedRect inTexture:mainTexture];
        CGFloat offsetX = -(spriteInfo.location.x - rect.origin.x - (rect.size.width / 2));
        CGFloat offsetY = -(spriteInfo.location.y - rect.origin.y - (rect.size.height / 2));
        DSTexture *texture = [[DSTexture alloc] initWithTexture:spriteTexture andPoint:CGPointMake(offsetX, offsetY)];
        [textures addObject:texture];
    }

    // Map the textures
    _groupIdToTextures[[NSNumber numberWithInt:spriteObjectClass.groupID]] = textures;
    _groupIdToSpriteInfo[[NSNumber numberWithInt:spriteObjectClass.groupID]] = spriteObjectClass.sprites;

    CGImageRelease(filteredImage);
}

- (void)configureSprite:(SKSpriteNode *)node forCob:(DynospriteCOB *)cob andScene:(SKScene *)scene andCamera:(SKCameraNode *)camera includeBackgroundSavers:(BOOL)includeBackgroundSavers {
    BOOL saveBackground = _groupIdToSpriteInfo[[NSNumber numberWithInt:cob->groupIdx]][cob->statePtr[0]].saveBackground;
    bool hide = ((cob->active & 2) == 0) || (!includeBackgroundSavers && saveBackground);
    if (cob->odtPtr->draw) {
        NSArray<DSTexture *> *textures = _groupIdToTextures[[NSNumber numberWithInt:cob->groupIdx]];
        cob->odtPtr->draw(cob, (__bridge void *)scene, (__bridge void *)camera, (__bridge void *)textures, (__bridge void *)node, hide);
    } else {
        DSTexture *texture = _groupIdToTextures[[NSNumber numberWithInt:cob->groupIdx]][cob->statePtr[0]];
        node.hidden = hide;
        node.size = texture.texture.size;
        node.texture = texture.texture;
        node.position = CGPointMake(cob->globalX + texture.point.x, -((float)cob->globalY + texture.point.y));
    }
}

@end
