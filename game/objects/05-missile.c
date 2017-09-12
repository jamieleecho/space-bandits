#pragma org 0x0
#include "05-missile.h"


byte didNotInit = TRUE;
byte initVal = 0;


void ObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
  if (didNotInit) {
    didNotInit = FALSE;
  }
}


void ObjectReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
}


void ObjectUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
  ShipObjectState *statePtr = (ShipObjectState *)(cob->statePtr);

  if (cob->globalY < 10) {
    cob->globalY = 170;
  } else {
    byte delta = ((DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2)) << 1;
    cob->globalY -= delta;
  }
}


/** Ignored, only used to guarantee functions will not get optimized away */
int main() {
  ObjectInit((DynospriteCOB *)0x0, (DynospriteODT *)0x0, (byte *)0x0);
  ObjectReactivate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  ObjectUpdate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  return 0;
}
