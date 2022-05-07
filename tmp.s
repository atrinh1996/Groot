	.text
	.file	"gROOT"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	leaq	.LglobalChar(%rip), %rcx
	movq	%rcx, 32(%rsp)
	movq	_a_1@GOTPCREL(%rip), %rax
	movq	%rcx, (%rax)
	leaq	.LglobalChar.1(%rip), %rdx
	movq	%rdx, 24(%rsp)
	movq	_b_1@GOTPCREL(%rip), %rcx
	movq	%rdx, (%rcx)
	movb	$1, 15(%rsp)
	movb	$1, %dl
	testb	%dl, %dl
	je	.LBB0_2
# %bb.1:                                # %then6
	movq	(%rax), %rax
	jmp	.LBB0_3
.LBB0_2:                                # %else7
	movq	(%rcx), %rax
.LBB0_3:                                # %merge5
	movq	%rax, 16(%rsp)
	movq	16(%rsp), %rdi
	callq	puts@PLT
	xorl	%eax, %eax
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
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

	.type	_a_1,@object                    # @_a_1
	.bss
	.globl	_a_1
	.p2align	3
_a_1:
	.quad	0
	.size	_a_1, 8

	.type	_b_1,@object                    # @_b_1
	.globl	_b_1
	.p2align	3
_b_1:
	.quad	0
	.size	_b_1, 8

	.type	.LglobalChar,@object            # @globalChar
	.section	.rodata.str1.1,"aMS",@progbits,1
.LglobalChar:
	.asciz	"a"
	.size	.LglobalChar, 2

	.type	.LglobalChar.1,@object          # @globalChar.1
.LglobalChar.1:
	.asciz	"b"
	.size	.LglobalChar.1, 2

	.section	".note.GNU-stack","",@progbits
