#pragma org 0x0
#include "03-moon.h"

#include "FixedPoint.h"
#include "FixedPoint.c"


byte didNotInit = TRUE;
byte initVal = 0;


void Object0Init(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
  if (didNotInit) {
    didNotInit = FALSE;
    FixedPointInitialize();
  }

  FooObject0State *statePtr = (FooObject0State *)(cob->statePtr);
  statePtr->spriteIdx = 4;
  cob->globalX = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX2;
  cob->globalY = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY;
}


void Object0Reactivate(DynospriteCOB *cob, DynospriteODT *odt) {
}


void Object0Update(DynospriteCOB *cob, DynospriteODT *odt) {
  FooObject0State *statePtr = (FooObject0State *)(cob->statePtr);
  statePtr->spriteIdx =  4; //(statePtr->spriteIdx + 1) & 3;
  statePtr->counter++;
  
  FixedPoint val = FixedPointInit(statePtr->counter, 0);
  FixedPoint val2 = FixedPointInit(0, 16080); // 10 * 2 * pi / 256
  FixedPointMul(&val, &val, &val2);
  FixedPointSin(&val2, &val);
  FixedPoint val3 = FixedPointInit(40, 0);
  FixedPointMul(&val3, &val2, &val3);
  cob->globalX = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX2 + 100 + val3.Whole;

  FixedPointCos(&val2, &val);
  FixedPointSet(&val3, 40, 0);
  FixedPointMul(&val3, &val2, &val3);
  cob->globalY = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY + 80 + val3.Whole;
}


/** Ignored, only used to guarantee functions will not get optimized away */
int main() {
  Object0Init((DynospriteCOB *)0x0, (DynospriteODT *)0x0, (byte *)0x0);
  Object0Reactivate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  Object0Update((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  return 0;
}
