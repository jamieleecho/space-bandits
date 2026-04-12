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
    globals->numShips = 3;
}


static word scrollY = 888;
static byte scrollCounter = 0;

byte SpaceCalculateBkgrndNewXY() {
    /* Auto-scroll upward: 10 pixels/sec = 1 pixel every 6 frames at 60Hz */
    if (++scrollCounter >= 6) {
        scrollCounter = 0;
        if (scrollY > 0)
            scrollY--;
    }

    DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = 8;
    DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY = scrollY;
    return 0;
}


RegisterLevel(SpaceInit, SpaceCalculateBkgrndNewXY);

#ifdef __cplusplus
}
#endif
