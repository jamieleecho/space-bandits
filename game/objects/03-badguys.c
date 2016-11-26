#pragma org 0x0
#include "03-badguys.h"

#include "FixedPoint.h"
#include "FixedPoint.c"


byte didNotInit = TRUE;
byte initVal = 0;


void Object0Init(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
  if (didNotInit) {
    didNotInit = FALSE;
    FixedPointInitialize();
  }

  BadGuyObjectState *statePtr = (BadGuyObjectState *)(cob->statePtr);
  statePtr->spriteIdx = 0;
  statePtr->counter = 0;
  statePtr->xx = cob->globalX;
  statePtr->yy = cob->globalY;
  //cob->globalX = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX2;
  //cob->globalY = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY;
}


void Object0Reactivate(DynospriteCOB *cob, DynospriteODT *odt) {
}


void Object0Update(DynospriteCOB *cob, DynospriteODT *odt) {
  BadGuyObjectState *statePtr = (BadGuyObjectState *)(cob->statePtr);
  statePtr->spriteIdx =  (statePtr->spriteIdx + 1) % 3;
  statePtr->counter++;
  
  FixedPoint val = FixedPointInit(statePtr->counter, 0);
  FixedPoint val2 = FixedPointInit(0, 1608); // 1 * 2 * pi / 256
  FixedPointMul(&val, &val, &val2);
  FixedPointSin(&val2, &val);
  FixedPoint val3 = FixedPointInit(40, 0);
  FixedPointMul(&val3, &val2, &val3);
  cob->globalX = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX2 + statePtr->xx + val3.Whole;

  FixedPointCos(&val2, &val);
  FixedPointSet(&val3, 40, 0);
  FixedPointMul(&val3, &val2, &val3);
  cob->globalY = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY + statePtr->yy + val3.Whole;
}


/** Ignored, only used to guarantee functions will not get optimized away */
int main() {
  Object0Init((DynospriteCOB *)0x0, (DynospriteODT *)0x0, (byte *)0x0);
  Object0Reactivate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  Object0Update((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  return 0;
}
