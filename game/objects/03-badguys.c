#include "03-badguys.h"
#include "05-missile.h"
#include "07-bad-missile.h"
#include "object_info.h"


#define BAD_PTR ((DynospriteCOB *)0xffff)
#define SCREEN_LOCATION_MIN 14
#define SCREEN_LOCATION_MAX 306
#define DELTA_Y 4
#define MAX_Y 155
#define TOP_SPEED 3


/* The invader direction code is a bit confusing. We have to keep all of the
 * invaders in sync, going in the same direction, but switching depends on
 * the location of the left most or right most invader. This gets a little
 * confusing because the invaders are updated object by object without any
 * global context. So, if invader 3 is the leading invader and wants to
 * start moving in the opposite direction, invader 1 won't get the message
 * until the next iteration, but invaders 3 and up will want to go in the
 * other direction.
 *
 * We solve the problem by creating a 2-bit state machine and relying on the
 * fact that the invaders are updated sequentially. When an invader hits the
 * extreme left or right of the screen, it sets the LSB of the state machine
 * and sets switchDirCob to its value. This tells the other invaders in the
 * sequence to not worry about changing direction. When the next iteration
 * occurs, the first invader to get updated (its pointer will be <=
 * lastCob) will see that the bit is set and know it has to update the
 * location.
 */
enum DirectionMode {
  DirectionModeRight,
  DirectionModeChangeOnNextIterMask,
  DirectionModeLeft,
  DirectionModeMask
} DirectionMode;


byte didInit = FALSE;
enum DirectionMode directionMode;
DynospriteCOB *lastCob = (DynospriteCOB *)NULL;
byte numInvaders = 0;
byte deltaY = 0;


DynospriteCOB *badMissiles[NUM_BAD_MISSILES];
DynospriteCOB **endBadMissiles;
byte currentMissileFireColumnIndex = 0;


// From the original space invaders
byte missileFireColumns[] = {
  0x01, 0x07, 0x01, 0x01, 0x01, 0x04, 0x0B, 0x01, 0x06, 0x03, 0x01, 0x01,
  0x0B, 0x09, 0x02, 0x08, 0x02,0x0B,0x04,0x07,0x0A
};


void ObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
  if (!didInit) {
    didInit = TRUE;
    numInvaders = 0;
    deltaY = 0;

    endBadMissiles = &(badMissiles[sizeof(badMissiles)/sizeof(badMissiles[0])]);
    DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
    for (byte ii=0; obj && ii<sizeof(badMissiles)/sizeof(badMissiles[0]); ii++) {
      obj = findObjectByGroup(obj, BAD_MISSILE_GROUP_IDX);
      badMissiles[ii] = obj;
      obj = obj + 1;
    }
  }

  /* We want to animate the different invaders and they all have different
   * number of frames. This is a little hack where we pass the minimum
   * spriteIndex as part of the initialization data and because we know the
   * number of frames, we can set the max here. */
  BadGuyObjectState *statePtr = (BadGuyObjectState *)(cob->statePtr);
  byte spriteMin = *initData;
  if (spriteMin == BADGUY_SPRITE_ENEMY_SWATH_INDEX) {
    statePtr->spriteIdx = statePtr->spriteMin = spriteMin;
    statePtr->spriteMax = BADGUY_SPRITE_BLADE_INDEX - 1;
  } else if ((spriteMin == BADGUY_SPRITE_BLADE_INDEX) ||
             (spriteMin == BADGUY_SPRITE_DUDE_INDEX)) {
    statePtr->spriteIdx = statePtr->spriteMin = spriteMin;
    statePtr->spriteMax = statePtr->spriteMin + 4 - 1;
  } else if ((spriteMin == BADGUY_SPRITE_TINY_INDEX) ||
             (spriteMin == BADGUY_SPRITE_TIVO_INDEX)) {
    statePtr->spriteIdx = statePtr->spriteMin = spriteMin;
    statePtr->spriteMax = statePtr->spriteMin + 2 - 1;
  } else {
    statePtr->spriteIdx = statePtr->spriteMin = 0;
    statePtr->spriteMax = BADGUY_SPRITE_BLADE_INDEX - 1;
  }
  statePtr->originalSpriteIdx = statePtr->spriteIdx;
  statePtr->originalGlobalX = cob->globalX;
  statePtr->originalGlobalY = cob->globalY;

  numInvaders++;
}


void reset() {
  DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
  for (obj = findObjectByGroup(obj, BADGUY_GROUP_IDX); obj; obj = findObjectByGroup(obj, BADGUY_GROUP_IDX)) {
    BadGuyObjectState *statePtr = (BadGuyObjectState *)(obj->statePtr);
    obj->active = OBJECT_ACTIVE;
    statePtr->spriteIdx = statePtr->originalSpriteIdx;
    obj->globalX = statePtr->originalGlobalX;
    obj->globalY = statePtr->originalGlobalY;
    ++numInvaders;
    obj = obj + 1;
  }

  obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
  for (obj = findObjectByGroup(obj, MISSILE_GROUP_IDX); obj; obj = findObjectByGroup(obj, MISSILE_GROUP_IDX)) {
    MissileObjectState *statePtr = (MissileObjectState *)(obj->statePtr);
    obj->active = OBJECT_INACTIVE;
    obj = obj + 1;
  }
}


byte ObjectReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
  if (!numInvaders) {
    reset();
  }
  return 0;
}


byte ObjectUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
  BadGuyObjectState *statePtr = (BadGuyObjectState *)(cob->statePtr);
  // cob->active = (cob->active == OBJECT_UPDATE_ACTIVE) ? OBJECT_ACTIVE : OBJECT_UPDATE_ACTIVE;

  /* Switch to the next animation frame */
  byte spriteIdx = statePtr->spriteIdx;
  if (spriteIdx < statePtr->spriteMax) {
    statePtr->spriteIdx = spriteIdx + 1;
  } else if (spriteIdx == statePtr->spriteMax) {
    statePtr->spriteIdx = statePtr->spriteMin;
  } else if (spriteIdx >= BADGUY_SPRITE_LAST_INDEX) {
    cob->active = OBJECT_INACTIVE;
    --numInvaders;
    return 0;
  } else {
    statePtr->spriteIdx = spriteIdx + 1;
    return 0;
  }

  // If we are at the first bad guy...
  if (lastCob >= cob) {
    if (directionMode & DirectionModeChangeOnNextIterMask) {
      /* toggle direction and clear DirectionModeChangeOnNextIterMask */
      directionMode = (directionMode + 1) & DirectionModeMask;
      deltaY = DELTA_Y;
    } else {
      deltaY = 0;
    }
  }
  lastCob = cob;

  // Move down if needed
  cob->globalY += deltaY;
  if (cob->globalY > MAX_Y) {
    cob->globalY = MAX_Y;
    return LEVEL_1;
  }

  byte delta = (TOP_SPEED - (numInvaders >> 3)) * (DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2);
  delta = (delta > 128) ? 1 : ((delta < 1) ? 1 : delta);
  if (directionMode & DirectionModeLeft) {
    cob->globalX -= delta;
    if (cob->globalX <= SCREEN_LOCATION_MIN) {
      /* hit extreme left, so set DirectionModeChangeOnNextIterMask */
      directionMode = directionMode | DirectionModeChangeOnNextIterMask;
    }
  } else {
    cob->globalX += delta;
    if (cob->globalX >= SCREEN_LOCATION_MAX) {
      /* hit extreme right, so set DirectionModeChangeOnNextIterMask */
      directionMode = directionMode | DirectionModeChangeOnNextIterMask;
    }
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
