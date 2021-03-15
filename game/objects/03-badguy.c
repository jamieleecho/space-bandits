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
#define SCREEN_LOCATION_MIN 26
#define SCREEN_LOCATION_MAX 318
#define NUM_COLUMNS 9
#define NUM_ROWS 5
#define DELTA_Y 2
#define MAX_Y (SHIP_POSITION_Y - 20)
#define TOP_SPEED 4


/** The invader direction code is a bit confusing. We have to keep all of the */
typedef enum DirectionMode {
    DirectionModeRight,
    DirectionModeLeft,
} DirectionMode;


/** Invader grouping mode */
typedef enum GroupingMode {
    /** All invaders move together */
    GroupingModeAll = 0,

    /** All invaders in a column move together */
    GroupingModeColumn,

    /** All invaders in a row move together */
    GroupingModeRow,

    /** All invaders move in whatever direction they want */
    GroupingModeFreeForAll,

    /** Invalid grouping mode */
    GroupingModeInvalid
} GroupingMode;


/** Maps a groupingMode to the correspnding deltaY for that mode */
static const byte groupModeToDeltaY[] = {
    2, 4, 4, 6
};


/** Has the class been initialized */
static byte didInit = FALSE;

/** Direction that all of the invaders should be moving */
static byte /* DirectionMode */ groupDirection;

/** Direction that the given column all of the invaders should be moving */
static byte /* DirectionMode */ columnGroupDirection[NUM_COLUMNS];

/** Direction that the given row all of the invaders should be moving */
static byte /* DirectionMode */ rowGroupDirection[NUM_ROWS];

/** How the invaders shouls be grouped together */
static byte /* GroupingMode */ groupMode;

/** Number of invaders that are alive */
static byte numInvaders = 0;

/** Array containing the bad missile objects */
static DynospriteCOB *badMissiles[NUM_BAD_MISSILES];

/** Which invader array should be shooting */
static byte currentMissileFireColumnIndex = 0;

/** Game global variables */
static GameGlobals *globals;

/** Useful for indexing into bad guys */
static DynospriteCOB *firstBadGuy;

/** For checking the state of the ship */
static ShipObjectState *shipState;

/** The last bad guy processed */
static DynospriteCOB *lastBadGuyUpdated;

/** Number of pixels to move objDelta */
static sbyte objDelta = 0;

/** Whether or not we hit the bottom */
static byte hitBottom = FALSE;

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
    for(byte ii=0; ii<NUM_COLUMNS; ii++) {
        byte xx = column + ii;
        if (xx >= NUM_COLUMNS) {
            xx = xx - NUM_COLUMNS;
        }
        cob = firstBadGuy + (NUM_COLUMNS * (NUM_ROWS - 1)) + xx;

        for(; cob >= firstBadGuy ; cob = cob - NUM_COLUMNS) {
            if ((cob->active == OBJECT_ACTIVE) && (cob->globalY < BAD_GUY_FIRE_MAX_Y)) {
                return cob;
            }
        }
    }

    return (DynospriteCOB *)NULL;
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
        groupMode = GroupingModeAll;
        groupDirection = DirectionModeRight;
        memset(columnGroupDirection, DirectionModeRight, sizeof(columnGroupDirection));
        memset(rowGroupDirection, DirectionModeRight, sizeof(rowGroupDirection));
        
        lastBadGuyUpdated = (DynospriteCOB *)0xffff;
        hitBottom = FALSE;
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
    groupMode = (groupMode + 1) % GroupingModeInvalid;
    groupDirection = DirectionModeRight;
    memset(columnGroupDirection, DirectionModeRight, sizeof(columnGroupDirection));
    memset(rowGroupDirection, DirectionModeRight, sizeof(rowGroupDirection));

    DynospriteCOB *obj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
    for (obj = findObjectByGroup(obj, BADGUY_GROUP_IDX); obj; obj = findObjectByGroup(obj, BADGUY_GROUP_IDX)) {
        BadGuyObjectState *statePtr = (BadGuyObjectState *)(obj->statePtr);
        obj->active = OBJECT_ACTIVE;
        statePtr->spriteIdx = statePtr->originalSpriteIdx;

        if (groupMode == GroupingModeFreeForAll) {
            statePtr->direction = (statePtr->row + statePtr->column) & 1 ? DirectionModeRight : DirectionModeLeft;
        } else {
            statePtr->direction = statePtr->originalDirection;
        }
        obj->globalX = statePtr->originalGlobalX;
        obj->globalY = statePtr->originalGlobalY;
        numInvaders = NUM_BAD_GUYS;
        obj = obj + 1;
    }
    
    lastBadGuyUpdated = (DynospriteCOB *)0xffff;
    for(byte ii=0; ii<NUM_MISSILES; ii++) {
        badMissiles[ii]->active = OBJECT_INACTIVE;
    }
}


byte BadguyUpdate(DynospriteCOB *cob, DynospriteODT *odt);
byte BadguyReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    if (globals->counter) {
        return 0;
    }

    if (globals->gameState) {
        return 0;
    }

    if (hitBottom && (cob == firstBadGuy)) {
        globals->gameState = GameStateOver;
        globals->counter = 255;
        PlaySound(SOUND_EXPLOSION);
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

    // Whether or not there is a new frame
    byte newFrame = cob < lastBadGuyUpdated;
    lastBadGuyUpdated = cob;

    // Switch to the next animation frame
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

    if (globals->counter) {
        return 0;
    }

    if (globals->gameState) {
        return 0;
    }

    if (hitBottom && (cob == firstBadGuy)) {
        globals->gameState = GameStateOver;
        globals->counter = 255;
        PlaySound(SOUND_EXPLOSION);
        return 0;
    }
    
    // This code moves the bad guy. The basic logic is to move the bad guy in
    // its current direction. If this bad guy has hit the far left or right,
    // change its direction and change the global direction to match the
    // its new direction. If this bad guy's direction is different from the
    // global direction, then change this guy's direction to match the global
    // direction. Move the character down on any motion change.
    
    // Move the character
    if (newFrame) {
        sbyte frameDelta = DynospriteDirectPageGlobalsPtr->Obj_MotionFactor + 2;
        objDelta = (TOP_SPEED - (numInvaders >> 4)) * frameDelta;
    }
    if (statePtr->direction == DirectionModeRight) {
        cob->globalX += objDelta;
    } else {
        cob->globalX -= objDelta;
    }

    // Logic for deciding how things should be groups
    byte *groupDirectionPtr;
    sbyte iterDelta;
    switch(groupMode) {
        case GroupingModeAll:
            groupDirectionPtr = &groupDirection;
            iterDelta = -1;
            break;
        case GroupingModeColumn:
            groupDirectionPtr = columnGroupDirection + statePtr->column;
            iterDelta = -NUM_COLUMNS;
            break;
        case GroupingModeRow:
            groupDirectionPtr = rowGroupDirection + statePtr->row;
            iterDelta = -1;
            break;
        case GroupingModeFreeForAll:
        default:
            groupDirectionPtr = &statePtr->direction;
            iterDelta = -1;
            break;
    }
    
    // Did this character hit an extreme or move opposite from global direction?
    // If so, move down and update directions
    word xOffset = cob->globalX;
    if ((xOffset <= SCREEN_LOCATION_MIN && (statePtr->direction == DirectionModeLeft)) ||
        (xOffset >= SCREEN_LOCATION_MAX && (statePtr->direction == DirectionModeRight))) {
        
        // Adjust position if in column mode
        if (groupMode == GroupingModeColumn) {
            if (xOffset < SCREEN_LOCATION_MIN) {
                cob->globalX = SCREEN_LOCATION_MIN + (SCREEN_LOCATION_MIN - xOffset);
            } else if (xOffset > SCREEN_LOCATION_MAX) {
                cob->globalX = SCREEN_LOCATION_MAX + (SCREEN_LOCATION_MAX - xOffset);
            }
        }
        
        statePtr->direction =
            ((statePtr->direction == DirectionModeRight) ?
             DirectionModeLeft : DirectionModeRight);
        byte newDirection = (statePtr->direction != *groupDirectionPtr);
        
        *groupDirectionPtr = statePtr->direction;
        cob->globalY += groupModeToDeltaY[groupMode];

        // We have to patch up the direction of the previous bad guys
        if (newDirection && (groupMode != GroupingModeFreeForAll)) {
            for(DynospriteCOB *cob0 = cob + iterDelta; cob0 >= firstBadGuy ; cob0 = cob0 + iterDelta) {
                if (cob0->active) {
                    if (groupMode == GroupingModeRow) {
                        if (((BadGuyObjectState *)cob0->statePtr)->row != statePtr->row) {
                            break;
                        }
                    }
                    ((BadGuyObjectState *)cob0->statePtr)->direction = *groupDirectionPtr;
                    cob0->globalY += groupModeToDeltaY[groupMode];
                }
            }
        }
    } else if (statePtr->direction != *groupDirectionPtr) {
        statePtr->direction = *groupDirectionPtr;
        cob->globalY += groupModeToDeltaY[groupMode];
    }

    // If the invaders hit the bottom, then the game is over
    if (cob->globalY > MAX_Y) {
        cob->globalY = MAX_Y;
        hitBottom = TRUE;
        return 0;
    }
    
    // Shoot a missile if it is time to
    for(byte ii=0; ii<sizeof(globals->shootCounter)/sizeof(globals->shootCounter[0]); ii++) {
        globals->shootCounter[ii] = (globals->shootCounter[ii] & 0x7fff) + 1;
        if (!(badMissiles[ii]->active) && (globals->shootCounter[ii] > shootCounterMax[ii])) {
            DynospriteCOB *cob = getLowestBadguyToFireMissile();
            globals->shootCounter[ii] = 0;
            if (cob) {
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
