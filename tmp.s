	.text
	.file	"gROOT"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -16
	movq	_anon0@GOTPCREL(%rip), %rax
	movq	%rax, 8(%rsp)
	movq	_letterGrade_1@GOTPCREL(%rip), %rbx
	leaq	8(%rsp), %rcx
	movq	%rcx, (%rbx)
	movl	$89, %edi
	callq	*%rax
	movq	%rax, %rdi
	callq	puts@PLT
	movq	_anon1@GOTPCREL(%rip), %rax
	movq	%rax, 16(%rsp)
	movq	(%rbx), %rcx
	movq	%rcx, 24(%rsp)
	movq	_computeGrade_1@GOTPCREL(%rip), %rbx
	leaq	16(%rsp), %rdx
	movq	%rdx, (%rbx)
	movl	$88, %edi
	movl	$90, %esi
	movl	$91, %edx
	callq	*%rax
	movq	%rax, %rdi
	callq	puts@PLT
	movq	_anon2@GOTPCREL(%rip), %rax
	movq	%rax, (%rsp)
	movq	_letterGrade_2@GOTPCREL(%rip), %rcx
	movq	%rsp, %rdx
	movq	%rdx, (%rcx)
	movl	$89, %edi
	callq	*%rax
	movq	%rax, %rdi
	callq	puts@PLT
	movq	(%rbx), %rax
	movq	8(%rax), %rcx
	movl	$88, %edi
	movl	$90, %esi
	movl	$91, %edx
	callq	*(%rax)
	movq	%rax, %rdi
	callq	puts@PLT
	xorl	%eax, %eax
	addq	$32, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	_anon2                          # -- Begin function _anon2
	.p2align	4, 0x90
	.type	_anon2,@function
_anon2:                                 # @_anon2
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsp, %rax
	cmpl	$85, %edi
	jle	.LBB1_5
# %bb.1:                                # %then
	leaq	-16(%rax), %rsp
	leaq	.LglobalChar(%rip), %rcx
	movq	%rcx, -16(%rax)
	movq	%rcx, -16(%rbp)
	jmp	.LBB1_4
.LBB1_5:                                # %else
	addq	$-16, %rax
	movq	%rax, %rsp
	cmpl	$75, -4(%rbp)
	jle	.LBB1_6
# %bb.2:                                # %then7
	movq	%rsp, %rcx
	leaq	-16(%rcx), %rsp
	leaq	.LglobalChar.1(%rip), %rdx
	movq	%rdx, -16(%rcx)
	movq	%rdx, (%rax)
	jmp	.LBB1_3
.LBB1_6:                                # %else11
	movq	%rsp, %rcx
	addq	$-16, %rcx
	movq	%rcx, %rsp
	cmpl	$65, -4(%rbp)
	jle	.LBB1_9
# %bb.7:                                # %then16
	movq	%rsp, %rdx
	leaq	-16(%rdx), %rsp
	leaq	.LglobalChar.2(%rip), %rsi
	jmp	.LBB1_8
.LBB1_9:                                # %else20
	movq	%rsp, %rdx
	leaq	-16(%rdx), %rsp
	leaq	.LglobalChar.3(%rip), %rsi
.LBB1_8:                                # %merge15
	movq	%rsi, -16(%rdx)
	movq	%rsi, (%rcx)
	movq	(%rcx), %rcx
	movq	%rcx, (%rax)
.LBB1_3:                                # %merge6
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
.LBB1_4:                                # %merge
	movq	-16(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	_anon2, .Lfunc_end1-_anon2
	.cfi_endproc
                                        # -- End function
	.globl	_anon1                          # -- Begin function _anon1
	.p2align	4, 0x90
	.type	_anon1,@function
_anon1:                                 # @_anon1
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movl	%edi, 28(%rsp)
	movl	%esi, 24(%rsp)
	movl	%edx, 20(%rsp)
	movq	%rcx, 32(%rsp)
	addl	%esi, %edi
	addl	%edx, %edi
	movl	%edi, 16(%rsp)
	movslq	%edi, %rax
	imulq	$1431655766, %rax, %rdi         # imm = 0x55555556
	movq	%rdi, %rax
	shrq	$63, %rax
	shrq	$32, %rdi
	addl	%eax, %edi
	movl	%edi, 12(%rsp)
	movq	_letterGrade_1@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
                                        # kill: def $edi killed $edi killed $rdi
	callq	*(%rax)
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end2:
	.size	_anon1, .Lfunc_end2-_anon1
	.cfi_endproc
                                        # -- End function
	.globl	_anon0                          # -- Begin function _anon0
	.p2align	4, 0x90
	.type	_anon0,@function
_anon0:                                 # @_anon0
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsp, %rax
	cmpl	$90, %edi
	jle	.LBB3_5
# %bb.1:                                # %then
	leaq	-16(%rax), %rsp
	leaq	.LglobalChar.4(%rip), %rcx
	movq	%rcx, -16(%rax)
	movq	%rcx, -16(%rbp)
	jmp	.LBB3_4
.LBB3_5:                                # %else
	addq	$-16, %rax
	movq	%rax, %rsp
	cmpl	$80, -4(%rbp)
	jle	.LBB3_6
# %bb.2:                                # %then7
	movq	%rsp, %rcx
	leaq	-16(%rcx), %rsp
	leaq	.LglobalChar.5(%rip), %rdx
	movq	%rdx, -16(%rcx)
	movq	%rdx, (%rax)
	jmp	.LBB3_3
.LBB3_6:                                # %else11
	movq	%rsp, %rcx
	addq	$-16, %rcx
	movq	%rcx, %rsp
	cmpl	$70, -4(%rbp)
	jle	.LBB3_9
# %bb.7:                                # %then16
	movq	%rsp, %rdx
	leaq	-16(%rdx), %rsp
	leaq	.LglobalChar.6(%rip), %rsi
	jmp	.LBB3_8
.LBB3_9:                                # %else20
	movq	%rsp, %rdx
	leaq	-16(%rdx), %rsp
	leaq	.LglobalChar.7(%rip), %rsi
.LBB3_8:                                # %merge15
	movq	%rsi, -16(%rdx)
	movq	%rsi, (%rcx)
	movq	(%rcx), %rcx
	movq	%rcx, (%rax)
.LBB3_3:                                # %merge6
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
.LBB3_4:                                # %merge
	movq	-16(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end3:
	.size	_anon0, .Lfunc_end3-_anon0
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

	.type	_computeGrade_1,@object         # @_computeGrade_1
	.globl	_computeGrade_1
	.p2align	3
_computeGrade_1:
	.quad	0
	.size	_computeGrade_1, 8

	.type	_letterGrade_2,@object          # @_letterGrade_2
	.globl	_letterGrade_2
	.p2align	3
_letterGrade_2:
	.quad	0
	.size	_letterGrade_2, 8

	.type	_letterGrade_1,@object          # @_letterGrade_1
	.globl	_letterGrade_1
	.p2align	3
_letterGrade_1:
	.quad	0
	.size	_letterGrade_1, 8

	.type	.LglobalChar,@object            # @globalChar
	.section	.rodata.str1.1,"aMS",@progbits,1
.LglobalChar:
	.asciz	"A"
	.size	.LglobalChar, 2

	.type	.LglobalChar.1,@object          # @globalChar.1
.LglobalChar.1:
	.asciz	"B"
	.size	.LglobalChar.1, 2

	.type	.LglobalChar.2,@object          # @globalChar.2
.LglobalChar.2:
	.asciz	"C"
	.size	.LglobalChar.2, 2

	.type	.LglobalChar.3,@object          # @globalChar.3
.LglobalChar.3:
	.asciz	"D"
	.size	.LglobalChar.3, 2

	.type	.LglobalChar.4,@object          # @globalChar.4
.LglobalChar.4:
	.asciz	"A"
	.size	.LglobalChar.4, 2

	.type	.LglobalChar.5,@object          # @globalChar.5
.LglobalChar.5:
	.asciz	"B"
	.size	.LglobalChar.5, 2

	.type	.LglobalChar.6,@object          # @globalChar.6
.LglobalChar.6:
	.asciz	"C"
	.size	.LglobalChar.6, 2

	.type	.LglobalChar.7,@object          # @globalChar.7
.LglobalChar.7:
	.asciz	"D"
	.size	.LglobalChar.7, 2

	.section	".note.GNU-stack","",@progbits
