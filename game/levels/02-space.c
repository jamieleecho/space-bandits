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
    return 0;
}


RegisterLevel(SpaceInit, SpaceCalculateBkgrndNewXY);

#ifdef __cplusplus
}
#endif
