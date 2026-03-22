#ifdef __cplusplus
extern "C" {
#endif

#include "12-cat.h"
#include "10-littleguy.h"
#include "11-bird.h"
#include "object_info.h"

#define CAT_PLAY_AREA_WIDTH 640
#define CAT_MIN_X (CAT_HALF_WIDTH + 1)
#define CAT_MAX_X (CAT_PLAY_AREA_WIDTH - CAT_HALF_WIDTH - 1)
#define CAT_GROUND_Y 175
#define CAT_CHASE_SPEED 3
#define CAT_WALK_SPEED 2
#define CAT_JUMP_VELOCITY -7
#define CAT_GRAVITY 1
#define CAT_JUMP_RANGE 40
#define CAT_SNUGGLE_DISTANCE 20
#define CAT_SLEEP_DURATION 180
#define CAT_CHASE_DURATION 240
#define CAT_SNUGGLE_DURATION 200

static byte didNotInit = TRUE;


#ifdef __APPLE__
void CatClassInit() {
    didNotInit = TRUE;
}
#endif


void CatInit(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    if (didNotInit) {
        didNotInit = FALSE;
    }

    CatObjectState *statePtr = (CatObjectState *)(cob->statePtr);
    statePtr->spriteIdx = CAT_SPRITE_SLEEP1;
    statePtr->mood = CAT_MOOD_SLEEP;
    statePtr->moodTimer = CAT_SLEEP_DURATION;
    statePtr->animCounter = 0;
    statePtr->walkCounter = 0;
    statePtr->snuggleProximity = 0;
    statePtr->jumpVelocity = 0;
    statePtr->isJumping = 0;
}


byte CatReactivate(DynospriteCOB *cob, DynospriteODT *odt) {
    return 0;
}


byte CatUpdate(DynospriteCOB *cob, DynospriteODT *odt) {
    CatObjectState *statePtr = (CatObjectState *)(cob->statePtr);

    statePtr->animCounter++;

    /* Mood timer countdown and transitions */
    if (statePtr->moodTimer > 0) {
        statePtr->moodTimer--;
    } else {
        /* Pick next mood based on current state and pseudo-random value */
        byte nextMood = (statePtr->animCounter * 37 + cob->globalX) & 3;
        if (statePtr->mood == CAT_MOOD_SLEEP) {
            statePtr->mood = (nextMood < 2) ? CAT_MOOD_CHASE : CAT_MOOD_SNUGGLE;
            statePtr->moodTimer = (statePtr->mood == CAT_MOOD_CHASE) ? CAT_CHASE_DURATION : CAT_SNUGGLE_DURATION;
        } else {
            statePtr->mood = CAT_MOOD_SLEEP;
            statePtr->moodTimer = CAT_SLEEP_DURATION;
        }
        statePtr->walkCounter = 0;
        statePtr->snuggleProximity = 0;
    }

    if (statePtr->mood == CAT_MOOD_SLEEP) {
        /* Sleeping animation - cycle through sleep frames */
        byte sleepFrame = (statePtr->animCounter >> 4) % 3;
        statePtr->spriteIdx = CAT_SPRITE_SLEEP1 + sleepFrame;

    } else if (statePtr->mood == CAT_MOOD_CHASE) {
        /* Find nearest visible bird */
        DynospriteCOB *nearestBird = 0;
        int nearestDist = 9999;
        DynospriteCOB *searchObj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
        DynospriteCOB *endObj = searchObj + DynospriteDirectPageGlobalsPtr->Obj_NumCurrent;
        for (; searchObj < endObj; searchObj++) {
            if (searchObj->groupIdx == BIRD_GROUP_IDX) {
                BirdObjectState *bs = (BirdObjectState *)(searchObj->statePtr);
                if (bs->hideCounter == 0) {
                    int d = (int)searchObj->globalX - (int)cob->globalX;
                    if (d < 0) d = -d;
                    if (d < nearestDist) {
                        nearestDist = d;
                        nearestBird = searchObj;
                    }
                }
            }
        }

        if (nearestBird) {
            int dx = (int)nearestBird->globalX - (int)cob->globalX;
            int absDx = dx < 0 ? -dx : dx;

            /* Jump at the bird when close enough horizontally and on the ground */
            if (absDx < CAT_JUMP_RANGE && !statePtr->isJumping) {
                statePtr->isJumping = 1;
                statePtr->jumpVelocity = CAT_JUMP_VELOCITY;
            }

            /* Chase horizontally when not jumping */
            if (!statePtr->isJumping) {
                if (dx > CAT_CHASE_SPEED) {
                    cob->globalX += CAT_CHASE_SPEED;
                    statePtr->walkCounter++;
                    if ((statePtr->walkCounter >> 2) & 1) {
                        statePtr->spriteIdx = CAT_SPRITE_CHASE_RIGHT_A;
                    } else {
                        statePtr->spriteIdx = CAT_SPRITE_CHASE_RIGHT_B;
                    }
                } else if (dx < -CAT_CHASE_SPEED) {
                    cob->globalX -= CAT_CHASE_SPEED;
                    statePtr->walkCounter++;
                    if ((statePtr->walkCounter >> 2) & 1) {
                        statePtr->spriteIdx = CAT_SPRITE_CHASE_LEFT_A;
                    } else {
                        statePtr->spriteIdx = CAT_SPRITE_CHASE_LEFT_B;
                    }
                } else {
                    statePtr->spriteIdx = CAT_SPRITE_SIT;
                }
            }

            /* Check collision with all birds */
            searchObj = DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr;
            for (; searchObj < endObj; searchObj++) {
                if (searchObj->groupIdx == BIRD_GROUP_IDX) {
                    BirdObjectState *bs = (BirdObjectState *)(searchObj->statePtr);
                    if (bs->hideCounter == 0) {
                        int cdx = (int)cob->globalX - (int)searchObj->globalX;
                        int cdy = (int)cob->globalY - (int)searchObj->globalY;
                        if (cdx < 0) cdx = -cdx;
                        if (cdy < 0) cdy = -cdy;
                        if (cdx < (CAT_HALF_WIDTH + BIRD_HALF_WIDTH) &&
                            cdy < (CAT_HALF_HEIGHT + BIRD_HALF_HEIGHT)) {
                            PlaySound(SOUND_OUCH);
                            bumpScore(1);
                            bs->hideCounter = BIRD_HIDE_DURATION;
                        }
                    }
                }
            }
        } else {
            statePtr->spriteIdx = CAT_SPRITE_SIT;
        }

    } else if (statePtr->mood == CAT_MOOD_SNUGGLE) {
        /* Move toward the little guy */
        DynospriteCOB *guyCob = findObjectByGroup(DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr, LITTLEGUY_GROUP_IDX);
        if (guyCob) {
            int dx = (int)guyCob->globalX - (int)cob->globalX;
            int dist = dx < 0 ? -dx : dx;

            if (dist > CAT_SNUGGLE_DISTANCE) {
                /* Walk toward person */
                if (dx > 0) {
                    cob->globalX += CAT_WALK_SPEED;
                    statePtr->walkCounter++;
                    if ((statePtr->walkCounter >> 2) & 1) {
                        statePtr->spriteIdx = CAT_SPRITE_WALK_RIGHT_A;
                    } else {
                        statePtr->spriteIdx = CAT_SPRITE_WALK_RIGHT_B;
                    }
                } else {
                    cob->globalX -= CAT_WALK_SPEED;
                    statePtr->walkCounter++;
                    if ((statePtr->walkCounter >> 2) & 1) {
                        statePtr->spriteIdx = CAT_SPRITE_WALK_LEFT_A;
                    } else {
                        statePtr->spriteIdx = CAT_SPRITE_WALK_LEFT_B;
                    }
                }
                statePtr->snuggleProximity = 0;
            } else {
                /* Close enough - snuggle animation */
                statePtr->snuggleProximity = 1;
                if ((statePtr->animCounter >> 3) & 1) {
                    statePtr->spriteIdx = CAT_SPRITE_SNUGGLE1;
                } else {
                    statePtr->spriteIdx = CAT_SPRITE_SNUGGLE2;
                }
            }
        } else {
            statePtr->spriteIdx = CAT_SPRITE_SIT;
        }
    }

    /* Apply jump physics */
    if (statePtr->isJumping) {
        cob->globalY += statePtr->jumpVelocity;
        statePtr->jumpVelocity += CAT_GRAVITY;
        statePtr->spriteIdx = CAT_SPRITE_SIT;

        if (cob->globalY >= CAT_GROUND_Y) {
            cob->globalY = CAT_GROUND_Y;
            statePtr->isJumping = 0;
            statePtr->jumpVelocity = 0;
        }
    }

    /* Clamp position */
    if (cob->globalX < CAT_MIN_X) {
        cob->globalX = CAT_MIN_X;
    } else if (cob->globalX > CAT_MAX_X) {
        cob->globalX = CAT_MAX_X;
    }

    /* Hide cat when vertically clipped */
    int screenY = (int)cob->globalY - (int)DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY;
    if (screenY - CAT_HALF_HEIGHT < 0 || screenY + CAT_HALF_HEIGHT > SCREEN_HEIGHT) {
        cob->active = OBJECT_UPDATE_ACTIVE;
    } else {
        cob->active = OBJECT_ACTIVE;
    }

    return 0;
}


RegisterObject(CatClassInit, CatInit, 0, CatReactivate, CatUpdate, NULL, sizeof(CatObjectState));

#ifdef __cplusplus
}
#endif
