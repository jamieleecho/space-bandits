//
//  01-numerals.mm
//  Space Bandits
//
//  Created by Jamie Cho on 2/16/21.
//  Copyright © 2021 Jamie Cho. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DSTexture.h"
#import "object_info.h"

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
    sprite.position = CGPointMake(((float)cob->globalX + (float)DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX) * 2, (float)cob->globalY - (float)DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY);
    byte *score = (byte *)&((GameGlobals *)DynospriteGlobalsPtr)->score[0];
    for(size_t ii=0; ii<6; ii++) {
        if (sprite.children.count <= ii) {
            SKSpriteNode *digitNode = [[SKSpriteNode alloc] initWithTexture:textureArray[0].texture];
            digitNode.size = CGSizeMake(9.0, 11);
            digitNode.anchorPoint = CGPointMake(0, 1);
            digitNode.position = CGPointMake(4 + ii * 9.75, 0);
            [sprite addChild:digitNode];
        }
        SKSpriteNode *digitNode = (SKSpriteNode *)sprite.children[ii];
        byte msb = (ii + 1) & 1;
        byte digit = (msb ? score[ii / 2] >> 4 : score[ii / 2]) & 0xf;
        digitNode.texture = textureArray[digit].texture;
    }
}

    
RegisterObject(NumeralsClassInit, NumeralsInit, 0, NumeralsReactivate, NumeralsUpdate, NumeralsDraw, sizeof(NumeralsObjectState));

#ifdef __cplusplus
}
#endif
