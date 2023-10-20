; =============================================================
; Macro to set VRAM write access
; Arguments:	1 - raw VRAM offset
;		2 - register to write access bitfield in (Optional)
; By: Vladikcomper
; -------------------------------------------------------------
vram	macro
	if (narg=1)
		move.l	#($40000000+((\1&$3FFF)<<16)+((\1&$C000)>>14)),($C00004).l
	else
		move.l	#($40000000+((\1&$3FFF)<<16)+((\1&$C000)>>14)),\2
	endc
	endm


; =============================================================
; Macro to wait for VBlank
; By: Rivet
; -------------------------------------------------------------
WaitVBlank:    macro
        clr.b    (VBlankFlag).w
    @WaitVBlank\@:
        tst.b    (VBlankFlag).w
        beq.s    @WaitVBlank\@
    endm