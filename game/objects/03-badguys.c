#pragma org 0x0
#include "03-badguys.h"


/** Defines how invaders should move */
enum DirectionMode {
  DirectionGoRight,
  DirectionShouldSwitchLeft,
  DirectionGoLeft,
  DirectionShouldSwitchRight,
};

byte didNotInit = TRUE;
byte initVal = 0;
enum DirectionMode directionMode;
DynospriteCOB *switchDirCob=0xffff;


void Object0Init(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
  if (didNotInit) {
    didNotInit = FALSE;
  }

  BadGuyObjectState *statePtr = (BadGuyObjectState *)(cob->statePtr);
  statePtr->xx = cob->globalX;
  statePtr->yy = cob->globalY;
  byte spriteMin = *initData;
  switchDirCob = 0xffff;
  if (spriteMin == 0) {
    statePtr->spriteIdx = statePtr->spriteMin = spriteMin;
    statePtr->spriteMax = statePtr->spriteMin + 3 - 1;
  } else if ((spriteMin == 3) || (spriteMin == 7)) {
    statePtr->spriteIdx = statePtr->spriteMin = spriteMin;
    statePtr->spriteMax = statePtr->spriteMin + 4 - 1;
  } else if ((spriteMin == 11) || (spriteMin == 13)) {
    statePtr->spriteIdx = statePtr->spriteMin = spriteMin;
    statePtr->spriteMax = statePtr->spriteMin + 2 - 1;
  } else {
    statePtr->spriteIdx = statePtr->spriteMin = 1;
    statePtr->spriteMax = statePtr->spriteMin + 3 - 1;
  }
}


void Object0Reactivate(DynospriteCOB *cob, DynospriteODT *odt) {
  if ((cob <= switchDirCob) && (directionMode & 0x1)) {
    directionMode = (directionMode + 1) & 0x3;
    switchDirCob = 0xffff;
  }
}


void Object0Update(DynospriteCOB *cob, DynospriteODT *odt) {
  BadGuyObjectState *statePtr = (BadGuyObjectState *)(cob->statePtr);
  byte spriteIdx = statePtr->spriteIdx;
  if (spriteIdx < statePtr->spriteMax) {
    statePtr->spriteIdx = spriteIdx + 1;
  } else {
    statePtr->spriteIdx = statePtr->spriteMin;
  }

  if ((cob <= switchDirCob) && (directionMode & 0x1)) {
    directionMode = (directionMode + 1) & 0x3;
    switchDirCob = 0xffff;
  }
  if (directionMode & 0x2) {
    cob->globalX--;
    if (cob->globalX <= 10) {
      directionMode = directionMode | 0x1;
      if (switchDirCob == 0xffff) {
        switchDirCob = cob;
      }
      cob->active = FALSE;
    }
  } else {
    cob->globalX++;
    if (cob->globalX >= 310) {
      directionMode = directionMode | 0x1;
      if (switchDirCob == 0xffff) {
        switchDirCob = cob;
      }
    }
  }

  
#if 0
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
#endif
}


/** Ignored, only used to guarantee functions will not get optimized away */
int main() {
  Object0Init((DynospriteCOB *)0x0, (DynospriteODT *)0x0, (byte *)0x0);
  Object0Reactivate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  Object0Update((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  return 0;
}
