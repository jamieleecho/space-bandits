#ifdef __cplusplus
extern "C" {
#endif

#include <coco.h>
#include "dynosprite.h"
#include "../objects/object_info.h"
#include "../objects/universal_object.h"


byte SpaceCalculateBkgrndNewXY(void);


void SpaceInit() {
    GameGlobals *globals = (GameGlobals *)DynospriteGlobalsPtr;
    globals->gameState = GameStateOver;
    globals->counter = 0;
    globals->numShips = 3;
    
    SpaceCalculateBkgrndNewXY();
}


byte SpaceCalculateBkgrndNewXY() {
    sword minX = 2 * DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX;
    sword maxX = minX + 320;
    sword minY = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY;
    sword maxY = minY + 200;

    // Iterate through all active universal objects
    DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
    DynospriteCOB *lastObj = obj + DynospriteDirectPageGlobalsPtr->Obj_NumCurrent;
    sword xoffset = 2 * (DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX + 79);
    sword yoffset = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY + 99;
    
    for(; obj<lastObj; obj++) {
        if ((obj->active & OBJECT_ACTIVE) == 0) {
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
        
        sword globalXMin = obj->globalX + uobj->boundingBox[0];
        sword globalYMin = obj->globalY + uobj->boundingBox[1];
        sword globalXMax = obj->globalX + uobj->boundingBox[2];
        sword globalYMax = obj->globalY + uobj->boundingBox[3];
        if ((globalXMin < minX) || (globalYMin < minY) ||
            (globalXMax >= maxX) || (globalYMax > maxY)) {
            obj->active = obj->active & ~OBJECT_DRAW_ACTIVE;
        } else {
            obj->active = obj->active | OBJECT_DRAW_ACTIVE;
        }
    }

    return 0;
}


RegisterLevel(SpaceInit, SpaceCalculateBkgrndNewXY);

#ifdef __cplusplus
}
#endif
