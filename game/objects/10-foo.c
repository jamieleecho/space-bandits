#include "10-foo.h"


#ifdef __cplusplus
extern "C" {
#endif

#include "object_info.h"
#include "10-foo.h"


#ifdef __APPLE__
void FooClassInit() {
}
#endif


void FooInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    FooObjectState *state = (FooObjectState *)cob->statePtr;
    state->spriteIdx = 1;
}


byte FooReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte FooUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    unsigned int joyx = DynospriteDirectPageGlobalsPtr->Input_JoystickX;
    unsigned int joyy = DynospriteDirectPageGlobalsPtr->Input_JoystickY;
    int delta = 2;
    if (joyx < 16) {
        if (cob->globalX < 160) {
            if (DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX > 0) {
                DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX--;
            }
        }
        if (cob->globalX >= delta) {
            cob->globalX -= delta;
        }
    } else if (joyx > 48) {
        cob->globalX += delta;
        if (cob->globalX > 160) {
            if (DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX < 16) {
                DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX++;
            }
        }
        if (cob->globalX > 342) {
            cob->globalX = 342;
        }
    }

    if (joyy < 16) {
        if (cob->globalY < 100) {
            if (DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY > 0) {
                DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY--;
            }
        }
        if (cob->globalY <= 10) {
            cob->globalY = 10;
        } else {
            cob->globalY -= delta;
        }
    } else if (joyy > 48) {
        cob->globalY += delta;
        if (cob->globalY > 100) {
            if (DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY < 24) {
                DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY++;
            }
        }
        if (cob->globalY > 214) {
            cob->globalY = 214;
        }
    }

    
    return 0;
}


RegisterObject(FooClassInit, FooInit, 0, FooReactivate, FooUpdate, NULL, sizeof(FooObjectState));

#ifdef __cplusplus
}
#endif
