#include <coco.h>
#include "../objects/02-hero.h"


static Hero *hero;
static DynospriteCOB *cob;


#define GLOBAL_X_MIN 20
#define GLOBAL_X_SCROLL_MIN 160
#define GLOBAL_X_MAX 700
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
  hero = (Hero *)cob->statePtr;
}


byte LevelCalculateBkgrndNewXY() {
  unsigned int joyx = DynospriteDirectPageGlobalsPtr->Input_JoystickX;
  const unsigned int delta = 1;
  if (joyx < 16) { // want to move left
    if (cob->globalX > GLOBAL_X_MIN) { // can move left
      cob->globalX -= delta;
      if (hero->horizontalDirection != HorizontalDirectionLeft) { // was not moving left
        hero->horizontalDirection = HorizontalDirectionLeft;
        hero->motionFactor = -1;
        hero->spriteIdx = 1;
      } else {
        if (--hero->counter == 0) {
          hero->counter = HERO_COUNTER_MAX;
          hero->spriteIdx += hero->motionFactor;
          if (hero->motionFactor > 0 && hero->spriteIdx > 1) {
            hero->motionFactor = -1;
            hero->spriteIdx -= 2;
          } else if (hero->motionFactor < 0 && hero->spriteIdx >= 255) {
            hero->motionFactor = 1;
            hero->spriteIdx += 2;
          }
        }
      }
    }
  } else if (joyx > 48) {
    if (cob->globalX < GLOBAL_X_MAX) { // can move right
      cob->globalX += delta;
      if (hero->horizontalDirection != HorizontalDirectionRight) { // was not moving right
        hero->horizontalDirection = HorizontalDirectionRight;
        hero->motionFactor = 1;
        hero->spriteIdx = 4;
      } else {
        if (--hero->counter == 0) {
          hero->counter = HERO_COUNTER_MAX;
          hero->spriteIdx += hero->motionFactor;
          if (hero->motionFactor < 0 && hero->spriteIdx >= 3) {
            hero->motionFactor = 1;
            hero->spriteIdx += 2;
          } else if (hero->motionFactor > 0 && hero->spriteIdx >= 6) {
            hero->motionFactor = -1;
            hero->spriteIdx -= 2;
          }
        }
      }
    }
  }

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
