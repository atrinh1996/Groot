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
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -16
	movq	_x_1@GOTPCREL(%rip), %rax
	movl	$42, (%rax)
	leaq	.Lfmt(%rip), %rbx
	movq	%rbx, %rdi
	movl	$42, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	_x_2@GOTPCREL(%rip), %rax
	movl	$12, (%rax)
	movq	%rbx, %rdi
	movl	$12, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	leaq	.LglobalChar(%rip), %rdi
	movq	%rdi, 8(%rsp)
	callq	puts@PLT
	movl	%eax, 4(%rsp)
	xorl	%eax, %eax
	addq	$16, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
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

	.type	_x_2,@object                    # @_x_2
	.bss
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
	.asciz	"c"
	.size	.LglobalChar, 2

	.section	".note.GNU-stack","",@progbits
