	.text
	.file	"example2.c"
	.globl	test                    # -- Begin function test
	.p2align	4, 0x90
	.type	test,@function
test:                                   # @test
.Lfunc_begin0:
	.file	1 "/home/ubuntu/git/homework3_adrianoh/compilervec" "example2.c"
	.loc	1 9 0                   # example2.c:9:0
	.cfi_startproc
# %bb.0:                                # %entry
	#DEBUG_VALUE: test:a <- $rdi
	#DEBUG_VALUE: test:a <- $rdi
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:b <- $rsi
	xorl	%eax, %eax
.Ltmp0:
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:y <- undef
	#DEBUG_VALUE: test:x <- undef
	jmp	.LBB0_1
.Ltmp1:
	.p2align	4, 0x90
.LBB0_65:                               # %pred.store.continue83
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	.loc	1 15 26 prologue_end    # example2.c:15:26
	addq	$32, %rax
	cmpq	$65536, %rax            # imm = 0x10000
	je	.LBB0_66
.Ltmp2:
.LBB0_1:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	.loc	1 17 9                  # example2.c:17:9
	vmovdqu	(%rsi,%rax), %ymm0
	.loc	1 17 16 is_stmt 0       # example2.c:17:16
	vmovdqu	(%rdi,%rax), %ymm1
	.loc	1 17 14                 # example2.c:17:14
	vmovdqa	(%rsi,%rax), %xmm2
	vpminub	(%rdi,%rax), %xmm2, %xmm3
	vpcmpeqb	%xmm3, %xmm2, %xmm2
	vpextrb	$0, %xmm2, %ecx
	notb	%cl
.Ltmp3:
	.loc	1 15 26 is_stmt 1       # example2.c:15:26
	testb	$1, %cl
	je	.LBB0_3
.Ltmp4:
# %bb.2:                                # %pred.store.if
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	.loc	1 17 27                 # example2.c:17:27
	vpextrb	$0, %xmm0, (%rdi,%rax)
.Ltmp5:
.LBB0_3:                                # %pred.store.continue
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$1, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_5
.Ltmp6:
# %bb.4:                                # %pred.store.if22
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$1, %xmm0, 1(%rdi,%rax)
.Ltmp7:
.LBB0_5:                                # %pred.store.continue23
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$2, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_7
.Ltmp8:
# %bb.6:                                # %pred.store.if24
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$2, %xmm0, 2(%rdi,%rax)
.Ltmp9:
.LBB0_7:                                # %pred.store.continue25
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$3, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_9
.Ltmp10:
# %bb.8:                                # %pred.store.if26
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$3, %xmm0, 3(%rdi,%rax)
.Ltmp11:
.LBB0_9:                                # %pred.store.continue27
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$4, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_11
.Ltmp12:
# %bb.10:                               # %pred.store.if28
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$4, %xmm0, 4(%rdi,%rax)
.Ltmp13:
.LBB0_11:                               # %pred.store.continue29
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$5, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_13
.Ltmp14:
# %bb.12:                               # %pred.store.if30
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$5, %xmm0, 5(%rdi,%rax)
.Ltmp15:
.LBB0_13:                               # %pred.store.continue31
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$6, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_15
.Ltmp16:
# %bb.14:                               # %pred.store.if32
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$6, %xmm0, 6(%rdi,%rax)
.Ltmp17:
.LBB0_15:                               # %pred.store.continue33
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$7, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_17
.Ltmp18:
# %bb.16:                               # %pred.store.if34
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$7, %xmm0, 7(%rdi,%rax)
.Ltmp19:
.LBB0_17:                               # %pred.store.continue35
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$8, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_19
.Ltmp20:
# %bb.18:                               # %pred.store.if36
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$8, %xmm0, 8(%rdi,%rax)
.Ltmp21:
.LBB0_19:                               # %pred.store.continue37
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$9, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_21
.Ltmp22:
# %bb.20:                               # %pred.store.if38
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$9, %xmm0, 9(%rdi,%rax)
.Ltmp23:
.LBB0_21:                               # %pred.store.continue39
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$10, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_23
.Ltmp24:
# %bb.22:                               # %pred.store.if40
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$10, %xmm0, 10(%rdi,%rax)
.Ltmp25:
.LBB0_23:                               # %pred.store.continue41
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$11, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_25
.Ltmp26:
# %bb.24:                               # %pred.store.if42
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$11, %xmm0, 11(%rdi,%rax)
.Ltmp27:
.LBB0_25:                               # %pred.store.continue43
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$12, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_27
.Ltmp28:
# %bb.26:                               # %pred.store.if44
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$12, %xmm0, 12(%rdi,%rax)
.Ltmp29:
.LBB0_27:                               # %pred.store.continue45
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$13, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_29
.Ltmp30:
# %bb.28:                               # %pred.store.if46
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$13, %xmm0, 13(%rdi,%rax)
.Ltmp31:
.LBB0_29:                               # %pred.store.continue47
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$14, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_31
.Ltmp32:
# %bb.30:                               # %pred.store.if48
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$14, %xmm0, 14(%rdi,%rax)
.Ltmp33:
.LBB0_31:                               # %pred.store.continue49
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpminub	%xmm1, %xmm0, %xmm2
	vpcmpeqb	%xmm2, %xmm0, %xmm2
	vpextrb	$15, %xmm2, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_33
.Ltmp34:
# %bb.32:                               # %pred.store.if50
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$15, %xmm0, 15(%rdi,%rax)
.Ltmp35:
.LBB0_33:                               # %pred.store.continue51
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vextracti128	$1, %ymm1, %xmm1
	vextracti128	$1, %ymm0, %xmm0
	vpminub	%xmm1, %xmm0, %xmm1
	vpcmpeqb	%xmm1, %xmm0, %xmm1
	vpextrb	$0, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_34
.Ltmp36:
# %bb.35:                               # %pred.store.continue53
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$1, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_36
.Ltmp37:
.LBB0_37:                               # %pred.store.continue55
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$2, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_38
.Ltmp38:
.LBB0_39:                               # %pred.store.continue57
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$3, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_40
.Ltmp39:
.LBB0_41:                               # %pred.store.continue59
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$4, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_42
.Ltmp40:
.LBB0_43:                               # %pred.store.continue61
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$5, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_44
.Ltmp41:
.LBB0_45:                               # %pred.store.continue63
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$6, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_46
.Ltmp42:
.LBB0_47:                               # %pred.store.continue65
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$7, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_48
.Ltmp43:
.LBB0_49:                               # %pred.store.continue67
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$8, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_50
.Ltmp44:
.LBB0_51:                               # %pred.store.continue69
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$9, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_52
.Ltmp45:
.LBB0_53:                               # %pred.store.continue71
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$10, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_54
.Ltmp46:
.LBB0_55:                               # %pred.store.continue73
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$11, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_56
.Ltmp47:
.LBB0_57:                               # %pred.store.continue75
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$12, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_58
.Ltmp48:
.LBB0_59:                               # %pred.store.continue77
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$13, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_60
.Ltmp49:
.LBB0_61:                               # %pred.store.continue79
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$14, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	jne	.LBB0_62
.Ltmp50:
.LBB0_63:                               # %pred.store.continue81
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$15, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_65
	jmp	.LBB0_64
.Ltmp51:
	.p2align	4, 0x90
.LBB0_34:                               # %pred.store.if52
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$0, %xmm0, 16(%rdi,%rax)
	vpextrb	$1, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_37
.Ltmp52:
.LBB0_36:                               # %pred.store.if54
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$1, %xmm0, 17(%rdi,%rax)
	vpextrb	$2, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_39
.Ltmp53:
.LBB0_38:                               # %pred.store.if56
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$2, %xmm0, 18(%rdi,%rax)
	vpextrb	$3, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_41
.Ltmp54:
.LBB0_40:                               # %pred.store.if58
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$3, %xmm0, 19(%rdi,%rax)
	vpextrb	$4, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_43
.Ltmp55:
.LBB0_42:                               # %pred.store.if60
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$4, %xmm0, 20(%rdi,%rax)
	vpextrb	$5, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_45
.Ltmp56:
.LBB0_44:                               # %pred.store.if62
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$5, %xmm0, 21(%rdi,%rax)
	vpextrb	$6, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_47
.Ltmp57:
.LBB0_46:                               # %pred.store.if64
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$6, %xmm0, 22(%rdi,%rax)
	vpextrb	$7, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_49
.Ltmp58:
.LBB0_48:                               # %pred.store.if66
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$7, %xmm0, 23(%rdi,%rax)
	vpextrb	$8, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_51
.Ltmp59:
.LBB0_50:                               # %pred.store.if68
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$8, %xmm0, 24(%rdi,%rax)
	vpextrb	$9, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_53
.Ltmp60:
.LBB0_52:                               # %pred.store.if70
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$9, %xmm0, 25(%rdi,%rax)
	vpextrb	$10, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_55
.Ltmp61:
.LBB0_54:                               # %pred.store.if72
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$10, %xmm0, 26(%rdi,%rax)
	vpextrb	$11, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_57
.Ltmp62:
.LBB0_56:                               # %pred.store.if74
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$11, %xmm0, 27(%rdi,%rax)
	vpextrb	$12, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_59
.Ltmp63:
.LBB0_58:                               # %pred.store.if76
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$12, %xmm0, 28(%rdi,%rax)
	vpextrb	$13, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_61
.Ltmp64:
.LBB0_60:                               # %pred.store.if78
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$13, %xmm0, 29(%rdi,%rax)
	vpextrb	$14, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_63
.Ltmp65:
.LBB0_62:                               # %pred.store.if80
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$14, %xmm0, 30(%rdi,%rax)
	vpextrb	$15, %xmm1, %ecx
	notb	%cl
	testb	$1, %cl
	je	.LBB0_65
.Ltmp66:
.LBB0_64:                               # %pred.store.if82
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	vpextrb	$15, %xmm0, 31(%rdi,%rax)
	jmp	.LBB0_65
.Ltmp67:
.LBB0_66:                               # %for.end
	#DEBUG_VALUE: test:i <- 0
	#DEBUG_VALUE: test:b <- $rsi
	#DEBUG_VALUE: test:a <- $rdi
	.loc	1 19 1                  # example2.c:19:1
	vzeroupper
	retq
.Ltmp68:
.Lfunc_end0:
	.size	test, .Lfunc_end0-test
	.cfi_endproc
                                        # -- End function
	.file	2 "/usr/include/x86_64-linux-gnu/bits" "types.h"
	.file	3 "/usr/include/x86_64-linux-gnu/bits" "stdint-uintn.h"
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"clang version 10.0.1 " # string offset=0
.Linfo_string1:
	.asciz	"example2.c"            # string offset=22
.Linfo_string2:
	.asciz	"/home/ubuntu/git/homework3_adrianoh/compilervec" # string offset=33
.Linfo_string3:
	.asciz	"test"                  # string offset=81
.Linfo_string4:
	.asciz	"a"                     # string offset=86
.Linfo_string5:
	.asciz	"unsigned char"         # string offset=88
.Linfo_string6:
	.asciz	"__uint8_t"             # string offset=102
.Linfo_string7:
	.asciz	"uint8_t"               # string offset=112
.Linfo_string8:
	.asciz	"b"                     # string offset=120
.Linfo_string9:
	.asciz	"i"                     # string offset=122
.Linfo_string10:
	.asciz	"long unsigned int"     # string offset=124
.Linfo_string11:
	.asciz	"__uint64_t"            # string offset=142
.Linfo_string12:
	.asciz	"uint64_t"              # string offset=153
.Linfo_string13:
	.asciz	"y"                     # string offset=162
.Linfo_string14:
	.asciz	"x"                     # string offset=164
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	85                      # DW_OP_reg5
	.quad	0
	.quad	0
.Ldebug_loc1:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	0
	.quad	0
.Ldebug_loc2:
	.quad	.Ltmp0-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	48                      # DW_OP_lit0
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
	.section	.debug_abbrev,"",@progbits
	.byte	1                       # Abbreviation Code
	.byte	17                      # DW_TAG_compile_unit
	.byte	1                       # DW_CHILDREN_yes
	.byte	37                      # DW_AT_producer
	.byte	14                      # DW_FORM_strp
	.byte	19                      # DW_AT_language
	.byte	5                       # DW_FORM_data2
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	16                      # DW_AT_stmt_list
	.byte	23                      # DW_FORM_sec_offset
	.byte	27                      # DW_AT_comp_dir
	.byte	14                      # DW_FORM_strp
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	2                       # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	64                      # DW_AT_frame_base
	.byte	24                      # DW_FORM_exprloc
	.ascii	"\227B"                 # DW_AT_GNU_all_call_sites
	.byte	25                      # DW_FORM_flag_present
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.byte	63                      # DW_AT_external
	.byte	25                      # DW_FORM_flag_present
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	3                       # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	4                       # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	5                       # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	6                       # Abbreviation Code
	.byte	55                      # DW_TAG_restrict_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	7                       # Abbreviation Code
	.byte	15                      # DW_TAG_pointer_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	8                       # Abbreviation Code
	.byte	22                      # DW_TAG_typedef
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	9                       # Abbreviation Code
	.byte	36                      # DW_TAG_base_type
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	62                      # DW_AT_encoding
	.byte	11                      # DW_FORM_data1
	.byte	11                      # DW_AT_byte_size
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	0                       # EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.long	.Ldebug_info_end0-.Ldebug_info_start0 # Length of Unit
.Ldebug_info_start0:
	.short	4                       # DWARF version number
	.long	.debug_abbrev           # Offset Into Abbrev. Section
	.byte	8                       # Address Size (in bytes)
	.byte	1                       # Abbrev [1] 0xb:0xbd DW_TAG_compile_unit
	.long	.Linfo_string0          # DW_AT_producer
	.short	12                      # DW_AT_language
	.long	.Linfo_string1          # DW_AT_name
	.long	.Lline_table_start0     # DW_AT_stmt_list
	.long	.Linfo_string2          # DW_AT_comp_dir
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0 # DW_AT_high_pc
	.byte	2                       # Abbrev [2] 0x2a:0x59 DW_TAG_subprogram
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0 # DW_AT_high_pc
	.byte	1                       # DW_AT_frame_base
	.byte	87
                                        # DW_AT_GNU_all_call_sites
	.long	.Linfo_string3          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	9                       # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_external
	.byte	3                       # Abbrev [3] 0x3f:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc0            # DW_AT_location
	.long	.Linfo_string4          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	9                       # DW_AT_decl_line
	.long	131                     # DW_AT_type
	.byte	3                       # Abbrev [3] 0x4e:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc1            # DW_AT_location
	.long	.Linfo_string8          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	9                       # DW_AT_decl_line
	.long	131                     # DW_AT_type
	.byte	4                       # Abbrev [4] 0x5d:0xf DW_TAG_variable
	.long	.Ldebug_loc2            # DW_AT_location
	.long	.Linfo_string9          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	10                      # DW_AT_decl_line
	.long	170                     # DW_AT_type
	.byte	5                       # Abbrev [5] 0x6c:0xb DW_TAG_variable
	.long	.Linfo_string13         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	13                      # DW_AT_decl_line
	.long	136                     # DW_AT_type
	.byte	5                       # Abbrev [5] 0x77:0xb DW_TAG_variable
	.long	.Linfo_string14         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	12                      # DW_AT_decl_line
	.long	136                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	6                       # Abbrev [6] 0x83:0x5 DW_TAG_restrict_type
	.long	136                     # DW_AT_type
	.byte	7                       # Abbrev [7] 0x88:0x5 DW_TAG_pointer_type
	.long	141                     # DW_AT_type
	.byte	8                       # Abbrev [8] 0x8d:0xb DW_TAG_typedef
	.long	152                     # DW_AT_type
	.long	.Linfo_string7          # DW_AT_name
	.byte	3                       # DW_AT_decl_file
	.byte	24                      # DW_AT_decl_line
	.byte	8                       # Abbrev [8] 0x98:0xb DW_TAG_typedef
	.long	163                     # DW_AT_type
	.long	.Linfo_string6          # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	37                      # DW_AT_decl_line
	.byte	9                       # Abbrev [9] 0xa3:0x7 DW_TAG_base_type
	.long	.Linfo_string5          # DW_AT_name
	.byte	8                       # DW_AT_encoding
	.byte	1                       # DW_AT_byte_size
	.byte	8                       # Abbrev [8] 0xaa:0xb DW_TAG_typedef
	.long	181                     # DW_AT_type
	.long	.Linfo_string12         # DW_AT_name
	.byte	3                       # DW_AT_decl_file
	.byte	27                      # DW_AT_decl_line
	.byte	8                       # Abbrev [8] 0xb5:0xb DW_TAG_typedef
	.long	192                     # DW_AT_type
	.long	.Linfo_string11         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	44                      # DW_AT_decl_line
	.byte	9                       # Abbrev [9] 0xc0:0x7 DW_TAG_base_type
	.long	.Linfo_string10         # DW_AT_name
	.byte	7                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	0                       # End Of Children Mark
.Ldebug_info_end0:
	.ident	"clang version 10.0.1 "
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.section	.debug_line,"",@progbits
.Lline_table_start0:
