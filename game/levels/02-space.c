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
        
        
    }
    
    
    return 0;
}


RegisterLevel(SpaceInit, SpaceCalculateBkgrndNewXY);

#ifdef __cplusplus
}
#endif
