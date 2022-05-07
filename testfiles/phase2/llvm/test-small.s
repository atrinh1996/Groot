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
	pushq	%r12
	.cfi_def_cfa_offset 32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	pushq	%rax
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -40
	.cfi_offset %r12, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	_x_1@GOTPCREL(%rip), %r14
	movl	$42, (%r14)
	movq	_retx_1@GOTPCREL(%rip), %rax
	movq	_retx_1.2@GOTPCREL(%rip), %r15
	movq	%rax, (%r15)
	movl	$42, %edi
	callq	*%rax
	leaq	.Lfmt(%rip), %r12
	movq	%r12, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	_x_2@GOTPCREL(%rip), %rbx
	movl	$12, (%rbx)
	movl	(%r14), %edi
	callq	*(%r15)
	movq	%r12, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	_retx_2@GOTPCREL(%rip), %rax
	movq	_retx_2.1@GOTPCREL(%rip), %rcx
	movq	%rax, (%rcx)
	movl	(%rbx), %edi
	callq	*%rax
	movq	%r12, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	_retx2_1@GOTPCREL(%rip), %rax
	movq	_retx2_1.3@GOTPCREL(%rip), %rcx
	movq	%rax, (%rcx)
	movl	(%rbx), %edx
	movl	$9, %edi
	movl	$8, %esi
	callq	*%rax
	movq	%r12, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	xorl	%eax, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%r12
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
	.globl	_retx2_1                        # -- Begin function _retx2_1
	.p2align	4, 0x90
	.type	_retx2_1,@function
_retx2_1:                               # @_retx2_1
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edx, %eax
	movl	%edi, -4(%rsp)
	movl	%esi, -8(%rsp)
	movl	%edx, -12(%rsp)
	retq
.Lfunc_end1:
	.size	_retx2_1, .Lfunc_end1-_retx2_1
	.cfi_endproc
                                        # -- End function
	.globl	_retx_2                         # -- Begin function _retx_2
	.p2align	4, 0x90
	.type	_retx_2,@function
_retx_2:                                # @_retx_2
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	movl	%edi, -4(%rsp)
	retq
.Lfunc_end2:
	.size	_retx_2, .Lfunc_end2-_retx_2
	.cfi_endproc
                                        # -- End function
	.globl	_retx_1                         # -- Begin function _retx_1
	.p2align	4, 0x90
	.type	_retx_1,@function
_retx_1:                                # @_retx_1
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	movl	%edi, -4(%rsp)
	retq
.Lfunc_end3:
	.size	_retx_1, .Lfunc_end3-_retx_1
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

	.type	_retx_2.1,@object               # @_retx_2.1
	.bss
	.globl	_retx_2.1
	.p2align	3
_retx_2.1:
	.quad	0
	.size	_retx_2.1, 8

	.type	_retx_1.2,@object               # @_retx_1.2
	.globl	_retx_1.2
	.p2align	3
_retx_1.2:
	.quad	0
	.size	_retx_1.2, 8

	.type	_retx2_1.3,@object              # @_retx2_1.3
	.globl	_retx2_1.3
	.p2align	3
_retx2_1.3:
	.quad	0
	.size	_retx2_1.3, 8

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
