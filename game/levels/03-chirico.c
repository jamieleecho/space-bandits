#ifdef __cplusplus
extern "C" {
#endif

#include <coco.h>
#include "dynosprite.h"
#include "../objects/object_info.h"


void ChiricoInit() {
    GameGlobals *globals = (GameGlobals *)DynospriteGlobalsPtr;
    globals->numShips = 1;
    globals->initialized = TRUE;
    globals->score[0] = globals->score[1] = globals->score[2] = 0;
    globals->gameState = GameStatePlaying;
    globals->counter = 0;
    globals->gameWave = 0;
}


byte ChiricoCalculateBkgrndNewXY() {
    return 0;
}


RegisterLevel(ChiricoInit, ChiricoCalculateBkgrndNewXY);

#ifdef __cplusplus
}
#endif
