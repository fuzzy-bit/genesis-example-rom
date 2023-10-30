ConsoleName:        dc.b	"SEGA MEGA DRIVE "
ProductDate:        dc.b	"(C)EZRA 2022    "
TitleLocal:         dc.b	"TEST ROM                                        "
TitleInter:         dc.b	"TEST ROM                                        "
SerialNumber:       dc.b	"GM 0123456789A"
Checksum:           dc.w	$0000
IOSupport:          dc.b	"J               "
ROMStart:           dc.l	StartOfROM
ROMFinish:          dc.l	EndOfROM-$01
RAMStart:           dc.l	$00FF0000
RAMFinish:          dc.l	$00FFFFFF
SupportRAM:         dc.l	$20202020	; dc.b	'RA',%11111000,%00100000
SRAMStart:          dc.l	$20202020	; $00200000
SRAMFinish:         dc.l	$20202020	; $002003FF
ModemInfo:          dc.b	"                                                    "
ProductRegion:      dc.b	"JUE             "
