;=======================================
; Retro Devops
; Hello World 80's Style
; 
; Based on the great tutorials at http://tnd64.unikat.sk/assemble_it.html
;=======================================

; Basic loader so the demo can start when you type run
*= $0801                                ; BASIC start address (#2049)
!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152
    				        ; start address for 6502 code

;call out some variables and positions for those variables
scrollpos = $2700 ;this is where the scrolltext will be
                  ;read from memory

scrreel  = $0330 ;the scroll control
flashdat1 = $2400
flashdat2 = $2500

*= $c000 

         sei

         lda #<scrollpos ;initialise
         sta msg+1       ;the message
         lda #>scrollpos ;so after each
         sta msg+2       ;run the
                         ;scrolltext
                         ;restarts at
                         ;$2700

;set up the charset and then blank the
;screen using - lda #$20 -, #$20
;represents spacebar.

         lda #$18   ;change charset
         sta $d018  ;to read from $2000

         ldx #$00    ;start of loop

clear    lda #$20    ;clear the screen
         sta $0400,x ;and fill with the
         sta $0500,x ;spacebar character
         sta $0600,x ;so that it all
         sta $06e8,x ;clears
         lda #$01
         sta $d800,x
         sta $d900,x
         sta $da00,x
         sta $dae8,x
         inx         ;count process 256
                     ;times. if not 256
                     ;then send the loop
         bne clear   ;to -clear- prompt

;setup the char ('@') for those lines,
;which the colours will wash across.

         ldx #$00    ;our loop
plot     lda #$00    ;
         sta $0400,x ;fill with '@' 240
         sta $06f8,x ;times at the top
         inx         ;and bottom portion
         cpx #$f0    ;of the screen
         bne plot

         ldx #$00    ;
linemesg lda line1,x ;copy the text from
         sta $0522,x ;$2600+ to $0522+
         ora #$40    ;read half charset
         sta $054a,x ;copy same text but
                     ;to $054a+

         lda line2,x ;copy the text from
         sta $068a,x ;$2620+ to $068a+
         ora #$40    ;read half charset
         sta $06b2,x ;copy same text but
                     ;to $06b2+

         inx         ;perform process 18
         cpx #$13    ;times else call
         bne linemesg;loop

;set up the irq raster interrupt player
;routines
         lda #<int
         sta $0314
         lda #>int
         sta $0315
         lda #$00
         sta $d012
         lda #$7f
         sta $dc0d
         sta $dd0d
         lda #$01
         sta $d019
         sta $d01a
         lda #$00
         tax
         tay
         jsr $1000
         cli
         jmp *-1 ;this is different but
                 ;works well.

int      inc $d019

;this is where we read all the flashing
;datas. 
         lda flashdat1+$00
         sta flashdat1+$50
         lda flashdat1+$80
         sta flashdat1+$d0
         lda flashdat2+$80
         sta flashdat2+$d0
         ldx #$00
scroll1  lda flashdat1+$01,x
         sta flashdat1+$00,x
         lda flashdat1+$81,x
         sta flashdat1+$80,x
         lda flashdat2+$81,x
         sta flashdat2+$80,x
         inx
         cpx #$50
         bne scroll1

         lda flashdat2+$50
         sta flashdat2+$00
         lda flashdat2+$00
         sta flashdat2+$01
         ldx #$50
scroll2  lda flashdat2+$00,x
         sta flashdat2+$01,x
         dex
         bne scroll2
         ldx #0
paint    lda flashdat1+$00,x
         sta $d800,x
         sta $d828,x
         sta $d850,x
         sta $d878,x
         sta $d8a0,x
         sta $d8c8,x
         sta $d8f0,x
         lda flashdat1+$80
         sta $d918,x
         sta $d940,x
         sta $da80,x
         sta $daa8,x
         inx
         cpx #40
         bne paint
         ldy #0
flash2   lda flashdat2+$00,y
         sta $dad0,y
         sta $daf8,y
         sta $db20,y
         sta $db48,y
         sta $db70,y
         sta $db98,y
         sta $dbc0,y
         iny
         cpy #40
         bne flash2

;our raster screen cuts to divide areas of the screen

         lda #$7c
raster1  cmp $d012  ; perform cut
         bne raster1
         lda #$00   ; screen is cut so
         sta $d021  ; we have a black
         sta $d020  ; background and a
         jsr scroll ; nifty scroll text

         lda #$90     ;
raster1b cmp $d012    ; perform cut
         bne raster1b ;
         ldx #$0a     ; add timing so
time1    dex          ; that we kill the
         bne time1    ; flickering

         lda $2580    ; this time here,
         sta $d021    ; we have a
         sta $d020    ; flashing bar

         lda #$a4     ; our final cut
raster2  cmp $d012    ; to the screen to
         bne raster2  ; make a still
         ldx #$0a     ; screen with no
time2    dex          ; flashing bar,
         bne time2    ; and also keep
         lda #$00     ; that portion of
         sta $d021    ; the screen
         sta $d020    ; black!

         lda #$08     ; still screen
         sta $d016    ;

         jsr $1003    ;play music

         lda $dc01    ;read spacebar if
         cmp #$ef     ;not pressed
         bne main     ;then jump to main
                      ;prompt

         jmp $fce2    ;reset c64
main     jmp $ea31


;our scrolltext for the intro

scroll   ldy #$00    ; controlling the
loop     dec scrreel ; smoothness for
         lda scrreel ; our scrolltext
         and #$07    ; message using
         sta $d016   ; the screen x-pos
         cmp #$07    ; and counting 7
         bne control ; times else
                     ; move to the
                     ; control sequence

         ldx #$00
message  lda $05e1,x ; pull characters
         sta $05e0,x ; for the scroll
         lda $0609,x ; text
         sta $0608,x ;
         inx
         cpx #$28

         bne message

msg      lda $0607   ;check $0607 (the
                     ;very last char on
                     ;the middle line)

         cmp #$00    ;is '@' (wrap mark)
                     ;read? if not then
         bne end     ;jump to end prompt

         lda #<scrollpos ;reset msg+1
         sta msg+1       ;and msg+2 so
         lda #>scrollpos ;that the text
         sta msg+2       ;will restart
         jmp msg         ;then jump msg

end      sta $0607 ;place character, read from scrollpos
         ora #$40  ;calculate half cset
         sta $062f ;place other half of
                   ;cset at bottom

         inc msg+1 ;increment msg+1 by one character so
         lda msg+1 ;that it will read the next character
                   ;for the message in memory

         cmp #$00  ;is the reset counter ('@') marked? if not
                   ;then jump to control
         bne control
         inc msg+2 ;do the same for the

control  iny       ;next message counter

         cpy #$02  ;speed of our scroll
         bne loop
         rts

;end!

;Insert music:
	*= $1000-2
	!binary "musicdata.prg"

;Insert 1x2 charset
	*= $2000-2
	!binary "1x2charset.prg"

;Insert flashcolours data
	*= $2400-2
	!binary "colours.prg"

;Insert 1-liner presentation text here
	
	*= $2600-2  
        line1 !scr "   hello world      "
        line2 !scr "   1980's style     "

;Insert scrolltext data
	*= $2700-2
        !scr "  greetings ndc sydney - do devops - "
        !scr "deliver value - be excellent to each other - "               
        !byte 0 ;SETS @  
;END
