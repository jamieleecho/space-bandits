*********************************************************************************
* DynoSprite - game/levels/00-marbledemo.asm
* Copyright (c) 2013-2014, Richard Goedeken
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
* * Redistributions of source code must retain the above copyright notice, this
*   list of conditions and the following disclaimer.
* 
* * Redistributions in binary form must reproduce the above copyright notice,
*   this list of conditions and the following disclaimer in the documentation
*   and/or other materials provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*********************************************************************************
* Note: The dynamic Level handling code is always loaded first in the level/object code page,
*       and this page is always mapped to $6000 when being accesssed in the DynoSprite core.
*       For this reason, you may use position-dependent instructions if desired for local data
*       and code.

* -----------------------------------------------------------------------------
* -- Type definitions only
* -----------------------------------------------------------------------------

            include     datastruct.asm
            include     dynosprite-symbols.asm

***********************************************************
* Level_Initialize:
*
* - IN:      None
* - OUT:     None
* - Trashed: A,B,X,Y,U
***********************************************************

Level_Initialize
            sts         DynoStackPointer,pcr
            lds         #$8000
            tst         LibraryInit,pcr
            bne         Level_Skip_INILIB
            lbsr        INITGL
            inc         LibraryInit,pcr
Level_Skip_INILIB:
            lbsr        _LevelInit
            lds         DynoStackPointer,pcr
program_start
program_end
_main
            rts


***********************************************************
* Level_CalculateBkgrndNewXY:
*
* - IN:      None
* - OUT:     None
* - Trashed: A,B,X,U
***********************************************************
* This function calculates a new background X/Y starting
* location for the next frame.

Level_CalculateBkgrndNewXY
            sts         DynoStackPointer,pcr
            lds         #$8000
            pshs        y
            lbsr        _LevelCalculateBkgrndNewXY
            puls        y
            lds         DynoStackPointer,pcr
            tstb
            beq         >
            tfr         b,a
            leas        2,s
            jmp         Ldr_Jump_To_New_Level
!           rts


LibraryInit             fcb         0           * Whether or not we initialized the library
DynoStackPointer        fdb         0           * Dynosprite Stack Pointer

Level_Initialize EXPORT
Level_CalculateBkgrndNewXY EXPORT
Level_Skip_INILIB EXPORT
DynoStackPointer EXPORT
program_start EXPORT
program_end EXPORT
INILIB IMPORT

        ENDSECTION

        SECTION initgl_start

INITGL	EXPORT
INITGL	EQU	*

	ENDSECTION


	SECTION	initgl_end
INITGLEND	EXPORT
INITGLEND EQU *
	rts

