; FILE: ldosbioscall.s

;-------------------------------------------------------------------------------------------
;char _read_sector(unsigned char * buffer,unsigned char drive,unsigned char track,unsigned char sector);

_read_sector::

        
        ld      hl,#4
        add     hl,sp
        ld      c,(hl)   ;drive number

        ld      hl,#5
        add     hl,sp
        ld      d,(hl)   ;track number

        ld      hl,#6
        add     hl,sp
        ld      e,(hl)   ; sector number

        ld      hl,#2
        add     hl,sp
        ld      a,(hl)

        ld      hl,#3
        add     hl,sp
        ld      h,(hl)   ; PTR
        ld      l,a

        call  0x4777
        ld l,a

        ret

;-------------------------------------------------------------------------------------------
;char _write_sector(unsigned char * buffer,unsigned char drive,unsigned char track,unsigned char sector);

_write_sector::

        
        ld      hl,#4
        add     hl,sp
        ld      c,(hl)   ;drive number

        ld      hl,#5
        add     hl,sp
        ld      d,(hl)   ;track number

        ld      hl,#6
        add     hl,sp
        ld      e,(hl)   ; sector number

        ld      hl,#2
        add     hl,sp
        ld      a,(hl)

        ld      hl,#3
        add     hl,sp
        ld      h,(hl)   ; PTR
        ld      l,a

        call  0x4763
        ld l,a

        ret

;-------------------------------------------------------------------------------------------
;void _cfg_disk_drive(unsigned char * buffer);

_cfg_disk_drive::


        
        ret


;-------------------------------------------------------------------------------------------
;void _move_to_track(unsigned char track);

_move_to_track:: ;NEEDS LOOKING !!!!!!

        ld      c,#07
        call    0xb90f   ;ROM7 disquette


        LD HL,(#0xBE7D)
        LD E,(HL) ; lecteur courant dans A (0 ou 1)

        ld      hl,#2
        add     hl,sp
        ld      d,(hl)
        call 0xC045

        call    0xb903   ; disable upper ROM
        ret
;-------------------------------------------------------------------------------------------
;char _wait_key();

_wait_key::
        call  0x0049
        ld l,a

        ret

;char _wait_key2();

_wait_key2::
        call  0x0049
        ld l,a

        ret

;char _reboot();

_reboot::

        jp	0

;-------------------------------------------------------------------------------------------
;void _init_key(unsigned char c);

_init_key::

        ret
        
_init_all::

        ret

; IN: a = char to print
; IN: de = screen ptr
PrivatePrintChar:	
	ld	(de),a
	ret

; IN: a = char to print
; IN: de = screen ptr
PrivatePrintChar2:	
	ld l, a
	ld h, #0
	add hl, hl ; * 2
	add hl, hl ; * 4
	add hl, hl ; * 8
	ld bc, #0x9A00
	add hl, bc
	
	ld b, #8
	ld a, ( hl )
	ld ( de ), a
	inc hl
	set 3, d
	ld a, ( hl )
	ld ( de ), a
	inc hl
	ld a, d
	add a, b
	ld d, a
	ld a, ( hl )
	ld ( de ), a
	inc hl
	set 3, d
	ld a, ( hl )
	ld ( de ), a
	inc hl
	ld a, d
	add a, b
	ld d, a
	ld a, ( hl )
	ld ( de ), a
	inc hl
	set 3, d
	ld a, ( hl )
	ld ( de ), a
	inc hl
	ld a, d
	add a, b
	ld d, a
	ld a, ( hl )
	ld ( de ), a
	inc hl
	set 3, d
	ld a, ( hl )
	ld ( de ), a

	ret
	
;-------------------------------------------------------------------------------------------
;void fastPrintChar(unsigned char *screenBuffer, unsigned char c );
.globl _fastPrintChar
_fastPrintChar::
	pop bc
	pop de
	pop hl
	
	push hl
	push de
	push bc
	
	ld a, l
	call PrivatePrintChar	
	ret


;-------------------------------------------------------------------------------------------
;void fastPrintString(unsigned char *screenBuffer, unsigned char *string );
.globl _fastPrintString
_fastPrintString::
	pop bc
	pop de
	pop ix
	
	push ix
	push de
	push bc
	
	; ix = string
	; de = screenBuffer
	
	;.db 0xed, 0xff
	
fastPrintString_loop:
	ld a, ( ix )
	or a
	ret z
	inc ix
	push de
	call PrivatePrintChar
	pop de
	inc de
	jr fastPrintString_loop
	
;-------------------------------------------------------------------------------------------
;void clear_line(unsigned char y_pos);

_clear_line::

        ld      hl,#2
        add     hl,sp
        ld      a,(hl)
        
        ld hl, #0x3C00	;Start of TRS-80 video memory
        ld bc, #0x0040	;64 chars per line
        
        or a
        
clearLineCalcYLoop:
        jp z, endClearLineCalcY
        add hl, bc
        dec a
        jp clearLineCalcYLoop
        
endClearLineCalcY:

		ld a, #8
clearLineDrawLoop:	;NEEDS LOOKING!!!!!
		push af
		push hl
		ld d, h
		ld e, l
		inc de
		ld bc, #79
		ld ( hl ), #0
		ldir
		pop hl
		ld bc, #0x800
		add hl, bc
		pop af
		dec a
		jp nz, clearLineDrawLoop

        ret
        
;-------------------------------------------------------------------------------------------
;void invert_line(unsigned char y_pos);

_invert_line:: ;NEEDS LOOKING!!!!

        ld      hl,#2
        add     hl,sp
        ld      a,(hl)
        
        ld hl, #0xc000
        ld bc, #0x0050
        
        or a
        
invertLineCalcYLoop:
        jp z, endInvertLineCalcY
        add hl, bc
        dec a
        jp invertLineCalcYLoop
        
endInvertLineCalcY:

		ld a, #8
invertLineDrawLoop:
		push af
		push hl
		ld c, #79
invertLineDrawLoopScanline:
		ld a, (hl)
		xor #255
		ld ( hl ), a
		inc hl
		dec c
		jp nz, invertLineDrawLoopScanline
		pop hl
		ld bc, #0x800
		add hl, bc
		pop af
		dec a
		jp nz, invertLineDrawLoop

        ret