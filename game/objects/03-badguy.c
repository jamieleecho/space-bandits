#ifdef __cplusplus
extern "C" {
#endif

#include "03-badguy.h"
#include "04-ship.h"
#include "05-missile.h"
#include "07-badmissile.h"
#include "object_info.h"
#include "dynosprite.h"


#define BAD_PTR ((DynospriteCOB *)0xffff)
#define SCREEN_LOCATION_MIN 14
#define SCREEN_LOCATION_MAX 306
#define NUM_COLUMNS 9
#define NUM_ROWS 5
#define DELTA_Y 2
#define MAX_Y 155
#define TOP_SPEED 4


/* The invader direction code is a bit confusing. We have to keep all of the
 */
typedef enum DirectionMode {
    DirectionModeRight,
    DirectionModeLeft,
} DirectionMode;


// Has the class been initialized
static byte didInit = FALSE;

// Direction that all of the invaders should be moving
static byte /* DirectionMode */ groupDirection;

// Number of invaders that are alive
static byte numInvaders = 0;

// Array containing the bad missile objects
static DynospriteCOB *badMissiles[NUM_BAD_MISSILES];

// Which invader array should be shooting
static byte currentMissileFireColumnIndex = 0;

// Game global variables
static GameGlobals *globals;

// Useful for indexing into bad guys
static DynospriteCOB *firstBadGuy;

// For checking the state of the ship
static ShipObjectState *shipState;

/** Maximum shooting counters */
static const word shootCounterMax[] = {
    (NUM_COLUMNS * NUM_ROWS * 193), (NUM_COLUMNS * NUM_ROWS * 201), (NUM_COLUMNS * NUM_ROWS * 369)
};

/* From the original space invaders */
static const byte missileFireColumns[] = {
    0x01, 0x07, 0x01, 0x01, 0x01, 0x04, 0x0B, 0x01, 0x06, 0x03, 0x01, 0x01,
    0x0B, 0x09, 0x02, 0x08, 0x02, 0x0B, 0x04, 0x07, 0x0A
};


#ifdef __APPLE__
void BadguyClassInit() {
    didInit = FALSE;
}
#endif


/**
 * Finds the lowest ship that should fire based on missileFireColumns and currentMissileFireColumnIndex.
 * Increments and resets to 0 if needed currentMissileFireColumnIndex.
 * @return lowest ship COB or possibly NULL.
 */
static DynospriteCOB *getLowestBadguyToFireMissile() {
    byte column = missileFireColumns[currentMissileFireColumnIndex];
    currentMissileFireColumnIndex = currentMissileFireColumnIndex + 1;
    if (currentMissileFireColumnIndex >= sizeof(missileFireColumns)/sizeof(missileFireColumns[0])) {
        currentMissileFireColumnIndex = 0;
    }

    DynospriteCOB *cob = NULL;
    byte foundCob = FALSE;
    for(byte ii=0; !foundCob && ii<NUM_COLUMNS; ii++) {
        byte xx = column + ii;
        if (xx >= NUM_COLUMNS) {
            xx = xx - NUM_COLUMNS;
        }
        cob = firstBadGuy + (NUM_COLUMNS * (NUM_ROWS - 1)) + xx;

        for(; cob >= firstBadGuy ; cob = cob - NUM_COLUMNS) {
            if ((cob->active) && (cob->globalY < 130)) {
                foundCob = TRUE;
                break;
            }
        }
    }

    return foundCob ? cob : (DynospriteCOB *)NULL;
}


void BadguyInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (!didInit) {
        didInit = TRUE;
        numInvaders = 0;
        globals = (GameGlobals *)&(DynospriteGlobalsPtr->UserGlobals_Init);

        DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
        for (byte ii=0; obj && ii<sizeof(badMissiles)/sizeof(badMissiles[0]); ii++) {
            obj = findObjectByGroup(obj, BAD_MISSILE_GROUP_IDX);
            badMissiles[ii] = obj;
            obj = obj + 1;
        }
        
        firstBadGuy = findObjectByGroup(DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr, BADGUY_GROUP_IDX);
        shipState = (ShipObjectState *)findObjectByGroup(DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr, SHIP_GROUP_IDX)->statePtr;
        groupDirection = DirectionModeRight;
    }
    
    /* We want to animate the different invaders and they all have different
     * number of frames. This is a little hack where we pass the minimum
     * spriteIndex as part of the initialization data and because we know the
     * number of frames, we can set the max here. */
    BadGuyObjectState *statePtr = (BadGuyObjectState *)(cob->statePtr);

    statePtr->originalGlobalX = cob->globalX;
    statePtr->originalGlobalY = cob->globalY;
    statePtr->originalSpriteIdx = initData[0];
    statePtr->column = initData[1];
    statePtr->row = initData[2];
    statePtr->originalDirection = initData[3];

    statePtr->spriteMin = statePtr->originalSpriteIdx;
    statePtr->spriteIdx = statePtr->spriteMin;
    if (statePtr->spriteMin == BADGUY_SPRITE_ENEMY_SWATH_INDEX) {
        statePtr->spriteMax = BADGUY_SPRITE_BLADE_INDEX - 1;
    } else if ((statePtr->spriteMin == BADGUY_SPRITE_BLADE_INDEX) ||
               (statePtr->spriteMin == BADGUY_SPRITE_DUDE_INDEX)) {
        statePtr->spriteMax = statePtr->spriteMin + 3;
    } else if ((statePtr->spriteIdx == BADGUY_SPRITE_TINY_INDEX) ||
               (statePtr->spriteIdx == BADGUY_SPRITE_TIVO_INDEX)) {
        statePtr->spriteMax = statePtr->spriteMin + 1;
    } else {
        statePtr->spriteMax = BADGUY_SPRITE_BLADE_INDEX - 1;
    }
    statePtr->direction = statePtr->originalDirection;

    numInvaders = NUM_BAD_GUYS;
}


void reset() {
    DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
    for (obj = findObjectByGroup(obj, BADGUY_GROUP_IDX); obj; obj = findObjectByGroup(obj, BADGUY_GROUP_IDX)) {
        BadGuyObjectState *statePtr = (BadGuyObjectState *)(obj->statePtr);
        obj->active = OBJECT_ACTIVE;
        statePtr->spriteIdx = statePtr->originalSpriteIdx;
        statePtr->direction = statePtr->originalDirection;
        obj->globalX = statePtr->originalGlobalX;
        obj->globalY = statePtr->originalGlobalY;
        numInvaders = NUM_BAD_GUYS;
        obj = obj + 1;
    }
    
    groupDirection = DirectionModeRight;
    
    obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
    for (obj = findObjectByGroup(obj, MISSILE_GROUP_IDX); obj; obj = findObjectByGroup(obj, MISSILE_GROUP_IDX)) {
        obj->active = OBJECT_INACTIVE;
        obj = obj + 1;
    }
}


byte BadguyUpdate(DynospriteCOB *cob, DynospriteODT *odt);
byte BadguyReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    if (shipState->counter) {
        return 0;
    }

    if (globals->gameState) {
        return 0;
    }

    if (!numInvaders) {
        reset();

        // We have to patch up the direction of the previous bad guys
        for(DynospriteCOB *cob0 = cob; cob0 >= firstBadGuy ; cob0 = cob0 - 1) {
            BadguyUpdate(cob0, odt);
        }

        return 0;
    }
    
    byte delta = DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2;
    globals->shootCounter[0] = (globals->shootCounter[0] & 0x7fff) + delta;
    globals->shootCounter[1] = (globals->shootCounter[1] & 0x7fff) + 2 * delta;
    globals->shootCounter[2] = (globals->shootCounter[2] & 0x7fff) + 3 * delta;

    return 0;
}


byte BadguyUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    BadGuyObjectState *statePtr = (BadGuyObjectState *)(cob->statePtr);
    
    /* Switch to the next animation frame */
    byte spriteIdx = statePtr->spriteIdx;
    if (spriteIdx < statePtr->spriteMax) {
        statePtr->spriteIdx = spriteIdx + 1;
    } else if (spriteIdx == statePtr->spriteMax) {
        statePtr->spriteIdx = statePtr->spriteMin;
    } else if (spriteIdx >= BADGUY_SPRITE_LAST_INDEX) {
        cob->active = OBJECT_INACTIVE;
        --numInvaders;
        return 0;
    } else {
        statePtr->spriteIdx = spriteIdx + 1;
        return 0;
    }

    if (shipState->counter) {
        return 0;
    }

    if (globals->gameState) {
        return 0;
    }
    
    // This code moves the bad guy. The basic logic is to move the bad guy in
    // its current direction. If this bad guy has hit the far left or right,
    // change its direction and change the global direction to match the
    // its new direction. If this bad guy's direction is different from the
    // global direction, then change this guy's direction to match the global
    // direction. Move the character down on any motion change.
    
    // Move the character
    sbyte frameDelta = DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2;
    byte delta = (TOP_SPEED - (numInvaders >> 4)) * frameDelta;
    if (statePtr->direction == DirectionModeRight) {
        cob->globalX += delta;
    } else {
        cob->globalX -= delta;
    }
    
    // Did this character hit an extreme or move opposite from global direction?
    // If so, move down and update directions
    if ((cob->globalX <= SCREEN_LOCATION_MIN && (statePtr->direction == DirectionModeLeft)) ||
        (cob->globalX >= SCREEN_LOCATION_MAX && (statePtr->direction == DirectionModeRight))) {
        statePtr->direction =
            ((statePtr->direction == DirectionModeRight) ?
             DirectionModeLeft : DirectionModeRight);
        byte newDirection = (statePtr->direction != groupDirection);
        groupDirection = statePtr->direction;
        cob->globalY += DELTA_Y;

        // We have to patch up the direction of the previous bad guys
        if (newDirection) {
            for(DynospriteCOB *cob0 = cob - 1; cob0 >= firstBadGuy ; cob0 = cob0 - 1) {
                if (cob0->active) {
                    ((BadGuyObjectState *)cob0->statePtr)->direction = groupDirection;
                    cob0->globalY += DELTA_Y;
                }
            }
        }
    } else if (statePtr->direction != groupDirection) {
        statePtr->direction = groupDirection;
        cob->globalY += DELTA_Y;
    }

    // If the invaders hit the bottom, then the game is over
    if (cob->globalY > MAX_Y) {
         cob->globalY = MAX_Y;
         globals->gameState = GameStateOver;
         return 0;
    }
    
    // Shoot a missile if it is time to
    for(byte ii=0; ii<sizeof(globals->shootCounter)/sizeof(globals->shootCounter[0]); ii++) {
        globals->shootCounter[ii] = (globals->shootCounter[ii] & 0x7fff) + 1;
        if (!(badMissiles[ii]->active) && (globals->shootCounter[ii] > shootCounterMax[ii])) {
            DynospriteCOB *cob = getLowestBadguyToFireMissile();
            if (cob) {                
                globals->shootCounter[ii] = 0;
                badMissiles[ii]->active = OBJECT_ACTIVE;
                badMissiles[ii]->globalX = cob->globalX;
                badMissiles[ii]->globalY = cob->globalY + MISSILE_HEIGHT + BADGUY_HALF_HEIGHT;
            }
        }
    }

    return 0;
}


RegisterObject(BadguyClassInit, BadguyInit, 4, BadguyReactivate, BadguyUpdate, NULL, sizeof(BadGuyObjectState));

#ifdef __cplusplus
}
#endif
