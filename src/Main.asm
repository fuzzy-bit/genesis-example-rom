; ===========================================================================
; Initialize ROM
; ===========================================================================
; Vector Table
; ---------------------------------------------------------------------------
StartROM:	
		dc.l	$00000000, EntryPoint, $00000000, $00000000	; TODO: FILL THESE COMMENTS OUT LATER
		dc.l	$00000000, $00000000, $00000000, $00000000	; 
		dc.l	$00000000, $00000000, $00000000, $00000000	; 
		dc.l	$00000000, $00000000, $00000000, $00000000	; 
		dc.l	$00000000, $00000000, $00000000, $00000000	; 
		dc.l	$00000000, $00000000, $00000000, $00000000	; 
		dc.l	$00000000, $00000000, $00000000, $00000000	; 
		dc.l	$00000000, $00000000, VBlank,	   $00000000	; screw it let's just do what rivet tells me to do 
		dc.l	$00000000, $00000000, $00000000, $00000000	; 
		dc.l	$00000000, $00000000, $00000000, $00000000	; 
		dc.l	$00000000, $00000000, $00000000, $00000000	; 
		dc.l	$00000000, $00000000, $00000000, $00000000	; 
		dc.l	$00000000, $00000000, $00000000, $00000000	; 
		dc.l	$00000000, $00000000, $00000000, $00000000	; 
		dc.l	$00000000, $00000000, $00000000, $00000000	; 
		dc.l	$00000000, $00000000, $00000000, $00000000	; 

; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------
		include "src/System/Header.asm"
	
; ---------------------------------------------------------------------------
; Macros & Constants
; ---------------------------------------------------------------------------
		include "src/Macros.asm"
		include "src/Constants.asm"



; ===========================================================================
; Start of code (Setup)
; ===========================================================================
EntryPoint:
		move.b	($A10001).l,d0			; load hardware version/region
		andi.l	#$0F,d0							; get only the version number
		beq.s	NoTMSS							; if the version is 0, branch (no TMSS in this machine)
		move.l	(ConsoleName).w,($A14000).l	; give TMSS the string "SEGA" so it unlocks the VDP
		moveq	#$00,d0							; clear d0

NoTMSS:
		move.w	#$0100,d1					; prepare Z80 value/VDP register increment
		move.w	d1,($A11100).l			; request Z80 to stop
		move.w	d0,($A11200).l			; request Z80 reset on (resets YM2612)
		
		lea	($C00000).l,a5					; load VDP data port
		lea	$04(a5),a6							; load VDP control port
		
		move.w  #$8100|%01100100, VDPControl	; turn on screen, enable vblank, and set resolution
		move.w  #$8000|%00000100, VDPControl	; disable low-color mode
		move.w  #$2300, sr					; enable VBlank on CPU



; ===========================================================================
; Main Program
; ===========================================================================
		bsr.w	InitializeVDP				; initialize vdp
		
		; load palette (temporary)
		move.w 	#$0E00,	VDPDataPort			; palette 0 slot 0
		move.w 	#$0EE0,	VDPDataPort			; palette 0 slot 1
MainLoop:
		WaitVBL									; wait for vblank
		vram	$0000							; set control port to beginning of VRAM
		
		lea 	TestTile, a0						; set a0 to point to tile data
		move.w	#7, d0						; loop loading for 8 lines
		bsr.w	LoadTiles					; load tiles into vram
		
		bra.w	MainLoop					; loop endlessly

VBlank:
		move.b	#1, (VBFlag)			; set vblank flag to true
		rte
		
		
		
; ===========================================================================
; Includes
; ===========================================================================
		include "src/System/VDP/InitializeVDP.asm"
		include "src/System/VDP/LoadTiles.asm"

TestTile:
		incbin "res/Tiles/TestTile.bin"	

FinishROM:	END