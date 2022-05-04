	.text
	.file	"gROOT"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	movq	anon0@GOTPCREL(%rip), %rax
	movq	%rax, -24(%rsp)
	movq	_retn_1@GOTPCREL(%rip), %rax
	leaq	-24(%rsp), %rcx
	movq	%rcx, (%rax)
	movq	anon1@GOTPCREL(%rip), %rax
	movq	%rax, -16(%rsp)
	movq	%rcx, -8(%rsp)
	movq	_test_1@GOTPCREL(%rip), %rax
	leaq	-16(%rsp), %rcx
	movq	%rcx, (%rax)
	xorl	%eax, %eax
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
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
	movq	%rdi, %rax
	movq	%rdi, (%rsp)
	movl	$5, %edi
	callq	*(%rax)
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	anon1, .Lfunc_end1-anon1
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
.Lfunc_end2:
	.size	anon0, .Lfunc_end2-anon0
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

	.type	_retn_1,@object                 # @_retn_1
	.globl	_retn_1
	.p2align	3
_retn_1:
	.quad	0
	.size	_retn_1, 8

	.type	_test_1,@object                 # @_test_1
	.globl	_test_1
	.p2align	3
_test_1:
	.quad	0
	.size	_test_1, 8

	.section	".note.GNU-stack","",@progbits
