	.text
	.file	"gROOT"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	movq	_anon0@GOTPCREL(%rip), %rax
	movq	%rax, -8(%rsp)
	movq	_anon1@GOTPCREL(%rip), %rax
	movq	%rax, -16(%rsp)
	movq	_anon2@GOTPCREL(%rip), %rax
	movq	%rax, -24(%rsp)
	movq	_anon3@GOTPCREL(%rip), %rax
	movq	%rax, -32(%rsp)
	movq	_anon4@GOTPCREL(%rip), %rax
	movq	%rax, -40(%rsp)
	movq	_anon5@GOTPCREL(%rip), %rax
	movq	%rax, -48(%rsp)
	movq	_anon6@GOTPCREL(%rip), %rax
	movq	%rax, -56(%rsp)
	xorl	%eax, %eax
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	_anon6                          # -- Begin function _anon6
	.p2align	4, 0x90
	.type	_anon6,@function
_anon6:                                 # @_anon6
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, -4(%rsp)
	movl	%esi, -8(%rsp)
	movl	$9, %eax
	retq
.Lfunc_end1:
	.size	_anon6, .Lfunc_end1-_anon6
	.cfi_endproc
                                        # -- End function
	.globl	_anon5                          # -- Begin function _anon5
	.p2align	4, 0x90
	.type	_anon5,@function
_anon5:                                 # @_anon5
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, -4(%rsp)
	movl	$4, %eax
	retq
.Lfunc_end2:
	.size	_anon5, .Lfunc_end2-_anon5
	.cfi_endproc
                                        # -- End function
	.globl	_anon4                          # -- Begin function _anon4
	.p2align	4, 0x90
	.type	_anon4,@function
_anon4:                                 # @_anon4
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, -4(%rsp)
	movl	%esi, -8(%rsp)
	movl	$3, %eax
	retq
.Lfunc_end3:
	.size	_anon4, .Lfunc_end3-_anon4
	.cfi_endproc
                                        # -- End function
	.globl	_anon3                          # -- Begin function _anon3
	.p2align	4, 0x90
	.type	_anon3,@function
_anon3:                                 # @_anon3
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, -4(%rsp)
	movl	%esi, -8(%rsp)
	movl	$9, %eax
	retq
.Lfunc_end4:
	.size	_anon3, .Lfunc_end4-_anon3
	.cfi_endproc
                                        # -- End function
	.globl	_anon2                          # -- Begin function _anon2
	.p2align	4, 0x90
	.type	_anon2,@function
_anon2:                                 # @_anon2
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, -4(%rsp)
	movl	$9, %eax
	retq
.Lfunc_end5:
	.size	_anon2, .Lfunc_end5-_anon2
	.cfi_endproc
                                        # -- End function
	.globl	_anon1                          # -- Begin function _anon1
	.p2align	4, 0x90
	.type	_anon1,@function
_anon1:                                 # @_anon1
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, -4(%rsp)
	movl	$4, %eax
	retq
.Lfunc_end6:
	.size	_anon1, .Lfunc_end6-_anon1
	.cfi_endproc
                                        # -- End function
	.globl	_anon0                          # -- Begin function _anon0
	.p2align	4, 0x90
	.type	_anon0,@function
_anon0:                                 # @_anon0
	.cfi_startproc
# %bb.0:                                # %entry
	movl	$4, %eax
	retq
.Lfunc_end7:
	.size	_anon0, .Lfunc_end7-_anon0
	.cfi_endproc
                                        # -- End function
	.type	.Lfmt,@object                   # @fmt
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lfmt:
	.asciz	"%d\n"
	.size	.Lfmt, 4

	.type	.LboolT,@object                 # @boolT
.LboolT:
	.asciz	"#t"
	.size	.LboolT, 3

	.type	.LboolF,@object                 # @boolF
.LboolF:
	.asciz	"#f"
	.size	.LboolF, 3

	.type	__anon0_1,@object               # @__anon0_1
	.bss
	.globl	__anon0_1
	.p2align	3
__anon0_1:
	.quad	0
	.size	__anon0_1, 8

	.type	__anon1_1,@object               # @__anon1_1
	.globl	__anon1_1
	.p2align	3
__anon1_1:
	.quad	0
	.size	__anon1_1, 8

	.type	__anon2_1,@object               # @__anon2_1
	.globl	__anon2_1
	.p2align	3
__anon2_1:
	.quad	0
	.size	__anon2_1, 8

	.type	__anon3_1,@object               # @__anon3_1
	.globl	__anon3_1
	.p2align	3
__anon3_1:
	.quad	0
	.size	__anon3_1, 8

	.type	__anon4_1,@object               # @__anon4_1
	.globl	__anon4_1
	.p2align	3
__anon4_1:
	.quad	0
	.size	__anon4_1, 8

	.type	__anon5_1,@object               # @__anon5_1
	.globl	__anon5_1
	.p2align	3
__anon5_1:
	.quad	0
	.size	__anon5_1, 8

	.type	__anon6_1,@object               # @__anon6_1
	.globl	__anon6_1
	.p2align	3
__anon6_1:
	.quad	0
	.size	__anon6_1, 8

	.section	".note.GNU-stack","",@progbits
