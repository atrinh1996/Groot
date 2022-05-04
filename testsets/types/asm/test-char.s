	.text
	.file	"gROOT"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	leaq	.LglobalChar(%rip), %rax
	movq	%rax, -8(%rsp)
	leaq	.LglobalChar.1(%rip), %rax
	movq	%rax, -16(%rsp)
	leaq	.LglobalChar.2(%rip), %rax
	movq	%rax, -24(%rsp)
	xorl	%eax, %eax
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

	.type	.LglobalChar,@object            # @globalChar
.LglobalChar:
	.asciz	"a"
	.size	.LglobalChar, 2

	.type	.LglobalChar.1,@object          # @globalChar.1
.LglobalChar.1:
	.asciz	" "
	.size	.LglobalChar.1, 2

	.type	.LglobalChar.2,@object          # @globalChar.2
.LglobalChar.2:
	.asciz	"a"
	.size	.LglobalChar.2, 2

	.section	".note.GNU-stack","",@progbits
