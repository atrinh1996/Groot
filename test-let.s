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
	movq	_var_1@GOTPCREL(%rip), %rax
	movl	$2, (%rax)
	movl	$4, 28(%rsp)
	leaq	.Lfmt(%rip), %rbx
	movq	%rbx, %rdi
	movl	$4, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movl	$4, 24(%rsp)
	movq	%rbx, %rdi
	movl	$4, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movl	$2, 20(%rsp)
	movl	$3, 16(%rsp)
	movq	%rbx, %rdi
	movl	$5, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movl	$5, 12(%rsp)
	movl	$5, 8(%rsp)
	movl	$5, 4(%rsp)
	movq	%rbx, %rdi
	movl	$125, %esi
	xorl	%eax, %eax
	callq	printf@PLT
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

	.type	_var_1,@object                  # @_var_1
	.bss
	.globl	_var_1
	.p2align	2
_var_1:
	.long	0                               # 0x0
	.size	_var_1, 4

	.section	".note.GNU-stack","",@progbits
