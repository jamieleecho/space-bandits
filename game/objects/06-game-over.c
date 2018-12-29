#include "object_info.h"
#include "06-game-over.h"


void ObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
  GameOverObjectState *statePtr = (GameOverObjectState *)(cob->statePtr);
  statePtr->spriteIdx = 0;
}


byte ObjectReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
  return 0;
}


byte ObjectUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
  return 0;
}
