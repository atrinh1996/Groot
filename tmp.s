	.text
	.file	"gROOT"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	leaq	.LboolT(%rip), %r14
	movq	%r14, %rdi
	callq	puts@PLT
	leaq	.Lfmt(%rip), %r15
	movq	%r15, %rdi
	movl	$10, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	leaq	.LglobalChar(%rip), %rdi
	movq	%rdi, 8(%rsp)
	callq	puts@PLT
	movq	%r15, %rdi
	movl	$3, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%r15, %rdi
	movl	$-1, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%r15, %rdi
	movl	$2, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%r15, %rdi
	xorl	%esi, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%r15, %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%r14, %rdi
	callq	puts@PLT
	leaq	.LboolF(%rip), %rbx
	movq	%rbx, %rdi
	callq	puts@PLT
	movq	%rbx, %rdi
	callq	puts@PLT
	movq	%r14, %rdi
	callq	puts@PLT
	movq	%rbx, %rdi
	callq	puts@PLT
	movq	%r14, %rdi
	callq	puts@PLT
	movq	%rbx, %rdi
	callq	puts@PLT
	movq	%r14, %rdi
	callq	puts@PLT
	movq	%rbx, %rdi
	callq	puts@PLT
	movq	%r15, %rdi
	movl	$-3, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	xorl	%eax, %eax
	addq	$16, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
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

	.type	.LglobalChar,@object            # @globalChar
.LglobalChar:
	.asciz	"x"
	.size	.LglobalChar, 2

	.section	".note.GNU-stack","",@progbits
