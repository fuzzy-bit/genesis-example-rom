; ===========================================================================
; Subroutine - LoadTiles.asm
; ---------------------------------------------------------------------------
; Description:
; 		Load tiles to VRAM
; 
; Parameters:
; 		a0: Tile data
;		d0: Size of tile data in longwords
; ===========================================================================
LoadTiles:
		move.l  (a0)+, VDPDataPort
		dbra    d0, LoadTiles
		
		rts
