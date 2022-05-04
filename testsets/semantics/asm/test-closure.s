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
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	_x_1@GOTPCREL(%rip), %rbx
	movl	$1, (%rbx)
	leaq	.Lfmt(%rip), %r14
	movq	%r14, %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	anon0@GOTPCREL(%rip), %rax
	movq	%rax, 8(%rsp)
	movl	(%rbx), %edi
	movl	%edi, 16(%rsp)
	movq	_retx1_1@GOTPCREL(%rip), %rbx
	leaq	8(%rsp), %rcx
	movq	%rcx, (%rbx)
	callq	*%rax
	movq	%r14, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	_x_2@GOTPCREL(%rip), %rax
	movl	$42, (%rax)
	movq	%r14, %rdi
	movl	$42, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	(%rbx), %rax
	movl	8(%rax), %edi
	callq	*(%rax)
	movq	%r14, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	xorl	%eax, %eax
	addq	$24, %rsp
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
	.globl	anon0                           # -- Begin function anon0
	.p2align	4, 0x90
	.type	anon0,@function
anon0:                                  # @anon0
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	movl	%edi, -4(%rsp)
	retq
.Lfunc_end1:
	.size	anon0, .Lfunc_end1-anon0
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

	.type	_anon0_1,@object                # @_anon0_1
	.bss
	.globl	_anon0_1
	.p2align	3
_anon0_1:
	.quad	0
	.size	_anon0_1, 8

	.type	_retx1_1,@object                # @_retx1_1
	.globl	_retx1_1
	.p2align	3
_retx1_1:
	.quad	0
	.size	_retx1_1, 8

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
