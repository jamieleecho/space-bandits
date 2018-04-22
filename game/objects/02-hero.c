#include "02-hero.h"

#define GLOBAL_X_MIN 20
#define GLOBAL_X_MAX 700
#define COUNTER_MAX 20

byte didInit = FALSE;


void ObjectInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
  if (!didInit) {
    didInit = TRUE;
  }
  Hero *hero = (Hero *)(cob->statePtr);
  hero->spriteIdx = 3;
  hero->motionFactor = 1;
  hero->horizontalDirection = HorizontalDirectionRight;
  hero->counter = COUNTER_MAX;
}


byte ObjectReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
  return 0;
}


byte ObjectUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
  Hero *hero = (Hero *)(cob->statePtr);

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
          hero->counter = COUNTER_MAX;
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
          hero->counter = COUNTER_MAX;
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

  return 0;
}


/** Ignored, only used to guarantee functions will not get optimized away */
int main() {
  ObjectInit((DynospriteCOB *)0x0, (DynospriteODT *)0x0, (byte *)0x0);
  ObjectReactivate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  ObjectUpdate((DynospriteCOB *)0x0, (DynospriteODT *)0x0);
  return 0;
}
