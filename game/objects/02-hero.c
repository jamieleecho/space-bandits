#include "02-hero.h"


byte didInit = FALSE;


void ObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
  if (!didInit) {
    didInit = TRUE;
  }
  Hero *hero = (Hero *)(cob->statePtr);
  hero->spriteIdx = 0;
}


byte ObjectReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
  return 0;
}


byte ObjectUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
  Hero *hero = (Hero *)(cob->statePtr);
  return 0;
}


/** Ignored, only used to guarantee functions will not get optimized away */
int main() {
  ObjectInit((DynospriteCOB *)0x0, (DynospriteODT *)0x0, (byte *)0x0);
  ObjectReactivate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  ObjectUpdate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  return 0;
}
