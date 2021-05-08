#ifdef __cplusplus
extern "C" {
#endif

#include "object_info.h"
#include "06-gameover.h"


#ifdef __APPLE__
void GameoverClassInit() {
}
#endif


// Whether or not p was pressed
byte pPressed;

// Whether or not button was pressed
byte buttonPressed;


void GameoverInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    GameOverObjectState *statePtr = (GameOverObjectState *)(cob->statePtr);
    statePtr->spriteIdx = 0;
    statePtr->initX = cob->globalX - (DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX / 2);
    statePtr->initY = cob->globalY - DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY;
    pPressed = FALSE;
}


byte GameoverReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    byte *matrix = DynospriteDirectPageGlobalsPtr->Input_KeyMatrix;
    GameGlobals *globals = (GameGlobals *)DynospriteGlobalsPtr;
    GameOverObjectState *statePtr = (GameOverObjectState *)(cob->statePtr);
    
    // Make sure the p button is unpressed
    if (globals->gameState == GameStatePaused) {
        if (matrix[0] & 0x04) {
            globals->gameState = GameStatePlaying;
        }
        return 0;
    }
    
    if (globals->gameState == GameStateOver) {
        cob->active = OBJECT_ACTIVE;
        statePtr->spriteIdx =  (byte)(globals->gameState - 1);
        buttonPressed = TRUE;
        return 0;
    }

    if ((matrix[0] & 0x04) == 0x00) {
        globals->gameState = GameStatePaused;
        cob->active = OBJECT_ACTIVE;
        statePtr->spriteIdx =  (byte)(globals->gameState - 1);
        pPressed = TRUE;
    } else if ((matrix[2] & 0x40) == 0x00) {
        globals->gameState = GameStateQuit;
        cob->active = OBJECT_ACTIVE;
        statePtr->spriteIdx =  (byte)(globals->gameState - 1);
    }
    cob->globalX = statePtr->initX + (2 * DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX);
    cob->globalY = statePtr->initY + DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY;
    
    return 0;
}


byte GameoverUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    byte *matrix = DynospriteDirectPageGlobalsPtr->Input_KeyMatrix;
    GameGlobals *globals = (GameGlobals *)DynospriteGlobalsPtr;
    GameOverObjectState *statePtr = (GameOverObjectState *)(cob->statePtr);

    cob->globalX = statePtr->initX + (2 * DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX);
    cob->globalY = statePtr->initY + DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY;
    
    
    // Handle the paused state
    if (globals->gameState == GameStatePaused) {
        // Make sure p is unpressed
        byte keyIsPressed = (matrix[0] & 0x04) == 0x00;
        if (!keyIsPressed) {
            pPressed = FALSE;
        }
        if (pPressed) {
            return 0;
        }
        
        // If P was pressed then start playing
        if (keyIsPressed) {
            cob->active = OBJECT_INACTIVE;
        }
    } else if (globals->gameState == GameStateQuit) {
        byte yKeyIsPressed = (matrix[1] & 0x08) == 0x00;
        byte nKeyIsPressed = (matrix[6] & 0x02) == 0x00;

        if (nKeyIsPressed) {
            globals->gameState = GameStatePlaying;
            cob->active = OBJECT_INACTIVE;
        } else if (yKeyIsPressed) {
            return -1;
        }
    } else if (globals->gameState == GameStateOver) {
        if (DynospriteDirectPageGlobalsPtr->Input_Buttons & Joy1Button1) {
            buttonPressed = FALSE;
        }
        if (buttonPressed) {
            return 0;
        }
        if (!(DynospriteDirectPageGlobalsPtr->Input_Buttons & Joy1Button1)) {
            return -1;
        }
    }

    return 0;
}


RegisterObject(GameoverClassInit, GameoverInit, 0, GameoverReactivate, GameoverUpdate, NULL, sizeof(GameOverObjectState));

#ifdef __cplusplus
}
#endif
