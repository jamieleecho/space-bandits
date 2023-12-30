#ifdef __cplusplus
extern "C" {
#endif

#include <coco.h>
#include "dynosprite.h"
#include "../objects/object_info.h"


void SpaceInit() {
    GameGlobals *globals = (GameGlobals *)DynospriteGlobalsPtr;
    globals->gameState = GameStateOver;
    globals->counter = 0;
}


byte SpaceCalculateBkgrndNewXY() {
    // Iterate through all active universal objects
    DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
    DynospriteCOB *lastObj = obj + DynospriteDirectPageGlobalsPtr->Obj_NumCurrent;
    for(; obj<lastObj; obj++) {
        if (obj->active & OBJECT_ACTIVE) {
            continue;
        }
        // Update the screen position of this object based on its location
        UniversalObject *uobj = (UniversalObject *)obj->statePtr;
        if (uobj->magicNumber != UNIVERSAL_OBJECT_MAGIC_NUMBER) {
            continue;
        }
        word depth = uobj->depth - 1;
        obj->globalX = uobj->position[0] + (uobj->position[0] - xoffset) * depth;
        obj->globalY = uobj->position[1] + (uobj->position[1] - yoffset) * depth;
    }

    return 0;
}


RegisterLevel(SpaceInit, SpaceCalculateBkgrndNewXY);

#ifdef __cplusplus
}
#endif
