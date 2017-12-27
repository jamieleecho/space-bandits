#include "07-bad-missile.h"
#include "03-badguys.h"
#include "object_info.h"


#define BAD_MISSILE_HALF_WIDTH 2
#define BAD_MISSILE_HEIGHT 10
#define GOODGUY_HALF_WIDTH 7
#define GOODGUY_HALF_HEIGHT 7


byte didNotInit = TRUE;


void ObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
  if (didNotInit) {
    didNotInit = FALSE;
  }
  BadMissileObjectState *statePtr = (BadMissileObjectState *)(cob->statePtr);
  statePtr->spriteIdx = 0;
}


byte ObjectReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
  return 0;
}


byte ObjectUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
  BadMissileObjectState *statePtr = (BadMissileObjectState *)(cob->statePtr);

  if (cob->globalY > 170) {
    cob->active = 0;
  } else {
    byte delta = ((DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2)) << 1;
    cob->globalY += delta;
  }
  return 0;
}


/** Ignored, only used to guarantee functions will not get optimized away */
int main() {
  ObjectInit((DynospriteCOB *)0x0, (DynospriteODT *)0x0, (byte *)0x0);
  ObjectReactivate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  ObjectUpdate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  return 0;
}
