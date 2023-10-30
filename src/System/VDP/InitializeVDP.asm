; ===========================================================================
; Subroutine - InitializeVDP.asm
; ---------------------------------------------------------------------------
; Description:
; 		Initializes the VDP for the main program
; 
; Parameters:
; 		N/A
; ===========================================================================
InitializeVDP:
		move.w	#$8F02, VDPControl          ; auto-increment register (by 2)
		move.w	#$8230, VDPControl          ; set plane A vram address
		move.w	#$832C, VDPControl          ; set window table vram address
		move.w	#$8407, VDPControl          ; set plane B vram address
		move.w	#$8578, VDPControl          ; set sprite table vram address
		move.l	#$C0000000, VDPControl      ; beginning of color RAM (CRAM)

		rts
