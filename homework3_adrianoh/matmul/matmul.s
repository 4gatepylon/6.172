	.text
	.file	"matmul.c"
	.file	1 "/usr/include" "stdlib.h"
	.file	2 "/usr/include" "time.h"
	.file	3 "/usr/include/x86_64-linux-gnu/bits" "types.h"
	.file	4 "/usr/include/x86_64-linux-gnu/bits/types" "struct_timespec.h"
	.file	5 "/home/ubuntu/git/homework3_adrianoh/matmul" "matmul.c"
	.globl	matmul_base             # -- Begin function matmul_base
	.p2align	4, 0x90
	.type	matmul_base,@function
matmul_base:                            # @matmul_base
.Lfunc_begin0:
	.loc	5 45 0                  # matmul.c:45:0
	.cfi_startproc
# %bb.0:                                # %entry
	#DEBUG_VALUE: matmul_base:C <- $rdi
	#DEBUG_VALUE: matmul_base:A <- $rsi
	#DEBUG_VALUE: matmul_base:B <- $rdx
	#DEBUG_VALUE: matmul_base:size <- $r8d
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %r14
.Ltmp0:
	#DEBUG_VALUE: matmul_base:A <- $r14
	movq	%rdi, %rbx
	#DEBUG_VALUE: matmul_base:row_length <- undef
	#DEBUG_VALUE: matmul_base:size <- $r8d
.Ltmp1:
	#DEBUG_VALUE: matmul_base:B <- undef
	#DEBUG_VALUE: matmul_base:A <- undef
	#DEBUG_VALUE: matmul_base:C <- undef
	.loc	5 51 12 prologue_end    # matmul.c:51:12
	cmpl	$32, %r8d
.Ltmp2:
	.loc	5 51 7 is_stmt 0        # matmul.c:51:7
	je	.LBB0_2
.Ltmp3:
# %bb.1:                                # %if.then
	#DEBUG_VALUE: matmul_base:A <- $r14
	#DEBUG_VALUE: matmul_base:size <- $r8d
	#DEBUG_VALUE: matmul_base:B <- $rdx
	#DEBUG_VALUE: matmul_base:C <- $rdi
	.loc	5 52 5 is_stmt 1        # matmul.c:52:5
	movl	$.L.str, %edi
.Ltmp4:
	movl	%r8d, %esi
	xorl	%eax, %eax
	callq	printf
.Ltmp5:
	#DEBUG_VALUE: matmul_base:size <- [DW_OP_constu 0, DW_OP_div, DW_OP_stack_value] undef
.LBB0_2:                                # %for.cond8.preheader.preheader
	#DEBUG_VALUE: matmul_base:A <- $r14
	.loc	5 57 3                  # matmul.c:57:3
	leaq	96(%r14), %r8
	xorl	%r15d, %r15d
.Ltmp6:
	.p2align	4, 0x90
.LBB0_3:                                # %for.cond8.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
	#DEBUG_VALUE: matmul_base:A <- $r14
	#DEBUG_VALUE: ACrow <- $r15
	#DEBUG_VALUE: i <- 0
	.loc	5 0 0 is_stmt 0         # matmul.c:0:0
	movq	%r15, %rdx
	.loc	5 63 24 is_stmt 1       # matmul.c:63:24
	movq	%r15, %rdi
	shlq	$7, %rdi
.Ltmp7:
	#DEBUG_VALUE: idx <- 7
	.loc	5 63 22 is_stmt 0       # matmul.c:63:22
	vmovss	(%r14,%rdi), %xmm0      # xmm0 = mem[0],zero,zero,zero
	vmovss	16(%r14,%rdi), %xmm1    # xmm1 = mem[0],zero,zero,zero
	vinsertps	$16, 4(%r14,%rdi), %xmm0, %xmm0 # xmm0 = xmm0[0],mem[0],xmm0[2,3]
	vinsertps	$32, 8(%r14,%rdi), %xmm0, %xmm0 # xmm0 = xmm0[0,1],mem[0],xmm0[3]
	vinsertps	$48, 12(%r14,%rdi), %xmm0, %xmm2 # xmm2 = xmm0[0,1,2],mem[0]
	vinsertps	$16, 20(%r14,%rdi), %xmm1, %xmm0 # xmm0 = xmm1[0],mem[0],xmm1[2,3]
	vinsertps	$32, 24(%r14,%rdi), %xmm0, %xmm0 # xmm0 = xmm0[0,1],mem[0],xmm0[3]
	vinsertps	$48, 28(%r14,%rdi), %xmm0, %xmm3 # xmm3 = xmm0[0,1,2],mem[0]
	.loc	5 66 22 is_stmt 1       # matmul.c:66:22
	vmovss	(%rbx,%rdi), %xmm1      # xmm1 = mem[0],zero,zero,zero
	vmovss	16(%rbx,%rdi), %xmm0    # xmm0 = mem[0],zero,zero,zero
	vinsertps	$16, 20(%rbx,%rdi), %xmm0, %xmm0 # xmm0 = xmm0[0],mem[0],xmm0[2,3]
	vinsertps	$32, 24(%rbx,%rdi), %xmm0, %xmm0 # xmm0 = xmm0[0,1],mem[0],xmm0[3]
	vinsertps	$48, 28(%rbx,%rdi), %xmm0, %xmm0 # xmm0 = xmm0[0,1,2],mem[0]
	vinsertps	$16, 4(%rbx,%rdi), %xmm1, %xmm1 # xmm1 = xmm1[0],mem[0],xmm1[2,3]
	vinsertps	$32, 8(%rbx,%rdi), %xmm1, %xmm1 # xmm1 = xmm1[0,1],mem[0],xmm1[3]
	vinsertps	$48, 12(%rbx,%rdi), %xmm1, %xmm1 # xmm1 = xmm1[0,1,2],mem[0]
	.loc	5 63 22                 # matmul.c:63:22
	vmovaps	%xmm3, Avec+16(%rip)
	.loc	5 0 0 is_stmt 0         # matmul.c:0:0
	shlq	$5, %rdx
.Ltmp8:
	#DEBUG_VALUE: idx <- 0
	.loc	5 63 22                 # matmul.c:63:22
	vmovaps	%xmm2, Avec(%rip)
.Ltmp9:
	#DEBUG_VALUE: i <- 1
	vmovss	32(%r14,%rdx,4), %xmm2  # xmm2 = mem[0],zero,zero,zero
	vinsertps	$16, 36(%r14,%rdi), %xmm2, %xmm2 # xmm2 = xmm2[0],mem[0],xmm2[2,3]
	vinsertps	$32, 40(%r14,%rdi), %xmm2, %xmm2 # xmm2 = xmm2[0,1],mem[0],xmm2[3]
	vinsertps	$48, 44(%r14,%rdi), %xmm2, %xmm2 # xmm2 = xmm2[0,1,2],mem[0]
	vmovss	48(%r14,%rdi), %xmm3    # xmm3 = mem[0],zero,zero,zero
	vinsertps	$16, 52(%r14,%rdi), %xmm3, %xmm3 # xmm3 = xmm3[0],mem[0],xmm3[2,3]
	vinsertps	$32, 56(%r14,%rdi), %xmm3, %xmm3 # xmm3 = xmm3[0,1],mem[0],xmm3[3]
	vinsertps	$48, 60(%r14,%rdi), %xmm3, %xmm3 # xmm3 = xmm3[0,1,2],mem[0]
	.loc	5 66 22 is_stmt 1       # matmul.c:66:22
	vmovss	48(%rbx,%rdi), %xmm4    # xmm4 = mem[0],zero,zero,zero
	vinsertps	$16, 52(%rbx,%rdi), %xmm4, %xmm4 # xmm4 = xmm4[0],mem[0],xmm4[2,3]
	vinsertps	$32, 56(%rbx,%rdi), %xmm4, %xmm4 # xmm4 = xmm4[0,1],mem[0],xmm4[3]
	vinsertps	$48, 60(%rbx,%rdi), %xmm4, %xmm4 # xmm4 = xmm4[0,1,2],mem[0]
	vmovss	32(%rbx,%rdx,4), %xmm5  # xmm5 = mem[0],zero,zero,zero
	vinsertps	$16, 36(%rbx,%rdi), %xmm5, %xmm5 # xmm5 = xmm5[0],mem[0],xmm5[2,3]
	vinsertps	$32, 40(%rbx,%rdi), %xmm5, %xmm5 # xmm5 = xmm5[0,1],mem[0],xmm5[3]
	vinsertps	$48, 44(%rbx,%rdi), %xmm5, %xmm5 # xmm5 = xmm5[0,1,2],mem[0]
	.loc	5 63 22                 # matmul.c:63:22
	vmovaps	%xmm3, Avec+48(%rip)
	vmovaps	%xmm2, Avec+32(%rip)
.Ltmp10:
	#DEBUG_VALUE: i <- 2
	vmovss	64(%r14,%rdx,4), %xmm2  # xmm2 = mem[0],zero,zero,zero
	vinsertps	$16, 68(%r14,%rdi), %xmm2, %xmm2 # xmm2 = xmm2[0],mem[0],xmm2[2,3]
	vinsertps	$32, 72(%r14,%rdi), %xmm2, %xmm2 # xmm2 = xmm2[0,1],mem[0],xmm2[3]
	vinsertps	$48, 76(%r14,%rdi), %xmm2, %xmm2 # xmm2 = xmm2[0,1,2],mem[0]
	vmovss	80(%r14,%rdi), %xmm3    # xmm3 = mem[0],zero,zero,zero
	vinsertps	$16, 84(%r14,%rdi), %xmm3, %xmm3 # xmm3 = xmm3[0],mem[0],xmm3[2,3]
	vinsertps	$32, 88(%r14,%rdi), %xmm3, %xmm3 # xmm3 = xmm3[0,1],mem[0],xmm3[3]
	.loc	5 66 22                 # matmul.c:66:22
	vinsertf128	$1, %xmm0, %ymm1, %ymm0
.Ltmp11:
	#DEBUG_VALUE: idx <- 8
	.loc	5 63 22                 # matmul.c:63:22
	vinsertps	$48, 92(%r14,%rdi), %xmm3, %xmm1 # xmm1 = xmm3[0,1,2],mem[0]
	.loc	5 66 22                 # matmul.c:66:22
	vmovss	80(%rbx,%rdi), %xmm3    # xmm3 = mem[0],zero,zero,zero
	vinsertps	$16, 84(%rbx,%rdi), %xmm3, %xmm3 # xmm3 = xmm3[0],mem[0],xmm3[2,3]
	vinsertps	$32, 88(%rbx,%rdi), %xmm3, %xmm3 # xmm3 = xmm3[0,1],mem[0],xmm3[3]
	.loc	5 0 0 is_stmt 0         # matmul.c:0:0
	leaq	8(%rdx), %r9
.Ltmp12:
	#DEBUG_VALUE: idx <- 7
	.loc	5 66 22                 # matmul.c:66:22
	vinsertps	$48, 92(%rbx,%rdi), %xmm3, %xmm3 # xmm3 = xmm3[0,1,2],mem[0]
	vmovss	64(%rbx,%rdx,4), %xmm6  # xmm6 = mem[0],zero,zero,zero
	vinsertps	$16, 68(%rbx,%rdi), %xmm6, %xmm6 # xmm6 = xmm6[0],mem[0],xmm6[2,3]
	vinsertps	$32, 72(%rbx,%rdi), %xmm6, %xmm6 # xmm6 = xmm6[0,1],mem[0],xmm6[3]
	vinsertps	$48, 76(%rbx,%rdi), %xmm6, %xmm6 # xmm6 = xmm6[0,1,2],mem[0]
	.loc	5 63 22 is_stmt 1       # matmul.c:63:22
	vmovaps	%xmm1, Avec+80(%rip)
	.loc	5 66 22                 # matmul.c:66:22
	vinsertf128	$1, %xmm4, %ymm5, %ymm1
.Ltmp13:
	#DEBUG_VALUE: idx <- 8
	.loc	5 63 22                 # matmul.c:63:22
	vmovaps	%xmm2, Avec+64(%rip)
.Ltmp14:
	#DEBUG_VALUE: idx <- 0
	#DEBUG_VALUE: i <- 3
	vmovss	96(%r14,%rdx,4), %xmm2  # xmm2 = mem[0],zero,zero,zero
	vinsertps	$16, 100(%r14,%rdi), %xmm2, %xmm2 # xmm2 = xmm2[0],mem[0],xmm2[2,3]
	vinsertps	$32, 104(%r14,%rdi), %xmm2, %xmm2 # xmm2 = xmm2[0,1],mem[0],xmm2[3]
	.loc	5 0 0 is_stmt 0         # matmul.c:0:0
	leaq	16(%rdx), %r10
.Ltmp15:
	#DEBUG_VALUE: idx <- 7
	.loc	5 63 22                 # matmul.c:63:22
	vinsertps	$48, 108(%r14,%rdi), %xmm2, %xmm4 # xmm4 = xmm2[0,1,2],mem[0]
	vmovss	112(%r14,%rdi), %xmm2   # xmm2 = mem[0],zero,zero,zero
	vinsertps	$16, 116(%r14,%rdi), %xmm2, %xmm2 # xmm2 = xmm2[0],mem[0],xmm2[2,3]
	vinsertps	$32, 120(%r14,%rdi), %xmm2, %xmm5 # xmm5 = xmm2[0,1],mem[0],xmm2[3]
	.loc	5 66 22 is_stmt 1       # matmul.c:66:22
	vinsertf128	$1, %xmm3, %ymm6, %ymm2
.Ltmp16:
	#DEBUG_VALUE: idx <- 8
	.loc	5 63 22                 # matmul.c:63:22
	vinsertps	$48, 124(%r14,%rdi), %xmm5, %xmm3 # xmm3 = xmm5[0,1,2],mem[0]
	.loc	5 66 22                 # matmul.c:66:22
	vmovss	112(%rbx,%rdi), %xmm5   # xmm5 = mem[0],zero,zero,zero
	vinsertps	$16, 116(%rbx,%rdi), %xmm5, %xmm5 # xmm5 = xmm5[0],mem[0],xmm5[2,3]
	vinsertps	$32, 120(%rbx,%rdi), %xmm5, %xmm5 # xmm5 = xmm5[0,1],mem[0],xmm5[3]
	.loc	5 0 0 is_stmt 0         # matmul.c:0:0
	leaq	24(%rdx), %r11
.Ltmp17:
	#DEBUG_VALUE: idx <- 7
	.loc	5 66 22                 # matmul.c:66:22
	vinsertps	$48, 124(%rbx,%rdi), %xmm5, %xmm5 # xmm5 = xmm5[0,1,2],mem[0]
	vmovss	96(%rbx,%rdx,4), %xmm6  # xmm6 = mem[0],zero,zero,zero
	vinsertps	$16, 100(%rbx,%rdi), %xmm6, %xmm6 # xmm6 = xmm6[0],mem[0],xmm6[2,3]
	vinsertps	$32, 104(%rbx,%rdi), %xmm6, %xmm6 # xmm6 = xmm6[0,1],mem[0],xmm6[3]
	vinsertps	$48, 108(%rbx,%rdi), %xmm6, %xmm6 # xmm6 = xmm6[0,1,2],mem[0]
	.loc	5 63 22 is_stmt 1       # matmul.c:63:22
	vmovaps	%xmm3, Avec+112(%rip)
	.loc	5 66 22                 # matmul.c:66:22
	vinsertf128	$1, %xmm5, %ymm6, %ymm3
.Ltmp18:
	#DEBUG_VALUE: idx <- 8
	.loc	5 63 22                 # matmul.c:63:22
	vmovaps	%xmm4, Avec+96(%rip)
.Ltmp19:
	#DEBUG_VALUE: i <- 4
	.loc	5 0 22 is_stmt 0        # matmul.c:0:22
	movq	%r8, %rdi
	movl	$0, %esi
.Ltmp20:
	#DEBUG_VALUE: Brow <- 0
	.p2align	4, 0x90
.LBB0_4:                                # %for.cond37.preheader
                                        #   Parent Loop BB0_3 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#DEBUG_VALUE: ACrow <- $r15
	#DEBUG_VALUE: matmul_base:A <- $r14
	#DEBUG_VALUE: Brow <- $rsi
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: idx <- 0
	.loc	5 77 26 is_stmt 1       # matmul.c:77:26
	vmovaps	-96(%rdi), %ymm4
.Ltmp21:
	#DEBUG_VALUE: i <- 1
	vmovaps	-64(%rdi), %ymm5
.Ltmp22:
	#DEBUG_VALUE: i <- 2
	vmovaps	-32(%rdi), %ymm6
.Ltmp23:
	#DEBUG_VALUE: i <- 3
	vmovaps	(%rdi), %ymm7
.Ltmp24:
	#DEBUG_VALUE: idx <- 8
	#DEBUG_VALUE: i <- 4
	.loc	5 82 18                 # matmul.c:82:18
	movl	%esi, %ecx
	andl	$-8, %ecx
	.loc	5 82 38 is_stmt 0       # matmul.c:82:38
	movl	%esi, %eax
	andl	$7, %eax
	.loc	5 82 18                 # matmul.c:82:18
	shlq	$2, %rax
	vbroadcastss	Avec(%rax,%rcx,4), %ymm8
	.loc	5 82 43                 # matmul.c:82:43
	vmulps	%ymm4, %ymm8, %ymm9
	.loc	5 82 15                 # matmul.c:82:15
	vaddps	%ymm0, %ymm9, %ymm0
	.loc	5 83 43 is_stmt 1       # matmul.c:83:43
	vmulps	%ymm5, %ymm8, %ymm9
	.loc	5 83 15 is_stmt 0       # matmul.c:83:15
	vaddps	%ymm1, %ymm9, %ymm1
	.loc	5 84 43 is_stmt 1       # matmul.c:84:43
	vmulps	%ymm6, %ymm8, %ymm9
	.loc	5 84 15 is_stmt 0       # matmul.c:84:15
	vaddps	%ymm2, %ymm9, %ymm2
	.loc	5 85 43 is_stmt 1       # matmul.c:85:43
	vmulps	%ymm7, %ymm8, %ymm8
	.loc	5 85 15 is_stmt 0       # matmul.c:85:15
	vaddps	%ymm3, %ymm8, %ymm3
.Ltmp25:
	.loc	5 72 39 is_stmt 1       # matmul.c:72:39
	incq	%rsi
.Ltmp26:
	#DEBUG_VALUE: Brow <- $rsi
	.loc	5 72 29 is_stmt 0       # matmul.c:72:29
	subq	$-128, %rdi
	cmpq	$32, %rsi
.Ltmp27:
	.loc	5 72 5                  # matmul.c:72:5
	jne	.LBB0_4
.Ltmp28:
# %bb.5:                                # %for.cond97.preheader
                                        #   in Loop: Header=BB0_3 Depth=1
	#DEBUG_VALUE: ACrow <- $r15
	#DEBUG_VALUE: matmul_base:A <- $r14
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: idx <- 7
	.loc	5 92 37 is_stmt 1       # matmul.c:92:37
	vmovaps	%ymm0, (%rbx,%rdx,4)
.Ltmp29:
	#DEBUG_VALUE: i <- 1
	vmovaps	%ymm1, (%rbx,%r9,4)
.Ltmp30:
	#DEBUG_VALUE: i <- 2
	vmovaps	%ymm2, (%rbx,%r10,4)
.Ltmp31:
	#DEBUG_VALUE: i <- 3
	vmovaps	%ymm3, (%rbx,%r11,4)
.Ltmp32:
	#DEBUG_VALUE: idx <- 8
	#DEBUG_VALUE: i <- 4
	.loc	5 57 40                 # matmul.c:57:40
	incq	%r15
.Ltmp33:
	#DEBUG_VALUE: ACrow <- $r15
	.loc	5 57 29 is_stmt 0       # matmul.c:57:29
	cmpq	$32, %r15
.Ltmp34:
	.loc	5 57 3                  # matmul.c:57:3
	jne	.LBB0_3
.Ltmp35:
# %bb.6:                                # %for.cond.cleanup
	#DEBUG_VALUE: ACrow <- $r15
	#DEBUG_VALUE: matmul_base:A <- $r14
	.loc	5 66 22 is_stmt 1       # matmul.c:66:22
	vmovaps	%ymm0, Cvec(%rip)
	vmovaps	%ymm1, Cvec+32(%rip)
	vmovaps	%ymm2, Cvec+64(%rip)
	vmovaps	%ymm3, Cvec+96(%rip)
.Ltmp36:
	.loc	5 77 24                 # matmul.c:77:24
	vmovaps	%ymm4, Bvec(%rip)
	vmovaps	%ymm5, Bvec+32(%rip)
	vmovaps	%ymm6, Bvec+64(%rip)
	vmovaps	%ymm7, Bvec+96(%rip)
.Ltmp37:
	.loc	5 96 1                  # matmul.c:96:1
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%r14
.Ltmp38:
	.cfi_def_cfa_offset 16
	popq	%r15
.Ltmp39:
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.Ltmp40:
.Lfunc_end0:
	.size	matmul_base, .Lfunc_end0-matmul_base
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2               # -- Begin function main
.LCPI1_0:
	.long	805306368               # float 4.65661287E-10
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI1_1:
	.quad	4472406533629990549     # double 1.0000000000000001E-9
	.text
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
.Lfunc_begin1:
	.loc	5 157 0                 # matmul.c:157:0
	.cfi_startproc
# %bb.0:                                # %entry
	#DEBUG_VALUE: main:argc <- $edi
	#DEBUG_VALUE: main:argv <- $rsi
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$120, %rsp
	.cfi_def_cfa_offset 176
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movl	$10, %r12d
.Ltmp41:
	#DEBUG_VALUE: main:lg_n <- 10
	#DEBUG_VALUE: main:argv <- $rsi
	#DEBUG_VALUE: main:argc <- $edi
	.loc	5 161 12 prologue_end   # matmul.c:161:12
	cmpl	$2, %edi
.Ltmp42:
	.loc	5 161 7 is_stmt 0       # matmul.c:161:7
	jl	.LBB1_2
.Ltmp43:
# %bb.1:                                # %if.then
	#DEBUG_VALUE: main:lg_n <- 10
	#DEBUG_VALUE: main:argv <- $rsi
	#DEBUG_VALUE: main:argc <- $edi
	.loc	5 162 17 is_stmt 1      # matmul.c:162:17
	movq	8(%rsi), %rdi
.Ltmp44:
	#DEBUG_VALUE: atoi:__nptr <- $rdi
	.loc	1 363 16                # /usr/include/stdlib.h:363:16
	xorl	%esi, %esi
.Ltmp45:
	movl	$10, %edx
	callq	strtol
.Ltmp46:
	movq	%rax, %r12
.Ltmp47:
	#DEBUG_VALUE: main:lg_n <- $r12d
.LBB1_2:                                # %if.end
	#DEBUG_VALUE: main:lg_n <- $r12d
	.loc	1 0 16 is_stmt 0        # /usr/include/stdlib.h:0:16
	movl	$1, %eax
	.loc	5 165 19 is_stmt 1      # matmul.c:165:19
	shlxl	%r12d, %eax, %r13d
.Ltmp48:
	#DEBUG_VALUE: main:n <- $r13d
	.loc	5 167 20                # matmul.c:167:20
	cmpl	$33, %r13d
	movl	$32, %eax
	cmovll	%r13d, %eax
.Ltmp49:
	#DEBUG_VALUE: main:size <- $eax
	.loc	5 0 20 is_stmt 0        # matmul.c:0:20
	movl	%eax, 4(%rsp)           # 4-byte Spill
.Ltmp50:
	#DEBUG_VALUE: main:size <- [DW_OP_plus_uconst 4] [$rsp+0]
	#DEBUG_VALUE: main:size <- [DW_OP_plus_uconst 4] [$rsp+0]
	.loc	5 172 30 is_stmt 1      # matmul.c:172:30
	shlxl	%r12d, %r13d, %eax
	.loc	5 172 28 is_stmt 0      # matmul.c:172:28
	movslq	%eax, %rbp
	.loc	5 172 34                # matmul.c:172:34
	shlq	$2, %rbp
	.loc	5 172 21                # matmul.c:172:21
	movq	%rbp, %rdi
	callq	malloc
.Ltmp51:
	.loc	5 0 21                  # matmul.c:0:21
	movq	%rax, 24(%rsp)          # 8-byte Spill
.Ltmp52:
	#DEBUG_VALUE: main:A <- [DW_OP_plus_uconst 24] [$rsp+0]
	.loc	5 173 21 is_stmt 1      # matmul.c:173:21
	movq	%rbp, %rdi
	callq	malloc
.Ltmp53:
	.loc	5 0 21 is_stmt 0        # matmul.c:0:21
	movq	%rax, 16(%rsp)          # 8-byte Spill
.Ltmp54:
	#DEBUG_VALUE: main:B <- [DW_OP_plus_uconst 16] [$rsp+0]
	.loc	5 174 21 is_stmt 1      # matmul.c:174:21
	movq	%rbp, %rdi
	callq	malloc
.Ltmp55:
	.loc	5 0 21 is_stmt 0        # matmul.c:0:21
	movq	%rax, 8(%rsp)           # 8-byte Spill
.Ltmp56:
	#DEBUG_VALUE: main:C <- [DW_OP_plus_uconst 8] [$rsp+0]
	.loc	5 187 3 is_stmt 1       # matmul.c:187:3
	movslq	%r13d, %rax
	movq	%rax, 48(%rsp)          # 8-byte Spill
.Ltmp57:
	#DEBUG_VALUE: i <- 0
	.loc	5 177 21                # matmul.c:177:21
	cmpl	$31, %r12d
	movq	%r12, 40(%rsp)          # 8-byte Spill
.Ltmp58:
	#DEBUG_VALUE: main:lg_n <- [DW_OP_plus_uconst 40] [$rsp+0]
	.loc	5 177 3 is_stmt 0       # matmul.c:177:3
	je	.LBB1_7
.Ltmp59:
# %bb.3:                                # %for.cond14.preheader.us.preheader
	#DEBUG_VALUE: main:lg_n <- [DW_OP_plus_uconst 40] [$rsp+0]
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: main:C <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: main:B <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: main:A <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: main:size <- [DW_OP_plus_uconst 4] [$rsp+0]
	#DEBUG_VALUE: main:n <- $r13d
	.loc	5 0 3                   # matmul.c:0:3
	xorl	%r14d, %r14d
.Ltmp60:
	.p2align	4, 0x90
.LBB1_4:                                # %for.cond14.preheader.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_5 Depth 2
	#DEBUG_VALUE: main:lg_n <- [DW_OP_plus_uconst 40] [$rsp+0]
	#DEBUG_VALUE: main:C <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: main:B <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: main:A <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: main:size <- [DW_OP_plus_uconst 4] [$rsp+0]
	#DEBUG_VALUE: main:n <- $r13d
	#DEBUG_VALUE: i <- $r14d
	#DEBUG_VALUE: j <- 0
	shlxl	%r12d, %r14d, %eax
.Ltmp61:
	.loc	5 178 5 is_stmt 1       # matmul.c:178:5
	cltq
	movq	24(%rsp), %rcx          # 8-byte Reload
	leaq	(%rcx,%rax,4), %r15
	movq	16(%rsp), %rcx          # 8-byte Reload
	leaq	(%rcx,%rax,4), %r12
	movq	8(%rsp), %rcx           # 8-byte Reload
	leaq	(%rcx,%rax,4), %rbp
	xorl	%ebx, %ebx
.Ltmp62:
	.p2align	4, 0x90
.LBB1_5:                                # %for.body18.us
                                        #   Parent Loop BB1_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#DEBUG_VALUE: i <- $r14d
	#DEBUG_VALUE: main:lg_n <- [DW_OP_plus_uconst 40] [$rsp+0]
	#DEBUG_VALUE: main:C <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: main:B <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: main:A <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: main:size <- [DW_OP_plus_uconst 4] [$rsp+0]
	#DEBUG_VALUE: main:n <- $r13d
	#DEBUG_VALUE: j <- $rbx
	.loc	5 179 26                # matmul.c:179:26
	callq	rand
.Ltmp63:
	.loc	5 179 20 is_stmt 0      # matmul.c:179:20
	vcvtsi2ss	%eax, %xmm2, %xmm0
	.loc	5 179 33                # matmul.c:179:33
	vmulss	.LCPI1_0(%rip), %xmm0, %xmm0
	.loc	5 179 18                # matmul.c:179:18
	vmovss	%xmm0, (%r15,%rbx,4)
	.loc	5 180 26 is_stmt 1      # matmul.c:180:26
	callq	rand
.Ltmp64:
	.loc	5 0 26 is_stmt 0        # matmul.c:0:26
	vmovss	.LCPI1_0(%rip), %xmm1   # xmm1 = mem[0],zero,zero,zero
	.loc	5 180 20                # matmul.c:180:20
	vcvtsi2ss	%eax, %xmm2, %xmm0
	.loc	5 180 33                # matmul.c:180:33
	vmulss	%xmm1, %xmm0, %xmm0
	.loc	5 180 18                # matmul.c:180:18
	vmovss	%xmm0, (%r12,%rbx,4)
	.loc	5 181 18 is_stmt 1      # matmul.c:181:18
	movl	$0, (%rbp,%rbx,4)
.Ltmp65:
	.loc	5 178 28                # matmul.c:178:28
	incq	%rbx
.Ltmp66:
	#DEBUG_VALUE: j <- $rbx
	.loc	5 178 23 is_stmt 0      # matmul.c:178:23
	cmpq	48(%rsp), %rbx          # 8-byte Folded Reload
.Ltmp67:
	.loc	5 178 5                 # matmul.c:178:5
	jl	.LBB1_5
.Ltmp68:
# %bb.6:                                # %for.cond14.for.cond.cleanup17_crit_edge.us
                                        #   in Loop: Header=BB1_4 Depth=1
	#DEBUG_VALUE: i <- $r14d
	#DEBUG_VALUE: main:lg_n <- [DW_OP_plus_uconst 40] [$rsp+0]
	#DEBUG_VALUE: main:C <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: main:B <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: main:A <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: main:size <- [DW_OP_plus_uconst 4] [$rsp+0]
	#DEBUG_VALUE: main:n <- $r13d
	.loc	5 177 26 is_stmt 1      # matmul.c:177:26
	incl	%r14d
.Ltmp69:
	#DEBUG_VALUE: i <- $r14d
	.loc	5 177 21 is_stmt 0      # matmul.c:177:21
	cmpl	%r13d, %r14d
	movq	40(%rsp), %r12          # 8-byte Reload
.Ltmp70:
	.loc	5 177 3                 # matmul.c:177:3
	jl	.LBB1_4
.Ltmp71:
.LBB1_7:                                # %for.cond.cleanup
	#DEBUG_VALUE: main:lg_n <- [DW_OP_plus_uconst 40] [$rsp+0]
	#DEBUG_VALUE: main:C <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: main:B <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: main:A <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: main:size <- [DW_OP_plus_uconst 4] [$rsp+0]
	#DEBUG_VALUE: main:n <- $r13d
	.loc	5 0 3                   # matmul.c:0:3
	leaq	56(%rsp), %rsi
.Ltmp72:
	.file	6 "/home/ubuntu/git/homework3_adrianoh/matmul" "././fasttime.h"
	.loc	6 72 3 is_stmt 1        # ././fasttime.h:72:3
	movl	$1, %edi
	callq	clock_gettime
.Ltmp73:
	.loc	6 77 3                  # ././fasttime.h:77:3
	movq	56(%rsp), %rax
	movq	%rax, 72(%rsp)          # 8-byte Spill
	movq	64(%rsp), %rax
.Ltmp74:
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 72, DW_OP_LLVM_fragment 0 64] [$rsp+0]
	#DEBUG_VALUE: main:start <- [DW_OP_LLVM_fragment 64 64] $rax
	.loc	6 0 3 is_stmt 0         # ././fasttime.h:0:3
	movq	%rax, 80(%rsp)          # 8-byte Spill
.Ltmp75:
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 80, DW_OP_LLVM_fragment 64 64] [$rsp+0]
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 80, DW_OP_LLVM_fragment 64 64] [$rsp+0]
	.loc	5 177 21 is_stmt 1      # matmul.c:177:21
	cmpl	$31, %r12d
.Ltmp76:
	#DEBUG_VALUE: i <- 0
	.loc	5 187 3                 # matmul.c:187:3
	je	.LBB1_14
.Ltmp77:
# %bb.8:                                # %for.cond44.preheader.lr.ph
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 80, DW_OP_LLVM_fragment 64 64] [$rsp+0]
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 72, DW_OP_LLVM_fragment 0 64] [$rsp+0]
	#DEBUG_VALUE: main:lg_n <- [DW_OP_plus_uconst 40] [$rsp+0]
	#DEBUG_VALUE: main:C <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: main:B <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: main:A <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: main:size <- [DW_OP_plus_uconst 4] [$rsp+0]
	#DEBUG_VALUE: main:n <- $r13d
	movslq	4(%rsp), %rbp           # 4-byte Folded Reload
	leaq	(,%rbp,4), %rbx
	xorl	%eax, %eax
	movl	%r13d, 36(%rsp)         # 4-byte Spill
.Ltmp78:
	#DEBUG_VALUE: main:n <- [DW_OP_plus_uconst 36] [$rsp+0]
	.p2align	4, 0x90
.LBB1_9:                                # %for.cond50.preheader.us.us.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_10 Depth 2
                                        #       Child Loop BB1_11 Depth 3
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 80, DW_OP_LLVM_fragment 64 64] [$rsp+0]
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 72, DW_OP_LLVM_fragment 0 64] [$rsp+0]
	#DEBUG_VALUE: main:lg_n <- [DW_OP_plus_uconst 40] [$rsp+0]
	#DEBUG_VALUE: main:C <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: main:B <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: main:A <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: main:size <- [DW_OP_plus_uconst 4] [$rsp+0]
	#DEBUG_VALUE: i <- $eax
	#DEBUG_VALUE: k <- 0
	.loc	5 0 3 is_stmt 0         # matmul.c:0:3
	movq	%rax, 88(%rsp)          # 8-byte Spill
.Ltmp79:
	#DEBUG_VALUE: i <- [DW_OP_plus_uconst 88] [$rsp+0]
	shlxl	%r12d, %eax, %eax
.Ltmp80:
	.loc	5 188 5 is_stmt 1       # matmul.c:188:5
	movslq	%eax, %rcx
	movq	8(%rsp), %rax           # 8-byte Reload
	movq	%rcx, 104(%rsp)         # 8-byte Spill
	leaq	(%rax,%rcx,4), %rax
	movq	%rax, 96(%rsp)          # 8-byte Spill
	xorl	%edx, %edx
.Ltmp81:
	.p2align	4, 0x90
.LBB1_10:                               # %for.cond50.preheader.us.us
                                        #   Parent Loop BB1_9 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_11 Depth 3
	#DEBUG_VALUE: i <- [DW_OP_plus_uconst 88] [$rsp+0]
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 80, DW_OP_LLVM_fragment 64 64] [$rsp+0]
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 72, DW_OP_LLVM_fragment 0 64] [$rsp+0]
	#DEBUG_VALUE: main:lg_n <- [DW_OP_plus_uconst 40] [$rsp+0]
	#DEBUG_VALUE: main:C <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: main:B <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: main:A <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: main:size <- [DW_OP_plus_uconst 4] [$rsp+0]
	#DEBUG_VALUE: k <- $rdx
	#DEBUG_VALUE: j <- 0
	.loc	5 0 5 is_stmt 0         # matmul.c:0:5
	movq	104(%rsp), %rax         # 8-byte Reload
.Ltmp82:
	addq	%rdx, %rax
	movq	24(%rsp), %rcx          # 8-byte Reload
	leaq	(%rcx,%rax,4), %r15
	movq	%rdx, 112(%rsp)         # 8-byte Spill
.Ltmp83:
	#DEBUG_VALUE: k <- [DW_OP_plus_uconst 112] [$rsp+0]
	shlxl	%r12d, %edx, %eax
.Ltmp84:
	.loc	5 189 7 is_stmt 1       # matmul.c:189:7
	cltq
	movq	16(%rsp), %rcx          # 8-byte Reload
	leaq	(%rcx,%rax,4), %r14
	movq	96(%rsp), %r12          # 8-byte Reload
	xorl	%r13d, %r13d
.Ltmp85:
	.p2align	4, 0x90
.LBB1_11:                               # %for.body54.us.us
                                        #   Parent Loop BB1_9 Depth=1
                                        #     Parent Loop BB1_10 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	#DEBUG_VALUE: k <- [DW_OP_plus_uconst 112] [$rsp+0]
	#DEBUG_VALUE: i <- [DW_OP_plus_uconst 88] [$rsp+0]
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 80, DW_OP_LLVM_fragment 64 64] [$rsp+0]
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 72, DW_OP_LLVM_fragment 0 64] [$rsp+0]
	#DEBUG_VALUE: main:lg_n <- [DW_OP_plus_uconst 40] [$rsp+0]
	#DEBUG_VALUE: main:C <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: main:B <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: main:A <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: main:size <- [DW_OP_plus_uconst 4] [$rsp+0]
	#DEBUG_VALUE: j <- $r13
	.loc	5 190 9                 # matmul.c:190:9
	movq	%r12, %rdi
	movq	%r15, %rsi
	movq	%r14, %rdx
	movl	%ebp, %r8d
	callq	matmul_base
.Ltmp86:
	.loc	5 0 9 is_stmt 0         # matmul.c:0:9
	movq	48(%rsp), %rax          # 8-byte Reload
.Ltmp87:
	.loc	5 189 32 is_stmt 1      # matmul.c:189:32
	addq	%rbp, %r13
.Ltmp88:
	#DEBUG_VALUE: j <- $r13
	.loc	5 189 25 is_stmt 0      # matmul.c:189:25
	addq	%rbx, %r14
	addq	%rbx, %r12
	cmpq	%rax, %r13
.Ltmp89:
	.loc	5 189 7                 # matmul.c:189:7
	jl	.LBB1_11
.Ltmp90:
# %bb.12:                               # %for.cond50.for.cond.cleanup53_crit_edge.us.us
                                        #   in Loop: Header=BB1_10 Depth=2
	#DEBUG_VALUE: k <- [DW_OP_plus_uconst 112] [$rsp+0]
	#DEBUG_VALUE: i <- [DW_OP_plus_uconst 88] [$rsp+0]
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 80, DW_OP_LLVM_fragment 64 64] [$rsp+0]
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 72, DW_OP_LLVM_fragment 0 64] [$rsp+0]
	#DEBUG_VALUE: main:lg_n <- [DW_OP_plus_uconst 40] [$rsp+0]
	#DEBUG_VALUE: main:C <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: main:B <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: main:A <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: main:size <- [DW_OP_plus_uconst 4] [$rsp+0]
	.loc	5 0 7                   # matmul.c:0:7
	movq	112(%rsp), %rdx         # 8-byte Reload
	.loc	5 188 30 is_stmt 1      # matmul.c:188:30
	addq	%rbp, %rdx
.Ltmp91:
	#DEBUG_VALUE: k <- $rdx
	.loc	5 188 23 is_stmt 0      # matmul.c:188:23
	cmpq	%rax, %rdx
	movq	40(%rsp), %r12          # 8-byte Reload
.Ltmp92:
	.loc	5 188 5                 # matmul.c:188:5
	jl	.LBB1_10
.Ltmp93:
# %bb.13:                               # %for.cond44.for.cond.cleanup47_crit_edge.us
                                        #   in Loop: Header=BB1_9 Depth=1
	#DEBUG_VALUE: i <- [DW_OP_plus_uconst 88] [$rsp+0]
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 80, DW_OP_LLVM_fragment 64 64] [$rsp+0]
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 72, DW_OP_LLVM_fragment 0 64] [$rsp+0]
	#DEBUG_VALUE: main:lg_n <- [DW_OP_plus_uconst 40] [$rsp+0]
	#DEBUG_VALUE: main:C <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: main:B <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: main:A <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: main:size <- [DW_OP_plus_uconst 4] [$rsp+0]
	.loc	5 0 5                   # matmul.c:0:5
	movq	88(%rsp), %rax          # 8-byte Reload
	.loc	5 187 28 is_stmt 1      # matmul.c:187:28
	addl	4(%rsp), %eax           # 4-byte Folded Reload
.Ltmp94:
	#DEBUG_VALUE: i <- $eax
	.loc	5 0 28 is_stmt 0        # matmul.c:0:28
	movl	36(%rsp), %r13d         # 4-byte Reload
.Ltmp95:
	#DEBUG_VALUE: main:n <- $r13d
	.loc	5 187 21                # matmul.c:187:21
	cmpl	%r13d, %eax
.Ltmp96:
	.loc	5 187 3                 # matmul.c:187:3
	jl	.LBB1_9
.Ltmp97:
.LBB1_14:                               # %for.cond.cleanup42
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 80, DW_OP_LLVM_fragment 64 64] [$rsp+0]
	#DEBUG_VALUE: main:start <- [DW_OP_plus_uconst 72, DW_OP_LLVM_fragment 0 64] [$rsp+0]
	#DEBUG_VALUE: main:lg_n <- [DW_OP_plus_uconst 40] [$rsp+0]
	#DEBUG_VALUE: main:C <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: main:B <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: main:A <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: main:size <- [DW_OP_plus_uconst 4] [$rsp+0]
	.loc	5 0 3                   # matmul.c:0:3
	leaq	56(%rsp), %rsi
.Ltmp98:
	.loc	6 72 3 is_stmt 1        # ././fasttime.h:72:3
	movl	$1, %edi
	callq	clock_gettime
.Ltmp99:
	.loc	6 77 3                  # ././fasttime.h:77:3
	movq	56(%rsp), %rax
.Ltmp100:
	.loc	6 83 21                 # ././fasttime.h:83:21
	subq	72(%rsp), %rax          # 8-byte Folded Reload
.Ltmp101:
	.loc	6 77 3                  # ././fasttime.h:77:3
	movq	64(%rsp), %rcx
.Ltmp102:
	#DEBUG_VALUE: tdiff:end <- [DW_OP_LLVM_fragment 0 64] undef
	#DEBUG_VALUE: main:end <- [DW_OP_LLVM_fragment 0 64] undef
	#DEBUG_VALUE: tdiff:end <- [DW_OP_LLVM_fragment 64 64] $rcx
	#DEBUG_VALUE: main:end <- [DW_OP_LLVM_fragment 64 64] $rcx
	#DEBUG_VALUE: tdiff:start <- [DW_OP_plus_uconst 80, DW_OP_LLVM_fragment 64 64] [$rsp+0]
	#DEBUG_VALUE: tdiff:start <- [DW_OP_LLVM_fragment 0 64] undef
	.loc	6 83 56                 # ././fasttime.h:83:56
	subq	80(%rsp), %rcx          # 8-byte Folded Reload
.Ltmp103:
	.loc	6 83 10 is_stmt 0       # ././fasttime.h:83:10
	vcvtsi2sd	%rax, %xmm2, %xmm0
	.loc	6 83 43                 # ././fasttime.h:83:43
	vcvtsi2sd	%rcx, %xmm2, %xmm1
	.loc	6 83 42                 # ././fasttime.h:83:42
	vmulsd	.LCPI1_1(%rip), %xmm1, %xmm1
	.loc	6 83 36                 # ././fasttime.h:83:36
	vaddsd	%xmm0, %xmm1, %xmm0
.Ltmp104:
	#DEBUG_VALUE: main:elapsed <- $xmm0
	.loc	5 198 3 is_stmt 1       # matmul.c:198:3
	movl	$.L.str.1, %edi
	movb	$1, %al
	callq	printf
.Ltmp105:
	.loc	5 0 3 is_stmt 0         # matmul.c:0:3
	movq	8(%rsp), %r15           # 8-byte Reload
	.loc	5 201 17 is_stmt 1      # matmul.c:201:17
	movq	%r15, %rdi
	movq	24(%rsp), %rbp          # 8-byte Reload
	movq	%rbp, %rsi
	movq	16(%rsp), %r14          # 8-byte Reload
	movq	%r14, %rdx
	movl	%r13d, %ecx
	callq	check_correctness
.Ltmp106:
	movl	%eax, %ebx
.Ltmp107:
	#DEBUG_VALUE: main:passed <- $bl
	.loc	5 204 3                 # matmul.c:204:3
	movq	%rbp, %rdi
	callq	free
.Ltmp108:
	.loc	5 205 3                 # matmul.c:205:3
	movq	%r14, %rdi
	callq	free
.Ltmp109:
	.loc	5 206 3                 # matmul.c:206:3
	movq	%r15, %rdi
	callq	free
.Ltmp110:
	.loc	5 209 10                # matmul.c:209:10
	xorb	$1, %bl
.Ltmp111:
	movzbl	%bl, %eax
	.loc	5 210 1                 # matmul.c:210:1
	addq	$120, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Ltmp112:
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2               # -- Begin function check_correctness
.LCPI2_0:
	.long	2147483648              # float -0
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI2_1:
	.quad	4576918229304087675     # double 0.01
.LCPI2_2:
	.quad	4532020583610935537     # double 1.0000000000000001E-5
	.text
	.p2align	4, 0x90
	.type	check_correctness,@function
check_correctness:                      # @check_correctness
.Lfunc_begin2:
	.loc	5 121 0                 # matmul.c:121:0
	.cfi_startproc
# %bb.0:                                # %entry
	#DEBUG_VALUE: check_correctness:C <- $rdi
	#DEBUG_VALUE: check_correctness:A <- $rsi
	#DEBUG_VALUE: check_correctness:B <- $rdx
	#DEBUG_VALUE: check_correctness:n <- $ecx
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movl	%ecx, %ebx
	movq	%rdx, %r14
	movq	%rsi, %r15
	movq	%rdi, %rbp
.Ltmp113:
	#DEBUG_VALUE: check_correctness:passed <- 1
	#DEBUG_VALUE: check_correctness:n <- $ebx
	#DEBUG_VALUE: check_correctness:B <- $r14
	#DEBUG_VALUE: check_correctness:A <- $r15
	#DEBUG_VALUE: check_correctness:C <- $rbp
	.loc	5 123 11 prologue_end   # matmul.c:123:11
	movq	stderr(%rip), %rcx
	.loc	5 123 3 is_stmt 0       # matmul.c:123:3
	movl	$.L.str.2, %edi
	movl	$22, %esi
	movl	$1, %edx
	callq	fwrite
.Ltmp114:
	.loc	5 125 33 is_stmt 1      # matmul.c:125:33
	movl	%ebx, %eax
	imull	%eax, %eax
	.loc	5 125 37 is_stmt 0      # matmul.c:125:37
	leaq	(,%rax,4), %rdi
	.loc	5 125 24                # matmul.c:125:24
	callq	malloc
.Ltmp115:
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: check_correctness:Ctmp <- $rax
	.loc	5 126 21 is_stmt 1      # matmul.c:126:21
	testl	%ebx, %ebx
	movq	%rax, 8(%rsp)           # 8-byte Spill
.Ltmp116:
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	.loc	5 126 3 is_stmt 0       # matmul.c:126:3
	jle	.LBB2_28
.Ltmp117:
# %bb.1:                                # %for.cond4.preheader.us.preheader
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: check_correctness:C <- $rbp
	#DEBUG_VALUE: check_correctness:A <- $r15
	#DEBUG_VALUE: check_correctness:B <- $r14
	#DEBUG_VALUE: check_correctness:n <- $ebx
	#DEBUG_VALUE: check_correctness:passed <- 1
	.loc	5 0 3                   # matmul.c:0:3
	movq	%r15, 56(%rsp)          # 8-byte Spill
.Ltmp118:
	#DEBUG_VALUE: check_correctness:A <- [DW_OP_plus_uconst 56] [$rsp+0]
	movq	%r14, 24(%rsp)          # 8-byte Spill
.Ltmp119:
	#DEBUG_VALUE: check_correctness:B <- [DW_OP_plus_uconst 24] [$rsp+0]
	movq	%rbp, 64(%rsp)          # 8-byte Spill
.Ltmp120:
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	.loc	5 126 3                 # matmul.c:126:3
	movl	%ebx, %r14d
.Ltmp121:
	#DEBUG_VALUE: check_correctness:n <- $r14d
	.loc	5 0 0                   # matmul.c:0:0
	leaq	(,%r14,4), %r12
.Ltmp122:
	.loc	5 126 3                 # matmul.c:126:3
	leaq	-1(%r14), %rcx
	movl	%r14d, %r15d
	andl	$7, %r15d
	movq	%rcx, 32(%rsp)          # 8-byte Spill
	cmpq	$7, %rcx
	jae	.LBB2_3
.Ltmp123:
# %bb.2:
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:B <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: check_correctness:A <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: check_correctness:passed <- 1
	.loc	5 0 3                   # matmul.c:0:3
	xorl	%r13d, %r13d
	jmp	.LBB2_5
.Ltmp124:
.LBB2_28:                               # %for.cond.cleanup57.thread
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: check_correctness:C <- $rbp
	#DEBUG_VALUE: check_correctness:A <- $r15
	#DEBUG_VALUE: check_correctness:B <- $r14
	#DEBUG_VALUE: check_correctness:n <- $ebx
	#DEBUG_VALUE: check_correctness:passed <- 1
	movq	stderr(%rip), %rcx
	jmp	.LBB2_29
.Ltmp125:
.LBB2_3:                                # %for.cond4.preheader.us.preheader.new
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:B <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: check_correctness:A <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: check_correctness:passed <- 1
	.loc	5 126 3                 # matmul.c:126:3
	movq	%r14, %rcx
	shlq	$5, %rcx
	movq	%rcx, 16(%rsp)          # 8-byte Spill
	movq	%r14, %rcx
	subq	%r15, %rcx
	movq	%rcx, 48(%rsp)          # 8-byte Spill
	xorl	%r13d, %r13d
	movq	%rax, %rbx
.Ltmp126:
.LBB2_4:                                # %for.cond4.preheader.us
                                        # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:B <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: check_correctness:A <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: check_correctness:passed <- 1
	#DEBUG_VALUE: i <- undef
	#DEBUG_VALUE: j <- 0
	.loc	5 128 21 is_stmt 1      # matmul.c:128:21
	movq	%rbx, %rdi
	xorl	%esi, %esi
	movq	%r12, %rdx
	callq	memset
.Ltmp127:
	#DEBUG_VALUE: i <- [DW_OP_plus_uconst 1, DW_OP_stack_value] undef
	#DEBUG_VALUE: i <- undef
	leaq	(%rbx,%r12), %rbp
	movq	%rbp, %rdi
	xorl	%esi, %esi
	movq	%r12, %rdx
	callq	memset
.Ltmp128:
	#DEBUG_VALUE: i <- [DW_OP_plus_uconst 1, DW_OP_stack_value] undef
	#DEBUG_VALUE: i <- undef
	addq	%r12, %rbp
	movq	%rbp, %rdi
	xorl	%esi, %esi
	movq	%r12, %rdx
	callq	memset
.Ltmp129:
	#DEBUG_VALUE: i <- [DW_OP_plus_uconst 1, DW_OP_stack_value] undef
	#DEBUG_VALUE: i <- undef
	addq	%r12, %rbp
	movq	%rbp, %rdi
	xorl	%esi, %esi
	movq	%r12, %rdx
	callq	memset
.Ltmp130:
	#DEBUG_VALUE: i <- [DW_OP_plus_uconst 1, DW_OP_stack_value] undef
	#DEBUG_VALUE: i <- undef
	addq	%r12, %rbp
	movq	%rbp, %rdi
	xorl	%esi, %esi
	movq	%r12, %rdx
	callq	memset
.Ltmp131:
	#DEBUG_VALUE: i <- [DW_OP_plus_uconst 1, DW_OP_stack_value] undef
	#DEBUG_VALUE: i <- undef
	addq	%r12, %rbp
	movq	%rbp, %rdi
	xorl	%esi, %esi
	movq	%r12, %rdx
	callq	memset
.Ltmp132:
	#DEBUG_VALUE: i <- [DW_OP_plus_uconst 1, DW_OP_stack_value] undef
	#DEBUG_VALUE: i <- undef
	addq	%r12, %rbp
	movq	%rbp, %rdi
	xorl	%esi, %esi
	movq	%r12, %rdx
	callq	memset
.Ltmp133:
	#DEBUG_VALUE: i <- [DW_OP_plus_uconst 1, DW_OP_stack_value] undef
	#DEBUG_VALUE: i <- undef
	addq	%r12, %rbp
	movq	%rbp, %rdi
	xorl	%esi, %esi
	movq	%r12, %rdx
	callq	memset
.Ltmp134:
	.loc	5 0 21 is_stmt 0        # matmul.c:0:21
	movq	8(%rsp), %rax           # 8-byte Reload
.Ltmp135:
	#DEBUG_VALUE: i <- [DW_OP_plus_uconst 1, DW_OP_stack_value] undef
	#DEBUG_VALUE: j <- undef
	.loc	5 126 3 is_stmt 1       # matmul.c:126:3
	addq	$8, %r13
	addq	16(%rsp), %rbx          # 8-byte Folded Reload
	cmpq	%r13, 48(%rsp)          # 8-byte Folded Reload
	jne	.LBB2_4
.Ltmp136:
.LBB2_5:                                # %for.cond25.preheader.us.us.preheader.preheader.unr-lcssa
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:B <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: check_correctness:A <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: check_correctness:passed <- 1
	testq	%r15, %r15
	je	.LBB2_8
.Ltmp137:
# %bb.6:                                # %for.cond4.preheader.us.epil.preheader
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:B <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: check_correctness:A <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: check_correctness:passed <- 1
	imulq	%r14, %r13
	leaq	(%rax,%r13,4), %rbx
.Ltmp138:
.LBB2_7:                                # %for.cond4.preheader.us.epil
                                        # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:B <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: check_correctness:A <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: check_correctness:passed <- 1
	#DEBUG_VALUE: i <- undef
	#DEBUG_VALUE: j <- 0
	.loc	5 128 21                # matmul.c:128:21
	movq	%rbx, %rdi
	xorl	%esi, %esi
	movq	%r12, %rdx
	callq	memset
.Ltmp139:
	.loc	5 0 21 is_stmt 0        # matmul.c:0:21
	movq	8(%rsp), %rax           # 8-byte Reload
.Ltmp140:
	#DEBUG_VALUE: i <- [DW_OP_plus_uconst 1, DW_OP_stack_value] undef
	#DEBUG_VALUE: j <- undef
	.loc	5 126 3 is_stmt 1       # matmul.c:126:3
	addq	%r12, %rbx
	decq	%r15
	jne	.LBB2_7
.Ltmp141:
.LBB2_8:                                # %for.cond25.preheader.us.us.preheader.preheader
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:B <- [DW_OP_plus_uconst 24] [$rsp+0]
	#DEBUG_VALUE: check_correctness:A <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- 1
	.loc	5 0 0 is_stmt 0         # matmul.c:0:0
	movl	%r14d, %r11d
	andl	$3, %r11d
.Ltmp142:
	.loc	5 131 3 is_stmt 1       # matmul.c:131:3
	leaq	(%r12,%r12,2), %rcx
	movq	%rcx, 16(%rsp)          # 8-byte Spill
	movq	%r14, %r9
	shlq	$4, %r9
	movl	%r14d, %r10d
	andl	$-4, %r10d
	xorl	%edi, %edi
	movq	56(%rsp), %r8           # 8-byte Reload
.Ltmp143:
	#DEBUG_VALUE: check_correctness:A <- $r8
	leaq	12(%r8), %rbp
.Ltmp144:
.LBB2_9:                                # %for.cond25.preheader.us.us.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_10 Depth 2
                                        #       Child Loop BB2_27 Depth 3
                                        #       Child Loop BB2_14 Depth 3
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- 1
	#DEBUG_VALUE: i <- $rdi
	#DEBUG_VALUE: j <- 0
	.loc	5 0 0 is_stmt 0         # matmul.c:0:0
	movq	%rdi, %r15
	imulq	%r14, %r15
	movq	24(%rsp), %rbx          # 8-byte Reload
.Ltmp145:
	#DEBUG_VALUE: check_correctness:B <- $rbx
	xorl	%edx, %edx
.Ltmp146:
.LBB2_10:                               # %for.cond25.preheader.us.us
                                        #   Parent Loop BB2_9 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_27 Depth 3
                                        #       Child Loop BB2_14 Depth 3
	#DEBUG_VALUE: i <- $rdi
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- 1
	#DEBUG_VALUE: j <- $rdx
	#DEBUG_VALUE: k <- 0
	leaq	(%rdx,%r15), %r13
	.loc	5 134 23 is_stmt 1      # matmul.c:134:23
	vmovss	(%rax,%r13,4), %xmm0    # xmm0 = mem[0],zero,zero,zero
.Ltmp147:
	.loc	5 0 0 is_stmt 0         # matmul.c:0:0
	cmpq	$3, 32(%rsp)            # 8-byte Folded Reload
	.loc	5 133 7 is_stmt 1       # matmul.c:133:7
	jae	.LBB2_26
.Ltmp148:
# %bb.11:                               #   in Loop: Header=BB2_10 Depth=2
	#DEBUG_VALUE: k <- 0
	#DEBUG_VALUE: j <- $rdx
	#DEBUG_VALUE: i <- $rdi
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- 1
	.loc	5 0 7 is_stmt 0         # matmul.c:0:7
	xorl	%eax, %eax
	jmp	.LBB2_12
.Ltmp149:
	.p2align	4, 0x90
.LBB2_26:                               # %for.body29.us.us.preheader
                                        #   in Loop: Header=BB2_10 Depth=2
	#DEBUG_VALUE: k <- 0
	#DEBUG_VALUE: j <- $rdx
	#DEBUG_VALUE: i <- $rdi
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- 1
	movq	%rbx, %rcx
	xorl	%eax, %eax
.Ltmp150:
.LBB2_27:                               # %for.body29.us.us
                                        #   Parent Loop BB2_9 Depth=1
                                        #     Parent Loop BB2_10 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	#DEBUG_VALUE: j <- $rdx
	#DEBUG_VALUE: i <- $rdi
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- 1
	#DEBUG_VALUE: k <- $rax
	.loc	5 134 26 is_stmt 1      # matmul.c:134:26
	vmovss	-12(%rbp,%rax,4), %xmm1 # xmm1 = mem[0],zero,zero,zero
	.loc	5 134 37 is_stmt 0      # matmul.c:134:37
	vmulss	(%rcx), %xmm1, %xmm1
	.loc	5 134 26                # matmul.c:134:26
	vmovss	-8(%rbp,%rax,4), %xmm2  # xmm2 = mem[0],zero,zero,zero
	.loc	5 134 23                # matmul.c:134:23
	vaddss	%xmm1, %xmm0, %xmm0
	.loc	5 134 37                # matmul.c:134:37
	vmulss	(%rcx,%r14,4), %xmm2, %xmm1
	.loc	5 134 23                # matmul.c:134:23
	vaddss	%xmm1, %xmm0, %xmm0
	.loc	5 134 26                # matmul.c:134:26
	vmovss	-4(%rbp,%rax,4), %xmm1  # xmm1 = mem[0],zero,zero,zero
	.loc	5 134 37                # matmul.c:134:37
	vmulss	(%rcx,%r14,8), %xmm1, %xmm1
	.loc	5 134 23                # matmul.c:134:23
	vaddss	%xmm1, %xmm0, %xmm0
	.loc	5 134 26                # matmul.c:134:26
	vmovss	(%rbp,%rax,4), %xmm1    # xmm1 = mem[0],zero,zero,zero
	movq	16(%rsp), %rsi          # 8-byte Reload
	.loc	5 134 37                # matmul.c:134:37
	vmulss	(%rcx,%rsi), %xmm1, %xmm1
	.loc	5 134 23                # matmul.c:134:23
	vaddss	%xmm1, %xmm0, %xmm0
.Ltmp151:
	.loc	5 133 30 is_stmt 1      # matmul.c:133:30
	addq	$4, %rax
.Ltmp152:
	#DEBUG_VALUE: k <- $rax
	.loc	5 133 7 is_stmt 0       # matmul.c:133:7
	addq	%r9, %rcx
	cmpq	%rax, %r10
	jne	.LBB2_27
.Ltmp153:
.LBB2_12:                               # %for.cond25.for.cond.cleanup28_crit_edge.us.us.unr-lcssa
                                        #   in Loop: Header=BB2_10 Depth=2
	#DEBUG_VALUE: j <- $rdx
	#DEBUG_VALUE: i <- $rdi
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- 1
	.loc	5 0 0                   # matmul.c:0:0
	testq	%r11, %r11
	.loc	5 133 7                 # matmul.c:133:7
	je	.LBB2_15
.Ltmp154:
# %bb.13:                               # %for.body29.us.us.epil.preheader
                                        #   in Loop: Header=BB2_10 Depth=2
	#DEBUG_VALUE: j <- $rdx
	#DEBUG_VALUE: i <- $rdi
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- 1
	movq	%r14, %rcx
	imulq	%rax, %rcx
	addq	%rdx, %rcx
	movq	24(%rsp), %rsi          # 8-byte Reload
	leaq	(%rsi,%rcx,4), %rcx
	leaq	(%r8,%rax,4), %rax
	.loc	5 0 0                   # matmul.c:0:0
	xorl	%esi, %esi
.Ltmp155:
.LBB2_14:                               # %for.body29.us.us.epil
                                        #   Parent Loop BB2_9 Depth=1
                                        #     Parent Loop BB2_10 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	#DEBUG_VALUE: j <- $rdx
	#DEBUG_VALUE: i <- $rdi
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- 1
	#DEBUG_VALUE: k <- undef
	.loc	5 134 26 is_stmt 1      # matmul.c:134:26
	vmovss	(%rax,%rsi,4), %xmm1    # xmm1 = mem[0],zero,zero,zero
	.loc	5 134 37 is_stmt 0      # matmul.c:134:37
	vmulss	(%rcx), %xmm1, %xmm1
	.loc	5 134 23                # matmul.c:134:23
	vaddss	%xmm1, %xmm0, %xmm0
.Ltmp156:
	#DEBUG_VALUE: k <- [DW_OP_plus_uconst 1, DW_OP_stack_value] undef
	.loc	5 133 7 is_stmt 1       # matmul.c:133:7
	addq	%r12, %rcx
	incq	%rsi
	cmpq	%rsi, %r11
	jne	.LBB2_14
.Ltmp157:
.LBB2_15:                               # %for.cond25.for.cond.cleanup28_crit_edge.us.us
                                        #   in Loop: Header=BB2_10 Depth=2
	#DEBUG_VALUE: j <- $rdx
	#DEBUG_VALUE: i <- $rdi
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- 1
	.loc	5 0 7 is_stmt 0         # matmul.c:0:7
	movq	8(%rsp), %rax           # 8-byte Reload
.Ltmp158:
	.loc	5 134 23 is_stmt 1      # matmul.c:134:23
	vmovss	%xmm0, (%rax,%r13,4)
.Ltmp159:
	.loc	5 132 28                # matmul.c:132:28
	incq	%rdx
.Ltmp160:
	#DEBUG_VALUE: j <- $rdx
	.loc	5 132 5 is_stmt 0       # matmul.c:132:5
	addq	$4, %rbx
.Ltmp161:
	.loc	5 132 23                # matmul.c:132:23
	cmpq	%r14, %rdx
.Ltmp162:
	.loc	5 132 5                 # matmul.c:132:5
	jne	.LBB2_10
.Ltmp163:
# %bb.16:                               # %for.cond20.for.cond.cleanup23_crit_edge.us
                                        #   in Loop: Header=BB2_9 Depth=1
	#DEBUG_VALUE: i <- $rdi
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- 1
	.loc	5 131 26 is_stmt 1      # matmul.c:131:26
	incq	%rdi
.Ltmp164:
	#DEBUG_VALUE: i <- $rdi
	.loc	5 131 3 is_stmt 0       # matmul.c:131:3
	addq	%r12, %rbp
	addq	%r12, %r8
.Ltmp165:
	.loc	5 131 21                # matmul.c:131:21
	cmpq	%r14, %rdi
.Ltmp166:
	.loc	5 131 3                 # matmul.c:131:3
	jne	.LBB2_9
.Ltmp167:
# %bb.17:                               # %for.cond60.preheader.us.preheader
	#DEBUG_VALUE: i <- $rdi
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:C <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- 1
	.loc	5 0 3                   # matmul.c:0:3
	movb	$1, %dl
	xorl	%r15d, %r15d
	vxorps	%xmm5, %xmm5, %xmm5
	vbroadcastss	.LCPI2_0(%rip), %xmm6 # xmm6 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
	vmovsd	.LCPI2_1(%rip), %xmm7   # xmm7 = mem[0],zero
	vmovsd	.LCPI2_2(%rip), %xmm8   # xmm8 = mem[0],zero
	movq	%rax, %r13
	movq	64(%rsp), %rbx          # 8-byte Reload
.Ltmp168:
	#DEBUG_VALUE: check_correctness:C <- $rbx
.LBB2_18:                               # %for.cond60.preheader.us
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_19 Depth 2
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- $dl
	#DEBUG_VALUE: i <- $r15
	#DEBUG_VALUE: j <- 0
	xorl	%ebp, %ebp
.Ltmp169:
.LBB2_19:                               # %for.body64.us
                                        #   Parent Loop BB2_18 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#DEBUG_VALUE: i <- $r15
	#DEBUG_VALUE: check_correctness:passed <- $dl
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- $dl
	#DEBUG_VALUE: j <- $rbp
	.loc	5 140 25 is_stmt 1      # matmul.c:140:25
	vmovss	(%rbx,%rbp,4), %xmm0    # xmm0 = mem[0],zero,zero,zero
	.loc	5 140 37 is_stmt 0      # matmul.c:140:37
	vmovss	(%r13,%rbp,4), %xmm1    # xmm1 = mem[0],zero,zero,zero
.Ltmp170:
	#DEBUG_VALUE: close_enough:x <- $xmm0
	#DEBUG_VALUE: close_enough:y <- $xmm1
	.loc	5 103 10 is_stmt 1      # matmul.c:103:10
	vinsertps	$16, %xmm0, %xmm1, %xmm2 # xmm2 = xmm1[0],xmm0[0],xmm1[2,3]
	vcmpltps	%xmm5, %xmm2, %xmm3
	.loc	5 103 7 is_stmt 0       # matmul.c:103:7
	vxorps	%xmm6, %xmm2, %xmm4
	vblendvps	%xmm3, %xmm4, %xmm2, %xmm2
.Ltmp171:
	.loc	5 104 9 is_stmt 1       # matmul.c:104:9
	vmovshdup	%xmm2, %xmm3    # xmm3 = xmm2[1,1,3,3]
	vucomiss	%xmm3, %xmm2
	seta	%cl
.Ltmp172:
	.loc	5 104 7 is_stmt 0       # matmul.c:104:7
	vmovd	%ecx, %xmm3
	vpbroadcastb	%xmm3, %xmm3
	vpslld	$31, %xmm3, %xmm3
	vpermilps	$225, %xmm2, %xmm4 # xmm4 = xmm2[1,0,2,3]
	vblendvps	%xmm3, %xmm2, %xmm4, %xmm2
	.loc	5 110 17 is_stmt 1      # matmul.c:110:17
	vmovshdup	%xmm2, %xmm3    # xmm3 = xmm2[1,1,3,3]
	vsubss	%xmm3, %xmm2, %xmm3
.Ltmp173:
	#DEBUG_VALUE: close_enough:diff <- $xmm3
	.loc	5 112 11                # matmul.c:112:11
	vcvtss2sd	%xmm3, %xmm3, %xmm4
	.loc	5 112 16 is_stmt 0      # matmul.c:112:16
	vucomisd	%xmm4, %xmm7
	.loc	5 112 24                # matmul.c:112:24
	ja	.LBB2_22
.Ltmp174:
# %bb.20:                               # %close_enough.exit.us
                                        #   in Loop: Header=BB2_19 Depth=2
	#DEBUG_VALUE: close_enough:diff <- $xmm3
	#DEBUG_VALUE: close_enough:y <- $xmm1
	#DEBUG_VALUE: close_enough:x <- $xmm0
	#DEBUG_VALUE: j <- $rbp
	#DEBUG_VALUE: i <- $r15
	#DEBUG_VALUE: check_correctness:passed <- $dl
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	.loc	5 112 33                # matmul.c:112:33
	vdivss	%xmm2, %xmm3, %xmm2
	.loc	5 112 28                # matmul.c:112:28
	vcvtss2sd	%xmm2, %xmm2, %xmm2
	.loc	5 112 37                # matmul.c:112:37
	vucomisd	%xmm2, %xmm8
.Ltmp175:
	.loc	5 140 11 is_stmt 1      # matmul.c:140:11
	ja	.LBB2_22
.Ltmp176:
# %bb.21:                               # %if.then.us
                                        #   in Loop: Header=BB2_19 Depth=2
	#DEBUG_VALUE: j <- $rbp
	#DEBUG_VALUE: i <- $r15
	#DEBUG_VALUE: check_correctness:passed <- $dl
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- 0
	.loc	5 142 17                # matmul.c:142:17
	movq	stderr(%rip), %rdi
	.loc	5 144 23                # matmul.c:144:23
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	.loc	5 144 35 is_stmt 0      # matmul.c:144:35
	vcvtss2sd	%xmm1, %xmm1, %xmm1
	.loc	5 142 9 is_stmt 1       # matmul.c:142:9
	movl	$.L.str.3, %esi
	movl	%r15d, %edx
	movl	%ebp, %ecx
	movb	$2, %al
	vmovaps	%xmm6, 32(%rsp)         # 16-byte Spill
	callq	fprintf
.Ltmp177:
	.loc	5 0 9 is_stmt 0         # matmul.c:0:9
	vmovsd	.LCPI2_2(%rip), %xmm8   # xmm8 = mem[0],zero
	vmovsd	.LCPI2_1(%rip), %xmm7   # xmm7 = mem[0],zero
	vmovaps	32(%rsp), %xmm6         # 16-byte Reload
	vxorps	%xmm5, %xmm5, %xmm5
	xorl	%edx, %edx
.Ltmp178:
.LBB2_22:                               # %for.inc85.us
                                        #   in Loop: Header=BB2_19 Depth=2
	#DEBUG_VALUE: j <- $rbp
	#DEBUG_VALUE: i <- $r15
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- $dl
	.loc	5 139 28 is_stmt 1      # matmul.c:139:28
	incq	%rbp
.Ltmp179:
	#DEBUG_VALUE: j <- $rbp
	.loc	5 139 23 is_stmt 0      # matmul.c:139:23
	cmpq	%rbp, %r14
.Ltmp180:
	.loc	5 139 5                 # matmul.c:139:5
	jne	.LBB2_19
.Ltmp181:
# %bb.23:                               # %for.cond60.for.cond.cleanup63_crit_edge.us
                                        #   in Loop: Header=BB2_18 Depth=1
	#DEBUG_VALUE: i <- $r15
	#DEBUG_VALUE: check_correctness:passed <- $dl
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- $dl
	.loc	5 138 26 is_stmt 1      # matmul.c:138:26
	incq	%r15
.Ltmp182:
	#DEBUG_VALUE: i <- $r15
	.loc	5 138 3 is_stmt 0       # matmul.c:138:3
	addq	%r12, %rbx
	addq	%r12, %r13
.Ltmp183:
	.loc	5 138 21                # matmul.c:138:21
	cmpq	%r14, %r15
.Ltmp184:
	.loc	5 138 3                 # matmul.c:138:3
	jne	.LBB2_18
.Ltmp185:
# %bb.24:                               # %for.cond.cleanup57
	#DEBUG_VALUE: check_correctness:passed <- $dl
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: check_correctness:passed <- $dl
	.loc	5 0 0                   # matmul.c:0:0
	movq	stderr(%rip), %rcx
.Ltmp186:
	.loc	5 148 7 is_stmt 1       # matmul.c:148:7
	testb	$1, %dl
	jne	.LBB2_29
.Ltmp187:
# %bb.25:                               # %if.then91
	#DEBUG_VALUE: check_correctness:passed <- $dl
	#DEBUG_VALUE: check_correctness:n <- $r14d
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	.loc	5 149 5                 # matmul.c:149:5
	movl	$.L.str.4, %edi
	movl	$26, %esi
	movl	$1, %edx
.Ltmp188:
	callq	fwrite
.Ltmp189:
	.loc	5 0 5 is_stmt 0         # matmul.c:0:5
	xorl	%ebx, %ebx
	jmp	.LBB2_30
.Ltmp190:
.LBB2_29:                               # %if.else
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	.loc	5 151 5 is_stmt 1       # matmul.c:151:5
	movl	$.L.str.5, %edi
	movl	$26, %esi
	movl	$1, %edx
	callq	fwrite
.Ltmp191:
	.loc	5 0 5 is_stmt 0         # matmul.c:0:5
	movb	$1, %bl
.Ltmp192:
.LBB2_30:                               # %if.end94
	#DEBUG_VALUE: check_correctness:Ctmp <- [DW_OP_plus_uconst 8] [$rsp+0]
	movq	8(%rsp), %rdi           # 8-byte Reload
	.loc	5 153 3 is_stmt 1       # matmul.c:153:3
	callq	free
.Ltmp193:
	.loc	5 154 3                 # matmul.c:154:3
	movl	%ebx, %eax
	addq	$72, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Ltmp194:
.Lfunc_end2:
	.size	check_correctness, .Lfunc_end2-check_correctness
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Wrong block size: %d; Want: 32\n"
	.size	.L.str, 32

	.type	Avec,@object            # @Avec
	.comm	Avec,128,32
	.type	Cvec,@object            # @Cvec
	.comm	Cvec,128,32
	.type	Bvec,@object            # @Bvec
	.comm	Bvec,128,32
	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"Running time: %f sec\n"
	.size	.L.str.1, 22

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"Checking correctness.\n"
	.size	.L.str.2, 23

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"Unexpected value found in matrix product:   C[%d,%d] = %f, expected %f\n"
	.size	.L.str.3, 72

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"FAILED correctness check.\n"
	.size	.L.str.4, 27

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"PASSED correctness check.\n"
	.size	.L.str.5, 27

	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"clang version 10.0.1 " # string offset=0
.Linfo_string1:
	.asciz	"matmul.c"              # string offset=22
.Linfo_string2:
	.asciz	"/home/ubuntu/git/homework3_adrianoh/matmul" # string offset=31
.Linfo_string3:
	.asciz	"rand"                  # string offset=74
.Linfo_string4:
	.asciz	"int"                   # string offset=79
.Linfo_string5:
	.asciz	"free"                  # string offset=83
.Linfo_string6:
	.asciz	"clock_gettime"         # string offset=88
.Linfo_string7:
	.asciz	"tv_sec"                # string offset=102
.Linfo_string8:
	.asciz	"long int"              # string offset=109
.Linfo_string9:
	.asciz	"__time_t"              # string offset=118
.Linfo_string10:
	.asciz	"tv_nsec"               # string offset=127
.Linfo_string11:
	.asciz	"__syscall_slong_t"     # string offset=135
.Linfo_string12:
	.asciz	"timespec"              # string offset=153
.Linfo_string13:
	.asciz	"Avec"                  # string offset=162
.Linfo_string14:
	.asciz	"float"                 # string offset=167
.Linfo_string15:
	.asciz	"__ARRAY_SIZE_TYPE__"   # string offset=173
.Linfo_string16:
	.asciz	"vfloat_t"              # string offset=193
.Linfo_string17:
	.asciz	"Bvec"                  # string offset=202
.Linfo_string18:
	.asciz	"Cvec"                  # string offset=207
.Linfo_string19:
	.asciz	"el_t"                  # string offset=212
.Linfo_string20:
	.asciz	"char"                  # string offset=217
.Linfo_string21:
	.asciz	"atoi"                  # string offset=222
.Linfo_string22:
	.asciz	"__nptr"                # string offset=227
.Linfo_string23:
	.asciz	"gettime"               # string offset=234
.Linfo_string24:
	.asciz	"fasttime_t"            # string offset=242
.Linfo_string25:
	.asciz	"s"                     # string offset=253
.Linfo_string26:
	.asciz	"tdiff"                 # string offset=255
.Linfo_string27:
	.asciz	"double"                # string offset=261
.Linfo_string28:
	.asciz	"start"                 # string offset=268
.Linfo_string29:
	.asciz	"end"                   # string offset=274
.Linfo_string30:
	.asciz	"close_enough"          # string offset=278
.Linfo_string31:
	.asciz	"_Bool"                 # string offset=291
.Linfo_string32:
	.asciz	"x"                     # string offset=297
.Linfo_string33:
	.asciz	"y"                     # string offset=299
.Linfo_string34:
	.asciz	"diff"                  # string offset=301
.Linfo_string35:
	.asciz	"tmp"                   # string offset=306
.Linfo_string36:
	.asciz	"matmul_base"           # string offset=310
.Linfo_string37:
	.asciz	"main"                  # string offset=322
.Linfo_string38:
	.asciz	"check_correctness"     # string offset=327
.Linfo_string39:
	.asciz	"C"                     # string offset=345
.Linfo_string40:
	.asciz	"A"                     # string offset=347
.Linfo_string41:
	.asciz	"B"                     # string offset=349
.Linfo_string42:
	.asciz	"size"                  # string offset=351
.Linfo_string43:
	.asciz	"row_length"            # string offset=356
.Linfo_string44:
	.asciz	"ACrow"                 # string offset=367
.Linfo_string45:
	.asciz	"i"                     # string offset=373
.Linfo_string46:
	.asciz	"idx"                   # string offset=375
.Linfo_string47:
	.asciz	"Brow"                  # string offset=379
.Linfo_string48:
	.asciz	"argc"                  # string offset=384
.Linfo_string49:
	.asciz	"argv"                  # string offset=389
.Linfo_string50:
	.asciz	"lg_n"                  # string offset=394
.Linfo_string51:
	.asciz	"n"                     # string offset=399
.Linfo_string52:
	.asciz	"j"                     # string offset=401
.Linfo_string53:
	.asciz	"k"                     # string offset=403
.Linfo_string54:
	.asciz	"elapsed"               # string offset=405
.Linfo_string55:
	.asciz	"passed"                # string offset=413
.Linfo_string56:
	.asciz	"Ctmp"                  # string offset=420
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp1-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	85                      # DW_OP_reg5
	.quad	.Ltmp3-.Lfunc_begin0
	.quad	.Ltmp4-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	85                      # DW_OP_reg5
	.quad	0
	.quad	0
.Ldebug_loc1:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp0-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	.Ltmp0-.Lfunc_begin0
	.quad	.Ltmp1-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # DW_OP_reg14
	.quad	.Ltmp3-.Lfunc_begin0
	.quad	.Ltmp38-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # DW_OP_reg14
	.quad	0
	.quad	0
.Ldebug_loc2:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp1-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	81                      # DW_OP_reg1
	.quad	.Ltmp3-.Lfunc_begin0
	.quad	.Ltmp5-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	81                      # DW_OP_reg1
	.quad	0
	.quad	0
.Ldebug_loc3:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp5-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	88                      # super-register DW_OP_reg8
	.quad	0
	.quad	0
.Ldebug_loc4:
	.quad	.Ltmp6-.Lfunc_begin0
	.quad	.Ltmp39-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.quad	0
	.quad	0
.Ldebug_loc5:
	.quad	.Ltmp6-.Lfunc_begin0
	.quad	.Ltmp9-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp9-.Lfunc_begin0
	.quad	.Ltmp10-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	1                       # 1
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp10-.Lfunc_begin0
	.quad	.Ltmp14-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	2                       # 2
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp14-.Lfunc_begin0
	.quad	.Ltmp19-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	3                       # 3
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp19-.Lfunc_begin0
	.quad	.Ltmp20-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	4                       # 4
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc6:
	.quad	.Ltmp7-.Lfunc_begin0
	.quad	.Ltmp8-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	7                       # 7
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp8-.Lfunc_begin0
	.quad	.Ltmp11-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp11-.Lfunc_begin0
	.quad	.Ltmp12-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	8                       # 8
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Ltmp13-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	7                       # 7
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp13-.Lfunc_begin0
	.quad	.Ltmp14-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	8                       # 8
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp14-.Lfunc_begin0
	.quad	.Ltmp15-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp15-.Lfunc_begin0
	.quad	.Ltmp16-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	7                       # 7
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp16-.Lfunc_begin0
	.quad	.Ltmp17-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	8                       # 8
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp17-.Lfunc_begin0
	.quad	.Ltmp18-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	7                       # 7
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp18-.Lfunc_begin0
	.quad	.Ltmp20-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	8                       # 8
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc7:
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp28-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	0
	.quad	0
.Ldebug_loc8:
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp21-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp21-.Lfunc_begin0
	.quad	.Ltmp22-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	1                       # 1
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp22-.Lfunc_begin0
	.quad	.Ltmp23-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	2                       # 2
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp23-.Lfunc_begin0
	.quad	.Ltmp24-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	3                       # 3
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp24-.Lfunc_begin0
	.quad	.Ltmp28-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	4                       # 4
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc9:
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp24-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp24-.Lfunc_begin0
	.quad	.Ltmp28-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	8                       # 8
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc10:
	.quad	.Ltmp28-.Lfunc_begin0
	.quad	.Ltmp29-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp29-.Lfunc_begin0
	.quad	.Ltmp30-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	1                       # 1
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp30-.Lfunc_begin0
	.quad	.Ltmp31-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	2                       # 2
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp31-.Lfunc_begin0
	.quad	.Ltmp32-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	3                       # 3
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp32-.Lfunc_begin0
	.quad	.Ltmp35-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	4                       # 4
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc11:
	.quad	.Ltmp28-.Lfunc_begin0
	.quad	.Ltmp32-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	7                       # 7
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp32-.Lfunc_begin0
	.quad	.Ltmp35-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	8                       # 8
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc12:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp44-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	85                      # super-register DW_OP_reg5
	.quad	0
	.quad	0
.Ldebug_loc13:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp45-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	0
	.quad	0
.Ldebug_loc14:
	.quad	.Ltmp41-.Lfunc_begin0
	.quad	.Ltmp47-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	10                      # 10
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp47-.Lfunc_begin0
	.quad	.Ltmp58-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	92                      # super-register DW_OP_reg12
	.quad	.Ltmp58-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	40                      # 40
	.quad	0
	.quad	0
.Ldebug_loc15:
	.quad	.Ltmp44-.Lfunc_begin0
	.quad	.Ltmp46-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	85                      # DW_OP_reg5
	.quad	0
	.quad	0
.Ldebug_loc16:
	.quad	.Ltmp48-.Lfunc_begin0
	.quad	.Ltmp78-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # super-register DW_OP_reg13
	.quad	.Ltmp95-.Lfunc_begin0
	.quad	.Ltmp97-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # super-register DW_OP_reg13
	.quad	0
	.quad	0
.Ldebug_loc17:
	.quad	.Ltmp49-.Lfunc_begin0
	.quad	.Ltmp50-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # super-register DW_OP_reg0
	.quad	.Ltmp50-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	4                       # 4
	.quad	0
	.quad	0
.Ldebug_loc18:
	.quad	.Ltmp52-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	24                      # 24
	.quad	0
	.quad	0
.Ldebug_loc19:
	.quad	.Ltmp54-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	16                      # 16
	.quad	0
	.quad	0
.Ldebug_loc20:
	.quad	.Ltmp56-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc21:
	.quad	.Ltmp57-.Lfunc_begin0
	.quad	.Ltmp60-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp60-.Lfunc_begin0
	.quad	.Ltmp71-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # super-register DW_OP_reg14
	.quad	0
	.quad	0
.Ldebug_loc22:
	.quad	.Ltmp60-.Lfunc_begin0
	.quad	.Ltmp62-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp62-.Lfunc_begin0
	.quad	.Ltmp68-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	83                      # DW_OP_reg3
	.quad	0
	.quad	0
.Ldebug_loc23:
	.quad	.Ltmp74-.Lfunc_begin0
	.quad	.Ltmp75-.Lfunc_begin0
	.short	8                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	200                     # 72
	.byte	0                       # 
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	80                      # DW_OP_reg0
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	10                      # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	200                     # 72
	.byte	0                       # 
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	119                     # DW_OP_breg7
	.byte	208                     # 80
	.byte	0                       # 
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc24:
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Ltmp78-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp78-.Lfunc_begin0
	.quad	.Ltmp79-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # super-register DW_OP_reg0
	.quad	.Ltmp79-.Lfunc_begin0
	.quad	.Ltmp94-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	216                     # 88
	.byte	0                       # 
	.quad	.Ltmp94-.Lfunc_begin0
	.quad	.Ltmp97-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # super-register DW_OP_reg0
	.quad	0
	.quad	0
.Ldebug_loc25:
	.quad	.Ltmp78-.Lfunc_begin0
	.quad	.Ltmp81-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp81-.Lfunc_begin0
	.quad	.Ltmp83-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	81                      # DW_OP_reg1
	.quad	.Ltmp83-.Lfunc_begin0
	.quad	.Ltmp91-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	240                     # 112
	.byte	0                       # 
	.quad	.Ltmp91-.Lfunc_begin0
	.quad	.Ltmp93-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	81                      # DW_OP_reg1
	.quad	0
	.quad	0
.Ldebug_loc26:
	.quad	.Ltmp81-.Lfunc_begin0
	.quad	.Ltmp85-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp85-.Lfunc_begin0
	.quad	.Ltmp90-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	0
	.quad	0
.Ldebug_loc27:
	.quad	.Ltmp102-.Lfunc_begin0
	.quad	.Ltmp103-.Lfunc_begin0
	.short	5                       # Loc expr size
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	82                      # DW_OP_reg2
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc28:
	.quad	.Ltmp102-.Lfunc_begin0
	.quad	.Ltmp103-.Lfunc_begin0
	.short	5                       # Loc expr size
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	82                      # DW_OP_reg2
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc29:
	.quad	.Ltmp102-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	7                       # Loc expr size
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	119                     # DW_OP_breg7
	.byte	208                     # 80
	.byte	0                       # 
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc30:
	.quad	.Ltmp104-.Lfunc_begin0
	.quad	.Ltmp105-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	0
	.quad	0
.Ldebug_loc31:
	.quad	.Ltmp107-.Lfunc_begin0
	.quad	.Ltmp111-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	83                      # super-register DW_OP_reg3
	.quad	0
	.quad	0
.Ldebug_loc32:
	.quad	.Lfunc_begin2-.Lfunc_begin0
	.quad	.Ltmp113-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	85                      # DW_OP_reg5
	.quad	.Ltmp113-.Lfunc_begin0
	.quad	.Ltmp120-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	86                      # DW_OP_reg6
	.quad	.Ltmp120-.Lfunc_begin0
	.quad	.Ltmp124-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	192                     # 64
	.byte	0                       # 
	.quad	.Ltmp124-.Lfunc_begin0
	.quad	.Ltmp125-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	86                      # DW_OP_reg6
	.quad	.Ltmp125-.Lfunc_begin0
	.quad	.Ltmp168-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	192                     # 64
	.byte	0                       # 
	.quad	0
	.quad	0
.Ldebug_loc33:
	.quad	.Lfunc_begin2-.Lfunc_begin0
	.quad	.Ltmp113-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	.Ltmp113-.Lfunc_begin0
	.quad	.Ltmp118-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.quad	.Ltmp118-.Lfunc_begin0
	.quad	.Ltmp124-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	56                      # 56
	.quad	.Ltmp124-.Lfunc_begin0
	.quad	.Ltmp125-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.quad	.Ltmp125-.Lfunc_begin0
	.quad	.Ltmp143-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	56                      # 56
	.quad	.Ltmp143-.Lfunc_begin0
	.quad	.Ltmp144-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	88                      # DW_OP_reg8
	.quad	0
	.quad	0
.Ldebug_loc34:
	.quad	.Lfunc_begin2-.Lfunc_begin0
	.quad	.Ltmp113-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	81                      # DW_OP_reg1
	.quad	.Ltmp113-.Lfunc_begin0
	.quad	.Ltmp119-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # DW_OP_reg14
	.quad	.Ltmp119-.Lfunc_begin0
	.quad	.Ltmp124-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	24                      # 24
	.quad	.Ltmp124-.Lfunc_begin0
	.quad	.Ltmp125-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # DW_OP_reg14
	.quad	.Ltmp125-.Lfunc_begin0
	.quad	.Ltmp144-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	24                      # 24
	.quad	.Ltmp145-.Lfunc_begin0
	.quad	.Ltmp146-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	83                      # DW_OP_reg3
	.quad	0
	.quad	0
.Ldebug_loc35:
	.quad	.Lfunc_begin2-.Lfunc_begin0
	.quad	.Ltmp113-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	82                      # super-register DW_OP_reg2
	.quad	.Ltmp113-.Lfunc_begin0
	.quad	.Ltmp121-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	83                      # super-register DW_OP_reg3
	.quad	.Ltmp121-.Lfunc_begin0
	.quad	.Ltmp124-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # super-register DW_OP_reg14
	.quad	.Ltmp124-.Lfunc_begin0
	.quad	.Ltmp125-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	83                      # super-register DW_OP_reg3
	.quad	.Ltmp125-.Lfunc_begin0
	.quad	.Ltmp190-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # super-register DW_OP_reg14
	.quad	0
	.quad	0
.Ldebug_loc36:
	.quad	.Ltmp113-.Lfunc_begin0
	.quad	.Ltmp168-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	49                      # DW_OP_lit1
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp168-.Lfunc_begin0
	.quad	.Ltmp176-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	81                      # super-register DW_OP_reg1
	.quad	.Ltmp176-.Lfunc_begin0
	.quad	.Ltmp178-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	48                      # DW_OP_lit0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp178-.Lfunc_begin0
	.quad	.Ltmp188-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	81                      # super-register DW_OP_reg1
	.quad	0
	.quad	0
.Ldebug_loc37:
	.quad	.Ltmp115-.Lfunc_begin0
	.quad	.Ltmp126-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp136-.Lfunc_begin0
	.quad	.Ltmp138-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc38:
	.quad	.Ltmp115-.Lfunc_begin0
	.quad	.Ltmp116-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # DW_OP_reg0
	.quad	.Ltmp116-.Lfunc_begin0
	.quad	.Lfunc_end2-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc39:
	.quad	.Ltmp126-.Lfunc_begin0
	.quad	.Ltmp135-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp138-.Lfunc_begin0
	.quad	.Ltmp140-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc40:
	.quad	.Ltmp144-.Lfunc_begin0
	.quad	.Ltmp168-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	85                      # DW_OP_reg5
	.quad	0
	.quad	0
.Ldebug_loc41:
	.quad	.Ltmp144-.Lfunc_begin0
	.quad	.Ltmp146-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp146-.Lfunc_begin0
	.quad	.Ltmp163-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	81                      # DW_OP_reg1
	.quad	0
	.quad	0
.Ldebug_loc42:
	.quad	.Ltmp146-.Lfunc_begin0
	.quad	.Ltmp150-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp150-.Lfunc_begin0
	.quad	.Ltmp153-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # DW_OP_reg0
	.quad	0
	.quad	0
.Ldebug_loc43:
	.quad	.Ltmp168-.Lfunc_begin0
	.quad	.Ltmp185-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.quad	0
	.quad	0
.Ldebug_loc44:
	.quad	.Ltmp168-.Lfunc_begin0
	.quad	.Ltmp169-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	17                      # DW_OP_consts
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp169-.Lfunc_begin0
	.quad	.Ltmp181-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	86                      # DW_OP_reg6
	.quad	0
	.quad	0
.Ldebug_loc45:
	.quad	.Ltmp170-.Lfunc_begin0
	.quad	.Ltmp176-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	0
	.quad	0
.Ldebug_loc46:
	.quad	.Ltmp170-.Lfunc_begin0
	.quad	.Ltmp176-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	98                      # DW_OP_reg18
	.quad	0
	.quad	0
.Ldebug_loc47:
	.quad	.Ltmp173-.Lfunc_begin0
	.quad	.Ltmp176-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	100                     # DW_OP_reg20
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
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	5                       # DW_FORM_data2
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	60                      # DW_AT_declaration
	.byte	25                      # DW_FORM_flag_present
	.byte	63                      # DW_AT_external
	.byte	25                      # DW_FORM_flag_present
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	3                       # Abbreviation Code
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
	.byte	4                       # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	5                       # DW_FORM_data2
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.byte	60                      # DW_AT_declaration
	.byte	25                      # DW_FORM_flag_present
	.byte	63                      # DW_AT_external
	.byte	25                      # DW_FORM_flag_present
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	5                       # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	6                       # Abbreviation Code
	.byte	15                      # DW_TAG_pointer_type
	.byte	0                       # DW_CHILDREN_no
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	7                       # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	60                      # DW_AT_declaration
	.byte	25                      # DW_FORM_flag_present
	.byte	63                      # DW_AT_external
	.byte	25                      # DW_FORM_flag_present
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	8                       # Abbreviation Code
	.byte	15                      # DW_TAG_pointer_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	9                       # Abbreviation Code
	.byte	19                      # DW_TAG_structure_type
	.byte	1                       # DW_CHILDREN_yes
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	11                      # DW_AT_byte_size
	.byte	11                      # DW_FORM_data1
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	10                      # Abbreviation Code
	.byte	13                      # DW_TAG_member
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	56                      # DW_AT_data_member_location
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	11                      # Abbreviation Code
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
	.byte	12                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	63                      # DW_AT_external
	.byte	25                      # DW_FORM_flag_present
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	2                       # DW_AT_location
	.byte	24                      # DW_FORM_exprloc
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	13                      # Abbreviation Code
	.byte	1                       # DW_TAG_array_type
	.byte	1                       # DW_CHILDREN_yes
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	14                      # Abbreviation Code
	.byte	33                      # DW_TAG_subrange_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	55                      # DW_AT_count
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	15                      # Abbreviation Code
	.byte	1                       # DW_TAG_array_type
	.byte	1                       # DW_CHILDREN_yes
	.ascii	"\207B"                 # DW_AT_GNU_vector
	.byte	25                      # DW_FORM_flag_present
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	16                      # Abbreviation Code
	.byte	36                      # DW_TAG_base_type
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	11                      # DW_AT_byte_size
	.byte	11                      # DW_FORM_data1
	.byte	62                      # DW_AT_encoding
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	17                      # Abbreviation Code
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
	.byte	18                      # Abbreviation Code
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
	.byte	19                      # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
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
	.byte	20                      # Abbreviation Code
	.byte	11                      # DW_TAG_lexical_block
	.byte	1                       # DW_CHILDREN_yes
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	21                      # Abbreviation Code
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
	.byte	22                      # Abbreviation Code
	.byte	11                      # DW_TAG_lexical_block
	.byte	1                       # DW_CHILDREN_yes
	.byte	85                      # DW_AT_ranges
	.byte	23                      # DW_FORM_sec_offset
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	23                      # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	5                       # DW_FORM_data2
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	63                      # DW_AT_external
	.byte	25                      # DW_FORM_flag_present
	.byte	32                      # DW_AT_inline
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	24                      # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	5                       # DW_FORM_data2
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	25                      # Abbreviation Code
	.byte	38                      # DW_TAG_const_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	26                      # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	32                      # DW_AT_inline
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	27                      # Abbreviation Code
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
	.byte	28                      # Abbreviation Code
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
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	63                      # DW_AT_external
	.byte	25                      # DW_FORM_flag_present
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	29                      # Abbreviation Code
	.byte	29                      # DW_TAG_inlined_subroutine
	.byte	1                       # DW_CHILDREN_yes
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	88                      # DW_AT_call_file
	.byte	11                      # DW_FORM_data1
	.byte	89                      # DW_AT_call_line
	.byte	11                      # DW_FORM_data1
	.byte	87                      # DW_AT_call_column
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	30                      # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	31                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	24                      # DW_FORM_exprloc
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	32                      # Abbreviation Code
	.byte	29                      # DW_TAG_inlined_subroutine
	.byte	1                       # DW_CHILDREN_yes
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	85                      # DW_AT_ranges
	.byte	23                      # DW_FORM_sec_offset
	.byte	88                      # DW_AT_call_file
	.byte	11                      # DW_FORM_data1
	.byte	89                      # DW_AT_call_line
	.byte	11                      # DW_FORM_data1
	.byte	87                      # DW_AT_call_column
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	33                      # Abbreviation Code
	.ascii	"\211\202\001"          # DW_TAG_GNU_call_site
	.byte	0                       # DW_CHILDREN_no
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	34                      # Abbreviation Code
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
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	35                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	36                      # Abbreviation Code
	.byte	11                      # DW_TAG_lexical_block
	.byte	1                       # DW_CHILDREN_yes
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	37                      # Abbreviation Code
	.byte	55                      # DW_TAG_restrict_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
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
	.byte	1                       # Abbrev [1] 0xb:0x69c DW_TAG_compile_unit
	.long	.Linfo_string0          # DW_AT_producer
	.short	12                      # DW_AT_language
	.long	.Linfo_string1          # DW_AT_name
	.long	.Lline_table_start0     # DW_AT_stmt_list
	.long	.Linfo_string2          # DW_AT_comp_dir
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.long	.Lfunc_end2-.Lfunc_begin0 # DW_AT_high_pc
	.byte	2                       # Abbrev [2] 0x2a:0xc DW_TAG_subprogram
	.long	.Linfo_string3          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.short	453                     # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	54                      # DW_AT_type
                                        # DW_AT_declaration
                                        # DW_AT_external
	.byte	3                       # Abbrev [3] 0x36:0x7 DW_TAG_base_type
	.long	.Linfo_string4          # DW_AT_name
	.byte	5                       # DW_AT_encoding
	.byte	4                       # DW_AT_byte_size
	.byte	4                       # Abbrev [4] 0x3d:0xe DW_TAG_subprogram
	.long	.Linfo_string5          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.short	563                     # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_declaration
                                        # DW_AT_external
	.byte	5                       # Abbrev [5] 0x45:0x5 DW_TAG_formal_parameter
	.long	75                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	6                       # Abbrev [6] 0x4b:0x1 DW_TAG_pointer_type
	.byte	7                       # Abbrev [7] 0x4c:0x16 DW_TAG_subprogram
	.long	.Linfo_string6          # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	219                     # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	54                      # DW_AT_type
                                        # DW_AT_declaration
                                        # DW_AT_external
	.byte	5                       # Abbrev [5] 0x57:0x5 DW_TAG_formal_parameter
	.long	54                      # DW_AT_type
	.byte	5                       # Abbrev [5] 0x5c:0x5 DW_TAG_formal_parameter
	.long	98                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	8                       # Abbrev [8] 0x62:0x5 DW_TAG_pointer_type
	.long	103                     # DW_AT_type
	.byte	9                       # Abbrev [9] 0x67:0x21 DW_TAG_structure_type
	.long	.Linfo_string12         # DW_AT_name
	.byte	16                      # DW_AT_byte_size
	.byte	4                       # DW_AT_decl_file
	.byte	9                       # DW_AT_decl_line
	.byte	10                      # Abbrev [10] 0x6f:0xc DW_TAG_member
	.long	.Linfo_string7          # DW_AT_name
	.long	136                     # DW_AT_type
	.byte	4                       # DW_AT_decl_file
	.byte	11                      # DW_AT_decl_line
	.byte	0                       # DW_AT_data_member_location
	.byte	10                      # Abbrev [10] 0x7b:0xc DW_TAG_member
	.long	.Linfo_string10         # DW_AT_name
	.long	154                     # DW_AT_type
	.byte	4                       # DW_AT_decl_file
	.byte	12                      # DW_AT_decl_line
	.byte	8                       # DW_AT_data_member_location
	.byte	0                       # End Of Children Mark
	.byte	11                      # Abbrev [11] 0x88:0xb DW_TAG_typedef
	.long	147                     # DW_AT_type
	.long	.Linfo_string9          # DW_AT_name
	.byte	3                       # DW_AT_decl_file
	.byte	148                     # DW_AT_decl_line
	.byte	3                       # Abbrev [3] 0x93:0x7 DW_TAG_base_type
	.long	.Linfo_string8          # DW_AT_name
	.byte	5                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	11                      # Abbrev [11] 0x9a:0xb DW_TAG_typedef
	.long	147                     # DW_AT_type
	.long	.Linfo_string11         # DW_AT_name
	.byte	3                       # DW_AT_decl_file
	.byte	184                     # DW_AT_decl_line
	.byte	12                      # Abbrev [12] 0xa5:0x15 DW_TAG_variable
	.long	.Linfo_string13         # DW_AT_name
	.long	186                     # DW_AT_type
                                        # DW_AT_external
	.byte	5                       # DW_AT_decl_file
	.byte	37                      # DW_AT_decl_line
	.byte	9                       # DW_AT_location
	.byte	3
	.quad	Avec
	.byte	13                      # Abbrev [13] 0xba:0xc DW_TAG_array_type
	.long	198                     # DW_AT_type
	.byte	14                      # Abbrev [14] 0xbf:0x6 DW_TAG_subrange_type
	.long	228                     # DW_AT_type
	.byte	4                       # DW_AT_count
	.byte	0                       # End Of Children Mark
	.byte	11                      # Abbrev [11] 0xc6:0xb DW_TAG_typedef
	.long	209                     # DW_AT_type
	.long	.Linfo_string16         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	34                      # DW_AT_decl_line
	.byte	15                      # Abbrev [15] 0xd1:0xc DW_TAG_array_type
                                        # DW_AT_GNU_vector
	.long	221                     # DW_AT_type
	.byte	14                      # Abbrev [14] 0xd6:0x6 DW_TAG_subrange_type
	.long	228                     # DW_AT_type
	.byte	8                       # DW_AT_count
	.byte	0                       # End Of Children Mark
	.byte	3                       # Abbrev [3] 0xdd:0x7 DW_TAG_base_type
	.long	.Linfo_string14         # DW_AT_name
	.byte	4                       # DW_AT_encoding
	.byte	4                       # DW_AT_byte_size
	.byte	16                      # Abbrev [16] 0xe4:0x7 DW_TAG_base_type
	.long	.Linfo_string15         # DW_AT_name
	.byte	8                       # DW_AT_byte_size
	.byte	7                       # DW_AT_encoding
	.byte	12                      # Abbrev [12] 0xeb:0x15 DW_TAG_variable
	.long	.Linfo_string17         # DW_AT_name
	.long	186                     # DW_AT_type
                                        # DW_AT_external
	.byte	5                       # DW_AT_decl_file
	.byte	37                      # DW_AT_decl_line
	.byte	9                       # DW_AT_location
	.byte	3
	.quad	Bvec
	.byte	12                      # Abbrev [12] 0x100:0x15 DW_TAG_variable
	.long	.Linfo_string18         # DW_AT_name
	.long	186                     # DW_AT_type
                                        # DW_AT_external
	.byte	5                       # DW_AT_decl_file
	.byte	37                      # DW_AT_decl_line
	.byte	9                       # DW_AT_location
	.byte	3
	.quad	Cvec
	.byte	8                       # Abbrev [8] 0x115:0x5 DW_TAG_pointer_type
	.long	282                     # DW_AT_type
	.byte	11                      # Abbrev [11] 0x11a:0xb DW_TAG_typedef
	.long	221                     # DW_AT_type
	.long	.Linfo_string19         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	33                      # DW_AT_decl_line
	.byte	8                       # Abbrev [8] 0x125:0x5 DW_TAG_pointer_type
	.long	298                     # DW_AT_type
	.byte	8                       # Abbrev [8] 0x12a:0x5 DW_TAG_pointer_type
	.long	303                     # DW_AT_type
	.byte	3                       # Abbrev [3] 0x12f:0x7 DW_TAG_base_type
	.long	.Linfo_string20         # DW_AT_name
	.byte	6                       # DW_AT_encoding
	.byte	1                       # DW_AT_byte_size
	.byte	17                      # Abbrev [17] 0x136:0x11d DW_TAG_subprogram
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0 # DW_AT_high_pc
	.byte	1                       # DW_AT_frame_base
	.byte	87
                                        # DW_AT_GNU_all_call_sites
	.long	.Linfo_string36         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	44                      # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_external
	.byte	18                      # Abbrev [18] 0x14b:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc0            # DW_AT_location
	.long	.Linfo_string39         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	44                      # DW_AT_decl_line
	.long	1677                    # DW_AT_type
	.byte	18                      # Abbrev [18] 0x15a:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc1            # DW_AT_location
	.long	.Linfo_string40         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	44                      # DW_AT_decl_line
	.long	1682                    # DW_AT_type
	.byte	18                      # Abbrev [18] 0x169:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc2            # DW_AT_location
	.long	.Linfo_string41         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	45                      # DW_AT_decl_line
	.long	1682                    # DW_AT_type
	.byte	19                      # Abbrev [19] 0x178:0xb DW_TAG_formal_parameter
	.long	.Linfo_string43         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	45                      # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	18                      # Abbrev [18] 0x183:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc3            # DW_AT_location
	.long	.Linfo_string42         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	45                      # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x192:0xc0 DW_TAG_lexical_block
	.quad	.Ltmp5                  # DW_AT_low_pc
	.long	.Ltmp37-.Ltmp5          # DW_AT_high_pc
	.byte	21                      # Abbrev [21] 0x19f:0xf DW_TAG_variable
	.long	.Ldebug_loc4            # DW_AT_location
	.long	.Linfo_string44         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	57                      # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	22                      # Abbrev [22] 0x1ae:0x2a DW_TAG_lexical_block
	.long	.Ldebug_ranges1         # DW_AT_ranges
	.byte	21                      # Abbrev [21] 0x1b3:0xf DW_TAG_variable
	.long	.Ldebug_loc5            # DW_AT_location
	.long	.Linfo_string45         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	60                      # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	22                      # Abbrev [22] 0x1c2:0x15 DW_TAG_lexical_block
	.long	.Ldebug_ranges0         # DW_AT_ranges
	.byte	21                      # Abbrev [21] 0x1c7:0xf DW_TAG_variable
	.long	.Ldebug_loc6            # DW_AT_location
	.long	.Linfo_string46         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	62                      # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	22                      # Abbrev [22] 0x1d8:0x3f DW_TAG_lexical_block
	.long	.Ldebug_ranges4         # DW_AT_ranges
	.byte	21                      # Abbrev [21] 0x1dd:0xf DW_TAG_variable
	.long	.Ldebug_loc7            # DW_AT_location
	.long	.Linfo_string47         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	72                      # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	22                      # Abbrev [22] 0x1ec:0x2a DW_TAG_lexical_block
	.long	.Ldebug_ranges3         # DW_AT_ranges
	.byte	21                      # Abbrev [21] 0x1f1:0xf DW_TAG_variable
	.long	.Ldebug_loc8            # DW_AT_location
	.long	.Linfo_string45         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	74                      # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	22                      # Abbrev [22] 0x200:0x15 DW_TAG_lexical_block
	.long	.Ldebug_ranges2         # DW_AT_ranges
	.byte	21                      # Abbrev [21] 0x205:0xf DW_TAG_variable
	.long	.Ldebug_loc9            # DW_AT_location
	.long	.Linfo_string46         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	76                      # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	20                      # Abbrev [20] 0x217:0x3a DW_TAG_lexical_block
	.quad	.Ltmp28                 # DW_AT_low_pc
	.long	.Ltmp32-.Ltmp28         # DW_AT_high_pc
	.byte	21                      # Abbrev [21] 0x224:0xf DW_TAG_variable
	.long	.Ldebug_loc10           # DW_AT_location
	.long	.Linfo_string45         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	90                      # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x233:0x1d DW_TAG_lexical_block
	.quad	.Ltmp28                 # DW_AT_low_pc
	.long	.Ltmp32-.Ltmp28         # DW_AT_high_pc
	.byte	21                      # Abbrev [21] 0x240:0xf DW_TAG_variable
	.long	.Ldebug_loc11           # DW_AT_location
	.long	.Linfo_string46         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	91                      # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	23                      # Abbrev [23] 0x253:0x1a DW_TAG_subprogram
	.long	.Linfo_string21         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.short	361                     # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	54                      # DW_AT_type
                                        # DW_AT_external
	.byte	1                       # DW_AT_inline
	.byte	24                      # Abbrev [24] 0x260:0xc DW_TAG_formal_parameter
	.long	.Linfo_string22         # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.short	361                     # DW_AT_decl_line
	.long	621                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	8                       # Abbrev [8] 0x26d:0x5 DW_TAG_pointer_type
	.long	626                     # DW_AT_type
	.byte	25                      # Abbrev [25] 0x272:0x5 DW_TAG_const_type
	.long	303                     # DW_AT_type
	.byte	26                      # Abbrev [26] 0x277:0x18 DW_TAG_subprogram
	.long	.Linfo_string23         # DW_AT_name
	.byte	6                       # DW_AT_decl_file
	.byte	69                      # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	655                     # DW_AT_type
	.byte	1                       # DW_AT_inline
	.byte	27                      # Abbrev [27] 0x283:0xb DW_TAG_variable
	.long	.Linfo_string25         # DW_AT_name
	.byte	6                       # DW_AT_decl_file
	.byte	70                      # DW_AT_decl_line
	.long	103                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	11                      # Abbrev [11] 0x28f:0xb DW_TAG_typedef
	.long	103                     # DW_AT_type
	.long	.Linfo_string24         # DW_AT_name
	.byte	6                       # DW_AT_decl_file
	.byte	66                      # DW_AT_decl_line
	.byte	26                      # Abbrev [26] 0x29a:0x23 DW_TAG_subprogram
	.long	.Linfo_string26         # DW_AT_name
	.byte	6                       # DW_AT_decl_file
	.byte	82                      # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	701                     # DW_AT_type
	.byte	1                       # DW_AT_inline
	.byte	19                      # Abbrev [19] 0x2a6:0xb DW_TAG_formal_parameter
	.long	.Linfo_string28         # DW_AT_name
	.byte	6                       # DW_AT_decl_file
	.byte	82                      # DW_AT_decl_line
	.long	655                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x2b1:0xb DW_TAG_formal_parameter
	.long	.Linfo_string29         # DW_AT_name
	.byte	6                       # DW_AT_decl_file
	.byte	82                      # DW_AT_decl_line
	.long	655                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	3                       # Abbrev [3] 0x2bd:0x7 DW_TAG_base_type
	.long	.Linfo_string27         # DW_AT_name
	.byte	4                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	28                      # Abbrev [28] 0x2c4:0x22b DW_TAG_subprogram
	.quad	.Lfunc_begin1           # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin1 # DW_AT_high_pc
	.byte	1                       # DW_AT_frame_base
	.byte	87
                                        # DW_AT_GNU_all_call_sites
	.long	.Linfo_string37         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	157                     # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	54                      # DW_AT_type
                                        # DW_AT_external
	.byte	18                      # Abbrev [18] 0x2dd:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc12           # DW_AT_location
	.long	.Linfo_string48         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	157                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	18                      # Abbrev [18] 0x2ec:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc13           # DW_AT_location
	.long	.Linfo_string49         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	157                     # DW_AT_decl_line
	.long	293                     # DW_AT_type
	.byte	21                      # Abbrev [21] 0x2fb:0xf DW_TAG_variable
	.long	.Ldebug_loc14           # DW_AT_location
	.long	.Linfo_string50         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	160                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	21                      # Abbrev [21] 0x30a:0xf DW_TAG_variable
	.long	.Ldebug_loc16           # DW_AT_location
	.long	.Linfo_string51         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	165                     # DW_AT_decl_line
	.long	1697                    # DW_AT_type
	.byte	21                      # Abbrev [21] 0x319:0xf DW_TAG_variable
	.long	.Ldebug_loc17           # DW_AT_location
	.long	.Linfo_string42         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	167                     # DW_AT_decl_line
	.long	1697                    # DW_AT_type
	.byte	21                      # Abbrev [21] 0x328:0xf DW_TAG_variable
	.long	.Ldebug_loc18           # DW_AT_location
	.long	.Linfo_string40         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	172                     # DW_AT_decl_line
	.long	277                     # DW_AT_type
	.byte	21                      # Abbrev [21] 0x337:0xf DW_TAG_variable
	.long	.Ldebug_loc19           # DW_AT_location
	.long	.Linfo_string41         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	173                     # DW_AT_decl_line
	.long	277                     # DW_AT_type
	.byte	21                      # Abbrev [21] 0x346:0xf DW_TAG_variable
	.long	.Ldebug_loc20           # DW_AT_location
	.long	.Linfo_string39         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	174                     # DW_AT_decl_line
	.long	277                     # DW_AT_type
	.byte	21                      # Abbrev [21] 0x355:0xf DW_TAG_variable
	.long	.Ldebug_loc23           # DW_AT_location
	.long	.Linfo_string28         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	186                     # DW_AT_decl_line
	.long	655                     # DW_AT_type
	.byte	21                      # Abbrev [21] 0x364:0xf DW_TAG_variable
	.long	.Ldebug_loc28           # DW_AT_location
	.long	.Linfo_string29         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	194                     # DW_AT_decl_line
	.long	655                     # DW_AT_type
	.byte	21                      # Abbrev [21] 0x373:0xf DW_TAG_variable
	.long	.Ldebug_loc30           # DW_AT_location
	.long	.Linfo_string54         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	197                     # DW_AT_decl_line
	.long	701                     # DW_AT_type
	.byte	21                      # Abbrev [21] 0x382:0xf DW_TAG_variable
	.long	.Ldebug_loc31           # DW_AT_location
	.long	.Linfo_string55         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	201                     # DW_AT_decl_line
	.long	1670                    # DW_AT_type
	.byte	29                      # Abbrev [29] 0x391:0x1e DW_TAG_inlined_subroutine
	.long	595                     # DW_AT_abstract_origin
	.quad	.Ltmp44                 # DW_AT_low_pc
	.long	.Ltmp47-.Ltmp44         # DW_AT_high_pc
	.byte	5                       # DW_AT_call_file
	.byte	162                     # DW_AT_call_line
	.byte	12                      # DW_AT_call_column
	.byte	30                      # Abbrev [30] 0x3a5:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc15           # DW_AT_location
	.long	608                     # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	22                      # Abbrev [22] 0x3af:0x47 DW_TAG_lexical_block
	.long	.Ldebug_ranges6         # DW_AT_ranges
	.byte	21                      # Abbrev [21] 0x3b4:0xf DW_TAG_variable
	.long	.Ldebug_loc24           # DW_AT_location
	.long	.Linfo_string45         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	187                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x3c3:0x32 DW_TAG_lexical_block
	.quad	.Ltmp79                 # DW_AT_low_pc
	.long	.Ltmp93-.Ltmp79         # DW_AT_high_pc
	.byte	21                      # Abbrev [21] 0x3d0:0xf DW_TAG_variable
	.long	.Ldebug_loc25           # DW_AT_location
	.long	.Linfo_string53         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	188                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	22                      # Abbrev [22] 0x3df:0x15 DW_TAG_lexical_block
	.long	.Ldebug_ranges5         # DW_AT_ranges
	.byte	21                      # Abbrev [21] 0x3e4:0xf DW_TAG_variable
	.long	.Ldebug_loc26           # DW_AT_location
	.long	.Linfo_string52         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	189                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	22                      # Abbrev [22] 0x3f6:0x32 DW_TAG_lexical_block
	.long	.Ldebug_ranges7         # DW_AT_ranges
	.byte	21                      # Abbrev [21] 0x3fb:0xf DW_TAG_variable
	.long	.Ldebug_loc21           # DW_AT_location
	.long	.Linfo_string45         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	177                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x40a:0x1d DW_TAG_lexical_block
	.quad	.Ltmp60                 # DW_AT_low_pc
	.long	.Ltmp68-.Ltmp60         # DW_AT_high_pc
	.byte	21                      # Abbrev [21] 0x417:0xf DW_TAG_variable
	.long	.Ldebug_loc22           # DW_AT_location
	.long	.Linfo_string52         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	178                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	29                      # Abbrev [29] 0x428:0x1d DW_TAG_inlined_subroutine
	.long	631                     # DW_AT_abstract_origin
	.quad	.Ltmp72                 # DW_AT_low_pc
	.long	.Ltmp75-.Ltmp72         # DW_AT_high_pc
	.byte	5                       # DW_AT_call_file
	.byte	186                     # DW_AT_call_line
	.byte	22                      # DW_AT_call_column
	.byte	31                      # Abbrev [31] 0x43c:0x8 DW_TAG_variable
	.byte	2                       # DW_AT_location
	.byte	145
	.byte	56
	.long	643                     # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	32                      # Abbrev [32] 0x445:0x15 DW_TAG_inlined_subroutine
	.long	631                     # DW_AT_abstract_origin
	.long	.Ldebug_ranges8         # DW_AT_ranges
	.byte	5                       # DW_AT_call_file
	.byte	194                     # DW_AT_call_line
	.byte	20                      # DW_AT_call_column
	.byte	31                      # Abbrev [31] 0x451:0x8 DW_TAG_variable
	.byte	2                       # DW_AT_location
	.byte	145
	.byte	56
	.long	643                     # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	32                      # Abbrev [32] 0x45a:0x1f DW_TAG_inlined_subroutine
	.long	666                     # DW_AT_abstract_origin
	.long	.Ldebug_ranges9         # DW_AT_ranges
	.byte	5                       # DW_AT_call_file
	.byte	197                     # DW_AT_call_line
	.byte	20                      # DW_AT_call_column
	.byte	30                      # Abbrev [30] 0x466:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc29           # DW_AT_location
	.long	678                     # DW_AT_abstract_origin
	.byte	30                      # Abbrev [30] 0x46f:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc27           # DW_AT_location
	.long	689                     # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	33                      # Abbrev [33] 0x479:0xd DW_TAG_GNU_call_site
	.long	42                      # DW_AT_abstract_origin
	.quad	.Ltmp63                 # DW_AT_low_pc
	.byte	33                      # Abbrev [33] 0x486:0xd DW_TAG_GNU_call_site
	.long	42                      # DW_AT_abstract_origin
	.quad	.Ltmp64                 # DW_AT_low_pc
	.byte	33                      # Abbrev [33] 0x493:0xd DW_TAG_GNU_call_site
	.long	76                      # DW_AT_abstract_origin
	.quad	.Ltmp73                 # DW_AT_low_pc
	.byte	33                      # Abbrev [33] 0x4a0:0xd DW_TAG_GNU_call_site
	.long	310                     # DW_AT_abstract_origin
	.quad	.Ltmp86                 # DW_AT_low_pc
	.byte	33                      # Abbrev [33] 0x4ad:0xd DW_TAG_GNU_call_site
	.long	76                      # DW_AT_abstract_origin
	.quad	.Ltmp99                 # DW_AT_low_pc
	.byte	33                      # Abbrev [33] 0x4ba:0xd DW_TAG_GNU_call_site
	.long	1263                    # DW_AT_abstract_origin
	.quad	.Ltmp106                # DW_AT_low_pc
	.byte	33                      # Abbrev [33] 0x4c7:0xd DW_TAG_GNU_call_site
	.long	61                      # DW_AT_abstract_origin
	.quad	.Ltmp108                # DW_AT_low_pc
	.byte	33                      # Abbrev [33] 0x4d4:0xd DW_TAG_GNU_call_site
	.long	61                      # DW_AT_abstract_origin
	.quad	.Ltmp109                # DW_AT_low_pc
	.byte	33                      # Abbrev [33] 0x4e1:0xd DW_TAG_GNU_call_site
	.long	61                      # DW_AT_abstract_origin
	.quad	.Ltmp110                # DW_AT_low_pc
	.byte	0                       # End Of Children Mark
	.byte	34                      # Abbrev [34] 0x4ef:0x15c DW_TAG_subprogram
	.quad	.Lfunc_begin2           # DW_AT_low_pc
	.long	.Lfunc_end2-.Lfunc_begin2 # DW_AT_high_pc
	.byte	1                       # DW_AT_frame_base
	.byte	87
                                        # DW_AT_GNU_all_call_sites
	.long	.Linfo_string38         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	120                     # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	1670                    # DW_AT_type
	.byte	18                      # Abbrev [18] 0x508:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc32           # DW_AT_location
	.long	.Linfo_string39         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	120                     # DW_AT_decl_line
	.long	1682                    # DW_AT_type
	.byte	18                      # Abbrev [18] 0x517:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc33           # DW_AT_location
	.long	.Linfo_string40         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	120                     # DW_AT_decl_line
	.long	1682                    # DW_AT_type
	.byte	18                      # Abbrev [18] 0x526:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc34           # DW_AT_location
	.long	.Linfo_string41         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	121                     # DW_AT_decl_line
	.long	1682                    # DW_AT_type
	.byte	18                      # Abbrev [18] 0x535:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc35           # DW_AT_location
	.long	.Linfo_string51         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	121                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	21                      # Abbrev [21] 0x544:0xf DW_TAG_variable
	.long	.Ldebug_loc36           # DW_AT_location
	.long	.Linfo_string55         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	122                     # DW_AT_decl_line
	.long	1670                    # DW_AT_type
	.byte	21                      # Abbrev [21] 0x553:0xf DW_TAG_variable
	.long	.Ldebug_loc38           # DW_AT_location
	.long	.Linfo_string56         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	125                     # DW_AT_decl_line
	.long	277                     # DW_AT_type
	.byte	22                      # Abbrev [22] 0x562:0x2a DW_TAG_lexical_block
	.long	.Ldebug_ranges11        # DW_AT_ranges
	.byte	21                      # Abbrev [21] 0x567:0xf DW_TAG_variable
	.long	.Ldebug_loc37           # DW_AT_location
	.long	.Linfo_string45         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	126                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	22                      # Abbrev [22] 0x576:0x15 DW_TAG_lexical_block
	.long	.Ldebug_ranges10        # DW_AT_ranges
	.byte	21                      # Abbrev [21] 0x57b:0xf DW_TAG_variable
	.long	.Ldebug_loc39           # DW_AT_location
	.long	.Linfo_string52         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	127                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	20                      # Abbrev [20] 0x58c:0x47 DW_TAG_lexical_block
	.quad	.Ltmp141                # DW_AT_low_pc
	.long	.Ltmp167-.Ltmp141       # DW_AT_high_pc
	.byte	21                      # Abbrev [21] 0x599:0xf DW_TAG_variable
	.long	.Ldebug_loc40           # DW_AT_location
	.long	.Linfo_string45         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	131                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	22                      # Abbrev [22] 0x5a8:0x2a DW_TAG_lexical_block
	.long	.Ldebug_ranges13        # DW_AT_ranges
	.byte	21                      # Abbrev [21] 0x5ad:0xf DW_TAG_variable
	.long	.Ldebug_loc41           # DW_AT_location
	.long	.Linfo_string52         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	132                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	22                      # Abbrev [22] 0x5bc:0x15 DW_TAG_lexical_block
	.long	.Ldebug_ranges12        # DW_AT_ranges
	.byte	21                      # Abbrev [21] 0x5c1:0xf DW_TAG_variable
	.long	.Ldebug_loc42           # DW_AT_location
	.long	.Linfo_string53         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	133                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	20                      # Abbrev [20] 0x5d3:0x6a DW_TAG_lexical_block
	.quad	.Ltmp169                # DW_AT_low_pc
	.long	.Ltmp185-.Ltmp169       # DW_AT_high_pc
	.byte	21                      # Abbrev [21] 0x5e0:0xf DW_TAG_variable
	.long	.Ldebug_loc43           # DW_AT_location
	.long	.Linfo_string45         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	138                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x5ef:0x4d DW_TAG_lexical_block
	.quad	.Ltmp169                # DW_AT_low_pc
	.long	.Ltmp181-.Ltmp169       # DW_AT_high_pc
	.byte	21                      # Abbrev [21] 0x5fc:0xf DW_TAG_variable
	.long	.Ldebug_loc44           # DW_AT_location
	.long	.Linfo_string52         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	139                     # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	29                      # Abbrev [29] 0x60b:0x30 DW_TAG_inlined_subroutine
	.long	1611                    # DW_AT_abstract_origin
	.quad	.Ltmp170                # DW_AT_low_pc
	.long	.Ltmp175-.Ltmp170       # DW_AT_high_pc
	.byte	5                       # DW_AT_call_file
	.byte	140                     # DW_AT_call_line
	.byte	12                      # DW_AT_call_column
	.byte	30                      # Abbrev [30] 0x61f:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc45           # DW_AT_location
	.long	1623                    # DW_AT_abstract_origin
	.byte	30                      # Abbrev [30] 0x628:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc46           # DW_AT_location
	.long	1634                    # DW_AT_abstract_origin
	.byte	35                      # Abbrev [35] 0x631:0x9 DW_TAG_variable
	.long	.Ldebug_loc47           # DW_AT_location
	.long	1645                    # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	33                      # Abbrev [33] 0x63d:0xd DW_TAG_GNU_call_site
	.long	61                      # DW_AT_abstract_origin
	.quad	.Ltmp193                # DW_AT_low_pc
	.byte	0                       # End Of Children Mark
	.byte	26                      # Abbrev [26] 0x64b:0x3b DW_TAG_subprogram
	.long	.Linfo_string30         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	100                     # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	1670                    # DW_AT_type
	.byte	1                       # DW_AT_inline
	.byte	19                      # Abbrev [19] 0x657:0xb DW_TAG_formal_parameter
	.long	.Linfo_string32         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	100                     # DW_AT_decl_line
	.long	282                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x662:0xb DW_TAG_formal_parameter
	.long	.Linfo_string33         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	100                     # DW_AT_decl_line
	.long	282                     # DW_AT_type
	.byte	27                      # Abbrev [27] 0x66d:0xb DW_TAG_variable
	.long	.Linfo_string34         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	110                     # DW_AT_decl_line
	.long	282                     # DW_AT_type
	.byte	36                      # Abbrev [36] 0x678:0xd DW_TAG_lexical_block
	.byte	27                      # Abbrev [27] 0x679:0xb DW_TAG_variable
	.long	.Linfo_string35         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	105                     # DW_AT_decl_line
	.long	282                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	3                       # Abbrev [3] 0x686:0x7 DW_TAG_base_type
	.long	.Linfo_string31         # DW_AT_name
	.byte	2                       # DW_AT_encoding
	.byte	1                       # DW_AT_byte_size
	.byte	37                      # Abbrev [37] 0x68d:0x5 DW_TAG_restrict_type
	.long	277                     # DW_AT_type
	.byte	37                      # Abbrev [37] 0x692:0x5 DW_TAG_restrict_type
	.long	1687                    # DW_AT_type
	.byte	8                       # Abbrev [8] 0x697:0x5 DW_TAG_pointer_type
	.long	1692                    # DW_AT_type
	.byte	25                      # Abbrev [25] 0x69c:0x5 DW_TAG_const_type
	.long	282                     # DW_AT_type
	.byte	25                      # Abbrev [25] 0x6a1:0x5 DW_TAG_const_type
	.long	54                      # DW_AT_type
	.byte	0                       # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.quad	.Ltmp6-.Lfunc_begin0
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp35-.Lfunc_begin0
	.quad	.Ltmp36-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges1:
	.quad	.Ltmp6-.Lfunc_begin0
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp35-.Lfunc_begin0
	.quad	.Ltmp36-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges2:
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp24-.Lfunc_begin0
	.quad	.Ltmp36-.Lfunc_begin0
	.quad	.Ltmp37-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges3:
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp24-.Lfunc_begin0
	.quad	.Ltmp36-.Lfunc_begin0
	.quad	.Ltmp37-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges4:
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp28-.Lfunc_begin0
	.quad	.Ltmp36-.Lfunc_begin0
	.quad	.Ltmp37-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges5:
	.quad	.Ltmp79-.Lfunc_begin0
	.quad	.Ltmp80-.Lfunc_begin0
	.quad	.Ltmp82-.Lfunc_begin0
	.quad	.Ltmp90-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges6:
	.quad	.Ltmp56-.Lfunc_begin0
	.quad	.Ltmp57-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Ltmp97-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges7:
	.quad	.Ltmp57-.Lfunc_begin0
	.quad	.Ltmp71-.Lfunc_begin0
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges8:
	.quad	.Ltmp98-.Lfunc_begin0
	.quad	.Ltmp100-.Lfunc_begin0
	.quad	.Ltmp101-.Lfunc_begin0
	.quad	.Ltmp102-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges9:
	.quad	.Ltmp100-.Lfunc_begin0
	.quad	.Ltmp101-.Lfunc_begin0
	.quad	.Ltmp102-.Lfunc_begin0
	.quad	.Ltmp104-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges10:
	.quad	.Ltmp121-.Lfunc_begin0
	.quad	.Ltmp122-.Lfunc_begin0
	.quad	.Ltmp126-.Lfunc_begin0
	.quad	.Ltmp135-.Lfunc_begin0
	.quad	.Ltmp138-.Lfunc_begin0
	.quad	.Ltmp140-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges11:
	.quad	.Ltmp115-.Lfunc_begin0
	.quad	.Ltmp123-.Lfunc_begin0
	.quad	.Ltmp125-.Lfunc_begin0
	.quad	.Ltmp141-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges12:
	.quad	.Ltmp141-.Lfunc_begin0
	.quad	.Ltmp142-.Lfunc_begin0
	.quad	.Ltmp144-.Lfunc_begin0
	.quad	.Ltmp159-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges13:
	.quad	.Ltmp141-.Lfunc_begin0
	.quad	.Ltmp142-.Lfunc_begin0
	.quad	.Ltmp144-.Lfunc_begin0
	.quad	.Ltmp163-.Lfunc_begin0
	.quad	0
	.quad	0
	.ident	"clang version 10.0.1 "
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.section	.debug_line,"",@progbits
.Lline_table_start0:
