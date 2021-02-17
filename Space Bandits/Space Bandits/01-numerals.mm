//
//  01-numerals.mm
//  Space Bandits
//
//  Created by Jamie Cho on 2/16/21.
//  Copyright © 2021 Jamie Cho. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DSTexture.h"

#ifdef __cplusplus
extern "C" {
#endif

    
#include "dynosprite.h"
#include "01-numerals.h"


static byte didInit = FALSE;


#ifdef __APPLE__
void NumeralsClassInit() {
}
#endif


void NumeralsInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (!didInit) {
        didInit = TRUE;
    }
}


byte NumeralsReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte NumeralsUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}

    
void NumeralsDraw(DynospriteCOB *cob, void *scene, void *camera, void *textures, void *node) {
    SKSpriteNode *sprite = (__bridge SKSpriteNode *)node;
    NSArray<DSTexture *> *textureArray = (__bridge NSArray<DSTexture *> *)textures;
    sprite.anchorPoint = CGPointMake(0, 1);
    sprite.position = CGPointMake(cob->globalX * 2, cob->globalY);
    if (sprite.children.count == 0) {
        for(size_t ii=0; ii<6; ii++) {
            SKSpriteNode *digitNode = [[SKSpriteNode alloc] initWithTexture:textureArray[0].texture];
            digitNode.size = CGSizeMake(8, 8);
            digitNode.anchorPoint = CGPointMake(0, 1);
            digitNode.position = CGPointMake(ii * 8, 0);
            [sprite addChild:digitNode];
            digitNode.texture = textureArray[ii].texture;
        }
    }
}

    
RegisterObject(NumeralsClassInit, NumeralsInit, 3, NumeralsReactivate, NumeralsUpdate, NumeralsDraw, sizeof(NumeralsObjectState));

#ifdef __cplusplus
}
#endif
