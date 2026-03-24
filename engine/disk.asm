*********************************************************************************
* DynoSprite - disk.asm
* Copyright (c) 2013, Richard Goedeken
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
*
* This file contains Disk_FileRead and its helpers, which must remain in
* the secondary code page ($E000) because the decompressor calls them
* while its buffers are mapped to $4000 via $FFA2.
*
* Disk_DirInit, Disk_FileOpen, Disk_FileSeekForward, Disk_FileClose, and
* Disk_SetProgressCallback are in disk-commands.asm (tertiary page at $4000),
* called via stubs below.

DC          STRUCT
OPC                     rmb     1
DRV                     rmb     1
TRK                     rmb     1
SEC                     rmb     1
BPT                     rmb     2
STA                     rmb     1
            ENDSTRUCT


***********************************************************
* Disk_DirInit (stub)
* - IN:      N/A
* - OUT:     N/A
* - Trashed: A,B,X,Y,U
***********************************************************
Disk_DirInit
            lda         $FFA2
            pshs        a
            lda         #MUSIC_CODE_PHYS_PAGE
            sta         $FFA2
            jsr         Disk_DirInit_Impl
            puls        a
            sta         $FFA2
            rts

***********************************************************
* Disk_FileOpen (stub)
* - IN:      X = Pointer to filename (11 characters, no extension separator)
* - OUT:     N/A
* - Trashed: A,B,U
***********************************************************
Disk_FileOpen
            lda         $FFA2
            pshs        a
            lda         #MUSIC_CODE_PHYS_PAGE
            sta         $FFA2
            jsr         Disk_FileOpen_Impl
            puls        a
            sta         $FFA2
            rts

***********************************************************
* Disk_FileSeekForward (stub)
* - IN:      D = distance to seek in bytes
* - OUT:     N/A
* - Trashed: A,B,X,U
***********************************************************
Disk_FileSeekForward
            pshs        a
            lda         $FFA2
            pshs        a
            lda         #MUSIC_CODE_PHYS_PAGE
            sta         $FFA2
            lda         1,s
            jsr         Disk_FileSeekForward_Impl
            puls        a
            sta         $FFA2
            puls        a,pc

***********************************************************
* Disk_FileClose (stub)
* - IN:      N/A
* - OUT:     N/A
* - Trashed: None
***********************************************************
Disk_FileClose
            lda         $FFA2
            pshs        a
            lda         #MUSIC_CODE_PHYS_PAGE
            sta         $FFA2
            jsr         Disk_FileClose_Impl
            puls        a
            sta         $FFA2
            rts

***********************************************************
* Disk_SetProgressCallback (stub)
* - IN:      X = address of callback function (or NULL)
* - OUT:     N/A
* - Trashed: None
***********************************************************
Disk_SetProgressCallback
            lda         $FFA2
            pshs        a
            lda         #MUSIC_CODE_PHYS_PAGE
            sta         $FFA2
            jsr         Disk_SetProgressCallback_Impl
            puls        a
            sta         $FFA2
            rts


***********************************************************
* Disk_FileRead:
*
* - IN:      Y = number of bytes to read, U = pointer to buffer to load data
* - OUT:     N/A
* - Trashed: A,B,X,Y,U
***********************************************************

Disk_FileRead
            cmpy        #0
            bne         NonZeroRead@
            rts                                 * read 0 bytes is NOP
NonZeroRead@
 IFDEF DISK_DEBUG
            tst         Disk_FileIsOpen
            bne         >
            swi                                 * error, no file is open
!           tst         Disk_FileAtEnd
            beq         >
            swi                                 * Error: file is already at end
 ENDC
!           ldx         Disk_FileCurTrack       * current file location
            cmpx        Disk_CachedTrackIdx     * do we already have this sector in disk cache?
            beq         >
            pshs        y,u
            jsr         Disk_ReadSector         * no, so go read this sector
            puls        y,u
!           ldx         #Disk_CacheSector
            ldb         Disk_FileCurByte
            abx
            clrb                                * B is negative counter of bytes copied
CopyLoop@   lda         ,x+
            sta         ,u+
            decb
            cmpx        #Disk_CacheSector+256   * did we just read the last byte in cached sector?
            beq         ReadNextSector@
            leay        -1,y
            bne         CopyLoop@               * continue until no bytes remaining to copy
            lda         #$ff                    * D is negative number of bytes copied from this sector
            addd        Disk_FileBytesInCurGran
 IFDEF DISK_DEBUG
            bpl         >
            swi                                 * Error: read past end of file
 ENDC
!           std         Disk_FileBytesInCurGran
            tfr         x,d
            subd        #Disk_CacheSector
            stb         Disk_FileCurByte        * update byte offset in current sector
            rts
ReadNextSector@
            clr         Disk_FileCurByte        * next copy will start at beginning of sector
            lda         #$ff                    * D is negative number of bytes copied from this sector
            addd        Disk_FileBytesInCurGran
 IFDEF DISK_DEBUG
            bpl         >
            swi                                 * Error: read past end of file
 ENDC
!           std         Disk_FileBytesInCurGran
            beq         ReadNextGranule@
            inc         Disk_FileCurSector      * read next sector
            pshs        u,y
            jsr         Disk_ReadSector
            puls        u,y
            leay        -1,y                    * update bytes remaining to copy
            bne         >
            rts                                 * all done, new sector is in cache with 256 bytes unread
!           ldx         #Disk_CacheSector
            clrb
            bra         CopyLoop@
ReadNextGranule@
            pshs        u,y
            lda         Disk_FileCurGranule
            ldu         #Disk_FAT
            ldb         a,u                     * B is next granule number
            cmpb        #$C0
            blo         NextGranValid@
 IFDEF DISK_DEBUG
            cmpy        #1                      * Previous granule was last one, so we better be done copying
            beq         >
            swi                                 * Error: read past end of file
!           inc         Disk_FileAtEnd
 ENDC
            rts
NextGranValid@
            stb         Disk_FileCurGranule
            dec         Disk_FileGranulesLeft
 IFDEF DISK_DEBUG
            bpl         >
            swi                                 * Error: broken FAT or internal logic
 ENDC
!           pshs        b
            lda         b,u
            cmpa        #$C0                    * is this granule full?
            blo         >
            anda        #$1F                    * no, it is partial, so calculate # of bytes in last granule
            clrb
            addd        Disk_FileBytesInLastSec
            deca
            bra         StoreNewGranSize@
!           ldd         #$900
StoreNewGranSize@
            std         Disk_FileBytesInCurGran * bytes remaining in new granule
            lda         ,s
            lsra
            cmpa        #17
            blo         >
            inca
!           sta         Disk_FileCurTrack
            puls        a
            anda        #1
            ldb         #9
            mul
            incb                                * B is starting sector # of new granule
            stb         Disk_FileCurSector
            jsr         Disk_ReadSector         * read first sector in new granule
            puls        u,y
            leay        -1,y                    * update bytes remaining to copy
            bne         >
            rts                                 * all done, new sector is in cache with 256 bytes unread
!           ldx         #Disk_CacheSector
            clrb
            jmp         CopyLoop@

Disk_ReadSector
            ldx         $C006                   * get pointer to DSKCON parameter block
            lda         #2
            sta         DC.OPC,x                * Operation Code == Read sector
            lda         Disk_FileCurTrack
            sta         Disk_CachedTrackIdx
            sta         DC.TRK,x                * Track
            lda         Disk_FileCurSector
            sta         Disk_CachedSectorIdx
            sta         DC.SEC,x                * Sector
            ldd         #Disk_CacheSector
            std         DC.BPT,x                * Sector Buffer == Disk_CacheSector
            jsr         System_CallDSKCON       * read current sector
            ldx         Disk_ProgressCallback   * send progress callback after every sector read
            beq         >
            jmp         ,x
!           rts

