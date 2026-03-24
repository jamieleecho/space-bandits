*********************************************************************************
* DynoSprite - disk-commands.asm
* Copyright (c) 2013, Richard Goedeken
* All rights reserved.
*
* Disk command implementations residing in the tertiary code page ($4000).
* These are called via stubs in disk.asm (secondary code page) that swap
* this page in/out of $4000-$5FFF via $FFA2.
*
* These functions are safe in the tertiary page because they are only called
* outside the decompression window (before Decomp_Init_Stream or after
* Decomp_Close_Stream), so $FFA2 is not in use by the decompressor.
*
* Disk_FileRead and Disk_ReadSector remain in disk.asm (secondary page)
* because the decompressor calls them while its buffers are mapped to $4000.
*********************************************************************************


***********************************************************
* Disk_DirInit_Impl:
*   We read and cache the disk 0 directory and FAT in this function,
*   for later use by the file handling functions
*
* - IN:      N/A
* - OUT:     N/A
* - Trashed: A,B,X,Y,U
***********************************************************
Disk_DirInit_Impl
            ldx         $C006                   * get pointer to DSKCON parameter block
            lda         #2
            sta         DC.OPC,x                * Operation Code == Read sector
            * we won't set the drive # here, so that we will load everything from the
            * most recently accessed drive (which loaded this program, so should contain our data)
            lda         #17
            sta         DC.TRK,x                * Track 17 (directory track)
            lda         #2
            sta         DC.SEC,x                * Sector 2 (FAT)
            ldd         #Disk_DirSector
            std         DC.BPT,x                * Sector Buffer == DiskDirSector
            jsr         System_CallDSKCON
!           ldy         #Disk_FAT
            ldu         #Disk_DirSector
            ldb         #68
!           lda         ,u+                     * copy 68 bytes of FAT into destination table
            sta         ,y+
            decb
            bne         <
            lda         #3
            sta         DC.SEC,x                * sector 3 (first 8 directory entries)
            sta         Disk_DirSectorNum
            jsr         System_CallDSKCON
            clr         $FF40                   * turn off drive motor
            clr         $986                    * clear DGRAM also, so Disk BASIC knows that drive motor was shut off
            rts


***********************************************************
* Disk_FileOpen_Impl:
*   We search for the given filename in the directory, and
*   set initial parameters in our data structures
*
* - IN:      X = Pointer to filename (11 characters, no extension separator)
* - OUT:     N/A
* - Trashed: A,B,U
***********************************************************
DirSecLeft@ zmb         1
Disk_FileOpen_Impl
 IFDEF DISK_DEBUG
            lda         Disk_FileIsOpen
            beq         >
            swi                                 * error, previous file was not closed
 ENDC
!           lda         #9                      * maximum number of directory sectors to search (3-11)
            sta         DirSecLeft@
SearchDirSector@
            ldu         #Disk_DirSector         * search for matching filename
FindMatch@  pshs        x,u
            ldb         #11
!           lda         ,u+
            cmpa        ,x+
            bne         DirEntryNoMatch@
            decb
            beq         DirEntryMatch@
            bra         <
DirEntryNoMatch@
            puls        x,u
            leau        32,u                    * go to next directory entry
            cmpu        #Disk_DirSector+256
            blo         FindMatch@
SectorNoMatch@
            dec         DirSecLeft@
            bne         LoadNextDirSector@
            swi                                 * Error: file not found in 72 directory entries
LoadNextDirSector@
            pshs        x
            ldx         $C006                   * get pointer to DSKCON parameter block
            lda         #2
            sta         DC.OPC,x                * Operation Code == Read sector
            * we won't set the drive # here, so that we will load everything from the
            * most recently accessed drive (which loaded this program, so should contain our data)
            lda         #17
            sta         DC.TRK,x                * Track 17 (directory track)
            lda         Disk_DirSectorNum
            inca                                * advance to next directory sector
            cmpa        #12
            blo         >
            lda         #3                      * wrap around from 12 to 3
!           sta         Disk_DirSectorNum
            sta         DC.SEC,x                * Directory Sector Number
            ldd         #Disk_DirSector
            std         DC.BPT,x                * Sector Buffer == DiskDirSector
            jsr         System_CallDSKCON       * read sector
            puls        x
            bra         SearchDirSector@        * go look through the directory entries in the newly loaded sector
DirEntryMatch@
            puls        x,u
 IFDEF DISK_DEBUG
            inc         Disk_FileIsOpen
            clr         Disk_FileAtEnd
 ENDC
            * store starting location
            lda         13,u                    * First granule in file
            sta         Disk_FileCurGranule
            tfr         a,b
            lsra
            cmpa        #17
            blo         >
            inca
!           sta         Disk_FileCurTrack
            andb        #1
            lda         #9
            mul
            incb
            stb         Disk_FileCurSector
            clr         Disk_FileCurByte
            * calculate and store number of granules and sectors remaining
            ldd         14,u                    * number of bytes in use in last sector of file
            std         Disk_FileBytesInLastSec
            ldu         #Disk_FAT
            clr         Disk_FileGranulesLeft
            ldd         #$900                   * assume the file is at least 1 granule long
            std         Disk_FileBytesInCurGran
            ldb         Disk_FileCurGranule
FileLengthLoop@
            lda         b,u
 IFDEF DISK_DEBUG
            cmpa        #$ff
            bne         >
            swi                                 * error in FAT: file points to empty granule
 ENDC
!           cmpa        #$C0
            bhs         LastGranule@
            inc         Disk_FileGranulesLeft
            tfr         a,b
            bra         FileLengthLoop@
LastGranule@
            tst         Disk_FileGranulesLeft   * is this file > 1 granule?
            bne         >
            anda        #$1f                    * no, so calculate size of current (final) granule
            clrb
            addd        Disk_FileBytesInLastSec
            deca
            std         Disk_FileBytesInCurGran
!           rts


***********************************************************
* Disk_FileSeekForward_Impl:
*
* - IN:      D = distance to seek in bytes
* - OUT:     N/A
* - Trashed: A,B,X,U
***********************************************************
*
SeekDistance@           rmd 1
*
Disk_FileSeekForward_Impl
            std         SeekDistance@
            bne         NonZeroSeek@
            rts                                 * seek 0 is NOP
NonZeroSeek@
 IFDEF DISK_DEBUG
            tst         Disk_FileAtEnd
            beq         >
            swi                                 * seek past end of file
!           tst         Disk_FileIsOpen
            bne         >
            swi                                 * error, file is not open
 ENDC
!           cmpd        Disk_FileBytesInCurGran * is the seeking end point in this granule?
            bhs         NotInThisGranule@
            * update counter of remaining bytes in current granule
            ldd         Disk_FileBytesInCurGran
            subd        SeekDistance@
            std         Disk_FileBytesInCurGran
            * update current sector/byte
            ldd         SeekDistance@
            addd        Disk_FileCurSector      * updated sector/byte location
            std         Disk_FileCurSector
            rts
NotInThisGranule@
            subd        Disk_FileBytesInCurGran * D is remaining bytes to seek forward after current granule
            tst         Disk_FileGranulesLeft   * are there any remaining granules in this file?
            bne         SeekNextGranule@
            cmpd        #0                      * no granules left, so we better be at end of file
            beq         >
            swi                                 * Error: seek past end of file
 IFDEF DISK_DEBUG
!           inc         Disk_FileAtEnd
 ENDC
!           rts
SeekNextGranule@
            tfr         d,x                     * X = bytes to seek forward, starting w/ next granule
            lda         Disk_FileCurGranule
            ldu         #Disk_FAT
GetFATEntry@
            ldb         a,u                     * Get next granule
            dec         Disk_FileGranulesLeft
            cmpx        #$900                   * is the seek end point in this granule?
            blo         InThisGranule@
 IFDEF DISK_DEBUG
            cmpb        #$C0
            blo         >
            swi                                 * Error: seek past end of file
 ENDC
!           leax        -$900,x
            tfr         b,a
            bra         GetFATEntry@
InThisGranule@
            stx         SeekDistance@           * save the offset to seek within this granule
            stb         Disk_FileCurGranule     * B contains the granule number which includes our seek end point
            pshs        b
            lda         b,u
            cmpa        #$C0                    * is this granule full?
            blo         >
            anda        #$1F                    * no, it is partial, so calculate # of bytes in last granule
            clrb
            addd        Disk_FileBytesInLastSec
            deca
            bra         ReCalcPosition@
!           ldd         #$900
ReCalcPosition@
            subd        SeekDistance@
 IFDEF DISK_DEBUG
            bhs         >
            swi                                 * Error: seek past end of file
 ENDC
!           std         Disk_FileBytesInCurGran * bytes remaining in current granule after seek operation
            lda         ,s
            lsra
            cmpa        #17
            blo         >
            inca
!           sta         Disk_FileCurTrack
            puls        a
            anda        #1
            eora        #1
            deca
            anda        #9
            inca                                * B is starting sector # of new granule
            clrb
            addd        SeekDistance@           * D is final sector/byte of file pointer after seeking
            std         Disk_FileCurSector
            rts


***********************************************************
* Disk_FileClose_Impl:
*
* - IN:      N/A
* - OUT:     N/A
* - Trashed: None
***********************************************************
Disk_FileClose_Impl
 IFDEF DISK_DEBUG
            tst         Disk_FileIsOpen
            bne         >
            swi                                 * error, no file is open
!           clr         Disk_FileIsOpen
 ENDC
            clr         $FF40                   * turn off drive motor
            clr         $986                    * clear DGRAM also, so Disk BASIC knows that drive motor was shut off
            rts


***********************************************************
* Disk_SetProgressCallback_Impl:
*
* - IN:      X = address of callback function (or NULL)
* - OUT:     N/A
* - Trashed: None
***********************************************************
Disk_SetProgressCallback_Impl
            stx         Disk_ProgressCallback
            rts

