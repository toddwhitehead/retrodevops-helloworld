;============================================================
; Retrodevops game-loader demo 
;
; A simple helloworld demo with a whole of C64 style rubbed all over it.
; Displays some text messages with colorwash effect and a SID playing
; for that authentic 1980's vibe.
;
; Based on excellent tutorial: http://dustlayer.coacmem/c64-coding-tutorials/2013/2/17/a-simple-c64-intro
;============================================================

;============================================================
; Setup the output format options here or can be specified as parameters
; at assemble time

!cpu 6502
;!to "build/gameloader.prg",cbm    ; specify output file

;==========================================================
; LABELS

address_music = $1000 ; loading address for sid tune
sid_init = $1000      ; init routine for music
sid_play = $1006      ; play music routine

;============================================================
; BASIC loader with start address $c000
;============================================================

* = $0801                               ; BASIC start address (#2049)
!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152
* = $c000     				            ; start address for 6502 code

;============================================================
; No concept of project/solutuion file so we include all
; the other code we need explicitly

!source "code/main.asm"              ; Main routine with IRQ setup and custom IRQ routine
!source "code/data_static_text.asm"  ; Tables and strings of data 
!source "code/data_colorwash.asm"
!source "code/init_clear_screen.asm" ; One-time initialization routines
!source "code/init_static_text.asm"

;============================================================
;    subroutines called during custom IRQ

!source "code/sub_colorwash.asm"
!source "code/sub_music.asm"

;============================================================
; load resource files (for this small intro its just the sid)

!source "code/load_resources.asm"