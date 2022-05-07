	.text
	.file	"gROOT"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	subq	$120, %rsp
	.cfi_def_cfa_offset 144
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	_anon0@GOTPCREL(%rip), %rax
	movq	%rax, 104(%rsp)
	movq	_add1_1@GOTPCREL(%rip), %rax
	leaq	104(%rsp), %rdi
	movq	%rdi, (%rax)
	movq	_anon1@GOTPCREL(%rip), %rax
	movq	%rax, 96(%rsp)
	movq	_sub1_1@GOTPCREL(%rip), %rbx
	leaq	96(%rsp), %rax
	movq	%rax, (%rbx)
	movq	_anon2@GOTPCREL(%rip), %rax
	movq	%rax, 88(%rsp)
	movq	_retx_1@GOTPCREL(%rip), %rax
	leaq	88(%rsp), %rcx
	movq	%rcx, (%rax)
	movq	_anon4@GOTPCREL(%rip), %rax
	movq	%rax, 80(%rsp)
	movq	_callFunc_1@GOTPCREL(%rip), %rcx
	leaq	80(%rsp), %rdx
	movq	%rdx, (%rcx)
	movl	$41, %esi
	callq	*%rax
	leaq	.Lfmt(%rip), %r14
	movq	%r14, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	_anon5@GOTPCREL(%rip), %rax
	movq	%rax, 72(%rsp)
	movq	_callFunc_2@GOTPCREL(%rip), %rcx
	leaq	72(%rsp), %rdx
	movq	%rdx, (%rcx)
	movq	(%rbx), %rdi
	movl	$43, %esi
	callq	*%rax
	movq	%r14, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	_anon7@GOTPCREL(%rip), %rax
	movq	%rax, 64(%rsp)
	movq	_retx_2@GOTPCREL(%rip), %rax
	leaq	64(%rsp), %rdi
	movq	%rdi, (%rax)
	movq	_anon6@GOTPCREL(%rip), %rax
	movq	%rax, 56(%rsp)
	movq	_callFunc_3@GOTPCREL(%rip), %rcx
	leaq	56(%rsp), %rdx
	movq	%rdx, (%rcx)
	leaq	.LglobalChar(%rip), %rsi
	movq	%rsi, 112(%rsp)
	callq	*%rax
	movq	%rax, %rdi
	callq	puts@PLT
	movq	_anon8@GOTPCREL(%rip), %rax
	movq	%rax, 48(%rsp)
	movq	_callFunc_4@GOTPCREL(%rip), %rcx
	leaq	48(%rsp), %rdx
	movq	%rdx, (%rcx)
	movq	_anon9@GOTPCREL(%rip), %rcx
	movq	%rcx, 40(%rsp)
	leaq	40(%rsp), %rdi
	movl	$2, %esi
	callq	*%rax
	movq	%r14, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	_anon11@GOTPCREL(%rip), %rax
	movq	%rax, 32(%rsp)
	movq	_retx_3@GOTPCREL(%rip), %rax
	leaq	32(%rsp), %rdi
	movq	%rdi, (%rax)
	movq	_anon10@GOTPCREL(%rip), %rax
	movq	%rax, 24(%rsp)
	movq	_callFunc_5@GOTPCREL(%rip), %rcx
	leaq	24(%rsp), %rdx
	movq	%rdx, (%rcx)
	movl	$42, %esi
	callq	*%rax
	movq	%r14, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	_anon13@GOTPCREL(%rip), %rax
	movq	%rax, 16(%rsp)
	movq	_retx_4@GOTPCREL(%rip), %rax
	leaq	16(%rsp), %rdi
	movq	%rdi, (%rax)
	movq	_anon12@GOTPCREL(%rip), %rax
	movq	%rax, 8(%rsp)
	movq	_callFunc_6@GOTPCREL(%rip), %rcx
	leaq	8(%rsp), %rdx
	movq	%rdx, (%rcx)
	movl	$1, %esi
	callq	*%rax
	leaq	.LboolF(%rip), %rdi
	callq	puts@PLT
	xorl	%eax, %eax
	addq	$120, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	_anon12                         # -- Begin function _anon12
	.p2align	4, 0x90
	.type	_anon12,@function
_anon12:                                # @_anon12
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rax
	movq	%rdi, 16(%rsp)
	movl	%esi, %ecx
	andl	$1, %ecx
	movb	%cl, 15(%rsp)
	movl	%esi, %edi
	callq	*(%rax)
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	_anon12, .Lfunc_end1-_anon12
	.cfi_endproc
                                        # -- End function
	.globl	_anon13                         # -- Begin function _anon13
	.p2align	4, 0x90
	.type	_anon13,@function
_anon13:                                # @_anon13
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	movl	%edi, %ecx
	andl	$1, %ecx
	movb	%cl, -1(%rsp)
                                        # kill: def $al killed $al killed $eax
	retq
.Lfunc_end2:
	.size	_anon13, .Lfunc_end2-_anon13
	.cfi_endproc
                                        # -- End function
	.globl	_anon10                         # -- Begin function _anon10
	.p2align	4, 0x90
	.type	_anon10,@function
_anon10:                                # @_anon10
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rax
	movq	%rdi, 16(%rsp)
	movl	%esi, 12(%rsp)
	movl	%esi, %edi
	callq	*(%rax)
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end3:
	.size	_anon10, .Lfunc_end3-_anon10
	.cfi_endproc
                                        # -- End function
	.globl	_anon11                         # -- Begin function _anon11
	.p2align	4, 0x90
	.type	_anon11,@function
_anon11:                                # @_anon11
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	movl	%edi, -4(%rsp)
	retq
.Lfunc_end4:
	.size	_anon11, .Lfunc_end4-_anon11
	.cfi_endproc
                                        # -- End function
	.globl	_anon9                          # -- Begin function _anon9
	.p2align	4, 0x90
	.type	_anon9,@function
_anon9:                                 # @_anon9
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	movl	%edi, -4(%rsp)
	imull	%edi, %eax
	retq
.Lfunc_end5:
	.size	_anon9, .Lfunc_end5-_anon9
	.cfi_endproc
                                        # -- End function
	.globl	_anon8                          # -- Begin function _anon8
	.p2align	4, 0x90
	.type	_anon8,@function
_anon8:                                 # @_anon8
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rax
	movq	%rdi, 16(%rsp)
	movl	%esi, 12(%rsp)
	movl	%esi, %edi
	callq	*(%rax)
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end6:
	.size	_anon8, .Lfunc_end6-_anon8
	.cfi_endproc
                                        # -- End function
	.globl	_anon6                          # -- Begin function _anon6
	.p2align	4, 0x90
	.type	_anon6,@function
_anon6:                                 # @_anon6
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rax
	movq	%rdi, 16(%rsp)
	movq	%rsi, 8(%rsp)
	movq	%rsi, %rdi
	callq	*(%rax)
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end7:
	.size	_anon6, .Lfunc_end7-_anon6
	.cfi_endproc
                                        # -- End function
	.globl	_anon7                          # -- Begin function _anon7
	.p2align	4, 0x90
	.type	_anon7,@function
_anon7:                                 # @_anon7
	.cfi_startproc
# %bb.0:                                # %entry
	movq	%rdi, %rax
	movq	%rdi, -8(%rsp)
	retq
.Lfunc_end8:
	.size	_anon7, .Lfunc_end8-_anon7
	.cfi_endproc
                                        # -- End function
	.globl	_anon5                          # -- Begin function _anon5
	.p2align	4, 0x90
	.type	_anon5,@function
_anon5:                                 # @_anon5
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rax
	movq	%rdi, 16(%rsp)
	movl	%esi, 12(%rsp)
	movl	%esi, %edi
	callq	*(%rax)
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end9:
	.size	_anon5, .Lfunc_end9-_anon5
	.cfi_endproc
                                        # -- End function
	.globl	_anon4                          # -- Begin function _anon4
	.p2align	4, 0x90
	.type	_anon4,@function
_anon4:                                 # @_anon4
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rax
	movq	%rdi, 16(%rsp)
	movl	%esi, 12(%rsp)
	movl	%esi, %edi
	callq	*(%rax)
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end10:
	.size	_anon4, .Lfunc_end10-_anon4
	.cfi_endproc
                                        # -- End function
	.globl	_anon2                          # -- Begin function _anon2
	.p2align	4, 0x90
	.type	_anon2,@function
_anon2:                                 # @_anon2
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	movl	%edi, -4(%rsp)
	retq
.Lfunc_end11:
	.size	_anon2, .Lfunc_end11-_anon2
	.cfi_endproc
                                        # -- End function
	.globl	_anon1                          # -- Begin function _anon1
	.p2align	4, 0x90
	.type	_anon1,@function
_anon1:                                 # @_anon1
	.cfi_startproc
# %bb.0:                                # %entry
                                        # kill: def $edi killed $edi def $rdi
	movl	%edi, -4(%rsp)
	leal	-1(%rdi), %eax
	retq
.Lfunc_end12:
	.size	_anon1, .Lfunc_end12-_anon1
	.cfi_endproc
                                        # -- End function
	.globl	_anon0                          # -- Begin function _anon0
	.p2align	4, 0x90
	.type	_anon0,@function
_anon0:                                 # @_anon0
	.cfi_startproc
# %bb.0:                                # %entry
                                        # kill: def $edi killed $edi def $rdi
	movl	%edi, -4(%rsp)
	leal	1(%rdi), %eax
	retq
.Lfunc_end13:
	.size	_anon0, .Lfunc_end13-_anon0
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

	.type	__anon10_1,@object              # @__anon10_1
	.globl	__anon10_1
	.p2align	3
__anon10_1:
	.quad	0
	.size	__anon10_1, 8

	.type	__anon11_1,@object              # @__anon11_1
	.globl	__anon11_1
	.p2align	3
__anon11_1:
	.quad	0
	.size	__anon11_1, 8

	.type	__anon12_1,@object              # @__anon12_1
	.globl	__anon12_1
	.p2align	3
__anon12_1:
	.quad	0
	.size	__anon12_1, 8

	.type	__anon13_1,@object              # @__anon13_1
	.globl	__anon13_1
	.p2align	3
__anon13_1:
	.quad	0
	.size	__anon13_1, 8

	.type	__anon2_1,@object               # @__anon2_1
	.globl	__anon2_1
	.p2align	3
__anon2_1:
	.quad	0
	.size	__anon2_1, 8

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

	.type	__anon7_1,@object               # @__anon7_1
	.globl	__anon7_1
	.p2align	3
__anon7_1:
	.quad	0
	.size	__anon7_1, 8

	.type	__anon8_1,@object               # @__anon8_1
	.globl	__anon8_1
	.p2align	3
__anon8_1:
	.quad	0
	.size	__anon8_1, 8

	.type	__anon9_1,@object               # @__anon9_1
	.globl	__anon9_1
	.p2align	3
__anon9_1:
	.quad	0
	.size	__anon9_1, 8

	.type	_add1_1,@object                 # @_add1_1
	.globl	_add1_1
	.p2align	3
_add1_1:
	.quad	0
	.size	_add1_1, 8

	.type	_callFunc_6,@object             # @_callFunc_6
	.globl	_callFunc_6
	.p2align	3
_callFunc_6:
	.quad	0
	.size	_callFunc_6, 8

	.type	_callFunc_5,@object             # @_callFunc_5
	.globl	_callFunc_5
	.p2align	3
_callFunc_5:
	.quad	0
	.size	_callFunc_5, 8

	.type	_callFunc_4,@object             # @_callFunc_4
	.globl	_callFunc_4
	.p2align	3
_callFunc_4:
	.quad	0
	.size	_callFunc_4, 8

	.type	_callFunc_3,@object             # @_callFunc_3
	.globl	_callFunc_3
	.p2align	3
_callFunc_3:
	.quad	0
	.size	_callFunc_3, 8

	.type	_callFunc_2,@object             # @_callFunc_2
	.globl	_callFunc_2
	.p2align	3
_callFunc_2:
	.quad	0
	.size	_callFunc_2, 8

	.type	_callFunc_1,@object             # @_callFunc_1
	.globl	_callFunc_1
	.p2align	3
_callFunc_1:
	.quad	0
	.size	_callFunc_1, 8

	.type	_retx_4,@object                 # @_retx_4
	.globl	_retx_4
	.p2align	3
_retx_4:
	.quad	0
	.size	_retx_4, 8

	.type	_retx_3,@object                 # @_retx_3
	.globl	_retx_3
	.p2align	3
_retx_3:
	.quad	0
	.size	_retx_3, 8

	.type	_retx_2,@object                 # @_retx_2
	.globl	_retx_2
	.p2align	3
_retx_2:
	.quad	0
	.size	_retx_2, 8

	.type	_retx_1,@object                 # @_retx_1
	.globl	_retx_1
	.p2align	3
_retx_1:
	.quad	0
	.size	_retx_1, 8

	.type	_sub1_1,@object                 # @_sub1_1
	.globl	_sub1_1
	.p2align	3
_sub1_1:
	.quad	0
	.size	_sub1_1, 8

	.type	.LglobalChar,@object            # @globalChar
	.section	.rodata.str1.1,"aMS",@progbits,1
.LglobalChar:
	.asciz	"c"
	.size	.LglobalChar, 2

	.section	".note.GNU-stack","",@progbits
