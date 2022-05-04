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
	pushq	%rax
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	leaq	.Lfmt(%rip), %rbx
	movq	%rbx, %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	movl	$2, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	movl	$3, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	movl	$4, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	movl	$5, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	leaq	.LboolF(%rip), %r14
	movq	%r14, %rdi
	callq	puts@PLT
	leaq	.LboolT(%rip), %rbx
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
	xorl	%eax, %eax
	addq	$8, %rsp
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

	.section	".note.GNU-stack","",@progbits
