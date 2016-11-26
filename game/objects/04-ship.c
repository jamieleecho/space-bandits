#pragma org 0x0
#include "04-ship.h"


byte didNotInit = TRUE;
byte initVal = 0;


void Object0Init(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
  if (didNotInit) {
    didNotInit = FALSE;
  }

  ShipObjectState *statePtr = (ShipObjectState *)(cob->statePtr);
  statePtr->spriteIdx = 0;
  //cob->globalX = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX2 + 160;
  //cob->globalY = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY + 170;
}


void Object0Reactivate(DynospriteCOB *cob, DynospriteODT *odt) {
}


void Object0Update(DynospriteCOB *cob, DynospriteODT *odt) {
  ShipObjectState *statePtr = (ShipObjectState *)(cob->statePtr);
  statePtr->spriteIdx = (statePtr->spriteIdx + 1) & 3;
}


/** Ignored, only used to guarantee functions will not get optimized away */
int main() {
  Object0Init((DynospriteCOB *)0x0, (DynospriteODT *)0x0, (byte *)0x0);
  Object0Reactivate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  Object0Update((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  return 0;
}
