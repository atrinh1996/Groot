	.text
	.file	"gROOT"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	_x_1@GOTPCREL(%rip), %rax
	movl	$42, (%rax)
	movq	anon0@GOTPCREL(%rip), %rax
	movq	%rax, (%rsp)
	movq	_retn_1@GOTPCREL(%rip), %rcx
	movq	%rsp, %rdx
	movq	%rdx, (%rcx)
	movl	$42, %edi
	movl	$9, %esi
	callq	*%rax
	leaq	.Lfmt(%rip), %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	xorl	%eax, %eax
	popq	%rcx
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
	movl	%esi, -8(%rsp)
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

	.type	_retn_1,@object                 # @_retn_1
	.globl	_retn_1
	.p2align	3
_retn_1:
	.quad	0
	.size	_retn_1, 8

	.type	_x_1,@object                    # @_x_1
	.globl	_x_1
	.p2align	2
_x_1:
	.long	0                               # 0x0
	.size	_x_1, 4

	.section	".note.GNU-stack","",@progbits
