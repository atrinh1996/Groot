	.text
	.file	"gROOT"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movb	$1, -1(%rbp)
	movb	$1, %al
	testb	%al, %al
	je	.LBB0_3
# %bb.1:                                # %then3
	movq	%rsp, %rax
	leaq	-16(%rax), %rsp
	leaq	.LglobalChar(%rip), %rdi
	jmp	.LBB0_2
.LBB0_3:                                # %else4
	movq	%rsp, %rax
	leaq	-16(%rax), %rsp
	leaq	.LglobalChar.1(%rip), %rdi
.LBB0_2:                                # %merge2
	movq	%rdi, -16(%rax)
	callq	puts@PLT
	movl	%eax, -8(%rbp)
	xorl	%eax, %eax
	movq	%rbp, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
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

	.type	.LglobalChar,@object            # @globalChar
.LglobalChar:
	.asciz	"a"
	.size	.LglobalChar, 2

	.type	.LglobalChar.1,@object          # @globalChar.1
.LglobalChar.1:
	.asciz	"b"
	.size	.LglobalChar.1, 2

	.section	".note.GNU-stack","",@progbits
