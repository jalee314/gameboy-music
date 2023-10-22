;Project 2

INCLUDE "hardware.inc"
INCLUDE "frequencies.inc"

SECTION "CART_HEAD", ROM0[$100]

	jp Entry
	ds $150-@, 0

Entry:
	WaitVBlank:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank

	ld a, 0
	ld [rLCDC], a

	; Turn on all channels via port write
	ld a, %10000000
	ld [$FF26], a

	; Set master volume ($FF24 or rNR50):
	ld a, %01110111
	ld [rNR50], a

	note:
	; See https://gbdev.io/pandocs/Audio_Registers.html
	; #ff12--nr12-channel-1-volume--envelope
	;Channel 1 Vol: $FF12
	ld a, %01111000
	ld [$FF12], a

	;Retrigger channel
	ld a, %10000000
	ld [$FF14], a
	
	Play:
	; Check joypad port $FF00, bit 0 
	; for change in the RIGHT/A bit
	ld a, [$FF00]
	bit 0, a
	jp z, PlayE4

	bit 1, a
	jp z, PlayC4

	bit 2, a
	jp z, PlayG4

	bit 3, a
	jp z, PlayG3

notejump:	
	jp note
	
	PlayE4:
	ld a, [$FF00]
	bit 0, a
	jp z, CheckE4
	call NoSound
	jp note
	CheckE4:	
	ld b, HI_4
	ld c, E4L
	call PlayNote
	jp PlayE4

	PlayC4:
	ld a, [$FF00]
	bit 1, a
	jp z, CheckC4
	call NoSound
	jp note
	CheckC4:	
	ld b, HI_4
	ld c, C4L
	call PlayNote
	jp PlayC4

	PlayG4:	
	ld a, [$FF00]
	bit 2, a
	jp z, CheckG4
	call NoSound
	jp note
	CheckG4:	
	ld b, HI_4
	ld c, G4L
	call PlayNote
	jp PlayG4

	PlayG3:	
	ld a, [$FF00]
	bit 3, a
	jp z, CheckG3
	call NoSound
	jp note
	CheckG3:	
	ld b, HI_3
	ld c, G3L
	call PlayNote
	jp PlayG3
	
PlayNote:
	; write a single music note to port $FF13 & $FF14
	ld a, b
	ld [$FF14], a
	ld a, c
	ld [$FF13], a
	ret

NoSound:
	ld a, %00001000
	ld [$FF12], a
	ret
 	
