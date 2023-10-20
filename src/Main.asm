; ===========================================================================
; Initialize ROM
; ===========================================================================
; Vector Table
; ---------------------------------------------------------------------------
StartOfROM:	
		dc.l	$00000000, EntryPoint, $00000000, $00000000	; Initial Stack Pointer, Entry Point, Bus Error, Address Error
		dc.l	$00000000, $00000000, $00000000, $00000000	; Illegal Instruction, Divide By Zero, CHK Exception, TRAPV Exception
		dc.l	$00000000, $00000000, $00000000, $00000000	; Privilege Violation, TRACE Exception, Line A Emulator, Line F Emulator
		dc.l	$00000000, $00000000, $00000000, $00000000	; Reserved, Co-Processor Protocol Violation, Format Error, Uninitialized Interrupt
		dc.l	$00000000, $00000000, $00000000, $00000000	; Reserved, Reserved, Reserved, Reserved
		dc.l	$00000000, $00000000, $00000000, $00000000	; Reserved, Reserved, Reserved, Reserved
		dc.l	$00000000, $00000000, $00000000, $00000000	; Spurious Interrupt, IRQ Level 1, IRQ Level 2, IRQ Level 3,
		dc.l	$00000000, $00000000, VBlank,	 $00000000	; Horizontal Interrput, IRQ Level 5, VBlank
		dc.l	$00000000, $00000000, $00000000, $00000000	; TRAP 0, TRAP 1, TRAP 2, TRAP 3
		dc.l	$00000000, $00000000, $00000000, $00000000	; TRAP 4, TRAP 5, TRAP 6, TRAP 7
		dc.l	$00000000, $00000000, $00000000, $00000000	; TRAP 8, TRAP 9, TRAP A, TRAP B
		dc.l	$00000000, $00000000, $00000000, $00000000	; TRAP C, TRAP D, TRAP E, TRAP F
		dc.l	$00000000, $00000000, $00000000, $00000000	; Floating Point Reserved, Floating Point Reserved, Floating Point Reserved, Floating Point Reserved
		dc.l	$00000000, $00000000, $00000000, $00000000	; Floating Point Reserved, Floating Point Reserved, Floating Point Reserved, Floating Point Reserved
		dc.l	$00000000, $00000000, $00000000, $00000000	; MMU Reserved, MMU Reserved, MMU Reserved, Reserved
		dc.l	$00000000, $00000000, $00000000, $00000000	; Reserved, Reserved, Reserved, Reserved

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
		move.b	($A10001).l, d0				; load hardware version/region
		andi.l	#$0F, d0				; get only the version number
		beq.s	NoTMSS					; if the version is 0, branch (no TMSS in this machine)
		move.l	(ConsoleName).w, ($A14000).l		; give TMSS the string "SEGA" so it unlocks the VDP
		moveq	#$00, d0				; clear d0

NoTMSS:
		move.w	#$0100, d1				; prepare Z80 value/VDP register increment
		move.w	d1, ($A11100).l				; request Z80 to stop
		move.w	d0, ($A11200).l				; request Z80 reset on (resets YM2612)
		
		lea	($C00000).l, a5				; load VDP data port
		lea	$04(a5), a6				; load VDP control port
		
		move.w  #$8100|%01100100, VDPControl		; turn on screen, enable vblank, and set resolution
		move.w  #$8000|%00000100, VDPControl		; disable low-color mode
		move.w  #$2300, sr				; enable VBlank on CPU

; ===========================================================================
; Main Program
; ===========================================================================
		bsr.w	InitializeVDP				; initialize vdp
		
		; make a small palette
		move.w 	#$0E00,	VDPDataPort			; palette 0 slot 0
		move.w 	#$0EE0,	VDPDataPort			; palette 0 slot 1

MainLoop:
		WaitVBlank						; wait for vblank
		vram	$0000					; set control port to beginning of VRAM
		
		lea 	TestTile, a0				; set a0 to point to tile data
		move.w	#7, d0					; loop loading for 8 lines
		bsr.w	LoadTiles				; load tiles into vram
		
		bra.w	MainLoop				; loop endlessly

; ===========================================================================
; VBlank routine
; ===========================================================================
VBlank:
		move.b	#1, VBlankFlag			; set vblank flag to true
		rte
		
		
		
; ---------------------------------------------------------------------------
; Includes
; ---------------------------------------------------------------------------
		include "src/System/VDP/InitializeVDP.asm"
		include "src/System/VDP/LoadTiles.asm"

TestTile:
		incbin "res/Tiles/TestTile.bin"	

EndOfROM:	END
