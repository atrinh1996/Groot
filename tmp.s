	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 12, 0
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #144                    ; =144
	stp	x20, x19, [sp, #112]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #128]            ; 16-byte Folded Spill
	.cfi_def_cfa_offset 144
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
Lloh0:
	adrp	x8, __anon0@PAGE
Lloh1:
	adrp	x9, __add1_1@PAGE
	add	x10, sp, #104                   ; =104
Lloh2:
	adrp	x11, __anon1@PAGE
Lloh3:
	add	x8, x8, __anon0@PAGEOFF
Lloh4:
	add	x11, x11, __anon1@PAGEOFF
	str	x10, [x9, __add1_1@PAGEOFF]
Lloh5:
	adrp	x9, __retx_1@PAGE
	add	x10, sp, #88                    ; =88
	str	x10, [x9, __retx_1@PAGEOFF]
	stp	x11, x8, [sp, #96]
Lloh6:
	adrp	x8, __anon2@PAGE
Lloh7:
	adrp	x10, __anon4@PAGE
	adrp	x20, __sub1_1@PAGE
	add	x9, sp, #96                     ; =96
Lloh8:
	add	x8, x8, __anon2@PAGEOFF
Lloh9:
	add	x10, x10, __anon4@PAGEOFF
	str	x9, [x20, __sub1_1@PAGEOFF]
	adrp	x9, __callFunc_1@PAGE
	stp	x10, x8, [sp, #80]
	add	x8, sp, #80                     ; =80
	add	x0, sp, #104                    ; =104
	mov	w1, #41
	str	x8, [x9, __callFunc_1@PAGEOFF]
	blr	x10
Lloh10:
	adrp	x19, l_fmt@PAGE
                                        ; kill: def $w0 killed $w0 def $x0
Lloh11:
	add	x19, x19, l_fmt@PAGEOFF
	str	x0, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x0, [x20, __sub1_1@PAGEOFF]
Lloh12:
	adrp	x8, __anon5@PAGE
Lloh13:
	add	x8, x8, __anon5@PAGEOFF
	adrp	x9, __callFunc_2@PAGE
	add	x10, sp, #72                    ; =72
	mov	w1, #43
	str	x8, [sp, #72]
	str	x10, [x9, __callFunc_2@PAGEOFF]
	blr	x8
                                        ; kill: def $w0 killed $w0 def $x0
	str	x0, [sp]
	mov	x0, x19
	bl	_printf
Lloh14:
	adrp	x8, __anon7@PAGE
Lloh15:
	adrp	x11, __anon6@PAGE
Lloh16:
	adrp	x1, l_globalChar@PAGE
Lloh17:
	add	x8, x8, __anon7@PAGEOFF
	adrp	x9, __retx_2@PAGE
	add	x10, sp, #64                    ; =64
Lloh18:
	add	x11, x11, __anon6@PAGEOFF
	adrp	x12, __callFunc_3@PAGE
	add	x13, sp, #56                    ; =56
Lloh19:
	add	x1, x1, l_globalChar@PAGEOFF
	add	x0, sp, #64                     ; =64
	stp	x11, x8, [sp, #56]
	str	x10, [x9, __retx_2@PAGEOFF]
	str	x13, [x12, __callFunc_3@PAGEOFF]
	str	x1, [sp, #48]
	blr	x11
	bl	_puts
Lloh20:
	adrp	x8, __anon9@PAGE
Lloh21:
	adrp	x11, __anon8@PAGE
Lloh22:
	add	x8, x8, __anon9@PAGEOFF
	adrp	x9, __retx_3@PAGE
	add	x10, sp, #40                    ; =40
Lloh23:
	add	x11, x11, __anon8@PAGEOFF
	adrp	x12, __callFunc_4@PAGE
	add	x13, sp, #32                    ; =32
	add	x0, sp, #40                     ; =40
	mov	w1, #42
	stp	x11, x8, [sp, #32]
	str	x10, [x9, __retx_3@PAGEOFF]
	str	x13, [x12, __callFunc_4@PAGEOFF]
	blr	x11
                                        ; kill: def $w0 killed $w0 def $x0
	str	x0, [sp]
	mov	x0, x19
	bl	_printf
Lloh24:
	adrp	x8, __anon11@PAGE
Lloh25:
	adrp	x11, __anon10@PAGE
Lloh26:
	add	x8, x8, __anon11@PAGEOFF
	adrp	x9, __retx_4@PAGE
	add	x10, sp, #24                    ; =24
Lloh27:
	add	x11, x11, __anon10@PAGEOFF
	adrp	x12, __callFunc_5@PAGE
	add	x13, sp, #16                    ; =16
	add	x0, sp, #24                     ; =24
	mov	w1, #1
	stp	x11, x8, [sp, #16]
	str	x10, [x9, __retx_4@PAGEOFF]
	str	x13, [x12, __callFunc_5@PAGEOFF]
	blr	x11
Lloh28:
	adrp	x0, l_boolF@PAGE
Lloh29:
	add	x0, x0, l_boolF@PAGEOFF
	bl	_puts
	ldp	x29, x30, [sp, #128]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #112]            ; 16-byte Folded Reload
	mov	w0, wzr
	add	sp, sp, #144                    ; =144
	ret
	.loh AdrpAdd	Lloh28, Lloh29
	.loh AdrpAdd	Lloh25, Lloh27
	.loh AdrpAdd	Lloh24, Lloh26
	.loh AdrpAdd	Lloh21, Lloh23
	.loh AdrpAdd	Lloh20, Lloh22
	.loh AdrpAdd	Lloh16, Lloh19
	.loh AdrpAdd	Lloh15, Lloh18
	.loh AdrpAdd	Lloh14, Lloh17
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh7, Lloh9
	.loh AdrpAdd	Lloh6, Lloh8
	.loh AdrpAdd	Lloh2, Lloh4
	.loh AdrpAdrp	Lloh1, Lloh5
	.loh AdrpAdd	Lloh0, Lloh3
	.cfi_endproc
                                        ; -- End function
	.globl	__anon10                        ; -- Begin function _anon10
	.p2align	2
__anon10:                               ; @_anon10
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #32                     ; =32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x8, [x0]
	str	x0, [sp, #8]
	and	w0, w1, #0x1
	strb	w0, [sp, #7]
	blr	x8
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	and	w0, w0, #0x1
	add	sp, sp, #32                     ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__anon11                        ; -- Begin function _anon11
	.p2align	2
__anon11:                               ; @_anon11
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #16                     ; =16
	.cfi_def_cfa_offset 16
	and	w0, w0, #0x1
	strb	w0, [sp, #15]
	add	sp, sp, #16                     ; =16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__anon8                         ; -- Begin function _anon8
	.p2align	2
__anon8:                                ; @_anon8
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #32                     ; =32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x8, [x0]
	str	x0, [sp, #8]
	mov	w0, w1
	str	w1, [sp, #4]
	blr	x8
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32                     ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__anon9                         ; -- Begin function _anon9
	.p2align	2
__anon9:                                ; @_anon9
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #16                     ; =16
	.cfi_def_cfa_offset 16
	str	w0, [sp, #12]
	add	sp, sp, #16                     ; =16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__anon6                         ; -- Begin function _anon6
	.p2align	2
__anon6:                                ; @_anon6
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #32                     ; =32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x8, [x0]
	stp	x1, x0, [sp]
	mov	x0, x1
	blr	x8
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32                     ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__anon7                         ; -- Begin function _anon7
	.p2align	2
__anon7:                                ; @_anon7
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #16                     ; =16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	add	sp, sp, #16                     ; =16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__anon5                         ; -- Begin function _anon5
	.p2align	2
__anon5:                                ; @_anon5
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #32                     ; =32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x8, [x0]
	str	x0, [sp, #8]
	mov	w0, w1
	str	w1, [sp, #4]
	blr	x8
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32                     ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__anon4                         ; -- Begin function _anon4
	.p2align	2
__anon4:                                ; @_anon4
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #32                     ; =32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x8, [x0]
	str	x0, [sp, #8]
	mov	w0, w1
	str	w1, [sp, #4]
	blr	x8
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32                     ; =32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__anon2                         ; -- Begin function _anon2
	.p2align	2
__anon2:                                ; @_anon2
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #16                     ; =16
	.cfi_def_cfa_offset 16
	str	w0, [sp, #12]
	add	sp, sp, #16                     ; =16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__anon1                         ; -- Begin function _anon1
	.p2align	2
__anon1:                                ; @_anon1
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #16                     ; =16
	.cfi_def_cfa_offset 16
	sub	w8, w0, #1                      ; =1
	str	w0, [sp, #12]
	mov	w0, w8
	add	sp, sp, #16                     ; =16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__anon0                         ; -- Begin function _anon0
	.p2align	2
__anon0:                                ; @_anon0
	.cfi_startproc
; %bb.0:                                ; %entry
	sub	sp, sp, #16                     ; =16
	.cfi_def_cfa_offset 16
	add	w8, w0, #1                      ; =1
	str	w0, [sp, #12]
	mov	w0, w8
	add	sp, sp, #16                     ; =16
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_fmt:                                  ; @fmt
	.asciz	"%d\n"

l_boolT:                                ; @boolT
	.asciz	"#t"

l_boolF:                                ; @boolF
	.asciz	"#f"

	.globl	___anon0_1                      ; @__anon0_1
.zerofill __DATA,__common,___anon0_1,8,3
	.globl	___anon1_1                      ; @__anon1_1
.zerofill __DATA,__common,___anon1_1,8,3
	.globl	___anon10_1                     ; @__anon10_1
.zerofill __DATA,__common,___anon10_1,8,3
	.globl	___anon11_1                     ; @__anon11_1
.zerofill __DATA,__common,___anon11_1,8,3
	.globl	___anon2_1                      ; @__anon2_1
.zerofill __DATA,__common,___anon2_1,8,3
	.globl	___anon4_1                      ; @__anon4_1
.zerofill __DATA,__common,___anon4_1,8,3
	.globl	___anon5_1                      ; @__anon5_1
.zerofill __DATA,__common,___anon5_1,8,3
	.globl	___anon6_1                      ; @__anon6_1
.zerofill __DATA,__common,___anon6_1,8,3
	.globl	___anon7_1                      ; @__anon7_1
.zerofill __DATA,__common,___anon7_1,8,3
	.globl	___anon8_1                      ; @__anon8_1
.zerofill __DATA,__common,___anon8_1,8,3
	.globl	___anon9_1                      ; @__anon9_1
.zerofill __DATA,__common,___anon9_1,8,3
	.globl	__add1_1                        ; @_add1_1
.zerofill __DATA,__common,__add1_1,8,3
	.globl	__callFunc_5                    ; @_callFunc_5
.zerofill __DATA,__common,__callFunc_5,8,3
	.globl	__callFunc_4                    ; @_callFunc_4
.zerofill __DATA,__common,__callFunc_4,8,3
	.globl	__callFunc_3                    ; @_callFunc_3
.zerofill __DATA,__common,__callFunc_3,8,3
	.globl	__callFunc_2                    ; @_callFunc_2
.zerofill __DATA,__common,__callFunc_2,8,3
	.globl	__callFunc_1                    ; @_callFunc_1
.zerofill __DATA,__common,__callFunc_1,8,3
	.globl	__retx_4                        ; @_retx_4
.zerofill __DATA,__common,__retx_4,8,3
	.globl	__retx_3                        ; @_retx_3
.zerofill __DATA,__common,__retx_3,8,3
	.globl	__retx_2                        ; @_retx_2
.zerofill __DATA,__common,__retx_2,8,3
	.globl	__retx_1                        ; @_retx_1
.zerofill __DATA,__common,__retx_1,8,3
	.globl	__sub1_1                        ; @_sub1_1
.zerofill __DATA,__common,__sub1_1,8,3
l_globalChar:                           ; @globalChar
	.asciz	"c"

.subsections_via_symbols
