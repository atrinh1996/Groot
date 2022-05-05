	.text
	.file	"gROOT"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	_anon0@GOTPCREL(%rip), %rax
	movq	%rax, 16(%rsp)
	movq	"_+_1"@GOTPCREL(%rip), %rax
	leaq	16(%rsp), %rcx
	movq	%rcx, (%rax)
	movq	_anon1@GOTPCREL(%rip), %rax
	movq	%rax, 8(%rsp)
	movq	"_+_2"@GOTPCREL(%rip), %rcx
	leaq	8(%rsp), %rdx
	movq	%rdx, (%rcx)
	movl	$1, %edi
	movl	$222, %esi
	callq	*%rax
	leaq	.Lfmt(%rip), %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	xorl	%eax, %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	_anon1                          # -- Begin function _anon1
	.p2align	4, 0x90
	.type	_anon1,@function
_anon1:                                 # @_anon1
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	movl	%edi, -4(%rsp)
	movl	%esi, -8(%rsp)
	retq
.Lfunc_end1:
	.size	_anon1, .Lfunc_end1-_anon1
	.cfi_endproc
                                        # -- End function
	.globl	_anon0                          # -- Begin function _anon0
	.p2align	4, 0x90
	.type	_anon0,@function
_anon0:                                 # @_anon0
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	movl	%edi, -4(%rsp)
	movl	%esi, -8(%rsp)
	retq
.Lfunc_end2:
	.size	_anon0, .Lfunc_end2-_anon0
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

	.type	"_+_2",@object                  # @"_+_2"
	.bss
	.globl	"_+_2"
	.p2align	3
"_+_2":
	.quad	0
	.size	"_+_2", 8

	.type	"_+_1",@object                  # @"_+_1"
	.globl	"_+_1"
	.p2align	3
"_+_1":
	.quad	0
	.size	"_+_1", 8

	.type	__anon0_1,@object               # @__anon0_1
	.globl	__anon0_1
	.p2align	3
__anon0_1:
	.quad	0
	.size	__anon0_1, 8

	.type	__anon1_1,@object               # @__anon1_1
	.globl	__anon1_1
	.p2align	3
__anon1_1:
	.quad	0
	.size	__anon1_1, 8

	.section	".note.GNU-stack","",@progbits
