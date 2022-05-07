	.text
	.file	"gROOT"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	movl	$5, -4(%rsp)
	xorl	%eax, %eax
	testb	%al, %al
	jne	.LBB0_3
# %bb.1:                                # %entry
	xorl	%eax, %eax
	testb	%al, %al
	je	.LBB0_3
# %bb.2:                                # %then4
	movl	$9, -12(%rsp)
	cmpl	$3, -12(%rsp)
	jg	.LBB0_5
.LBB0_6:                                # %else9
	movl	$6, -8(%rsp)
	xorl	%eax, %eax
	retq
.LBB0_3:                                # %else5
	movl	$6, -12(%rsp)
	cmpl	$3, -12(%rsp)
	jle	.LBB0_6
.LBB0_5:                                # %then8
	movl	$5, -8(%rsp)
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

	.section	".note.GNU-stack","",@progbits
