//
//  11-velocity_object.c
//  Space Bandits
//
//  Created by Jamie Cho on 10/16/22.
//  Copyright © 2022 Jamie Cho. All rights reserved.
//

#include "dynosprite.h"
#include "object_info.h"
#include "11-velocity_object.h"
#include "universal_object.c"


static GameGlobals *globals;


#ifdef __APPLE__
void Velocity_objectClassInit() {
    globals = NULL;
}
#endif


void Velocity_objectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (!globals) {
        globals = (GameGlobals *)DynospriteGlobalsPtr;
    }
    
    UniversalObjectVelocityObjectInit(cob, odt, initData);
}


byte Velocity_objectReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte Velocity_objectUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    UniversalObjectVelocityObjectUpdate(cob, odt);
    return 0;
}


RegisterObject(Velocity_objectClassInit, Velocity_objectInit, UNIVERSAL_VELOCITY_OBJECT_INIT_SIZE, Velocity_objectReactivate, Velocity_objectUpdate, NULL, sizeof(Velocity_objectObjectState));
