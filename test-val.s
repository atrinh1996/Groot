	.text
	.file	"gROOT"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r14
	pushq	%rbx
	subq	$16, %rsp
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	movq	_x_1@GOTPCREL(%rip), %rax
	movl	$10, (%rax)
	leaq	.Lfmt(%rip), %r14
	movq	%r14, %rdi
	movl	$10, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	_x_2@GOTPCREL(%rip), %rbx
	movl	$7, (%rbx)
	movq	%r14, %rdi
	movl	$7, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	cmpl	$2, (%rbx)
	jle	.LBB0_2
# %bb.1:                                # %then
	movl	$1, -20(%rbp)
	jmp	.LBB0_3
.LBB0_2:                                # %else
	movl	$0, -20(%rbp)
.LBB0_3:                                # %merge
	movl	-20(%rbp), %esi
	movq	_x_3@GOTPCREL(%rip), %rax
	movl	%esi, (%rax)
	leaq	.Lfmt(%rip), %rbx
	movq	%rbx, %rdi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rsp, %rax
	leaq	-16(%rax), %rsp
	leaq	.LglobalChar(%rip), %rdi
	movq	%rdi, -16(%rax)
	movq	_x_4@GOTPCREL(%rip), %rax
	movq	%rdi, (%rax)
	callq	puts@PLT
	movq	_x_5@GOTPCREL(%rip), %rax
	movl	$1, (%rax)
	movq	%rbx, %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rsp, %rax
	leaq	-16(%rax), %rcx
	movq	%rcx, %rsp
	movq	_anon0@GOTPCREL(%rip), %rdx
	movq	%rdx, -16(%rax)
	movq	_x_6@GOTPCREL(%rip), %rax
	movq	%rcx, (%rax)
	xorl	%eax, %eax
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	_anon0                          # -- Begin function _anon0
	.p2align	4, 0x90
	.type	_anon0,@function
_anon0:                                 # @_anon0
	.cfi_startproc
# %bb.0:                                # %entry
	movl	$7, %eax
	retq
.Lfunc_end1:
	.size	_anon0, .Lfunc_end1-_anon0
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

	.type	__anon0_1,@object               # @__anon0_1
	.bss
	.globl	__anon0_1
	.p2align	3
__anon0_1:
	.quad	0
	.size	__anon0_1, 8

	.type	_x_6,@object                    # @_x_6
	.globl	_x_6
	.p2align	3
_x_6:
	.quad	0
	.size	_x_6, 8

	.type	_x_5,@object                    # @_x_5
	.globl	_x_5
	.p2align	2
_x_5:
	.long	0                               # 0x0
	.size	_x_5, 4

	.type	_x_4,@object                    # @_x_4
	.globl	_x_4
	.p2align	3
_x_4:
	.quad	0
	.size	_x_4, 8

	.type	_x_3,@object                    # @_x_3
	.globl	_x_3
	.p2align	2
_x_3:
	.long	0                               # 0x0
	.size	_x_3, 4

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

	.type	.LglobalChar,@object            # @globalChar
	.section	.rodata.str1.1,"aMS",@progbits,1
.LglobalChar:
	.asciz	"a"
	.size	.LglobalChar, 2

	.section	".note.GNU-stack","",@progbits
