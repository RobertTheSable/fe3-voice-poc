lorom
!INDEX_FLAG = $10
!MEMORY_FLAG = $20

MSU_STATUS  =   $2000
MSU_READ    =   $2001
MSU_ID      =   $2002
MSU_SEEK    =   $2000
MSU_TRACK   =   $2004
MSU_VOLUME  =   $2006
MSU_CONTROL =   $2007

MSU_STATE_NOT_FOUND = %00001000
MSU_STATE_PLAYING = %00010000
MSU_STATE_BUSY = %01000000

TRACK_INDEX = $06C0
TRACK_STATUS = $06C2

; original algorithm for queueing text sfx
GOTO_SFX = $87c998
;

incsrc hooks.asm

ORG $87ed00
msu1StatusCheck:
    db "S-MSU1"
playMSU:
    pha
    phx
    phy
    php
    rep #(!MEMORY_FLAG|!INDEX_FLAG)
    lda TRACK_INDEX
    beq originalOperation ; if no track number is stored, use normal sound effects.
    dec
    tax
    sep #!MEMORY_FLAG
    ldy #$0005
availabilityCheckLoop:
    ; check that MSU1 is set up and available.
    lda.w MSU_ID,y
    cmp msu1StatusCheck,y
    bne originalOperation
    dey
    bpl availabilityCheckLoop
loadTrack:
    ; if Track status is not zero, another track was played.
    lda TRACK_STATUS
    bne end
    ; I thought checking the audio busy flag was required
    ; but it looks like audio is always busy and it can be ignored.
;     lda.w MSU_STATUS
;     bit.b #MSU_STATE_BUSY
;     bne end
    lda.b #$00
    sta.w MSU_CONTROL
    lda.b #$FF
    sta.w MSU_VOLUME
    stx.w MSU_TRACK
    lda.b #$01
    sta.w MSU_CONTROL
    lda.w MSU_STATUS
    bit.b #MSU_STATE_NOT_FOUND
    bne originalOperation
    inc.w TRACK_INDEX
    lda.b #$01
    sta.w TRACK_STATUS
end:
    plp
    ply
    plx
    pla
    rts
originalOperation:
    plp
    ply
    plx
    pla
    jmp normalTextSFX
storeTrackHook:
    ; use the dialogue table index to load the track number as well.
    lda [$0f],y
    pha
    phx
    php
    rep #$10
    asl
    tax
    lda.w trackIndexes,x
    sta $06C0
    plp
    plx
    pla
    asl
    rts
trackIndexes:
    incsrc trackindexes.asm
forceStopTrack:
    ; set the track status to zero after text is unpaused so that the next track can be played.
    php
    sep #!MEMORY_FLAG
    lda.w TRACK_STATUS
    beq nothingPlaying
    stz.w TRACK_STATUS
nothingPlaying:
    plp
    jml $87b0ff
endTextHook:
    ; once text is done, we need to 0 out the memory locations used for track info
    phx
    php
    sep #(!MEMORY_FLAG|!INDEX_FLAG)
    ldx #$02
resetTrackInfo:
    stz.w TRACK_INDEX,x
    dex
    bpl resetTrackInfo
    plp
    plx
    jmp endText
