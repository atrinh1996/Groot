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
	subq	$64, %rsp
	.cfi_def_cfa_offset 80
	.cfi_offset %rbx, -16
	movq	anon0@GOTPCREL(%rip), %rax
	movq	%rax, 8(%rsp)
	movq	_ret4_1@GOTPCREL(%rip), %rax
	leaq	8(%rsp), %rdi
	movq	%rdi, (%rax)
	movq	anon1@GOTPCREL(%rip), %rax
	movq	%rax, 48(%rsp)
	movq	%rdi, 56(%rsp)
	movq	_call4_1@GOTPCREL(%rip), %rcx
	leaq	48(%rsp), %rdx
	movq	%rdx, (%rcx)
	callq	*%rax
	leaq	.Lfmt(%rip), %rbx
	movq	%rbx, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	_x_1@GOTPCREL(%rip), %rax
	movl	$17, (%rax)
	movq	anon2@GOTPCREL(%rip), %rax
	movq	%rax, 32(%rsp)
	movl	$17, 40(%rsp)
	movq	_retx_1@GOTPCREL(%rip), %rax
	leaq	32(%rsp), %rsi
	movq	%rsi, (%rax)
	movq	anon3@GOTPCREL(%rip), %rax
	movq	%rax, 16(%rsp)
	movq	%rsi, 24(%rsp)
	movq	_takenthenx_1@GOTPCREL(%rip), %rcx
	leaq	16(%rsp), %rdx
	movq	%rdx, (%rcx)
	movl	$9, %edi
	callq	*%rax
	movq	%rbx, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	anon4@GOTPCREL(%rip), %rax
	movq	%rax, (%rsp)
	movq	_ret4_2@GOTPCREL(%rip), %rcx
	movq	%rsp, %rdx
	movq	%rdx, (%rcx)
	callq	*%rax
	movq	%rbx, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	xorl	%eax, %eax
	addq	$64, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	anon4                           # -- Begin function anon4
	.p2align	4, 0x90
	.type	anon4,@function
anon4:                                  # @anon4
	.cfi_startproc
# %bb.0:                                # %entry
	movl	$16, %eax
	retq
.Lfunc_end1:
	.size	anon4, .Lfunc_end1-anon4
	.cfi_endproc
                                        # -- End function
	.globl	anon3                           # -- Begin function anon3
	.p2align	4, 0x90
	.type	anon3,@function
anon3:                                  # @anon3
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movl	%edi, 12(%rsp)
	movq	%rsi, 16(%rsp)
	movl	8(%rsi), %edi
	callq	*(%rsi)
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end2:
	.size	anon3, .Lfunc_end2-anon3
	.cfi_endproc
                                        # -- End function
	.globl	anon2                           # -- Begin function anon2
	.p2align	4, 0x90
	.type	anon2,@function
anon2:                                  # @anon2
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	movl	%edi, -4(%rsp)
	retq
.Lfunc_end3:
	.size	anon2, .Lfunc_end3-anon2
	.cfi_endproc
                                        # -- End function
	.globl	anon1                           # -- Begin function anon1
	.p2align	4, 0x90
	.type	anon1,@function
anon1:                                  # @anon1
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdi, (%rsp)
	callq	*(%rdi)
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end4:
	.size	anon1, .Lfunc_end4-anon1
	.cfi_endproc
                                        # -- End function
	.globl	anon0                           # -- Begin function anon0
	.p2align	4, 0x90
	.type	anon0,@function
anon0:                                  # @anon0
	.cfi_startproc
# %bb.0:                                # %entry
	movl	$4, %eax
	retq
.Lfunc_end5:
	.size	anon0, .Lfunc_end5-anon0
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

	.type	_anon3_1,@object                # @_anon3_1
	.globl	_anon3_1
	.p2align	3
_anon3_1:
	.quad	0
	.size	_anon3_1, 8

	.type	_anon4_1,@object                # @_anon4_1
	.globl	_anon4_1
	.p2align	3
_anon4_1:
	.quad	0
	.size	_anon4_1, 8

	.type	_call4_1,@object                # @_call4_1
	.globl	_call4_1
	.p2align	3
_call4_1:
	.quad	0
	.size	_call4_1, 8

	.type	_ret4_2,@object                 # @_ret4_2
	.globl	_ret4_2
	.p2align	3
_ret4_2:
	.quad	0
	.size	_ret4_2, 8

	.type	_ret4_1,@object                 # @_ret4_1
	.globl	_ret4_1
	.p2align	3
_ret4_1:
	.quad	0
	.size	_ret4_1, 8

	.type	_retx_1,@object                 # @_retx_1
	.globl	_retx_1
	.p2align	3
_retx_1:
	.quad	0
	.size	_retx_1, 8

	.type	_takenthenx_1,@object           # @_takenthenx_1
	.globl	_takenthenx_1
	.p2align	3
_takenthenx_1:
	.quad	0
	.size	_takenthenx_1, 8

	.type	_x_1,@object                    # @_x_1
	.globl	_x_1
	.p2align	2
_x_1:
	.long	0                               # 0x0
	.size	_x_1, 4

	.section	".note.GNU-stack","",@progbits
