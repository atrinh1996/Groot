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
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	_x_1@GOTPCREL(%rip), %r14
	movl	$1, (%r14)
	leaq	.Lfmt(%rip), %rbx
	movq	%rbx, %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	_retx1_1@GOTPCREL(%rip), %rax
	movq	_retx1_1.1@GOTPCREL(%rip), %r15
	movq	%rax, (%r15)
	movl	(%r14), %edi
	callq	*%rax
	movq	%rbx, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	_x_2@GOTPCREL(%rip), %rax
	movl	$42, (%rax)
	movq	%rbx, %rdi
	movl	$42, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movl	(%r14), %edi
	callq	*(%r15)
	movq	%rbx, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	xorl	%eax, %eax
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
	.globl	_retx1_1                        # -- Begin function _retx1_1
	.p2align	4, 0x90
	.type	_retx1_1,@function
_retx1_1:                               # @_retx1_1
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	movl	%edi, -4(%rsp)
	retq
.Lfunc_end1:
	.size	_retx1_1, .Lfunc_end1-_retx1_1
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

	.type	_retx1_1.1,@object              # @_retx1_1.1
	.bss
	.globl	_retx1_1.1
	.p2align	3
_retx1_1.1:
	.quad	0
	.size	_retx1_1.1, 8

	.type	_x_2,@object                    # @_x_2
	.globl	_x_2
	.p2align	2
_x_2:
	.long	0                               # 0x0
	.size	_x_2, 4

	.type	_x_1,@object                    # @_x_1
	.globl	_x_1
	.p2align	2
_x_1:
	.long	0                               # 0x0
	.size	_x_1, 4

	.section	".note.GNU-stack","",@progbits
