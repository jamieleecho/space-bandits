#ifndef _object_info_h
#define _object_info_h

#include <coco.h>
#include "dynosprite.h"


#define BADGUY_GROUP_IDX 3
#define SHIP_GROUP_IDX 4
#define MISSILE_GROUP_IDX 5


/**
 * Starting from obj, finds an object with the given group index.
 *
 * @param obj starting object
 * @param groupIdx groupIdx to look for
 * @return new obj or NULL
 */
DynospriteCOB *findObjectByGroup(DynospriteCOB *obj, byte groupIdx) {
  DynospriteCOB *endObj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr + DynospriteDirectPageGlobalsPtr->Obj_NumCurrent;
  for (; obj<endObj; obj++) {
    if (obj->groupIdx == groupIdx) {
      return obj;
    }
  }
  return 0;
}

#endif
