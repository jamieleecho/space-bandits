#ifdef __cplusplus
extern "C" {
#endif

#include <coco.h>
#include "dynosprite.h"
#include "../objects/object_info.h"

    
void PerseiInit() {
    GameGlobals *globals = (GameGlobals *)DynospriteGlobalsPtr;
    memset(globals, 0, sizeof(*globals));
    globals->numShips = 3;
    globals->initialized = TRUE;
    globals->gameState = GameStatePlaying;
    globals->counter = 0;
}


byte PerseiCalculateBkgrndNewXY() {
    return 0;
}


RegisterLevel(PerseiInit, PerseiCalculateBkgrndNewXY);

#ifdef __cplusplus
}
#endif
