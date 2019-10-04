;============================================================
; write the three lines of text to screen center
; lda = load character from memory into the accumulator
; sta = store the value in the accumulator at the specified screen
;       memory location
;============================================================


init_text  ldx #$00          ; init X-Register with $00
loop_text  lda line1,x      ; read characters from line1 table of text...
           sta $0590,x      ; ...and store in screen ram at 1424 near the center
           lda line2,x      ; read characters from line2 table of text...
           sta $05e0,x      ; ...and put 2 rows below line1 1504
           lda line3,x      ; read characters from line3 table of text...
           sta $0630,x      ; ...and put 2 rows below line2 $0630

           inx              ; increment the value in the x register
           cpx #$28         ; finished when all 40 cols of a line are processed
           bne loop_text    ; loop if we are not done yet
           rts