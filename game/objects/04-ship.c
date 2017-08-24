#pragma org 0x0
#include "04-ship.h"


byte didNotInit = TRUE;
byte initVal = 0;


void ObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
  if (didNotInit) {
    didNotInit = FALSE;
  }

  ShipObjectState *statePtr = (ShipObjectState *)(cob->statePtr);
  statePtr->spriteIdx = 1;
}


void ObjectReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
}


void ObjectUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
  ShipObjectState *statePtr = (ShipObjectState *)(cob->statePtr);

  unsigned int joyx = DynospriteDirectPageGlobalsPtr->Input_JoystickX;
  if (joyx < 16) {
    if (cob->globalX > 2) {
      cob->globalX -= 4;
      statePtr->spriteIdx = 0;
      if (cob->globalX <= 2) {
        PlaySound(2);
      }
    } else {
      statePtr->spriteIdx = 1;
    }
  } else if (joyx > 48) {
    if (cob->globalX < 299) {
      cob->globalX += 4;
      statePtr->spriteIdx = 2;
      if (cob->globalX >= 299) {
        PlaySound(2);
      }
    } else {
      statePtr->spriteIdx = 1;
    }
  } else {
    statePtr->spriteIdx = 1;
  }
}


/** Ignored, only used to guarantee functions will not get optimized away */
int main() {
  ObjectInit((DynospriteCOB *)0x0, (DynospriteODT *)0x0, (byte *)0x0);
  ObjectReactivate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  ObjectUpdate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  return 0;
}
