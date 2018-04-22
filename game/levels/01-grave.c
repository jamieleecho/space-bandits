#include <dynosprite.h>


static DynospriteCOB *cob;


#define GLOBAL_X_SCROLL_MIN 160
#define GLOBAL_X_SCROLL_MAX 560


/**
 * Starting from obj, finds an object with the given group index.
 *
 * @param obj starting object
 * @param groupIdx groupIdx to look for
 * @return new obj or NULL
 */
DynospriteCOB *findObjectByGroup(DynospriteCOB *obj, byte groupIdx) {
  DynospriteCOB *endObj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr + DynospriteDirectPageGlobalsPtr->Obj_NumCurrent;
  for (; obj<endObj; ++obj) {
    if (obj->groupIdx == groupIdx) {
      return obj;
    }
  }
  return 0;
}


void LevelInit() {
  cob = findObjectByGroup(DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr, 2);
}


byte LevelCalculateBkgrndNewXY() {
  if (cob->globalX < GLOBAL_X_SCROLL_MIN) {
    DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = (GLOBAL_X_SCROLL_MIN - 160) / 2;
  } else if (cob->globalX > GLOBAL_X_SCROLL_MAX) {
    DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = (GLOBAL_X_SCROLL_MAX - 160) / 2;
  } else {
    DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = (cob->globalX - 160) / 2;
  }


  return 0;
}


int main() {
  LevelInit();
  LevelCalculateBkgrndNewXY();
  return 0;
}
