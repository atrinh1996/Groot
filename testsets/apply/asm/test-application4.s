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
	subq	$48, %rsp
	.cfi_def_cfa_offset 80
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	_x_1@GOTPCREL(%rip), %rax
	movl	$42, (%rax)
	movq	anon0@GOTPCREL(%rip), %rax
	movq	%rax, 32(%rsp)
	movl	$42, 40(%rsp)
	movq	_retx_1@GOTPCREL(%rip), %r15
	leaq	32(%rsp), %rcx
	movq	%rcx, (%r15)
	movl	$42, %edi
	callq	*%rax
	leaq	.Lfmt(%rip), %r14
	movq	%r14, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	_x_2@GOTPCREL(%rip), %rbx
	movl	$12, (%rbx)
	movq	(%r15), %rax
	movl	8(%rax), %edi
	callq	*(%rax)
	movq	%r14, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	anon1@GOTPCREL(%rip), %rax
	movq	%rax, 16(%rsp)
	movl	(%rbx), %edi
	movl	%edi, 24(%rsp)
	movq	_retx_2@GOTPCREL(%rip), %rcx
	leaq	16(%rsp), %rdx
	movq	%rdx, (%rcx)
	callq	*%rax
	movq	%r14, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	anon2@GOTPCREL(%rip), %rax
	movq	%rax, (%rsp)
	movl	(%rbx), %edx
	movl	%edx, 8(%rsp)
	movq	_retx2_1@GOTPCREL(%rip), %rcx
	movq	%rsp, %rsi
	movq	%rsi, (%rcx)
	movl	$9, %edi
	movl	$8, %esi
	callq	*%rax
	movq	%r14, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	xorl	%eax, %eax
	addq	$48, %rsp
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
	.globl	anon2                           # -- Begin function anon2
	.p2align	4, 0x90
	.type	anon2,@function
anon2:                                  # @anon2
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edx, %eax
	movl	%edi, -4(%rsp)
	movl	%esi, -8(%rsp)
	movl	%edx, -12(%rsp)
	retq
.Lfunc_end1:
	.size	anon2, .Lfunc_end1-anon2
	.cfi_endproc
                                        # -- End function
	.globl	anon1                           # -- Begin function anon1
	.p2align	4, 0x90
	.type	anon1,@function
anon1:                                  # @anon1
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	movl	%edi, -4(%rsp)
	retq
.Lfunc_end2:
	.size	anon1, .Lfunc_end2-anon1
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
.Lfunc_end3:
	.size	anon0, .Lfunc_end3-anon0
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

	.type	_anon1_1,@object                # @_anon1_1
	.globl	_anon1_1
	.p2align	3
_anon1_1:
	.quad	0
	.size	_anon1_1, 8

	.type	_anon2_1,@object                # @_anon2_1
	.globl	_anon2_1
	.p2align	3
_anon2_1:
	.quad	0
	.size	_anon2_1, 8

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

	.type	_retx2_1,@object                # @_retx2_1
	.globl	_retx2_1
	.p2align	3
_retx2_1:
	.quad	0
	.size	_retx2_1, 8

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
