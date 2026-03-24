//
//  dynosprite.h
//  Space Bandits
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#ifndef dynosprite_h
#define dynosprite_h

#ifdef __cplusplus
#define MAYBE_UNUSED [[maybe_unused]]
extern "C" {
#else
#define MAYBE_UNUSED
#endif

#include <stdlib.h>
#include "coco.h"
#include "DynospriteDirectPageGlobals.h"

/** Joystick 1 button 1 mask */
#define Joy1Button1 1

/** Joystick 2 button 1 mask */
#define Joy2Button1 2

/** Joystick 1 button 2 mask */
#define Joy1Button2 4

/** Joystick 2 button 2 mask */
#define Joy2Button2 8


/** DynospriteCOB.active flag indicating item inactive */
#define OBJECT_INACTIVE 0

/** DynospriteCOB.active flag indicating to update item */
#define OBJECT_UPDATE_ACTIVE 1

/** DynospriteCOB.active flag indicating to draw item */
#define OBJECT_DRAW_ACTIVE 2

/** DynospriteCOB.active flag indicating to draw and update item */
#define OBJECT_ACTIVE 3


/**
 * Registers the given level into the shared registry.
 * @param init level initialization function
 * @param backgroundNewXY function used to compute new XY location
 * @param file path to file that defines the functions - ust begin with XY where XY are digits
 * @return some value
 */
int DSLevelRegistryRegister(void init(void), byte backgroundNewXY(void), const char *file);

/**
  * Registers the given level into the shared registry.
 * @param classInitMethod method used to initialize the class
 * @param initMethod method used to initialize the object
 * @param reactivateMethod function used to reinitialize the object
 * @param updateMethod function used to update the method on each cycle
 * @param drawMethod function used to draw the sprite
  * @param stateSize size of the state informtaion in bytes
  * @param path location of the object
  * @return some value
 */
int DSObjectClassDataRegistryRegisterClassData(void(*classInitMethod)(void), void(*initMethod)(DynospriteCOB *, DynospriteODT *, byte *), size_t initSize, byte(*reactivateMethod)(DynospriteCOB *, DynospriteODT *), byte(*updateMethod)(DynospriteCOB *, DynospriteODT *), void(*drawMethod)(struct DynospriteCOB *, void *, void *, void *, void *, bool), size_t stateSize, const char *path);


#define RegisterLevel(init, calcuateBackgroundNewXY) static int levelInit = DSLevelRegistryRegister(init, calcuateBackgroundNewXY, __FILE__)
#define RegisterObject(classInit, init, initSize, reactivate, update, draw, stateSize) static int objectInit = DSObjectClassDataRegistryRegisterClassData(classInit, init, initSize, reactivate, update, draw, stateSize, __FILE__)

extern DynospriteDirectPageGlobals *DynospriteDirectPageGlobalsPtr;
extern DynospriteGlobals *DynospriteGlobalsPtr;

void PlaySound(int soundIndex);
void MusicStart(int phaseInc);
void MusicStart1(int phaseInc);
void MusicStart2(int phaseInc);
void MusicStop(void);
void MusicStop1(void);
void MusicStop2(void);

/** Set waveform for a voice */
void MusicSetWaveformForVoice(int voice, int waveform);
#define MusicSetWaveSine0()      MusicSetWaveformForVoice(0, 0)
#define MusicSetWaveSine1()      MusicSetWaveformForVoice(1, 0)
#define MusicSetWaveSine2()      MusicSetWaveformForVoice(2, 0)
#define MusicSetWaveTriangle0()  MusicSetWaveformForVoice(0, 1)
#define MusicSetWaveTriangle1()  MusicSetWaveformForVoice(1, 1)
#define MusicSetWaveTriangle2()  MusicSetWaveformForVoice(2, 1)
#define MusicSetWaveSawtooth0()  MusicSetWaveformForVoice(0, 2)
#define MusicSetWaveSawtooth1()  MusicSetWaveformForVoice(1, 2)
#define MusicSetWaveSawtooth2()  MusicSetWaveformForVoice(2, 2)
#define MusicSetWavePulse0()     MusicSetWaveformForVoice(0, 3)
#define MusicSetWavePulse1()     MusicSetWaveformForVoice(1, 3)
#define MusicSetWavePulse2()     MusicSetWaveformForVoice(2, 3)
/** Quiet waveforms (half amplitude) */
#define MusicSetWaveSineQuiet0()      MusicSetWaveformForVoice(0, 4)
#define MusicSetWaveSineQuiet1()      MusicSetWaveformForVoice(1, 4)
#define MusicSetWaveSineQuiet2()      MusicSetWaveformForVoice(2, 4)
#define MusicSetWaveTriangleQuiet0()  MusicSetWaveformForVoice(0, 5)
#define MusicSetWaveTriangleQuiet1()  MusicSetWaveformForVoice(1, 5)
#define MusicSetWaveTriangleQuiet2()  MusicSetWaveformForVoice(2, 5)
#define MusicSetWaveSawtoothQuiet0()  MusicSetWaveformForVoice(0, 6)
#define MusicSetWaveSawtoothQuiet1()  MusicSetWaveformForVoice(1, 6)
#define MusicSetWaveSawtoothQuiet2()  MusicSetWaveformForVoice(2, 6)
#define MusicSetWavePulseQuiet0()     MusicSetWaveformForVoice(0, 7)
#define MusicSetWavePulseQuiet1()     MusicSetWaveformForVoice(1, 7)
#define MusicSetWavePulseQuiet2()     MusicSetWaveformForVoice(2, 7)

#ifdef __cplusplus
}
#endif

#endif /* dynosprite_h */
