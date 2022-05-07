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
	movq	_foo_1@GOTPCREL(%rip), %rax
	movq	_foo_1.1@GOTPCREL(%rip), %rcx
	movq	%rax, (%rcx)
	movl	$1, %edi
	callq	*%rax
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	_foo_1                          # -- Begin function _foo_1
	.p2align	4, 0x90
	.type	_foo_1,@function
_foo_1:                                 # @_foo_1
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	movl	%edi, -4(%rsp)
	retq
.Lfunc_end1:
	.size	_foo_1, .Lfunc_end1-_foo_1
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

	.type	_foo_1.1,@object                # @_foo_1.1
	.bss
	.globl	_foo_1.1
	.p2align	3
_foo_1.1:
	.quad	0
	.size	_foo_1.1, 8

	.section	".note.GNU-stack","",@progbits
