#pragma org 0x0
#include "03-badguys.h"


#define BAD_PTR ((DynospriteCOB *)0xffff)
#define SCREEN_LOCATION_MIN 10
#define SCREEN_LOCATION_MAX 310

/** The invader direction code is a bit confusing. We have to keep all of the
 *  invaders in sync, going in the same direction, but switching depends on
 *  the location of the left most or right most invader. This gets a little
 *  confusing because the invaders are updated object by object without any
 *  global context. So, if invader 3 is the leading invader and wants to
 *  start moving in the opposite direction, invader 1 won't get the message
 *  until the next iteration, but invaders 3 and up will want to go in the
 *  other direction.
 *
 *  We solve the problem by creating a 2-bit state machine and relying on the
 *  fact that the invaders are updated sequentially. When an invader hits the
 *  extreme left or right of the screen, it sets the LSB of the state machine
 *  and sets switchDirCob to its value. This tells the other invaders in the
 *  sequence to not worry about changing direction. When the next iteration
 *  occurs, the first invader to get updated (its pointer will be <=
 *  switchDirCob) will see that the bit is set and know it has to update the
 *  location.
 */
enum DirectionMode {
  DirectionModeRight,
  DirectionModeChangeOnNextIterMask,
  DirectionModeLeft,
  DirectionModeMask
} DirectionMode;

byte didNotInit = TRUE;
byte initVal = 0;
enum DirectionMode directionMode;
DynospriteCOB *switchDirCob=BAD_PTR;


void ObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
  if (didNotInit) {
    didNotInit = FALSE;
  }

  BadGuyObjectState *statePtr = (BadGuyObjectState *)(cob->statePtr);
  statePtr->xx = cob->globalX;
  statePtr->yy = cob->globalY;
  byte spriteMin = *initData;
  switchDirCob = BAD_PTR;
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


void ObjectReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
  if ((cob <= switchDirCob) && (directionMode & DirectionModeChangeOnNextIterMask)) {
    directionMode = (directionMode + 1) & DirectionModeMask;
    switchDirCob = BAD_PTR;
  }
}


void ObjectUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
  BadGuyObjectState *statePtr = (BadGuyObjectState *)(cob->statePtr);
  byte spriteIdx = statePtr->spriteIdx;
  if (spriteIdx < statePtr->spriteMax) {
    statePtr->spriteIdx = spriteIdx + 1;
  } else {
    statePtr->spriteIdx = statePtr->spriteMin;
  }

  /* if this is the first invader and the change directon bit is set, then
   * change direction */
  if ((cob <= switchDirCob) && (directionMode & DirectionModeChangeOnNextIterMask)) {
    /* toggle direction and clear DirectionModeChangeOnNextIterMask */
    directionMode = (directionMode + 1) & DirectionModeMask;
    switchDirCob = BAD_PTR; /* switchDirCob is now undefined */
  }
  if (directionMode & DirectionModeLeft) {
    cob->globalX--;
    if (cob->globalX <= SCREEN_LOCATION_MIN) {
      /* hit extreme left, so set DirectionModeChangeOnNextIterMask */
      directionMode = directionMode | DirectionModeChangeOnNextIterMask;
      if (switchDirCob == BAD_PTR) {
        switchDirCob = cob;
      }
      cob->active = FALSE;
    }
  } else {
    cob->globalX++;
    if (cob->globalX >= SCREEN_LOCATION_MAX) {
      /* hit extreme right, so set DirectionModeChangeOnNextIterMask */
      directionMode = directionMode | DirectionModeChangeOnNextIterMask;
      if (switchDirCob == BAD_PTR) {
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
  ObjectInit((DynospriteCOB *)0x0, (DynospriteODT *)0x0, (byte *)0x0);
  ObjectReactivate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  ObjectUpdate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  return 0;
}
