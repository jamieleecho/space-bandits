#ifdef __cplusplus
extern "C" {
#endif

#include <coco.h>
#include "dynosprite.h"
#include "../objects/object_info.h"

    
void PerseiInit() {
    GameGlobals *globals = (GameGlobals *)DynospriteGlobalsPtr;
    globals->numShips = 3;
    globals->initialized = TRUE;
    globals->score[0] = globals->score[1] = globals->score[2] = 0;
    globals->gameState = GameStatePlaying;
    globals->counter = 0;
    globals->gameWave = GameWavePerseiBoss;
}


byte PerseiCalculateBkgrndNewXY() {
    return 0;
}


RegisterLevel(PerseiInit, PerseiCalculateBkgrndNewXY);

#ifdef __cplusplus
}
#endif
