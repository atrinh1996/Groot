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
	andb	$1, %sil
	andl	$1, %edi
	movb	%dil, -1(%rsp)
	movb	%sil, -2(%rsp)
	testb	%sil, %sil
	je	.LBB1_2
# %bb.1:                                # %then
	movb	-1(%rsp), %al
	jmp	.LBB1_3
.LBB1_2:                                # %else
	movb	-2(%rsp), %al
.LBB1_3:                                # %merge
	movb	%al, -3(%rsp)
	movb	-3(%rsp), %al
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

	.section	".note.GNU-stack","",@progbits
