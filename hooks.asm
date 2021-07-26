SPC_SONG_NUMBER_STORE = $0876
; chere the game jumps from to

ORG $87c0ca
    jsr $c998

ORG $87c998
    lda $0f09
    cmp #$00ff ; FF = player is skipping text
    beq scrollCheck2
    cmp #$0001 ; 01 = highest text speed
    bne textScrolls
scrollCheck2:
    lda $0137 ; frame count
    bit #$0001 ; At the highest speed, only queue sound effects every other frame.
    bne noSFX
textScrolls:
    lda $0f10
    and #$00ff
    asl
    tax
    jmp ($c9b8,x)
dw noSFX
dw playMSU
dw mapTextSFX
dw normalTextSFXDuplicate
dw normalTextSFX
dw normalTextSFX
dw normalTextSFX
dw normalTextSFX
dw normalTextSFX
dw normalTextSFX
dw normalTextSFX

ORG $87836e
    ; original location for code for loading text pointers
    jsr storeTrackHook
    clc
    adc [$0f],y
    clc
    adc.W #$9213

; original code for queueing sound effects for text
ORG $87C9CE
normalTextSFX:
    LDA #$0079
    JSL $80aa16
    rts
ORG $87C9D6
mapTextSFX:
    LDA #$0025
    JSL $80aa16
    rts
ORG $87C9DE
normalTextSFXDuplicate:
    LDA #$0079
    JSL $80aa16
    rts

ORG $87C9E5
noSFX:
    rts

ORG $87ca00
; text command pointer table
    dw endTextHook ; originally endText

ORG $87CA30
; original code for when
endText:
;     sep #$20
;     stz $0fa1
;     rep #$20
;     stz $0f05
;     stz $0f09
;     pla
;     sec
;     rts

ORG $87ad4a
    rep #$20
    lda $0f8a
    ldx $0f44
    sta $7e3000,x   ; removes the hole in the bg layer for the waiting arrow.
    lda $50
    sec
    sbc #$0004
    tax
    lda #$f400      ; ???
    sta $0210,x
    sta $0214,x
    sta $0218,x
    sta $021c,x
    pla
    sta $0c1b       ; text box width?
    pla
    sta $50         ; something to do with character portraits
    sta $52
    jsl forceStopTrack
    jsl $809374
    plp
    rtl
