#include "object_info.h"
#include "06-gameover.h"


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
