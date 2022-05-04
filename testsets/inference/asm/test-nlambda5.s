	.text
	.file	"gROOT"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	movq	anon0@GOTPCREL(%rip), %rax
	movq	%rax, -8(%rsp)
	movq	_testAB_1@GOTPCREL(%rip), %rax
	leaq	-8(%rsp), %rcx
	movq	%rcx, (%rax)
	xorl	%eax, %eax
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
	movl	%edi, -20(%rsp)
	movq	anon1@GOTPCREL(%rip), %rax
	movq	%rax, -16(%rsp)
	movl	%edi, -8(%rsp)
	leaq	-16(%rsp), %rax
	retq
.Lfunc_end1:
	.size	anon0, .Lfunc_end1-anon0
	.cfi_endproc
                                        # -- End function
	.globl	anon1                           # -- Begin function anon1
	.p2align	4, 0x90
	.type	anon1,@function
anon1:                                  # @anon1
	.cfi_startproc
# %bb.0:                                # %entry
                                        # kill: def $esi killed $esi def $rsi
                                        # kill: def $edi killed $edi def $rdi
	movl	%edi, -4(%rsp)
	movl	%esi, -8(%rsp)
	leal	(%rsi,%rdi), %eax
	retq
.Lfunc_end2:
	.size	anon1, .Lfunc_end2-anon1
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

	.type	_testAB_1,@object               # @_testAB_1
	.globl	_testAB_1
	.p2align	3
_testAB_1:
	.quad	0
	.size	_testAB_1, 8

	.section	".note.GNU-stack","",@progbits
