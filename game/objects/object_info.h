#ifndef _object_info_h
#define _object_info_h

#include "coco.h"
#include "dynosprite.h"


#define LEVEL_1 1

#define BADGUY_GROUP_IDX 3
#define SHIP_GROUP_IDX 4
#define MISSILE_GROUP_IDX 5

#define SOUND_LASER 1

#define GAME_OVER_GROUP_IDX 6
#define BAD_MISSILE_GROUP_IDX 7

#define SOUND_LASER 1

#define NUM_BAD_GUYS 55
#define NUM_MISSILES 3
#define NUM_BAD_MISSILES 3


/**
 * Starting from obj, finds an object with the given group index.
 *
 * @param obj starting object
 * @param groupIdx groupIdx to look for
 * @return new obj or NULL
 */
#ifdef __cplusplus
[[maybe_unused]]
#endif
static DynospriteCOB *findObjectByGroup(DynospriteCOB *obj, byte groupIdx) {
  DynospriteCOB *endObj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr + DynospriteDirectPageGlobalsPtr->Obj_NumCurrent;
  for (; obj<endObj; ++obj) {
    if (obj->groupIdx == groupIdx) {
      return obj;
    }
  }
  return 0;
}

#endif
