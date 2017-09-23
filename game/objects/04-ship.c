#pragma org 0x0
#include "04-ship.h"
#include "object_info.h"


byte didNotInit = TRUE;
byte initVal = 0;
DynospriteCOB *missiles[3];


/**
 * @return a missile or NULL if no missile is available.
 */
DynospriteCOB *findFreeMissile() {
  // Return NULL if we fired a missile too recently
  for (byte ii=0; ii<sizeof(missiles)/sizeof(missiles[0]); ii++) {
    DynospriteCOB *missile = missiles[ii];
    if (missile->active && missile->globalY > 113) {
      return 0;
    }
  }

  // Return an available missile
  for (byte ii=0; ii<sizeof(missiles)/sizeof(missiles[0]); ii++) {
    DynospriteCOB *missile = missiles[ii];
    if (!missile->active) {
      return missile;
    }
  }

  return 0;
}


void ObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
  if (didNotInit) {
    didNotInit = FALSE;

    DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
    for (byte ii=0; obj && ii<sizeof(missiles)/sizeof(missiles[0]); ii++) {
      obj = findObjectByGroup(obj, MISSILE_GROUP_IDX);

      if (obj) {
        missiles[ii] = obj;
        obj = obj + 1;
      }
    }
  }

  ShipObjectState *statePtr = (ShipObjectState *)(cob->statePtr);
  statePtr->spriteIdx = 1;
}


void ObjectReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
}


void ObjectUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
  ShipObjectState *statePtr = (ShipObjectState *)(cob->statePtr);
  byte delta = ((DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2)) << 1;

  unsigned int joyx = DynospriteDirectPageGlobalsPtr->Input_JoystickX;
  if (joyx < 16) {
    if (cob->globalX > delta) {
      cob->globalX -= delta;
      statePtr->spriteIdx = 0;
    } else {
      statePtr->spriteIdx = 1;
    }
  } else if (joyx > 48) {
    if (cob->globalX < 300 - delta) {
      cob->globalX += delta;
      statePtr->spriteIdx = 2;
    } else {
      statePtr->spriteIdx = 1;
    }
  } else {
    statePtr->spriteIdx = 1;
  }

  if (!(DynospriteDirectPageGlobalsPtr->Input_Buttons & Joy1Button1)) {
    DynospriteCOB *missile = findFreeMissile();
    if (missile) {
      missile->globalX = cob->globalX + 9;
      missile->globalY = 165;
      missile->active = OBJECT_ACTIVE;
      PlaySound(SOUND_LASER);
    }
  }
}


/** Ignored, only used to guarantee functions will not get optimized away */
int main() {
  ObjectInit((DynospriteCOB *)0x0, (DynospriteODT *)0x0, (byte *)0x0);
  ObjectReactivate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  ObjectUpdate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  return 0;
}
