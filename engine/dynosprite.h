#ifndef _Dynosprite_h
#define _Dynosprite_h


#include <coco.h>

/** Joystick 1 button 1 mask */
#define Joy1Button1 1
/** Joystick 2 button 1 mask */
#define Joy2Button1 2
/** Joystick 1 button 2 mask */
#define Joy1Button2 4
/** Joystick 2 button 2 mask */
#define Joy2Button2 8

/** Default audio sampling rate in Hz */
#define AudioSamplingRate 2000


/** DynospriteCOB.active flag indicating item inactive */
#define OBJECT_INACTIVE 0

/** DynospriteCOB.active flag indicating to update item */
#define OBJECT_UPDATE_ACTIVE 1

/** DynospriteCOB.active flag indicating to draw item */
#define OBJECT_DRAW_ACTIVE 2

/** DynospriteCOB.active flag indicating to draw and update item */
#define OBJECT_ACTIVE 3


/** Object Data Table */
typedef struct DynospriteODT {
  byte dataSize;
  byte drawType;
  byte initSize;
  byte res1;
  void *init;
  void *reactivate;
  void *update;
  void *draw;
  byte res2[4];
} DynospriteODT;


/** Curent Object Buffer */
typedef struct DynospriteCOB {
  byte groupIdx;
  byte objectIdx;
  byte active;
  byte res1;
  unsigned globalX;
  unsigned globalY;
  byte *statePtr;
  byte *odtPtr;
  byte *sprPtr;
  byte *rowPtr;
} DynospriteCOB;

/** Datastructure for DynospriteDirectPageGlobals */
typedef struct DynospriteDirectPageGlobals {
  byte MemMgr_VirtualTable[64];

  byte MemMgr_GfxAperStart;
  byte MemMgr_GfxAperEnd;
  unsigned MemMgr_HeapEndPtr;

  byte Gfx_BkgrndBlockCount;
  byte Gfx_BkgrndMaskCount;
  byte Gfx_BkgrndBlockPages;
  void *Gfx_CollisionTablePtr;

  byte Gfx_BkgrndMapPages;
  unsigned Gfx_BkgrndMapWidth;
  unsigned Gfx_BkgrndMapHeight;
  unsigned Gfx_BkgrndStartXMax;
  unsigned Gfx_BkgrndStartYMax;

  byte Gfx_CurrentFieldCount;
  byte Gfx_LastRenderedFrame;
  byte Gfx_DisplayedFrame;
  byte Gfx_RenderingFrameX4;

  unsigned Gfx_BkgrndStartXYList[4];
  unsigned Gfx_BkgrndPhyAddrList[4];

  unsigned Gfx_BkgrndLastX;
  unsigned Gfx_BkgrndLastY;
  unsigned Gfx_BkgrndRedrawOldX;
  unsigned Gfx_BkgrndRedrawOldY;
  unsigned Gfx_BkgrndNewX;
  unsigned Gfx_BkgrndNewY;
  unsigned Gfx_BkgrndNewX2;
  byte Gfx_BkgrndXFrac;
  byte Gfx_BkgrndYFrac;

  byte Gfx_DrawScreenPage;
  unsigned Gfx_DrawScreenOffset;

  unsigned Gfx_SpriteErasePtrs[4];
  unsigned Gfx_SpriteErasePtrPtr;

  byte Gfx_NumSpriteGroups;
  unsigned Gfx_SpriteGroupsPtr;

  byte Gfx_MonitorIsRGB;

  byte Obj_MotionFactor;

  byte Obj_NumCurrent;
  DynospriteCOB *Obj_CurrentTablePtr;
  unsigned Obj_StateDataPtr;

  byte Input_UseKeyboard;

  byte Input_JoystickX;
  byte Input_JoystickY;
  byte Input_Buttons;

  byte Input_JoyButtonMask;
  byte Input_KeyMatrix[8];
  byte Input_KeyMatrixDB[8];
  byte Input_NumPressedKeys;
  byte Input_PressedKeyCodes[8];

  byte Sound_OutputMode;

  byte Sound_NumWavePages;
  unsigned Sound_WavePageEndPtrs[8];

  byte Sound_ChannelsPlaying;
  byte Sound_Chan0VPage;
  unsigned Sound_Chan0Ptr;
  unsigned Sound_Chan0End;
  byte Sound_Chan1VPage;
  unsigned Sound_Chan1Ptr;
  unsigned Sound_Chan1End;

  byte Ldr_CurLevel;
  byte Ldr_LDD_LengthOIT[2];
  byte Ldr_LDD_LengthCodeRaw[2];
  byte Ldr_LDD_LengthCodeComp[2];
  byte Ldr_LDD_LengthMapComp[2];
  byte Ldr_LDD_PtrInitLevel[2];
  byte Ldr_LDD_PtrCalcBkgrnd[2];

  unsigned Demo_ScreenDeltaX88;
  unsigned Demo_ScreenDeltaY88;

  byte in_MinValue;
  byte in_MaxValue;

  byte gfx_DeltaXBlks;

  byte RR_RectBlocksX;
  byte RR_RectRowsY;
  byte RR_StartBlkX[2];
  byte RR_StartRowY[2];

  byte rr_TempMulHi;
  byte rr_TilemapPage;
  byte rr_ScreenPage;
  byte rr_BlocksLeftX;
  byte rr_RowsLeftY;
  byte rr_RowsLeftInBlk;
  byte rr_RowsToDraw;
  byte rr_TexRowOffset;

  byte gfx_DrawOffsetX[2];
  byte gfx_DrawOffsetY;
  byte gfx_DrawSpritePage;
  byte gfx_DrawSpriteOffset[2];
  byte gfx_DrawLeftOrRight;
} DynospriteDirectPageGlobals;


/** Dynosprite Global Variables */
typedef struct DynospriteGlobals {
  byte MemMgr_PhysicalMap[64];
  byte Gfx_Palette_CMP_RGB[32];
  byte Gfx_PalIdxBKColor;
  byte Gfx_PalIdxFGColor;
  byte Gfx_PalIdxBarColor;

  byte Disk_DirSector[256];
  byte Disk_CacheSector[256];

#ifdef DEBUG
  byte Disk_FileIsOpen;
  byte Disk_FileAtEnd;
#endif

  byte Disk_DirSectorNum;
  byte Disk_CachedTrackIdx;
  byte Disk_CachedSectorIdx;
  byte Disk_FileCurGranule;
  byte Disk_FileCurTrack;
  byte Disk_FileCurSector;
  byte Disk_FileCurByte;
  byte Disk_FileGranulesLeft;
  unsigned Disk_FileBytesInCurGran;
  unsigned Disk_FileBytesInLastSec;
  unsigned Disk_ProgressCallback;

  byte Disk_FAT;

  byte Img_Random161[161];
  byte Img_Random200[200];
} DynospriteGlobals;


/** Pointer to the Dynopsprite Direct Page Globals */
#define DynospriteDirectPageGlobalsPtr ((DynospriteDirectPageGlobals *)0x2000)

/** Pointer to the Dynopsprite Globals */
#define DynospriteGlobalsPtr ((DynospriteGlobals *)0x2100)


asm void PlaySound(byte val) {
  asm { 
  ldd 2,s
  pshs u
  jsr Sound_Play
  puls u
  }
}

#endif /* _Dynosprite_h */
