#ifdef __cplusplus
extern "C" {
#endif

#include "object_info.h"
#include "06-gameover.h"


#ifdef __APPLE__
void GameoverClassInit() {
}
#endif


void GameoverInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    GameOverObjectState *statePtr = (GameOverObjectState *)(cob->statePtr);
    statePtr->spriteIdx = 0;
}


byte GameoverReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte GameoverUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


RegisterObject(GameoverClassInit, GameoverInit, 0, GameoverReactivate, GameoverUpdate, sizeof(GameOverObjectState));

#ifdef __cplusplus
}
#endif
