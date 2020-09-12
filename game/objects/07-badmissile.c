#ifdef __cplusplus
extern "C" {
#endif

#include "07-badmissile.h"
#include "03-badguy.h"
#include "object_info.h"


#define BAD_MISSILE_HALF_WIDTH 2
#define BAD_MISSILE_HEIGHT 10
#define GOODGUY_HALF_WIDTH 7
#define GOODGUY_HALF_HEIGHT 7


static byte didNotInit = TRUE;


void BadmissileInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
  if (didNotInit) {
    didNotInit = FALSE;
  }
  BadMissileObjectState *statePtr = (BadMissileObjectState *)(cob->statePtr);
  statePtr->spriteIdx = 0;
}


byte BadmissileReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
  return 0;
}


byte BadmissileUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
  if (cob->globalY > 170) {
    cob->active = 0;
  } else {
    byte delta = ((DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2)) << 1;
    cob->globalY += delta;
  }
  return 0;
}


RegisterObject(BadmissileInit, BadmissileReactivate, BadmissileUpdate, sizeof(BadMissleObjectState));

#ifdef __cplusplus
}
#endif
