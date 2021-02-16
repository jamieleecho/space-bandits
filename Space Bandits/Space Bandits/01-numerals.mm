//
//  01-numerals.mm
//  Space Bandits
//
//  Created by Jamie Cho on 2/16/21.
//  Copyright © 2021 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

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

    
void NumeralsDraw(struct DynospriteCOB *, void *scene, void *camera, void *textures, void *node) {
}

    
RegisterObject(NumeralsClassInit, NumeralsInit, 3, NumeralsReactivate, NumeralsUpdate, NumeralsDraw, sizeof(NumeralsObjectState));

#ifdef __cplusplus
}
#endif
