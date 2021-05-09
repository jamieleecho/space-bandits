*********************************************************************************
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
* Note: Object handling assembly code must be position-independent, because it can
*       be loaded in different locations depending on the level.
*       1. If you use local variables, you must address them with PC-relative modes
*       2. You can only call locally defined functions with B**/LB** instuctions (no JSR or JMP)
*       This only applies for local data and code.  You can reference functions or data which are
*       defined in the DynoSprite core with position-dependent instructions, because the addresses
*       for these items are known at assembly time.


            include     macros.asm
            include     datastruct.asm
            include     dynosprite-symbols.asm

Object_Init:
            sts         DynoStackPointer,pcr
            lds         #$8000
            pshs        u,y,x
            tst         LibraryInit,pcr
            bne         Object_Skip_INILIB
            lbsr        INILIB
            inc         LibraryInit,pcr
Object_Skip_INILIB:
            lbsr        _ObjectInit
            puls        u,y,x
            lds         DynoStackPointer,pcr
program_start
program_end
_main
            rts

Object_Reactivate:
            sts         DynoStackPointer,pcr
            lds         #$8000
            pshs        u,x
            lbsr        _ObjectReactivate
            puls        u,x
            lds         DynoStackPointer,pcr
            bra         Object_TestMoveToNextLevel

Object_Update:
            sts         DynoStackPointer,pcr
            lds         #$8000
            pshs        u,x
            lbsr        _ObjectUpdate
            puls        u,x
            lds         DynoStackPointer,pcr
Object_TestMoveToNextLevel:
            tstb
            beq         >
	    bmi		Object_GotoMenu
Object_GotoLevel:
            tfr         b,a
            leas        2,s
            jmp         Ldr_Jump_To_New_Level 
!           rts
Object_GotoMenu:
            jsr         Ldr_Unload_Level
	    jmp	        Menu_RunMain


LibraryInit:            fcb     0                           * Whether or not we initialized the library
DynoStackPointer:       fdb     0                           * Dynosprite Stack Pointer

NumberOfObjects:        fcb     1
ObjectDescriptorTable:
                        fcb     DynospriteObject_DataSize
                        fcb     1                           * drawType == 1: standard sprite w/ no rowcrop
                        fcb     DynospriteObject_InitSize   * initSize
                        fcb     0                           * res1
                        fdb     Object_Init
                        fdb     Object_Reactivate
                        fdb     Object_Update
                        fdb     0                           * custom draw function
                        fdb     0                           * vpageAddr
                        fdb     0,0                         * res2

Object_Init EXPORT
LibraryInit EXPORT
NumberOfObjects EXPORT
ObjectDescriptorTable EXPORT
program_start EXPORT
program_end EXPORT
INILIB IMPORT

        ENDSECTION

        SECTION initgl_start

INITGL	EXPORT
INITGL	EQU	*

	ENDSECTION

	SECTION	initgl_end
INITGLEND EXPORT
INITGLEND EQU *
	rts

