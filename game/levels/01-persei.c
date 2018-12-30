#include <coco.h>

extern "C" {

#include "dynosprite.h"

void PerseiInit() {
}


byte PerseiCalculateBkgrndNewXY() {
  return 0;
}


RegisterLevel(PerseiInit, PerseiCalculateBkgrndNewXY);

}
