; ModuleID = 'matmul.c'
source_filename = "matmul.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.timespec = type { i64, i64 }

@.str = private unnamed_addr constant [32 x i8] c"Wrong block size: %d; Want: 32\0A\00", align 1
@Avec = common dso_local local_unnamed_addr global [4 x <8 x float>] zeroinitializer, align 32, !dbg !0
@Cvec = common dso_local local_unnamed_addr global [4 x <8 x float>] zeroinitializer, align 32, !dbg !45
@Bvec = common dso_local local_unnamed_addr global [4 x <8 x float>] zeroinitializer, align 32, !dbg !36
@.str.1 = private unnamed_addr constant [22 x i8] c"Running time: %f sec\0A\00", align 1
@stderr = external dso_local local_unnamed_addr global %struct._IO_FILE*, align 8
@.str.2 = private unnamed_addr constant [23 x i8] c"Checking correctness.\0A\00", align 1
@.str.3 = private unnamed_addr constant [72 x i8] c"Unexpected value found in matrix product:   C[%d,%d] = %f, expected %f\0A\00", align 1
@.str.4 = private unnamed_addr constant [27 x i8] c"FAILED correctness check.\0A\00", align 1
@.str.5 = private unnamed_addr constant [27 x i8] c"PASSED correctness check.\0A\00", align 1

; Function Attrs: nounwind uwtable
define dso_local void @matmul_base(float* noalias %C, float* noalias %A, float* noalias %B, i32 %row_length, i32 %size) local_unnamed_addr #0 !dbg !51 {
entry:
  call void @llvm.dbg.value(metadata float* %C, metadata !59, metadata !DIExpression()), !dbg !90
  call void @llvm.dbg.value(metadata float* %A, metadata !60, metadata !DIExpression()), !dbg !90
  call void @llvm.dbg.value(metadata float* %B, metadata !61, metadata !DIExpression()), !dbg !90
  call void @llvm.dbg.value(metadata i32 undef, metadata !62, metadata !DIExpression()), !dbg !90
  call void @llvm.dbg.value(metadata i32 %size, metadata !63, metadata !DIExpression()), !dbg !90
  %ptrint = ptrtoint float* %A to i64, !dbg !91
  %maskedptr = and i64 %ptrint, 31, !dbg !91
  %maskcond = icmp eq i64 %maskedptr, 0, !dbg !91
  tail call void @llvm.assume(i1 %maskcond), !dbg !91
  call void @llvm.dbg.value(metadata float* %A, metadata !60, metadata !DIExpression()), !dbg !90
  %ptrint1 = ptrtoint float* %B to i64, !dbg !92
  %maskedptr2 = and i64 %ptrint1, 31, !dbg !92
  %maskcond3 = icmp eq i64 %maskedptr2, 0, !dbg !92
  tail call void @llvm.assume(i1 %maskcond3), !dbg !92
  call void @llvm.dbg.value(metadata i64 %ptrint1, metadata !61, metadata !DIExpression()), !dbg !90
  %ptrint4 = ptrtoint float* %C to i64, !dbg !93
  %maskedptr5 = and i64 %ptrint4, 31, !dbg !93
  %maskcond6 = icmp eq i64 %maskedptr5, 0, !dbg !93
  tail call void @llvm.assume(i1 %maskcond6), !dbg !93
  call void @llvm.dbg.value(metadata float* %C, metadata !59, metadata !DIExpression()), !dbg !90
  %cmp = icmp eq i32 %size, 32, !dbg !94
  br i1 %cmp, label %for.cond8.preheader.preheader, label %if.then, !dbg !96

if.then:                                          ; preds = %entry
  %call = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([32 x i8], [32 x i8]* @.str, i64 0, i64 0), i32 %size), !dbg !97
  call void @llvm.dbg.value(metadata i32 %size, metadata !63, metadata !DIExpression(DW_OP_constu, 0, DW_OP_div, DW_OP_stack_value)), !dbg !90
  br label %for.cond8.preheader.preheader, !dbg !99

for.cond8.preheader.preheader:                    ; preds = %entry, %if.then
  br label %for.cond8.preheader, !dbg !100

for.cond8.preheader:                              ; preds = %for.cond8.preheader.preheader, %for.cond97.preheader
  %indvars.iv232 = phi i64 [ %indvars.iv.next233, %for.cond97.preheader ], [ 0, %for.cond8.preheader.preheader ]
  call void @llvm.dbg.value(metadata i64 %indvars.iv232, metadata !64, metadata !DIExpression()), !dbg !101
  call void @llvm.dbg.value(metadata i32 0, metadata !66, metadata !DIExpression()), !dbg !102
  %0 = shl i64 %indvars.iv232, 5, !dbg !103
  call void @llvm.dbg.value(metadata i64 0, metadata !66, metadata !DIExpression()), !dbg !102
  call void @llvm.dbg.value(metadata i32 0, metadata !70, metadata !DIExpression()), !dbg !106
  call void @llvm.dbg.value(metadata i64 0, metadata !70, metadata !DIExpression()), !dbg !106
  %arrayidx = getelementptr inbounds float, float* %A, i64 %0, !dbg !107
  %1 = load float, float* %arrayidx, align 32, !dbg !107, !tbaa !108
  %vecins = insertelement <8 x float> undef, float %1, i32 0, !dbg !112
  %arrayidx25 = getelementptr inbounds float, float* %C, i64 %0, !dbg !113
  %2 = load float, float* %arrayidx25, align 32, !dbg !113, !tbaa !108
  %vecins28 = insertelement <8 x float> undef, float %2, i32 0, !dbg !114
  call void @llvm.dbg.value(metadata i64 1, metadata !70, metadata !DIExpression()), !dbg !106
  %3 = or i64 %0, 1, !dbg !115
  %arrayidx.1 = getelementptr inbounds float, float* %A, i64 %3, !dbg !107
  %4 = load float, float* %arrayidx.1, align 4, !dbg !107, !tbaa !108
  %vecins.1 = insertelement <8 x float> %vecins, float %4, i32 1, !dbg !112
  %arrayidx25.1 = getelementptr inbounds float, float* %C, i64 %3, !dbg !113
  %5 = load float, float* %arrayidx25.1, align 4, !dbg !113, !tbaa !108
  %vecins28.1 = insertelement <8 x float> %vecins28, float %5, i32 1, !dbg !114
  call void @llvm.dbg.value(metadata i64 2, metadata !70, metadata !DIExpression()), !dbg !106
  %6 = or i64 %0, 2, !dbg !115
  %arrayidx.2 = getelementptr inbounds float, float* %A, i64 %6, !dbg !107
  %7 = load float, float* %arrayidx.2, align 8, !dbg !107, !tbaa !108
  %vecins.2 = insertelement <8 x float> %vecins.1, float %7, i32 2, !dbg !112
  %arrayidx25.2 = getelementptr inbounds float, float* %C, i64 %6, !dbg !113
  %8 = load float, float* %arrayidx25.2, align 8, !dbg !113, !tbaa !108
  %vecins28.2 = insertelement <8 x float> %vecins28.1, float %8, i32 2, !dbg !114
  call void @llvm.dbg.value(metadata i64 3, metadata !70, metadata !DIExpression()), !dbg !106
  %9 = or i64 %0, 3, !dbg !115
  %arrayidx.3 = getelementptr inbounds float, float* %A, i64 %9, !dbg !107
  %10 = load float, float* %arrayidx.3, align 4, !dbg !107, !tbaa !108
  %vecins.3 = insertelement <8 x float> %vecins.2, float %10, i32 3, !dbg !112
  %arrayidx25.3 = getelementptr inbounds float, float* %C, i64 %9, !dbg !113
  %11 = load float, float* %arrayidx25.3, align 4, !dbg !113, !tbaa !108
  %vecins28.3 = insertelement <8 x float> %vecins28.2, float %11, i32 3, !dbg !114
  call void @llvm.dbg.value(metadata i64 4, metadata !70, metadata !DIExpression()), !dbg !106
  %12 = or i64 %0, 4, !dbg !115
  %arrayidx.4 = getelementptr inbounds float, float* %A, i64 %12, !dbg !107
  %13 = load float, float* %arrayidx.4, align 16, !dbg !107, !tbaa !108
  %vecins.4 = insertelement <8 x float> %vecins.3, float %13, i32 4, !dbg !112
  %arrayidx25.4 = getelementptr inbounds float, float* %C, i64 %12, !dbg !113
  %14 = load float, float* %arrayidx25.4, align 16, !dbg !113, !tbaa !108
  %vecins28.4 = insertelement <8 x float> %vecins28.3, float %14, i32 4, !dbg !114
  call void @llvm.dbg.value(metadata i64 5, metadata !70, metadata !DIExpression()), !dbg !106
  %15 = or i64 %0, 5, !dbg !115
  %arrayidx.5 = getelementptr inbounds float, float* %A, i64 %15, !dbg !107
  %16 = load float, float* %arrayidx.5, align 4, !dbg !107, !tbaa !108
  %vecins.5 = insertelement <8 x float> %vecins.4, float %16, i32 5, !dbg !112
  %arrayidx25.5 = getelementptr inbounds float, float* %C, i64 %15, !dbg !113
  %17 = load float, float* %arrayidx25.5, align 4, !dbg !113, !tbaa !108
  %vecins28.5 = insertelement <8 x float> %vecins28.4, float %17, i32 5, !dbg !114
  call void @llvm.dbg.value(metadata i64 6, metadata !70, metadata !DIExpression()), !dbg !106
  %18 = or i64 %0, 6, !dbg !115
  %arrayidx.6 = getelementptr inbounds float, float* %A, i64 %18, !dbg !107
  %19 = load float, float* %arrayidx.6, align 8, !dbg !107, !tbaa !108
  %vecins.6 = insertelement <8 x float> %vecins.5, float %19, i32 6, !dbg !112
  %arrayidx25.6 = getelementptr inbounds float, float* %C, i64 %18, !dbg !113
  %20 = load float, float* %arrayidx25.6, align 8, !dbg !113, !tbaa !108
  %vecins28.6 = insertelement <8 x float> %vecins28.5, float %20, i32 6, !dbg !114
  call void @llvm.dbg.value(metadata i64 7, metadata !70, metadata !DIExpression()), !dbg !106
  %21 = or i64 %0, 7, !dbg !115
  %arrayidx.7 = getelementptr inbounds float, float* %A, i64 %21, !dbg !107
  %22 = load float, float* %arrayidx.7, align 4, !dbg !107, !tbaa !108
  %vecins.7 = insertelement <8 x float> %vecins.6, float %22, i32 7, !dbg !112
  %arrayidx25.7 = getelementptr inbounds float, float* %C, i64 %21, !dbg !113
  %23 = load float, float* %arrayidx25.7, align 4, !dbg !113, !tbaa !108
  %vecins28.7 = insertelement <8 x float> %vecins28.6, float %23, i32 7, !dbg !114
  call void @llvm.dbg.value(metadata i64 8, metadata !70, metadata !DIExpression()), !dbg !106
  store <8 x float> %vecins.7, <8 x float>* getelementptr inbounds ([4 x <8 x float>], [4 x <8 x float>]* @Avec, i64 0, i64 0), align 32, !dbg !112
  call void @llvm.dbg.value(metadata i64 1, metadata !66, metadata !DIExpression()), !dbg !102
  call void @llvm.dbg.value(metadata i32 0, metadata !70, metadata !DIExpression()), !dbg !106
  %24 = or i64 %0, 8, !dbg !103
  call void @llvm.dbg.value(metadata i64 0, metadata !70, metadata !DIExpression()), !dbg !106
  %arrayidx.1195 = getelementptr inbounds float, float* %A, i64 %24, !dbg !107
  %25 = load float, float* %arrayidx.1195, align 32, !dbg !107, !tbaa !108
  %vecins.1196 = insertelement <8 x float> undef, float %25, i32 0, !dbg !112
  %arrayidx25.1197 = getelementptr inbounds float, float* %C, i64 %24, !dbg !113
  %26 = load float, float* %arrayidx25.1197, align 32, !dbg !113, !tbaa !108
  %vecins28.1198 = insertelement <8 x float> undef, float %26, i32 0, !dbg !114
  call void @llvm.dbg.value(metadata i64 1, metadata !70, metadata !DIExpression()), !dbg !106
  %27 = or i64 %0, 9, !dbg !115
  %arrayidx.1.1 = getelementptr inbounds float, float* %A, i64 %27, !dbg !107
  %28 = load float, float* %arrayidx.1.1, align 4, !dbg !107, !tbaa !108
  %vecins.1.1 = insertelement <8 x float> %vecins.1196, float %28, i32 1, !dbg !112
  %arrayidx25.1.1 = getelementptr inbounds float, float* %C, i64 %27, !dbg !113
  %29 = load float, float* %arrayidx25.1.1, align 4, !dbg !113, !tbaa !108
  %vecins28.1.1 = insertelement <8 x float> %vecins28.1198, float %29, i32 1, !dbg !114
  call void @llvm.dbg.value(metadata i64 2, metadata !70, metadata !DIExpression()), !dbg !106
  %30 = or i64 %0, 10, !dbg !115
  %arrayidx.2.1 = getelementptr inbounds float, float* %A, i64 %30, !dbg !107
  %31 = load float, float* %arrayidx.2.1, align 8, !dbg !107, !tbaa !108
  %vecins.2.1 = insertelement <8 x float> %vecins.1.1, float %31, i32 2, !dbg !112
  %arrayidx25.2.1 = getelementptr inbounds float, float* %C, i64 %30, !dbg !113
  %32 = load float, float* %arrayidx25.2.1, align 8, !dbg !113, !tbaa !108
  %vecins28.2.1 = insertelement <8 x float> %vecins28.1.1, float %32, i32 2, !dbg !114
  call void @llvm.dbg.value(metadata i64 3, metadata !70, metadata !DIExpression()), !dbg !106
  %33 = or i64 %0, 11, !dbg !115
  %arrayidx.3.1 = getelementptr inbounds float, float* %A, i64 %33, !dbg !107
  %34 = load float, float* %arrayidx.3.1, align 4, !dbg !107, !tbaa !108
  %vecins.3.1 = insertelement <8 x float> %vecins.2.1, float %34, i32 3, !dbg !112
  %arrayidx25.3.1 = getelementptr inbounds float, float* %C, i64 %33, !dbg !113
  %35 = load float, float* %arrayidx25.3.1, align 4, !dbg !113, !tbaa !108
  %vecins28.3.1 = insertelement <8 x float> %vecins28.2.1, float %35, i32 3, !dbg !114
  call void @llvm.dbg.value(metadata i64 4, metadata !70, metadata !DIExpression()), !dbg !106
  %36 = or i64 %0, 12, !dbg !115
  %arrayidx.4.1 = getelementptr inbounds float, float* %A, i64 %36, !dbg !107
  %37 = load float, float* %arrayidx.4.1, align 16, !dbg !107, !tbaa !108
  %vecins.4.1 = insertelement <8 x float> %vecins.3.1, float %37, i32 4, !dbg !112
  %arrayidx25.4.1 = getelementptr inbounds float, float* %C, i64 %36, !dbg !113
  %38 = load float, float* %arrayidx25.4.1, align 16, !dbg !113, !tbaa !108
  %vecins28.4.1 = insertelement <8 x float> %vecins28.3.1, float %38, i32 4, !dbg !114
  call void @llvm.dbg.value(metadata i64 5, metadata !70, metadata !DIExpression()), !dbg !106
  %39 = or i64 %0, 13, !dbg !115
  %arrayidx.5.1 = getelementptr inbounds float, float* %A, i64 %39, !dbg !107
  %40 = load float, float* %arrayidx.5.1, align 4, !dbg !107, !tbaa !108
  %vecins.5.1 = insertelement <8 x float> %vecins.4.1, float %40, i32 5, !dbg !112
  %arrayidx25.5.1 = getelementptr inbounds float, float* %C, i64 %39, !dbg !113
  %41 = load float, float* %arrayidx25.5.1, align 4, !dbg !113, !tbaa !108
  %vecins28.5.1 = insertelement <8 x float> %vecins28.4.1, float %41, i32 5, !dbg !114
  call void @llvm.dbg.value(metadata i64 6, metadata !70, metadata !DIExpression()), !dbg !106
  %42 = or i64 %0, 14, !dbg !115
  %arrayidx.6.1 = getelementptr inbounds float, float* %A, i64 %42, !dbg !107
  %43 = load float, float* %arrayidx.6.1, align 8, !dbg !107, !tbaa !108
  %vecins.6.1 = insertelement <8 x float> %vecins.5.1, float %43, i32 6, !dbg !112
  %arrayidx25.6.1 = getelementptr inbounds float, float* %C, i64 %42, !dbg !113
  %44 = load float, float* %arrayidx25.6.1, align 8, !dbg !113, !tbaa !108
  %vecins28.6.1 = insertelement <8 x float> %vecins28.5.1, float %44, i32 6, !dbg !114
  call void @llvm.dbg.value(metadata i64 7, metadata !70, metadata !DIExpression()), !dbg !106
  %45 = or i64 %0, 15, !dbg !115
  %arrayidx.7.1 = getelementptr inbounds float, float* %A, i64 %45, !dbg !107
  %46 = load float, float* %arrayidx.7.1, align 4, !dbg !107, !tbaa !108
  %vecins.7.1 = insertelement <8 x float> %vecins.6.1, float %46, i32 7, !dbg !112
  %arrayidx25.7.1 = getelementptr inbounds float, float* %C, i64 %45, !dbg !113
  %47 = load float, float* %arrayidx25.7.1, align 4, !dbg !113, !tbaa !108
  %vecins28.7.1 = insertelement <8 x float> %vecins28.6.1, float %47, i32 7, !dbg !114
  call void @llvm.dbg.value(metadata i64 8, metadata !70, metadata !DIExpression()), !dbg !106
  store <8 x float> %vecins.7.1, <8 x float>* getelementptr inbounds ([4 x <8 x float>], [4 x <8 x float>]* @Avec, i64 0, i64 1), align 32, !dbg !112
  call void @llvm.dbg.value(metadata i64 2, metadata !66, metadata !DIExpression()), !dbg !102
  call void @llvm.dbg.value(metadata i32 0, metadata !70, metadata !DIExpression()), !dbg !106
  %48 = or i64 %0, 16, !dbg !103
  call void @llvm.dbg.value(metadata i64 0, metadata !70, metadata !DIExpression()), !dbg !106
  %arrayidx.2199 = getelementptr inbounds float, float* %A, i64 %48, !dbg !107
  %49 = load float, float* %arrayidx.2199, align 32, !dbg !107, !tbaa !108
  %vecins.2200 = insertelement <8 x float> undef, float %49, i32 0, !dbg !112
  %arrayidx25.2201 = getelementptr inbounds float, float* %C, i64 %48, !dbg !113
  %50 = load float, float* %arrayidx25.2201, align 32, !dbg !113, !tbaa !108
  %vecins28.2202 = insertelement <8 x float> undef, float %50, i32 0, !dbg !114
  call void @llvm.dbg.value(metadata i64 1, metadata !70, metadata !DIExpression()), !dbg !106
  %51 = or i64 %0, 17, !dbg !115
  %arrayidx.1.2 = getelementptr inbounds float, float* %A, i64 %51, !dbg !107
  %52 = load float, float* %arrayidx.1.2, align 4, !dbg !107, !tbaa !108
  %vecins.1.2 = insertelement <8 x float> %vecins.2200, float %52, i32 1, !dbg !112
  %arrayidx25.1.2 = getelementptr inbounds float, float* %C, i64 %51, !dbg !113
  %53 = load float, float* %arrayidx25.1.2, align 4, !dbg !113, !tbaa !108
  %vecins28.1.2 = insertelement <8 x float> %vecins28.2202, float %53, i32 1, !dbg !114
  call void @llvm.dbg.value(metadata i64 2, metadata !70, metadata !DIExpression()), !dbg !106
  %54 = or i64 %0, 18, !dbg !115
  %arrayidx.2.2 = getelementptr inbounds float, float* %A, i64 %54, !dbg !107
  %55 = load float, float* %arrayidx.2.2, align 8, !dbg !107, !tbaa !108
  %vecins.2.2 = insertelement <8 x float> %vecins.1.2, float %55, i32 2, !dbg !112
  %arrayidx25.2.2 = getelementptr inbounds float, float* %C, i64 %54, !dbg !113
  %56 = load float, float* %arrayidx25.2.2, align 8, !dbg !113, !tbaa !108
  %vecins28.2.2 = insertelement <8 x float> %vecins28.1.2, float %56, i32 2, !dbg !114
  call void @llvm.dbg.value(metadata i64 3, metadata !70, metadata !DIExpression()), !dbg !106
  %57 = or i64 %0, 19, !dbg !115
  %arrayidx.3.2 = getelementptr inbounds float, float* %A, i64 %57, !dbg !107
  %58 = load float, float* %arrayidx.3.2, align 4, !dbg !107, !tbaa !108
  %vecins.3.2 = insertelement <8 x float> %vecins.2.2, float %58, i32 3, !dbg !112
  %arrayidx25.3.2 = getelementptr inbounds float, float* %C, i64 %57, !dbg !113
  %59 = load float, float* %arrayidx25.3.2, align 4, !dbg !113, !tbaa !108
  %vecins28.3.2 = insertelement <8 x float> %vecins28.2.2, float %59, i32 3, !dbg !114
  call void @llvm.dbg.value(metadata i64 4, metadata !70, metadata !DIExpression()), !dbg !106
  %60 = or i64 %0, 20, !dbg !115
  %arrayidx.4.2 = getelementptr inbounds float, float* %A, i64 %60, !dbg !107
  %61 = load float, float* %arrayidx.4.2, align 16, !dbg !107, !tbaa !108
  %vecins.4.2 = insertelement <8 x float> %vecins.3.2, float %61, i32 4, !dbg !112
  %arrayidx25.4.2 = getelementptr inbounds float, float* %C, i64 %60, !dbg !113
  %62 = load float, float* %arrayidx25.4.2, align 16, !dbg !113, !tbaa !108
  %vecins28.4.2 = insertelement <8 x float> %vecins28.3.2, float %62, i32 4, !dbg !114
  call void @llvm.dbg.value(metadata i64 5, metadata !70, metadata !DIExpression()), !dbg !106
  %63 = or i64 %0, 21, !dbg !115
  %arrayidx.5.2 = getelementptr inbounds float, float* %A, i64 %63, !dbg !107
  %64 = load float, float* %arrayidx.5.2, align 4, !dbg !107, !tbaa !108
  %vecins.5.2 = insertelement <8 x float> %vecins.4.2, float %64, i32 5, !dbg !112
  %arrayidx25.5.2 = getelementptr inbounds float, float* %C, i64 %63, !dbg !113
  %65 = load float, float* %arrayidx25.5.2, align 4, !dbg !113, !tbaa !108
  %vecins28.5.2 = insertelement <8 x float> %vecins28.4.2, float %65, i32 5, !dbg !114
  call void @llvm.dbg.value(metadata i64 6, metadata !70, metadata !DIExpression()), !dbg !106
  %66 = or i64 %0, 22, !dbg !115
  %arrayidx.6.2 = getelementptr inbounds float, float* %A, i64 %66, !dbg !107
  %67 = load float, float* %arrayidx.6.2, align 8, !dbg !107, !tbaa !108
  %vecins.6.2 = insertelement <8 x float> %vecins.5.2, float %67, i32 6, !dbg !112
  %arrayidx25.6.2 = getelementptr inbounds float, float* %C, i64 %66, !dbg !113
  %68 = load float, float* %arrayidx25.6.2, align 8, !dbg !113, !tbaa !108
  %vecins28.6.2 = insertelement <8 x float> %vecins28.5.2, float %68, i32 6, !dbg !114
  call void @llvm.dbg.value(metadata i64 7, metadata !70, metadata !DIExpression()), !dbg !106
  %69 = or i64 %0, 23, !dbg !115
  %arrayidx.7.2 = getelementptr inbounds float, float* %A, i64 %69, !dbg !107
  %70 = load float, float* %arrayidx.7.2, align 4, !dbg !107, !tbaa !108
  %vecins.7.2 = insertelement <8 x float> %vecins.6.2, float %70, i32 7, !dbg !112
  %arrayidx25.7.2 = getelementptr inbounds float, float* %C, i64 %69, !dbg !113
  %71 = load float, float* %arrayidx25.7.2, align 4, !dbg !113, !tbaa !108
  %vecins28.7.2 = insertelement <8 x float> %vecins28.6.2, float %71, i32 7, !dbg !114
  call void @llvm.dbg.value(metadata i64 8, metadata !70, metadata !DIExpression()), !dbg !106
  store <8 x float> %vecins.7.2, <8 x float>* getelementptr inbounds ([4 x <8 x float>], [4 x <8 x float>]* @Avec, i64 0, i64 2), align 32, !dbg !112
  call void @llvm.dbg.value(metadata i64 3, metadata !66, metadata !DIExpression()), !dbg !102
  call void @llvm.dbg.value(metadata i32 0, metadata !70, metadata !DIExpression()), !dbg !106
  %72 = or i64 %0, 24, !dbg !103
  call void @llvm.dbg.value(metadata i64 0, metadata !70, metadata !DIExpression()), !dbg !106
  %arrayidx.3203 = getelementptr inbounds float, float* %A, i64 %72, !dbg !107
  %73 = load float, float* %arrayidx.3203, align 32, !dbg !107, !tbaa !108
  %vecins.3204 = insertelement <8 x float> undef, float %73, i32 0, !dbg !112
  %arrayidx25.3205 = getelementptr inbounds float, float* %C, i64 %72, !dbg !113
  %74 = load float, float* %arrayidx25.3205, align 32, !dbg !113, !tbaa !108
  %vecins28.3206 = insertelement <8 x float> undef, float %74, i32 0, !dbg !114
  call void @llvm.dbg.value(metadata i64 1, metadata !70, metadata !DIExpression()), !dbg !106
  %75 = or i64 %0, 25, !dbg !115
  %arrayidx.1.3 = getelementptr inbounds float, float* %A, i64 %75, !dbg !107
  %76 = load float, float* %arrayidx.1.3, align 4, !dbg !107, !tbaa !108
  %vecins.1.3 = insertelement <8 x float> %vecins.3204, float %76, i32 1, !dbg !112
  %arrayidx25.1.3 = getelementptr inbounds float, float* %C, i64 %75, !dbg !113
  %77 = load float, float* %arrayidx25.1.3, align 4, !dbg !113, !tbaa !108
  %vecins28.1.3 = insertelement <8 x float> %vecins28.3206, float %77, i32 1, !dbg !114
  call void @llvm.dbg.value(metadata i64 2, metadata !70, metadata !DIExpression()), !dbg !106
  %78 = or i64 %0, 26, !dbg !115
  %arrayidx.2.3 = getelementptr inbounds float, float* %A, i64 %78, !dbg !107
  %79 = load float, float* %arrayidx.2.3, align 8, !dbg !107, !tbaa !108
  %vecins.2.3 = insertelement <8 x float> %vecins.1.3, float %79, i32 2, !dbg !112
  %arrayidx25.2.3 = getelementptr inbounds float, float* %C, i64 %78, !dbg !113
  %80 = load float, float* %arrayidx25.2.3, align 8, !dbg !113, !tbaa !108
  %vecins28.2.3 = insertelement <8 x float> %vecins28.1.3, float %80, i32 2, !dbg !114
  call void @llvm.dbg.value(metadata i64 3, metadata !70, metadata !DIExpression()), !dbg !106
  %81 = or i64 %0, 27, !dbg !115
  %arrayidx.3.3 = getelementptr inbounds float, float* %A, i64 %81, !dbg !107
  %82 = load float, float* %arrayidx.3.3, align 4, !dbg !107, !tbaa !108
  %vecins.3.3 = insertelement <8 x float> %vecins.2.3, float %82, i32 3, !dbg !112
  %arrayidx25.3.3 = getelementptr inbounds float, float* %C, i64 %81, !dbg !113
  %83 = load float, float* %arrayidx25.3.3, align 4, !dbg !113, !tbaa !108
  %vecins28.3.3 = insertelement <8 x float> %vecins28.2.3, float %83, i32 3, !dbg !114
  call void @llvm.dbg.value(metadata i64 4, metadata !70, metadata !DIExpression()), !dbg !106
  %84 = or i64 %0, 28, !dbg !115
  %arrayidx.4.3 = getelementptr inbounds float, float* %A, i64 %84, !dbg !107
  %85 = load float, float* %arrayidx.4.3, align 16, !dbg !107, !tbaa !108
  %vecins.4.3 = insertelement <8 x float> %vecins.3.3, float %85, i32 4, !dbg !112
  %arrayidx25.4.3 = getelementptr inbounds float, float* %C, i64 %84, !dbg !113
  %86 = load float, float* %arrayidx25.4.3, align 16, !dbg !113, !tbaa !108
  %vecins28.4.3 = insertelement <8 x float> %vecins28.3.3, float %86, i32 4, !dbg !114
  call void @llvm.dbg.value(metadata i64 5, metadata !70, metadata !DIExpression()), !dbg !106
  %87 = or i64 %0, 29, !dbg !115
  %arrayidx.5.3 = getelementptr inbounds float, float* %A, i64 %87, !dbg !107
  %88 = load float, float* %arrayidx.5.3, align 4, !dbg !107, !tbaa !108
  %vecins.5.3 = insertelement <8 x float> %vecins.4.3, float %88, i32 5, !dbg !112
  %arrayidx25.5.3 = getelementptr inbounds float, float* %C, i64 %87, !dbg !113
  %89 = load float, float* %arrayidx25.5.3, align 4, !dbg !113, !tbaa !108
  %vecins28.5.3 = insertelement <8 x float> %vecins28.4.3, float %89, i32 5, !dbg !114
  call void @llvm.dbg.value(metadata i64 6, metadata !70, metadata !DIExpression()), !dbg !106
  %90 = or i64 %0, 30, !dbg !115
  %arrayidx.6.3 = getelementptr inbounds float, float* %A, i64 %90, !dbg !107
  %91 = load float, float* %arrayidx.6.3, align 8, !dbg !107, !tbaa !108
  %vecins.6.3 = insertelement <8 x float> %vecins.5.3, float %91, i32 6, !dbg !112
  %arrayidx25.6.3 = getelementptr inbounds float, float* %C, i64 %90, !dbg !113
  %92 = load float, float* %arrayidx25.6.3, align 8, !dbg !113, !tbaa !108
  %vecins28.6.3 = insertelement <8 x float> %vecins28.5.3, float %92, i32 6, !dbg !114
  call void @llvm.dbg.value(metadata i64 7, metadata !70, metadata !DIExpression()), !dbg !106
  %93 = or i64 %0, 31, !dbg !115
  %arrayidx.7.3 = getelementptr inbounds float, float* %A, i64 %93, !dbg !107
  %94 = load float, float* %arrayidx.7.3, align 4, !dbg !107, !tbaa !108
  %vecins.7.3 = insertelement <8 x float> %vecins.6.3, float %94, i32 7, !dbg !112
  %arrayidx25.7.3 = getelementptr inbounds float, float* %C, i64 %93, !dbg !113
  %95 = load float, float* %arrayidx25.7.3, align 4, !dbg !113, !tbaa !108
  %vecins28.7.3 = insertelement <8 x float> %vecins28.6.3, float %95, i32 7, !dbg !114
  call void @llvm.dbg.value(metadata i64 8, metadata !70, metadata !DIExpression()), !dbg !106
  store <8 x float> %vecins.7.3, <8 x float>* getelementptr inbounds ([4 x <8 x float>], [4 x <8 x float>]* @Avec, i64 0, i64 3), align 32, !dbg !112
  call void @llvm.dbg.value(metadata i64 4, metadata !66, metadata !DIExpression()), !dbg !102
  call void @llvm.dbg.value(metadata i32 0, metadata !74, metadata !DIExpression()), !dbg !116
  br label %for.cond37.preheader, !dbg !117

for.cond.cleanup:                                 ; preds = %for.cond97.preheader
  store <8 x float> %add65, <8 x float>* getelementptr inbounds ([4 x <8 x float>], [4 x <8 x float>]* @Cvec, i64 0, i64 0), align 32, !dbg !114
  store <8 x float> %add74, <8 x float>* getelementptr inbounds ([4 x <8 x float>], [4 x <8 x float>]* @Cvec, i64 0, i64 1), align 32, !dbg !114
  store <8 x float> %add83, <8 x float>* getelementptr inbounds ([4 x <8 x float>], [4 x <8 x float>]* @Cvec, i64 0, i64 2), align 32, !dbg !114
  store <8 x float> %add92, <8 x float>* getelementptr inbounds ([4 x <8 x float>], [4 x <8 x float>]* @Cvec, i64 0, i64 3), align 32, !dbg !114
  store <8 x float> %102, <8 x float>* getelementptr inbounds ([4 x <8 x float>], [4 x <8 x float>]* @Bvec, i64 0, i64 0), align 32, !dbg !118
  store <8 x float> %105, <8 x float>* getelementptr inbounds ([4 x <8 x float>], [4 x <8 x float>]* @Bvec, i64 0, i64 1), align 32, !dbg !118
  store <8 x float> %108, <8 x float>* getelementptr inbounds ([4 x <8 x float>], [4 x <8 x float>]* @Bvec, i64 0, i64 2), align 32, !dbg !118
  store <8 x float> %111, <8 x float>* getelementptr inbounds ([4 x <8 x float>], [4 x <8 x float>]* @Bvec, i64 0, i64 3), align 32, !dbg !118
  ret void, !dbg !121

for.cond97.preheader:                             ; preds = %for.cond37.preheader
  call void @llvm.dbg.value(metadata i32 0, metadata !84, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i64 0, metadata !84, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i32 0, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 0, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 1, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 2, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 3, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 4, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 5, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 6, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 7, metadata !86, metadata !DIExpression()), !dbg !123
  %96 = bitcast float* %arrayidx25 to <8 x float>*, !dbg !124
  store <8 x float> %add65, <8 x float>* %96, align 32, !dbg !124, !tbaa !108
  call void @llvm.dbg.value(metadata i64 1, metadata !84, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i32 0, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 0, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 1, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 2, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 3, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 4, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 5, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 6, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 7, metadata !86, metadata !DIExpression()), !dbg !123
  %97 = bitcast float* %arrayidx25.1197 to <8 x float>*, !dbg !124
  store <8 x float> %add74, <8 x float>* %97, align 32, !dbg !124, !tbaa !108
  call void @llvm.dbg.value(metadata i64 2, metadata !84, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i32 0, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 0, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 1, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 2, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 3, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 4, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 5, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 6, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 7, metadata !86, metadata !DIExpression()), !dbg !123
  %98 = bitcast float* %arrayidx25.2201 to <8 x float>*, !dbg !124
  store <8 x float> %add83, <8 x float>* %98, align 32, !dbg !124, !tbaa !108
  call void @llvm.dbg.value(metadata i64 3, metadata !84, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i32 0, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 0, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 1, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 2, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 3, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 4, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 5, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 6, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 7, metadata !86, metadata !DIExpression()), !dbg !123
  %99 = bitcast float* %arrayidx25.3205 to <8 x float>*, !dbg !124
  store <8 x float> %add92, <8 x float>* %99, align 32, !dbg !124, !tbaa !108
  call void @llvm.dbg.value(metadata i64 8, metadata !86, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.value(metadata i64 4, metadata !84, metadata !DIExpression()), !dbg !122
  %indvars.iv.next233 = add nuw nsw i64 %indvars.iv232, 1, !dbg !127
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next233, metadata !64, metadata !DIExpression()), !dbg !101
  %exitcond236 = icmp eq i64 %indvars.iv.next233, 32, !dbg !128
  br i1 %exitcond236, label %for.cond.cleanup, label %for.cond8.preheader, !dbg !100, !llvm.loop !129

for.cond37.preheader:                             ; preds = %for.cond37.preheader, %for.cond8.preheader
  %indvars.iv = phi i64 [ 0, %for.cond8.preheader ], [ %indvars.iv.next, %for.cond37.preheader ]
  %add92191 = phi <8 x float> [ %vecins28.7.3, %for.cond8.preheader ], [ %add92, %for.cond37.preheader ]
  %add83189 = phi <8 x float> [ %vecins28.7.2, %for.cond8.preheader ], [ %add83, %for.cond37.preheader ]
  %add74187 = phi <8 x float> [ %vecins28.7.1, %for.cond8.preheader ], [ %add74, %for.cond37.preheader ]
  %add65185 = phi <8 x float> [ %vecins28.7, %for.cond8.preheader ], [ %add65, %for.cond37.preheader ]
  call void @llvm.dbg.value(metadata i64 %indvars.iv, metadata !74, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata i32 0, metadata !76, metadata !DIExpression()), !dbg !131
  %100 = shl i64 %indvars.iv, 5, !dbg !132
  call void @llvm.dbg.value(metadata i64 0, metadata !76, metadata !DIExpression()), !dbg !131
  call void @llvm.dbg.value(metadata i32 0, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 0, metadata !80, metadata !DIExpression()), !dbg !133
  %arrayidx51 = getelementptr inbounds float, float* %A, i64 %100, !dbg !134
  %101 = bitcast float* %arrayidx51 to <8 x float>*, !dbg !134
  %102 = load <8 x float>, <8 x float>* %101, align 32, !dbg !134, !tbaa !108
  call void @llvm.dbg.value(metadata i64 1, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 2, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 3, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 4, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 5, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 6, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 7, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 8, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 1, metadata !76, metadata !DIExpression()), !dbg !131
  call void @llvm.dbg.value(metadata i32 0, metadata !80, metadata !DIExpression()), !dbg !133
  %103 = or i64 %100, 8, !dbg !132
  call void @llvm.dbg.value(metadata i64 0, metadata !80, metadata !DIExpression()), !dbg !133
  %arrayidx51.1210 = getelementptr inbounds float, float* %A, i64 %103, !dbg !134
  %104 = bitcast float* %arrayidx51.1210 to <8 x float>*, !dbg !134
  %105 = load <8 x float>, <8 x float>* %104, align 32, !dbg !134, !tbaa !108
  call void @llvm.dbg.value(metadata i64 1, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 2, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 3, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 4, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 5, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 6, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 7, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 8, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 2, metadata !76, metadata !DIExpression()), !dbg !131
  call void @llvm.dbg.value(metadata i32 0, metadata !80, metadata !DIExpression()), !dbg !133
  %106 = or i64 %100, 16, !dbg !132
  call void @llvm.dbg.value(metadata i64 0, metadata !80, metadata !DIExpression()), !dbg !133
  %arrayidx51.2212 = getelementptr inbounds float, float* %A, i64 %106, !dbg !134
  %107 = bitcast float* %arrayidx51.2212 to <8 x float>*, !dbg !134
  %108 = load <8 x float>, <8 x float>* %107, align 32, !dbg !134, !tbaa !108
  call void @llvm.dbg.value(metadata i64 1, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 2, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 3, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 4, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 5, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 6, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 7, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 8, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 3, metadata !76, metadata !DIExpression()), !dbg !131
  call void @llvm.dbg.value(metadata i32 0, metadata !80, metadata !DIExpression()), !dbg !133
  %109 = or i64 %100, 24, !dbg !132
  call void @llvm.dbg.value(metadata i64 0, metadata !80, metadata !DIExpression()), !dbg !133
  %arrayidx51.3214 = getelementptr inbounds float, float* %A, i64 %109, !dbg !134
  %110 = bitcast float* %arrayidx51.3214 to <8 x float>*, !dbg !134
  %111 = load <8 x float>, <8 x float>* %110, align 32, !dbg !134, !tbaa !108
  call void @llvm.dbg.value(metadata i64 1, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 2, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 3, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 4, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 5, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 6, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 7, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 8, metadata !80, metadata !DIExpression()), !dbg !133
  call void @llvm.dbg.value(metadata i64 4, metadata !76, metadata !DIExpression()), !dbg !131
  %112 = trunc i64 %indvars.iv to i32, !dbg !135
  %div61 = lshr i64 %indvars.iv, 3, !dbg !135
  %idxprom62 = and i64 %div61, 536870911, !dbg !136
  %arrayidx63 = getelementptr inbounds [4 x <8 x float>], [4 x <8 x float>]* @Avec, i64 0, i64 %idxprom62, !dbg !136
  %113 = load <8 x float>, <8 x float>* %arrayidx63, align 32, !dbg !136, !tbaa !137
  %rem = and i32 %112, 7, !dbg !138
  %vecext = extractelement <8 x float> %113, i32 %rem, !dbg !136
  %splat.splatinsert = insertelement <8 x float> undef, float %vecext, i32 0, !dbg !136
  %splat.splat = shufflevector <8 x float> %splat.splatinsert, <8 x float> undef, <8 x i32> zeroinitializer, !dbg !136
  %mul64 = fmul <8 x float> %102, %splat.splat, !dbg !139
  %add65 = fadd <8 x float> %add65185, %mul64, !dbg !140
  %mul73 = fmul <8 x float> %splat.splat, %105, !dbg !141
  %add74 = fadd <8 x float> %add74187, %mul73, !dbg !142
  %mul82 = fmul <8 x float> %splat.splat, %108, !dbg !143
  %add83 = fadd <8 x float> %add83189, %mul82, !dbg !144
  %mul91 = fmul <8 x float> %splat.splat, %111, !dbg !145
  %add92 = fadd <8 x float> %add92191, %mul91, !dbg !146
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !147
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next, metadata !74, metadata !DIExpression()), !dbg !116
  %exitcond = icmp eq i64 %indvars.iv.next, 32, !dbg !148
  br i1 %exitcond, label %for.cond97.preheader, label %for.cond37.preheader, !dbg !117, !llvm.loop !149
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind willreturn
declare void @llvm.assume(i1) #2

; Function Attrs: nofree nounwind
declare dso_local i32 @printf(i8* nocapture readonly, ...) local_unnamed_addr #3

; Function Attrs: nounwind uwtable
define dso_local i32 @main(i32 %argc, i8** nocapture readonly %argv) local_unnamed_addr #0 !dbg !151 {
entry:
  %retval.i146 = alloca %struct.timespec, align 8
  call void @llvm.dbg.declare(metadata %struct.timespec* %retval.i146, metadata !188, metadata !DIExpression()), !dbg !193
  %retval.i = alloca %struct.timespec, align 8
  call void @llvm.dbg.declare(metadata %struct.timespec* %retval.i, metadata !188, metadata !DIExpression()), !dbg !195
  call void @llvm.dbg.value(metadata i32 %argc, metadata !155, metadata !DIExpression()), !dbg !197
  call void @llvm.dbg.value(metadata i8** %argv, metadata !156, metadata !DIExpression()), !dbg !197
  call void @llvm.dbg.value(metadata i32 10, metadata !157, metadata !DIExpression()), !dbg !197
  %cmp = icmp sgt i32 %argc, 1, !dbg !198
  br i1 %cmp, label %if.then, label %if.end, !dbg !200

if.then:                                          ; preds = %entry
  %arrayidx = getelementptr inbounds i8*, i8** %argv, i64 1, !dbg !201
  %0 = load i8*, i8** %arrayidx, align 8, !dbg !201, !tbaa !202
  call void @llvm.dbg.value(metadata i8* %0, metadata !204, metadata !DIExpression()) #8, !dbg !211
  %call.i = tail call i64 @strtol(i8* nocapture nonnull %0, i8** null, i32 10) #8, !dbg !213
  %conv.i = trunc i64 %call.i to i32, !dbg !214
  call void @llvm.dbg.value(metadata i32 %conv.i, metadata !157, metadata !DIExpression()), !dbg !197
  br label %if.end, !dbg !215

if.end:                                           ; preds = %if.then, %entry
  %lg_n.0 = phi i32 [ %conv.i, %if.then ], [ 10, %entry ], !dbg !197
  call void @llvm.dbg.value(metadata i32 %lg_n.0, metadata !157, metadata !DIExpression()), !dbg !197
  %shl = shl nuw i32 1, %lg_n.0, !dbg !216
  call void @llvm.dbg.value(metadata i32 %shl, metadata !158, metadata !DIExpression()), !dbg !197
  %1 = icmp slt i32 %shl, 32, !dbg !217
  %cond = select i1 %1, i32 %shl, i32 32, !dbg !217
  call void @llvm.dbg.value(metadata i32 %cond, metadata !160, metadata !DIExpression()), !dbg !197
  %mul = shl i32 %shl, %lg_n.0, !dbg !218
  %conv = sext i32 %mul to i64, !dbg !219
  %mul2 = shl nsw i64 %conv, 2, !dbg !220
  %call3 = tail call noalias i8* @malloc(i64 %mul2) #8, !dbg !221
  %2 = bitcast i8* %call3 to float*, !dbg !222
  call void @llvm.dbg.value(metadata float* %2, metadata !161, metadata !DIExpression()), !dbg !197
  %call7 = tail call noalias i8* @malloc(i64 %mul2) #8, !dbg !223
  %3 = bitcast i8* %call7 to float*, !dbg !224
  call void @llvm.dbg.value(metadata float* %3, metadata !162, metadata !DIExpression()), !dbg !197
  %call11 = tail call noalias i8* @malloc(i64 %mul2) #8, !dbg !225
  %4 = bitcast i8* %call11 to float*, !dbg !226
  call void @llvm.dbg.value(metadata float* %4, metadata !163, metadata !DIExpression()), !dbg !197
  call void @llvm.dbg.value(metadata i32 0, metadata !164, metadata !DIExpression()), !dbg !227
  %cmp12163 = icmp eq i32 %lg_n.0, 31, !dbg !228
  br i1 %cmp12163, label %for.cond.cleanup, label %for.cond14.preheader.us.preheader, !dbg !229

for.cond14.preheader.us.preheader:                ; preds = %if.end
  %5 = sext i32 %shl to i64, !dbg !229
  br label %for.cond14.preheader.us, !dbg !229

for.cond14.preheader.us:                          ; preds = %for.cond14.preheader.us.preheader, %for.cond14.for.cond.cleanup17_crit_edge.us
  %i.0164.us = phi i32 [ %inc35.us, %for.cond14.for.cond.cleanup17_crit_edge.us ], [ 0, %for.cond14.preheader.us.preheader ]
  call void @llvm.dbg.value(metadata i32 %i.0164.us, metadata !164, metadata !DIExpression()), !dbg !227
  call void @llvm.dbg.value(metadata i32 0, metadata !166, metadata !DIExpression()), !dbg !230
  %mul21.us = shl i32 %i.0164.us, %lg_n.0, !dbg !231
  %6 = sext i32 %mul21.us to i64, !dbg !234
  br label %for.body18.us, !dbg !234

for.body18.us:                                    ; preds = %for.cond14.preheader.us, %for.body18.us
  %indvars.iv196 = phi i64 [ 0, %for.cond14.preheader.us ], [ %indvars.iv.next197, %for.body18.us ]
  call void @llvm.dbg.value(metadata i64 %indvars.iv196, metadata !166, metadata !DIExpression()), !dbg !230
  %call19.us = tail call i32 @rand() #8, !dbg !235
  %conv20.us = sitofp i32 %call19.us to float, !dbg !236
  %div.us = fmul float %conv20.us, 0x3E00000000000000, !dbg !237
  %7 = add nsw i64 %indvars.iv196, %6, !dbg !238
  %arrayidx22.us = getelementptr inbounds float, float* %2, i64 %7, !dbg !239
  store float %div.us, float* %arrayidx22.us, align 4, !dbg !240, !tbaa !108
  %call23.us = tail call i32 @rand() #8, !dbg !241
  %conv24.us = sitofp i32 %call23.us to float, !dbg !242
  %div25.us = fmul float %conv24.us, 0x3E00000000000000, !dbg !243
  %arrayidx29.us = getelementptr inbounds float, float* %3, i64 %7, !dbg !244
  store float %div25.us, float* %arrayidx29.us, align 4, !dbg !245, !tbaa !108
  %arrayidx33.us = getelementptr inbounds float, float* %4, i64 %7, !dbg !246
  store float 0.000000e+00, float* %arrayidx33.us, align 4, !dbg !247, !tbaa !108
  %indvars.iv.next197 = add nuw nsw i64 %indvars.iv196, 1, !dbg !248
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next197, metadata !166, metadata !DIExpression()), !dbg !230
  %cmp15.us = icmp slt i64 %indvars.iv.next197, %5, !dbg !249
  br i1 %cmp15.us, label %for.body18.us, label %for.cond14.for.cond.cleanup17_crit_edge.us, !dbg !234, !llvm.loop !250

for.cond14.for.cond.cleanup17_crit_edge.us:       ; preds = %for.body18.us
  %inc35.us = add nuw nsw i32 %i.0164.us, 1, !dbg !252
  call void @llvm.dbg.value(metadata i32 %inc35.us, metadata !164, metadata !DIExpression()), !dbg !227
  %cmp12.us = icmp slt i32 %inc35.us, %shl, !dbg !228
  br i1 %cmp12.us, label %for.cond14.preheader.us, label %for.cond.cleanup, !dbg !229, !llvm.loop !253

for.cond.cleanup:                                 ; preds = %for.cond14.for.cond.cleanup17_crit_edge.us, %if.end
  %8 = bitcast %struct.timespec* %retval.i to i8*, !dbg !255
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %8), !dbg !255
  %call.i145 = call i32 @clock_gettime(i32 1, %struct.timespec* nonnull %retval.i) #8, !dbg !255
  %.fca.0.gep.i = getelementptr inbounds %struct.timespec, %struct.timespec* %retval.i, i64 0, i32 0, !dbg !256
  %.fca.0.load.i = load i64, i64* %.fca.0.gep.i, align 8, !dbg !256
  %9 = getelementptr inbounds %struct.timespec, %struct.timespec* %retval.i, i64 0, i32 1, !dbg !256
  %.fca.1.load.i = load i64, i64* %9, align 8, !dbg !256
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %8), !dbg !256
  call void @llvm.dbg.value(metadata i64 %.fca.0.load.i, metadata !170, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !197
  call void @llvm.dbg.value(metadata i64 %.fca.1.load.i, metadata !170, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !197
  call void @llvm.dbg.value(metadata i32 0, metadata !173, metadata !DIExpression()), !dbg !257
  br i1 %cmp12163, label %for.cond.cleanup42, label %for.cond44.preheader.lr.ph, !dbg !258

for.cond44.preheader.lr.ph:                       ; preds = %for.cond.cleanup
  %10 = sext i32 %cond to i64, !dbg !258
  %11 = sext i32 %shl to i64, !dbg !258
  br label %for.cond50.preheader.us.us.preheader, !dbg !258

for.cond50.preheader.us.us.preheader:             ; preds = %for.cond44.preheader.lr.ph, %for.cond44.for.cond.cleanup47_crit_edge.us
  %i38.0160.us = phi i32 [ 0, %for.cond44.preheader.lr.ph ], [ %add74.us, %for.cond44.for.cond.cleanup47_crit_edge.us ]
  call void @llvm.dbg.value(metadata i32 %i38.0160.us, metadata !173, metadata !DIExpression()), !dbg !257
  call void @llvm.dbg.value(metadata i32 0, metadata !175, metadata !DIExpression()), !dbg !259
  %mul55.us = shl i32 %i38.0160.us, %lg_n.0, !dbg !260
  %12 = sext i32 %mul55.us to i64, !dbg !263
  br label %for.cond50.preheader.us.us, !dbg !263

for.cond44.for.cond.cleanup47_crit_edge.us:       ; preds = %for.cond50.for.cond.cleanup53_crit_edge.us.us
  %add74.us = add nsw i32 %i38.0160.us, %cond, !dbg !264
  call void @llvm.dbg.value(metadata i32 %add74.us, metadata !173, metadata !DIExpression()), !dbg !257
  %cmp40.us = icmp slt i32 %add74.us, %shl, !dbg !265
  br i1 %cmp40.us, label %for.cond50.preheader.us.us.preheader, label %for.cond.cleanup42, !dbg !258, !llvm.loop !266

for.cond50.preheader.us.us:                       ; preds = %for.cond50.preheader.us.us.preheader, %for.cond50.for.cond.cleanup53_crit_edge.us.us
  %indvars.iv193 = phi i64 [ 0, %for.cond50.preheader.us.us.preheader ], [ %indvars.iv.next194, %for.cond50.for.cond.cleanup53_crit_edge.us.us ]
  call void @llvm.dbg.value(metadata i64 %indvars.iv193, metadata !175, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.value(metadata i32 0, metadata !179, metadata !DIExpression()), !dbg !268
  %13 = add nsw i64 %indvars.iv193, %12, !dbg !260
  %arrayidx62.us.us = getelementptr inbounds float, float* %2, i64 %13, !dbg !260
  %14 = trunc i64 %indvars.iv193 to i32, !dbg !260
  %mul63.us.us = shl i32 %14, %lg_n.0, !dbg !260
  %15 = sext i32 %mul63.us.us to i64, !dbg !269
  br label %for.body54.us.us, !dbg !269

for.cond50.for.cond.cleanup53_crit_edge.us.us:    ; preds = %for.body54.us.us
  %indvars.iv.next194 = add i64 %indvars.iv193, %10, !dbg !270
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next194, metadata !175, metadata !DIExpression()), !dbg !259
  %cmp45.us.us = icmp slt i64 %indvars.iv.next194, %11, !dbg !271
  br i1 %cmp45.us.us, label %for.cond50.preheader.us.us, label %for.cond44.for.cond.cleanup47_crit_edge.us, !dbg !263, !llvm.loop !272

for.body54.us.us:                                 ; preds = %for.body54.us.us, %for.cond50.preheader.us.us
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body54.us.us ], [ 0, %for.cond50.preheader.us.us ]
  call void @llvm.dbg.value(metadata i64 %indvars.iv, metadata !179, metadata !DIExpression()), !dbg !268
  %16 = add nsw i64 %indvars.iv, %12, !dbg !274
  %arrayidx58.us.us = getelementptr inbounds float, float* %4, i64 %16, !dbg !275
  %17 = add nsw i64 %indvars.iv, %15, !dbg !276
  %arrayidx66.us.us = getelementptr inbounds float, float* %3, i64 %17, !dbg !277
  call void @matmul_base(float* %arrayidx58.us.us, float* %arrayidx62.us.us, float* %arrayidx66.us.us, i32 undef, i32 %cond), !dbg !278
  %indvars.iv.next = add i64 %indvars.iv, %10, !dbg !279
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next, metadata !179, metadata !DIExpression()), !dbg !268
  %cmp51.us.us = icmp slt i64 %indvars.iv.next, %11, !dbg !280
  br i1 %cmp51.us.us, label %for.body54.us.us, label %for.cond50.for.cond.cleanup53_crit_edge.us.us, !dbg !269, !llvm.loop !281

for.cond.cleanup42:                               ; preds = %for.cond44.for.cond.cleanup47_crit_edge.us, %for.cond.cleanup
  %18 = bitcast %struct.timespec* %retval.i146 to i8*, !dbg !283
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %18), !dbg !283
  %call.i147 = call i32 @clock_gettime(i32 1, %struct.timespec* nonnull %retval.i146) #8, !dbg !283
  %.fca.0.gep.i148 = getelementptr inbounds %struct.timespec, %struct.timespec* %retval.i146, i64 0, i32 0, !dbg !284
  %.fca.0.load.i149 = load i64, i64* %.fca.0.gep.i148, align 8, !dbg !284
  %19 = getelementptr inbounds %struct.timespec, %struct.timespec* %retval.i146, i64 0, i32 1, !dbg !284
  %.fca.1.load.i151 = load i64, i64* %19, align 8, !dbg !284
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %18), !dbg !284
  call void @llvm.dbg.value(metadata i64 %.fca.0.load.i149, metadata !183, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !197
  call void @llvm.dbg.value(metadata i64 %.fca.1.load.i151, metadata !183, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !197
  call void @llvm.dbg.value(metadata i64 %.fca.0.load.i, metadata !285, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !291
  call void @llvm.dbg.value(metadata i64 %.fca.1.load.i, metadata !285, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !291
  call void @llvm.dbg.value(metadata i64 %.fca.0.load.i149, metadata !290, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !291
  call void @llvm.dbg.value(metadata i64 %.fca.1.load.i151, metadata !290, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !291
  %sub.i = sub nsw i64 %.fca.0.load.i149, %.fca.0.load.i, !dbg !293
  %conv.i153 = sitofp i64 %sub.i to double, !dbg !294
  %sub3.i = sub nsw i64 %.fca.1.load.i151, %.fca.1.load.i, !dbg !295
  %conv4.i = sitofp i64 %sub3.i to double, !dbg !296
  %mul.i = fmul double %conv4.i, 1.000000e-09, !dbg !297
  %add.i = fadd double %mul.i, %conv.i153, !dbg !298
  call void @llvm.dbg.value(metadata double %add.i, metadata !184, metadata !DIExpression()), !dbg !197
  %call78 = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i64 0, i64 0), double %add.i), !dbg !299
  %call79 = call fastcc zeroext i1 @check_correctness(float* %4, float* %2, float* %3, i32 %shl), !dbg !300
  call void @llvm.dbg.value(metadata i1 %call79, metadata !186, metadata !DIExpression()), !dbg !197
  call void @free(i8* %call3) #8, !dbg !301
  call void @free(i8* %call7) #8, !dbg !302
  call void @free(i8* %call11) #8, !dbg !303
  %lnot = xor i1 %call79, true, !dbg !304
  %lnot.ext = zext i1 %lnot to i32, !dbg !304
  ret i32 %lnot.ext, !dbg !305
}

; Function Attrs: nofree nounwind
declare dso_local noalias i8* @malloc(i64) local_unnamed_addr #3

; Function Attrs: nounwind
declare !dbg !9 dso_local i32 @rand() local_unnamed_addr #4

; Function Attrs: noinline nounwind uwtable
define internal fastcc zeroext i1 @check_correctness(float* noalias nocapture readonly %C, float* noalias nocapture readonly %A, float* noalias nocapture readonly %B, i32 %n) unnamed_addr #5 !dbg !306 {
entry:
  call void @llvm.dbg.value(metadata float* %C, metadata !310, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata float* %A, metadata !311, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata float* %B, metadata !312, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i32 %n, metadata !313, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i8 1, metadata !314, metadata !DIExpression()), !dbg !338
  %0 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !339, !tbaa !202
  %1 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.2, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %0) #9, !dbg !340
  %mul = mul nsw i32 %n, %n, !dbg !341
  %conv = zext i32 %mul to i64, !dbg !342
  %mul1 = shl nuw nsw i64 %conv, 2, !dbg !343
  %call2 = tail call noalias i8* @malloc(i64 %mul1) #8, !dbg !344
  %2 = bitcast i8* %call2 to float*, !dbg !345
  call void @llvm.dbg.value(metadata float* %2, metadata !315, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i32 0, metadata !316, metadata !DIExpression()), !dbg !346
  %cmp169 = icmp sgt i32 %n, 0, !dbg !347
  br i1 %cmp169, label %for.cond4.preheader.us.preheader, label %for.cond.cleanup57.thread, !dbg !348

for.cond4.preheader.us.preheader:                 ; preds = %entry
  %3 = zext i32 %n to i64, !dbg !348
  %4 = shl nuw nsw i64 %3, 2, !dbg !349
  %5 = add nsw i64 %3, -1, !dbg !348
  %xtraiter238 = and i64 %3, 7, !dbg !348
  %6 = icmp ult i64 %5, 7, !dbg !348
  br i1 %6, label %for.cond25.preheader.us.us.preheader.preheader.unr-lcssa, label %for.cond4.preheader.us.preheader.new, !dbg !348

for.cond4.preheader.us.preheader.new:             ; preds = %for.cond4.preheader.us.preheader
  %unroll_iter241 = sub nsw i64 %3, %xtraiter238, !dbg !348
  br label %for.cond4.preheader.us, !dbg !348

for.cond4.preheader.us:                           ; preds = %for.cond4.preheader.us, %for.cond4.preheader.us.preheader.new
  %indvar = phi i64 [ 0, %for.cond4.preheader.us.preheader.new ], [ %indvar.next.7, %for.cond4.preheader.us ]
  %niter242 = phi i64 [ %unroll_iter241, %for.cond4.preheader.us.preheader.new ], [ %niter242.nsub.7, %for.cond4.preheader.us ]
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression()), !dbg !346
  call void @llvm.dbg.value(metadata i32 0, metadata !318, metadata !DIExpression()), !dbg !352
  %7 = mul i64 %4, %indvar, !dbg !349
  %scevgep = getelementptr i8, i8* %call2, i64 %7, !dbg !349
  call void @llvm.memset.p0i8.i64(i8* align 4 %scevgep, i8 0, i64 %4, i1 false), !dbg !353
  call void @llvm.dbg.value(metadata i32 undef, metadata !318, metadata !DIExpression()), !dbg !352
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !346
  %indvar.next = or i64 %indvar, 1, !dbg !348
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression()), !dbg !346
  call void @llvm.dbg.value(metadata i32 0, metadata !318, metadata !DIExpression()), !dbg !352
  %8 = mul i64 %4, %indvar.next, !dbg !349
  %scevgep.1 = getelementptr i8, i8* %call2, i64 %8, !dbg !349
  call void @llvm.memset.p0i8.i64(i8* align 4 %scevgep.1, i8 0, i64 %4, i1 false), !dbg !353
  call void @llvm.dbg.value(metadata i32 undef, metadata !318, metadata !DIExpression()), !dbg !352
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !346
  %indvar.next.1 = or i64 %indvar, 2, !dbg !348
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression()), !dbg !346
  call void @llvm.dbg.value(metadata i32 0, metadata !318, metadata !DIExpression()), !dbg !352
  %9 = mul i64 %4, %indvar.next.1, !dbg !349
  %scevgep.2 = getelementptr i8, i8* %call2, i64 %9, !dbg !349
  call void @llvm.memset.p0i8.i64(i8* align 4 %scevgep.2, i8 0, i64 %4, i1 false), !dbg !353
  call void @llvm.dbg.value(metadata i32 undef, metadata !318, metadata !DIExpression()), !dbg !352
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !346
  %indvar.next.2 = or i64 %indvar, 3, !dbg !348
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression()), !dbg !346
  call void @llvm.dbg.value(metadata i32 0, metadata !318, metadata !DIExpression()), !dbg !352
  %10 = mul i64 %4, %indvar.next.2, !dbg !349
  %scevgep.3 = getelementptr i8, i8* %call2, i64 %10, !dbg !349
  call void @llvm.memset.p0i8.i64(i8* align 4 %scevgep.3, i8 0, i64 %4, i1 false), !dbg !353
  call void @llvm.dbg.value(metadata i32 undef, metadata !318, metadata !DIExpression()), !dbg !352
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !346
  %indvar.next.3 = or i64 %indvar, 4, !dbg !348
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression()), !dbg !346
  call void @llvm.dbg.value(metadata i32 0, metadata !318, metadata !DIExpression()), !dbg !352
  %11 = mul i64 %4, %indvar.next.3, !dbg !349
  %scevgep.4 = getelementptr i8, i8* %call2, i64 %11, !dbg !349
  call void @llvm.memset.p0i8.i64(i8* align 4 %scevgep.4, i8 0, i64 %4, i1 false), !dbg !353
  call void @llvm.dbg.value(metadata i32 undef, metadata !318, metadata !DIExpression()), !dbg !352
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !346
  %indvar.next.4 = or i64 %indvar, 5, !dbg !348
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression()), !dbg !346
  call void @llvm.dbg.value(metadata i32 0, metadata !318, metadata !DIExpression()), !dbg !352
  %12 = mul i64 %4, %indvar.next.4, !dbg !349
  %scevgep.5 = getelementptr i8, i8* %call2, i64 %12, !dbg !349
  call void @llvm.memset.p0i8.i64(i8* align 4 %scevgep.5, i8 0, i64 %4, i1 false), !dbg !353
  call void @llvm.dbg.value(metadata i32 undef, metadata !318, metadata !DIExpression()), !dbg !352
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !346
  %indvar.next.5 = or i64 %indvar, 6, !dbg !348
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression()), !dbg !346
  call void @llvm.dbg.value(metadata i32 0, metadata !318, metadata !DIExpression()), !dbg !352
  %13 = mul i64 %4, %indvar.next.5, !dbg !349
  %scevgep.6 = getelementptr i8, i8* %call2, i64 %13, !dbg !349
  call void @llvm.memset.p0i8.i64(i8* align 4 %scevgep.6, i8 0, i64 %4, i1 false), !dbg !353
  call void @llvm.dbg.value(metadata i32 undef, metadata !318, metadata !DIExpression()), !dbg !352
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !346
  %indvar.next.6 = or i64 %indvar, 7, !dbg !348
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression()), !dbg !346
  call void @llvm.dbg.value(metadata i32 0, metadata !318, metadata !DIExpression()), !dbg !352
  %14 = mul i64 %4, %indvar.next.6, !dbg !349
  %scevgep.7 = getelementptr i8, i8* %call2, i64 %14, !dbg !349
  call void @llvm.memset.p0i8.i64(i8* align 4 %scevgep.7, i8 0, i64 %4, i1 false), !dbg !353
  call void @llvm.dbg.value(metadata i32 undef, metadata !318, metadata !DIExpression()), !dbg !352
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !346
  %indvar.next.7 = add nuw nsw i64 %indvar, 8, !dbg !348
  %niter242.nsub.7 = add i64 %niter242, -8, !dbg !348
  %niter242.ncmp.7 = icmp eq i64 %niter242.nsub.7, 0, !dbg !348
  br i1 %niter242.ncmp.7, label %for.cond25.preheader.us.us.preheader.preheader.unr-lcssa, label %for.cond4.preheader.us, !dbg !348, !llvm.loop !354

for.cond25.preheader.us.us.preheader.preheader.unr-lcssa: ; preds = %for.cond4.preheader.us, %for.cond4.preheader.us.preheader
  %indvar.unr = phi i64 [ 0, %for.cond4.preheader.us.preheader ], [ %indvar.next.7, %for.cond4.preheader.us ]
  %lcmp.mod240 = icmp eq i64 %xtraiter238, 0, !dbg !348
  br i1 %lcmp.mod240, label %for.cond25.preheader.us.us.preheader.preheader, label %for.cond4.preheader.us.epil, !dbg !348

for.cond4.preheader.us.epil:                      ; preds = %for.cond25.preheader.us.us.preheader.preheader.unr-lcssa, %for.cond4.preheader.us.epil
  %indvar.epil = phi i64 [ %indvar.next.epil, %for.cond4.preheader.us.epil ], [ %indvar.unr, %for.cond25.preheader.us.us.preheader.preheader.unr-lcssa ]
  %epil.iter239 = phi i64 [ %epil.iter239.sub, %for.cond4.preheader.us.epil ], [ %xtraiter238, %for.cond25.preheader.us.us.preheader.preheader.unr-lcssa ]
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression()), !dbg !346
  call void @llvm.dbg.value(metadata i32 0, metadata !318, metadata !DIExpression()), !dbg !352
  %15 = mul i64 %4, %indvar.epil, !dbg !349
  %scevgep.epil = getelementptr i8, i8* %call2, i64 %15, !dbg !349
  call void @llvm.memset.p0i8.i64(i8* align 4 %scevgep.epil, i8 0, i64 %4, i1 false), !dbg !353
  call void @llvm.dbg.value(metadata i32 undef, metadata !318, metadata !DIExpression()), !dbg !352
  call void @llvm.dbg.value(metadata i32 undef, metadata !316, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !346
  %indvar.next.epil = add nuw nsw i64 %indvar.epil, 1, !dbg !348
  %epil.iter239.sub = add i64 %epil.iter239, -1, !dbg !348
  %epil.iter239.cmp = icmp eq i64 %epil.iter239.sub, 0, !dbg !348
  br i1 %epil.iter239.cmp, label %for.cond25.preheader.us.us.preheader.preheader, label %for.cond4.preheader.us.epil, !dbg !348, !llvm.loop !356

for.cond25.preheader.us.us.preheader.preheader:   ; preds = %for.cond4.preheader.us.epil, %for.cond25.preheader.us.us.preheader.preheader.unr-lcssa
  %16 = add nsw i64 %3, -1, !dbg !358
  %xtraiter = and i64 %3, 3, !dbg !359
  %17 = icmp ult i64 %16, 3, !dbg !359
  %unroll_iter = sub nsw i64 %3, %xtraiter, !dbg !359
  %lcmp.mod = icmp eq i64 %xtraiter, 0, !dbg !359
  br label %for.cond25.preheader.us.us.preheader, !dbg !358

for.cond25.preheader.us.us.preheader:             ; preds = %for.cond25.preheader.us.us.preheader.preheader, %for.cond20.for.cond.cleanup23_crit_edge.us
  %indvars.iv221 = phi i64 [ %indvars.iv.next222, %for.cond20.for.cond.cleanup23_crit_edge.us ], [ 0, %for.cond25.preheader.us.us.preheader.preheader ]
  call void @llvm.dbg.value(metadata i64 %indvars.iv221, metadata !322, metadata !DIExpression()), !dbg !360
  call void @llvm.dbg.value(metadata i32 0, metadata !324, metadata !DIExpression()), !dbg !361
  %18 = mul nuw nsw i64 %indvars.iv221, %3, !dbg !362
  br label %for.cond25.preheader.us.us, !dbg !365

for.cond20.for.cond.cleanup23_crit_edge.us:       ; preds = %for.cond25.for.cond.cleanup28_crit_edge.us.us
  %indvars.iv.next222 = add nuw nsw i64 %indvars.iv221, 1, !dbg !366
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next222, metadata !322, metadata !DIExpression()), !dbg !360
  %exitcond225 = icmp eq i64 %indvars.iv.next222, %3, !dbg !367
  br i1 %exitcond225, label %for.cond60.preheader.us, label %for.cond25.preheader.us.us.preheader, !dbg !358, !llvm.loop !368

for.cond25.preheader.us.us:                       ; preds = %for.cond25.for.cond.cleanup28_crit_edge.us.us, %for.cond25.preheader.us.us.preheader
  %indvars.iv216 = phi i64 [ 0, %for.cond25.preheader.us.us.preheader ], [ %indvars.iv.next217, %for.cond25.for.cond.cleanup28_crit_edge.us.us ]
  call void @llvm.dbg.value(metadata i64 %indvars.iv216, metadata !324, metadata !DIExpression()), !dbg !361
  call void @llvm.dbg.value(metadata i32 0, metadata !328, metadata !DIExpression()), !dbg !359
  %19 = add nuw nsw i64 %indvars.iv216, %18, !dbg !362
  %arrayidx42.us.us = getelementptr inbounds float, float* %2, i64 %19, !dbg !362
  %arrayidx42.promoted.us.us = load float, float* %arrayidx42.us.us, align 4, !dbg !370, !tbaa !108
  br i1 %17, label %for.cond25.for.cond.cleanup28_crit_edge.us.us.unr-lcssa, label %for.body29.us.us, !dbg !371

for.cond25.for.cond.cleanup28_crit_edge.us.us.unr-lcssa: ; preds = %for.body29.us.us, %for.cond25.preheader.us.us
  %add43.us.us.lcssa.ph = phi float [ undef, %for.cond25.preheader.us.us ], [ %add43.us.us.3, %for.body29.us.us ]
  %indvars.iv209.unr = phi i64 [ 0, %for.cond25.preheader.us.us ], [ %indvars.iv.next210.3, %for.body29.us.us ]
  %add43172.us.us.unr = phi float [ %arrayidx42.promoted.us.us, %for.cond25.preheader.us.us ], [ %add43.us.us.3, %for.body29.us.us ]
  br i1 %lcmp.mod, label %for.cond25.for.cond.cleanup28_crit_edge.us.us, label %for.body29.us.us.epil, !dbg !371

for.body29.us.us.epil:                            ; preds = %for.cond25.for.cond.cleanup28_crit_edge.us.us.unr-lcssa, %for.body29.us.us.epil
  %indvars.iv209.epil = phi i64 [ %indvars.iv.next210.epil, %for.body29.us.us.epil ], [ %indvars.iv209.unr, %for.cond25.for.cond.cleanup28_crit_edge.us.us.unr-lcssa ], !dbg !359
  %add43172.us.us.epil = phi float [ %add43.us.us.epil, %for.body29.us.us.epil ], [ %add43172.us.us.unr, %for.cond25.for.cond.cleanup28_crit_edge.us.us.unr-lcssa ], !dbg !359
  %epil.iter = phi i64 [ %epil.iter.sub, %for.body29.us.us.epil ], [ %xtraiter, %for.cond25.for.cond.cleanup28_crit_edge.us.us.unr-lcssa ]
  call void @llvm.dbg.value(metadata i64 %indvars.iv209.epil, metadata !328, metadata !DIExpression()), !dbg !359
  %20 = add nuw nsw i64 %indvars.iv209.epil, %18, !dbg !372
  %arrayidx33.us.us.epil = getelementptr inbounds float, float* %A, i64 %20, !dbg !373
  %21 = load float, float* %arrayidx33.us.us.epil, align 4, !dbg !373, !tbaa !108
  %22 = mul nuw nsw i64 %indvars.iv209.epil, %3, !dbg !374
  %23 = add nuw nsw i64 %22, %indvars.iv216, !dbg !375
  %arrayidx37.us.us.epil = getelementptr inbounds float, float* %B, i64 %23, !dbg !376
  %24 = load float, float* %arrayidx37.us.us.epil, align 4, !dbg !376, !tbaa !108
  %mul38.us.us.epil = fmul float %21, %24, !dbg !377
  %add43.us.us.epil = fadd float %add43172.us.us.epil, %mul38.us.us.epil, !dbg !370
  %indvars.iv.next210.epil = add nuw nsw i64 %indvars.iv209.epil, 1, !dbg !378
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next210.epil, metadata !328, metadata !DIExpression()), !dbg !359
  %epil.iter.sub = add i64 %epil.iter, -1, !dbg !371
  %epil.iter.cmp = icmp eq i64 %epil.iter.sub, 0, !dbg !371
  br i1 %epil.iter.cmp, label %for.cond25.for.cond.cleanup28_crit_edge.us.us, label %for.body29.us.us.epil, !dbg !371, !llvm.loop !379

for.cond25.for.cond.cleanup28_crit_edge.us.us:    ; preds = %for.body29.us.us.epil, %for.cond25.for.cond.cleanup28_crit_edge.us.us.unr-lcssa
  %add43.us.us.lcssa = phi float [ %add43.us.us.lcssa.ph, %for.cond25.for.cond.cleanup28_crit_edge.us.us.unr-lcssa ], [ %add43.us.us.epil, %for.body29.us.us.epil ], !dbg !370
  store float %add43.us.us.lcssa, float* %arrayidx42.us.us, align 4, !dbg !370, !tbaa !108
  %indvars.iv.next217 = add nuw nsw i64 %indvars.iv216, 1, !dbg !380
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next217, metadata !324, metadata !DIExpression()), !dbg !361
  %exitcond220 = icmp eq i64 %indvars.iv.next217, %3, !dbg !381
  br i1 %exitcond220, label %for.cond20.for.cond.cleanup23_crit_edge.us, label %for.cond25.preheader.us.us, !dbg !365, !llvm.loop !382

for.body29.us.us:                                 ; preds = %for.cond25.preheader.us.us, %for.body29.us.us
  %indvars.iv209 = phi i64 [ %indvars.iv.next210.3, %for.body29.us.us ], [ 0, %for.cond25.preheader.us.us ], !dbg !359
  %add43172.us.us = phi float [ %add43.us.us.3, %for.body29.us.us ], [ %arrayidx42.promoted.us.us, %for.cond25.preheader.us.us ], !dbg !359
  %niter = phi i64 [ %niter.nsub.3, %for.body29.us.us ], [ %unroll_iter, %for.cond25.preheader.us.us ]
  call void @llvm.dbg.value(metadata i64 %indvars.iv209, metadata !328, metadata !DIExpression()), !dbg !359
  %25 = add nuw nsw i64 %indvars.iv209, %18, !dbg !372
  %arrayidx33.us.us = getelementptr inbounds float, float* %A, i64 %25, !dbg !373
  %26 = load float, float* %arrayidx33.us.us, align 4, !dbg !373, !tbaa !108
  %27 = mul nuw nsw i64 %indvars.iv209, %3, !dbg !374
  %28 = add nuw nsw i64 %27, %indvars.iv216, !dbg !375
  %arrayidx37.us.us = getelementptr inbounds float, float* %B, i64 %28, !dbg !376
  %29 = load float, float* %arrayidx37.us.us, align 4, !dbg !376, !tbaa !108
  %mul38.us.us = fmul float %26, %29, !dbg !377
  %add43.us.us = fadd float %add43172.us.us, %mul38.us.us, !dbg !370
  %indvars.iv.next210 = or i64 %indvars.iv209, 1, !dbg !378
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next210, metadata !328, metadata !DIExpression()), !dbg !359
  %30 = add nuw nsw i64 %indvars.iv.next210, %18, !dbg !372
  %arrayidx33.us.us.1 = getelementptr inbounds float, float* %A, i64 %30, !dbg !373
  %31 = load float, float* %arrayidx33.us.us.1, align 4, !dbg !373, !tbaa !108
  %32 = mul nuw nsw i64 %indvars.iv.next210, %3, !dbg !374
  %33 = add nuw nsw i64 %32, %indvars.iv216, !dbg !375
  %arrayidx37.us.us.1 = getelementptr inbounds float, float* %B, i64 %33, !dbg !376
  %34 = load float, float* %arrayidx37.us.us.1, align 4, !dbg !376, !tbaa !108
  %mul38.us.us.1 = fmul float %31, %34, !dbg !377
  %add43.us.us.1 = fadd float %add43.us.us, %mul38.us.us.1, !dbg !370
  %indvars.iv.next210.1 = or i64 %indvars.iv209, 2, !dbg !378
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next210.1, metadata !328, metadata !DIExpression()), !dbg !359
  %35 = add nuw nsw i64 %indvars.iv.next210.1, %18, !dbg !372
  %arrayidx33.us.us.2 = getelementptr inbounds float, float* %A, i64 %35, !dbg !373
  %36 = load float, float* %arrayidx33.us.us.2, align 4, !dbg !373, !tbaa !108
  %37 = mul nuw nsw i64 %indvars.iv.next210.1, %3, !dbg !374
  %38 = add nuw nsw i64 %37, %indvars.iv216, !dbg !375
  %arrayidx37.us.us.2 = getelementptr inbounds float, float* %B, i64 %38, !dbg !376
  %39 = load float, float* %arrayidx37.us.us.2, align 4, !dbg !376, !tbaa !108
  %mul38.us.us.2 = fmul float %36, %39, !dbg !377
  %add43.us.us.2 = fadd float %add43.us.us.1, %mul38.us.us.2, !dbg !370
  %indvars.iv.next210.2 = or i64 %indvars.iv209, 3, !dbg !378
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next210.2, metadata !328, metadata !DIExpression()), !dbg !359
  %40 = add nuw nsw i64 %indvars.iv.next210.2, %18, !dbg !372
  %arrayidx33.us.us.3 = getelementptr inbounds float, float* %A, i64 %40, !dbg !373
  %41 = load float, float* %arrayidx33.us.us.3, align 4, !dbg !373, !tbaa !108
  %42 = mul nuw nsw i64 %indvars.iv.next210.2, %3, !dbg !374
  %43 = add nuw nsw i64 %42, %indvars.iv216, !dbg !375
  %arrayidx37.us.us.3 = getelementptr inbounds float, float* %B, i64 %43, !dbg !376
  %44 = load float, float* %arrayidx37.us.us.3, align 4, !dbg !376, !tbaa !108
  %mul38.us.us.3 = fmul float %41, %44, !dbg !377
  %add43.us.us.3 = fadd float %add43.us.us.2, %mul38.us.us.3, !dbg !370
  %indvars.iv.next210.3 = add nuw nsw i64 %indvars.iv209, 4, !dbg !378
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next210.3, metadata !328, metadata !DIExpression()), !dbg !359
  %niter.nsub.3 = add i64 %niter, -4, !dbg !371
  %niter.ncmp.3 = icmp eq i64 %niter.nsub.3, 0, !dbg !371
  br i1 %niter.ncmp.3, label %for.cond25.for.cond.cleanup28_crit_edge.us.us.unr-lcssa, label %for.body29.us.us, !dbg !371, !llvm.loop !384

for.cond60.preheader.us:                          ; preds = %for.cond20.for.cond.cleanup23_crit_edge.us, %for.cond60.for.cond.cleanup63_crit_edge.us
  %indvars.iv204 = phi i64 [ %indvars.iv.next205, %for.cond60.for.cond.cleanup63_crit_edge.us ], [ 0, %for.cond20.for.cond.cleanup23_crit_edge.us ]
  %passed.0155.us = phi i8 [ %passed.2.us, %for.cond60.for.cond.cleanup63_crit_edge.us ], [ 1, %for.cond20.for.cond.cleanup23_crit_edge.us ]
  call void @llvm.dbg.value(metadata i64 %indvars.iv204, metadata !332, metadata !DIExpression()), !dbg !386
  call void @llvm.dbg.value(metadata i32 0, metadata !334, metadata !DIExpression()), !dbg !387
  call void @llvm.dbg.value(metadata i8 %passed.0155.us, metadata !314, metadata !DIExpression()), !dbg !338
  %45 = mul nuw nsw i64 %indvars.iv204, %3, !dbg !388
  %46 = trunc i64 %indvars.iv204 to i32, !dbg !392
  br label %for.body64.us, !dbg !394

for.body64.us:                                    ; preds = %for.inc85.us, %for.cond60.preheader.us
  %indvars.iv = phi i64 [ 0, %for.cond60.preheader.us ], [ %indvars.iv.next, %for.inc85.us ]
  %passed.1152.us = phi i8 [ %passed.0155.us, %for.cond60.preheader.us ], [ %passed.2.us, %for.inc85.us ]
  call void @llvm.dbg.value(metadata i64 %indvars.iv, metadata !334, metadata !DIExpression()), !dbg !387
  call void @llvm.dbg.value(metadata i8 %passed.1152.us, metadata !314, metadata !DIExpression()), !dbg !338
  %47 = add nuw nsw i64 %indvars.iv, %45, !dbg !395
  %arrayidx68.us = getelementptr inbounds float, float* %C, i64 %47, !dbg !396
  %48 = load float, float* %arrayidx68.us, align 4, !dbg !396, !tbaa !108
  %arrayidx72.us = getelementptr inbounds float, float* %2, i64 %47, !dbg !397
  %49 = load float, float* %arrayidx72.us, align 4, !dbg !397, !tbaa !108
  call void @llvm.dbg.value(metadata float %48, metadata !398, metadata !DIExpression()), !dbg !408
  call void @llvm.dbg.value(metadata float %49, metadata !403, metadata !DIExpression()), !dbg !408
  %50 = insertelement <2 x float> undef, float %49, i32 0, !dbg !410
  %51 = insertelement <2 x float> %50, float %48, i32 1, !dbg !410
  %52 = fcmp olt <2 x float> %51, zeroinitializer, !dbg !410
  %53 = fneg <2 x float> %51, !dbg !411
  %54 = select <2 x i1> %52, <2 x float> %53, <2 x float> %51, !dbg !411
  %55 = extractelement <2 x float> %54, i32 0, !dbg !412
  %56 = extractelement <2 x float> %54, i32 1, !dbg !412
  %cmp7.i.us = fcmp olt float %56, %55, !dbg !412
  %57 = insertelement <2 x i1> undef, i1 %cmp7.i.us, i32 0, !dbg !413
  %58 = shufflevector <2 x i1> %57, <2 x i1> undef, <2 x i32> zeroinitializer, !dbg !413
  %59 = shufflevector <2 x float> %54, <2 x float> undef, <2 x i32> <i32 1, i32 0>, !dbg !413
  %60 = select <2 x i1> %58, <2 x float> %54, <2 x float> %59, !dbg !413
  %61 = extractelement <2 x float> %60, i32 0, !dbg !414
  %62 = extractelement <2 x float> %60, i32 1, !dbg !414
  %sub.i.us = fsub float %61, %62, !dbg !414
  call void @llvm.dbg.value(metadata float %sub.i.us, metadata !407, metadata !DIExpression()), !dbg !408
  %conv.i.us = fpext float %sub.i.us to double, !dbg !415
  %cmp8.i.us = fcmp olt double %conv.i.us, 1.000000e-02, !dbg !416
  br i1 %cmp8.i.us, label %for.inc85.us, label %close_enough.exit.us, !dbg !417

close_enough.exit.us:                             ; preds = %for.body64.us
  %div.i.us = fdiv float %sub.i.us, %61, !dbg !418
  %conv10.i.us = fpext float %div.i.us to double, !dbg !419
  %cmp11.i.us = fcmp olt double %conv10.i.us, 1.000000e-05, !dbg !420
  br i1 %cmp11.i.us, label %for.inc85.us, label %if.then.us, !dbg !421

if.then.us:                                       ; preds = %close_enough.exit.us
  call void @llvm.dbg.value(metadata i8 0, metadata !314, metadata !DIExpression()), !dbg !338
  %63 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !422, !tbaa !202
  %conv78.us = fpext float %48 to double, !dbg !423
  %conv83.us = fpext float %49 to double, !dbg !424
  %64 = trunc i64 %indvars.iv to i32, !dbg !425
  %call84.us = tail call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %63, i8* getelementptr inbounds ([72 x i8], [72 x i8]* @.str.3, i64 0, i64 0), i32 %46, i32 %64, double %conv78.us, double %conv83.us) #9, !dbg !425
  br label %for.inc85.us, !dbg !426

for.inc85.us:                                     ; preds = %if.then.us, %close_enough.exit.us, %for.body64.us
  %passed.2.us = phi i8 [ %passed.1152.us, %close_enough.exit.us ], [ 0, %if.then.us ], [ %passed.1152.us, %for.body64.us ], !dbg !338
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !427
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next, metadata !334, metadata !DIExpression()), !dbg !387
  %exitcond = icmp eq i64 %indvars.iv.next, %3, !dbg !428
  br i1 %exitcond, label %for.cond60.for.cond.cleanup63_crit_edge.us, label %for.body64.us, !dbg !394, !llvm.loop !429

for.cond60.for.cond.cleanup63_crit_edge.us:       ; preds = %for.inc85.us
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  %indvars.iv.next205 = add nuw nsw i64 %indvars.iv204, 1, !dbg !431
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next205, metadata !332, metadata !DIExpression()), !dbg !386
  %exitcond208 = icmp eq i64 %indvars.iv.next205, %3, !dbg !432
  br i1 %exitcond208, label %for.cond.cleanup57, label %for.cond60.preheader.us, !dbg !433, !llvm.loop !434

for.cond.cleanup57.thread:                        ; preds = %entry
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  %65 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !436, !tbaa !202
  br label %if.else, !dbg !438

for.cond.cleanup57:                               ; preds = %for.cond60.for.cond.cleanup63_crit_edge.us
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.value(metadata i8 %passed.2.us, metadata !314, metadata !DIExpression()), !dbg !338
  %66 = and i8 %passed.2.us, 1, !dbg !439
  %tobool = icmp eq i8 %66, 0, !dbg !439
  %67 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !436, !tbaa !202
  br i1 %tobool, label %if.then91, label %if.else, !dbg !438

if.then91:                                        ; preds = %for.cond.cleanup57
  %68 = tail call i64 @fwrite(i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.4, i64 0, i64 0), i64 26, i64 1, %struct._IO_FILE* %67) #9, !dbg !440
  br label %if.end94, !dbg !440

if.else:                                          ; preds = %for.cond.cleanup57, %for.cond.cleanup57.thread
  %69 = phi %struct._IO_FILE* [ %65, %for.cond.cleanup57.thread ], [ %67, %for.cond.cleanup57 ]
  %70 = tail call i64 @fwrite(i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.5, i64 0, i64 0), i64 26, i64 1, %struct._IO_FILE* %69) #9, !dbg !441
  br label %if.end94

if.end94:                                         ; preds = %if.else, %if.then91
  %tobool235 = phi i1 [ true, %if.else ], [ false, %if.then91 ]
  tail call void @free(i8* %call2) #8, !dbg !442
  ret i1 %tobool235, !dbg !443
}

; Function Attrs: nounwind
declare !dbg !14 dso_local void @free(i8* nocapture) local_unnamed_addr #4

; Function Attrs: nofree nounwind
declare dso_local i64 @strtol(i8* readonly, i8** nocapture, i32) local_unnamed_addr #3

; Function Attrs: nounwind
declare !dbg !21 dso_local i32 @clock_gettime(i32, %struct.timespec*) local_unnamed_addr #4

; Function Attrs: nofree nounwind
declare dso_local i32 @fprintf(%struct._IO_FILE* nocapture, i8* nocapture readonly, ...) local_unnamed_addr #3

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

; Function Attrs: nofree nounwind
declare i64 @fwrite(i8* nocapture, i64, i64, %struct._IO_FILE* nocapture) local_unnamed_addr #6

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #7

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #7

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #7

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="haswell" "target-features"="+avx,+avx2,+bmi,+bmi2,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+rdrnd,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { nofree nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="haswell" "target-features"="+avx,+avx2,+bmi,+bmi2,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+rdrnd,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="haswell" "target-features"="+avx,+avx2,+bmi,+bmi2,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+rdrnd,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noinline nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="haswell" "target-features"="+avx,+avx2,+bmi,+bmi2,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+rdrnd,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nofree nounwind }
attributes #7 = { argmemonly nounwind willreturn }
attributes #8 = { nounwind }
attributes #9 = { cold }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!47, !48, !49}
!llvm.ident = !{!50}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "Avec", scope: !2, file: !3, line: 37, type: !38, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.1 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !35, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "matmul.c", directory: "/home/ubuntu/git/homework3_adrianoh/matmul")
!4 = !{}
!5 = !{!6, !7, !9, !14, !13, !18, !17, !21}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "el_t", file: !3, line: 33, baseType: !8)
!8 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!9 = !DISubprogram(name: "rand", scope: !10, file: !10, line: 453, type: !11, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !4)
!10 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!11 = !DISubroutineType(types: !12)
!12 = !{!13}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !DISubprogram(name: "free", scope: !10, file: !10, line: 563, type: !15, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{null, !17}
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!20 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!21 = !DISubprogram(name: "clock_gettime", scope: !22, file: !22, line: 219, type: !23, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !4)
!22 = !DIFile(filename: "/usr/include/time.h", directory: "")
!23 = !DISubroutineType(types: !24)
!24 = !{!13, !13, !25}
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!26 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !27, line: 9, size: 128, elements: !28)
!27 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_timespec.h", directory: "")
!28 = !{!29, !33}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !26, file: !27, line: 11, baseType: !30, size: 64)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !31, line: 148, baseType: !32)
!31 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!32 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !26, file: !27, line: 12, baseType: !34, size: 64, offset: 64)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "__syscall_slong_t", file: !31, line: 184, baseType: !32)
!35 = !{!0, !36, !45}
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "Bvec", scope: !2, file: !3, line: 37, type: !38, isLocal: false, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 1024, elements: !43)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "vfloat_t", file: !3, line: 34, baseType: !40)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 256, flags: DIFlagVector, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 8)
!43 = !{!44}
!44 = !DISubrange(count: 4)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(name: "Cvec", scope: !2, file: !3, line: 37, type: !38, isLocal: false, isDefinition: true)
!47 = !{i32 7, !"Dwarf Version", i32 4}
!48 = !{i32 2, !"Debug Info Version", i32 3}
!49 = !{i32 1, !"wchar_size", i32 4}
!50 = !{!"clang version 10.0.1 "}
!51 = distinct !DISubprogram(name: "matmul_base", scope: !3, file: !3, line: 44, type: !52, scopeLine: 45, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !58)
!52 = !DISubroutineType(types: !53)
!53 = !{null, !54, !55, !55, !13, !13}
!54 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !6)
!55 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !56)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!57 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !7)
!58 = !{!59, !60, !61, !62, !63, !64, !66, !70, !74, !76, !80, !84, !86}
!59 = !DILocalVariable(name: "C", arg: 1, scope: !51, file: !3, line: 44, type: !54)
!60 = !DILocalVariable(name: "A", arg: 2, scope: !51, file: !3, line: 44, type: !55)
!61 = !DILocalVariable(name: "B", arg: 3, scope: !51, file: !3, line: 45, type: !55)
!62 = !DILocalVariable(name: "row_length", arg: 4, scope: !51, file: !3, line: 45, type: !13)
!63 = !DILocalVariable(name: "size", arg: 5, scope: !51, file: !3, line: 45, type: !13)
!64 = !DILocalVariable(name: "ACrow", scope: !65, file: !3, line: 57, type: !13)
!65 = distinct !DILexicalBlock(scope: !51, file: !3, line: 57, column: 3)
!66 = !DILocalVariable(name: "i", scope: !67, file: !3, line: 60, type: !13)
!67 = distinct !DILexicalBlock(scope: !68, file: !3, line: 60, column: 5)
!68 = distinct !DILexicalBlock(scope: !69, file: !3, line: 57, column: 44)
!69 = distinct !DILexicalBlock(scope: !65, file: !3, line: 57, column: 3)
!70 = !DILocalVariable(name: "idx", scope: !71, file: !3, line: 62, type: !13)
!71 = distinct !DILexicalBlock(scope: !72, file: !3, line: 62, column: 7)
!72 = distinct !DILexicalBlock(scope: !73, file: !3, line: 60, column: 33)
!73 = distinct !DILexicalBlock(scope: !67, file: !3, line: 60, column: 5)
!74 = !DILocalVariable(name: "Brow", scope: !75, file: !3, line: 72, type: !13)
!75 = distinct !DILexicalBlock(scope: !68, file: !3, line: 72, column: 5)
!76 = !DILocalVariable(name: "i", scope: !77, file: !3, line: 74, type: !13)
!77 = distinct !DILexicalBlock(scope: !78, file: !3, line: 74, column: 7)
!78 = distinct !DILexicalBlock(scope: !79, file: !3, line: 72, column: 43)
!79 = distinct !DILexicalBlock(scope: !75, file: !3, line: 72, column: 5)
!80 = !DILocalVariable(name: "idx", scope: !81, file: !3, line: 76, type: !13)
!81 = distinct !DILexicalBlock(scope: !82, file: !3, line: 76, column: 9)
!82 = distinct !DILexicalBlock(scope: !83, file: !3, line: 74, column: 35)
!83 = distinct !DILexicalBlock(scope: !77, file: !3, line: 74, column: 7)
!84 = !DILocalVariable(name: "i", scope: !85, file: !3, line: 90, type: !13)
!85 = distinct !DILexicalBlock(scope: !68, file: !3, line: 90, column: 5)
!86 = !DILocalVariable(name: "idx", scope: !87, file: !3, line: 91, type: !13)
!87 = distinct !DILexicalBlock(scope: !88, file: !3, line: 91, column: 7)
!88 = distinct !DILexicalBlock(scope: !89, file: !3, line: 90, column: 33)
!89 = distinct !DILexicalBlock(scope: !85, file: !3, line: 90, column: 5)
!90 = !DILocation(line: 0, scope: !51)
!91 = !DILocation(line: 47, column: 7, scope: !51)
!92 = !DILocation(line: 48, column: 7, scope: !51)
!93 = !DILocation(line: 49, column: 7, scope: !51)
!94 = !DILocation(line: 51, column: 12, scope: !95)
!95 = distinct !DILexicalBlock(scope: !51, file: !3, line: 51, column: 7)
!96 = !DILocation(line: 51, column: 7, scope: !51)
!97 = !DILocation(line: 52, column: 5, scope: !98)
!98 = distinct !DILexicalBlock(scope: !95, file: !3, line: 51, column: 19)
!99 = !DILocation(line: 54, column: 3, scope: !98)
!100 = !DILocation(line: 57, column: 3, scope: !65)
!101 = !DILocation(line: 0, scope: !65)
!102 = !DILocation(line: 0, scope: !67)
!103 = !DILocation(line: 0, scope: !104)
!104 = distinct !DILexicalBlock(scope: !105, file: !3, line: 62, column: 41)
!105 = distinct !DILexicalBlock(scope: !71, file: !3, line: 62, column: 7)
!106 = !DILocation(line: 0, scope: !71)
!107 = !DILocation(line: 63, column: 24, scope: !104)
!108 = !{!109, !109, i64 0}
!109 = !{!"float", !110, i64 0}
!110 = !{!"omnipotent char", !111, i64 0}
!111 = !{!"Simple C/C++ TBAA"}
!112 = !DILocation(line: 63, column: 22, scope: !104)
!113 = !DILocation(line: 66, column: 24, scope: !104)
!114 = !DILocation(line: 66, column: 22, scope: !104)
!115 = !DILocation(line: 63, column: 45, scope: !104)
!116 = !DILocation(line: 0, scope: !75)
!117 = !DILocation(line: 72, column: 5, scope: !75)
!118 = !DILocation(line: 77, column: 24, scope: !119)
!119 = distinct !DILexicalBlock(scope: !120, file: !3, line: 76, column: 43)
!120 = distinct !DILexicalBlock(scope: !81, file: !3, line: 76, column: 9)
!121 = !DILocation(line: 96, column: 1, scope: !51)
!122 = !DILocation(line: 0, scope: !85)
!123 = !DILocation(line: 0, scope: !87)
!124 = !DILocation(line: 92, column: 37, scope: !125)
!125 = distinct !DILexicalBlock(scope: !126, file: !3, line: 91, column: 41)
!126 = distinct !DILexicalBlock(scope: !87, file: !3, line: 91, column: 7)
!127 = !DILocation(line: 57, column: 40, scope: !69)
!128 = !DILocation(line: 57, column: 29, scope: !69)
!129 = distinct !{!129, !100, !130}
!130 = !DILocation(line: 95, column: 3, scope: !65)
!131 = !DILocation(line: 0, scope: !77)
!132 = !DILocation(line: 0, scope: !119)
!133 = !DILocation(line: 0, scope: !81)
!134 = !DILocation(line: 77, column: 26, scope: !119)
!135 = !DILocation(line: 82, column: 28, scope: !78)
!136 = !DILocation(line: 82, column: 18, scope: !78)
!137 = !{!110, !110, i64 0}
!138 = !DILocation(line: 82, column: 38, scope: !78)
!139 = !DILocation(line: 82, column: 43, scope: !78)
!140 = !DILocation(line: 82, column: 15, scope: !78)
!141 = !DILocation(line: 83, column: 43, scope: !78)
!142 = !DILocation(line: 83, column: 15, scope: !78)
!143 = !DILocation(line: 84, column: 43, scope: !78)
!144 = !DILocation(line: 84, column: 15, scope: !78)
!145 = !DILocation(line: 85, column: 43, scope: !78)
!146 = !DILocation(line: 85, column: 15, scope: !78)
!147 = !DILocation(line: 72, column: 39, scope: !79)
!148 = !DILocation(line: 72, column: 29, scope: !79)
!149 = distinct !{!149, !117, !150}
!150 = !DILocation(line: 86, column: 5, scope: !75)
!151 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 157, type: !152, scopeLine: 157, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !154)
!152 = !DISubroutineType(types: !153)
!153 = !{!13, !13, !18}
!154 = !{!155, !156, !157, !158, !160, !161, !162, !163, !164, !166, !170, !173, !175, !179, !183, !184, !186}
!155 = !DILocalVariable(name: "argc", arg: 1, scope: !151, file: !3, line: 157, type: !13)
!156 = !DILocalVariable(name: "argv", arg: 2, scope: !151, file: !3, line: 157, type: !18)
!157 = !DILocalVariable(name: "lg_n", scope: !151, file: !3, line: 160, type: !13)
!158 = !DILocalVariable(name: "n", scope: !151, file: !3, line: 165, type: !159)
!159 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !13)
!160 = !DILocalVariable(name: "size", scope: !151, file: !3, line: 167, type: !159)
!161 = !DILocalVariable(name: "A", scope: !151, file: !3, line: 172, type: !6)
!162 = !DILocalVariable(name: "B", scope: !151, file: !3, line: 173, type: !6)
!163 = !DILocalVariable(name: "C", scope: !151, file: !3, line: 174, type: !6)
!164 = !DILocalVariable(name: "i", scope: !165, file: !3, line: 177, type: !13)
!165 = distinct !DILexicalBlock(scope: !151, file: !3, line: 177, column: 3)
!166 = !DILocalVariable(name: "j", scope: !167, file: !3, line: 178, type: !13)
!167 = distinct !DILexicalBlock(scope: !168, file: !3, line: 178, column: 5)
!168 = distinct !DILexicalBlock(scope: !169, file: !3, line: 177, column: 31)
!169 = distinct !DILexicalBlock(scope: !165, file: !3, line: 177, column: 3)
!170 = !DILocalVariable(name: "start", scope: !151, file: !3, line: 186, type: !171)
!171 = !DIDerivedType(tag: DW_TAG_typedef, name: "fasttime_t", file: !172, line: 66, baseType: !26)
!172 = !DIFile(filename: "././fasttime.h", directory: "/home/ubuntu/git/homework3_adrianoh/matmul")
!173 = !DILocalVariable(name: "i", scope: !174, file: !3, line: 187, type: !13)
!174 = distinct !DILexicalBlock(scope: !151, file: !3, line: 187, column: 3)
!175 = !DILocalVariable(name: "k", scope: !176, file: !3, line: 188, type: !13)
!176 = distinct !DILexicalBlock(scope: !177, file: !3, line: 188, column: 5)
!177 = distinct !DILexicalBlock(scope: !178, file: !3, line: 187, column: 37)
!178 = distinct !DILexicalBlock(scope: !174, file: !3, line: 187, column: 3)
!179 = !DILocalVariable(name: "j", scope: !180, file: !3, line: 189, type: !13)
!180 = distinct !DILexicalBlock(scope: !181, file: !3, line: 189, column: 7)
!181 = distinct !DILexicalBlock(scope: !182, file: !3, line: 188, column: 39)
!182 = distinct !DILexicalBlock(scope: !176, file: !3, line: 188, column: 5)
!183 = !DILocalVariable(name: "end", scope: !151, file: !3, line: 194, type: !171)
!184 = !DILocalVariable(name: "elapsed", scope: !151, file: !3, line: 197, type: !185)
!185 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!186 = !DILocalVariable(name: "passed", scope: !151, file: !3, line: 201, type: !187)
!187 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!188 = !DILocalVariable(name: "s", scope: !189, file: !172, line: 70, type: !26)
!189 = distinct !DISubprogram(name: "gettime", scope: !172, file: !172, line: 69, type: !190, scopeLine: 69, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !192)
!190 = !DISubroutineType(types: !191)
!191 = !{!171}
!192 = !{!188}
!193 = !DILocation(line: 70, column: 19, scope: !189, inlinedAt: !194)
!194 = distinct !DILocation(line: 194, column: 20, scope: !151)
!195 = !DILocation(line: 70, column: 19, scope: !189, inlinedAt: !196)
!196 = distinct !DILocation(line: 186, column: 22, scope: !151)
!197 = !DILocation(line: 0, scope: !151)
!198 = !DILocation(line: 161, column: 12, scope: !199)
!199 = distinct !DILexicalBlock(scope: !151, file: !3, line: 161, column: 7)
!200 = !DILocation(line: 161, column: 7, scope: !151)
!201 = !DILocation(line: 162, column: 17, scope: !199)
!202 = !{!203, !203, i64 0}
!203 = !{!"any pointer", !110, i64 0}
!204 = !DILocalVariable(name: "__nptr", arg: 1, scope: !205, file: !10, line: 361, type: !208)
!205 = distinct !DISubprogram(name: "atoi", scope: !10, file: !10, line: 361, type: !206, scopeLine: 362, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !210)
!206 = !DISubroutineType(types: !207)
!207 = !{!13, !208}
!208 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !209, size: 64)
!209 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !20)
!210 = !{!204}
!211 = !DILocation(line: 0, scope: !205, inlinedAt: !212)
!212 = distinct !DILocation(line: 162, column: 12, scope: !199)
!213 = !DILocation(line: 363, column: 16, scope: !205, inlinedAt: !212)
!214 = !DILocation(line: 363, column: 10, scope: !205, inlinedAt: !212)
!215 = !DILocation(line: 162, column: 5, scope: !199)
!216 = !DILocation(line: 165, column: 19, scope: !151)
!217 = !DILocation(line: 167, column: 20, scope: !151)
!218 = !DILocation(line: 172, column: 30, scope: !151)
!219 = !DILocation(line: 172, column: 28, scope: !151)
!220 = !DILocation(line: 172, column: 34, scope: !151)
!221 = !DILocation(line: 172, column: 21, scope: !151)
!222 = !DILocation(line: 172, column: 13, scope: !151)
!223 = !DILocation(line: 173, column: 21, scope: !151)
!224 = !DILocation(line: 173, column: 13, scope: !151)
!225 = !DILocation(line: 174, column: 21, scope: !151)
!226 = !DILocation(line: 174, column: 13, scope: !151)
!227 = !DILocation(line: 0, scope: !165)
!228 = !DILocation(line: 177, column: 21, scope: !169)
!229 = !DILocation(line: 177, column: 3, scope: !165)
!230 = !DILocation(line: 0, scope: !167)
!231 = !DILocation(line: 0, scope: !232)
!232 = distinct !DILexicalBlock(scope: !233, file: !3, line: 178, column: 33)
!233 = distinct !DILexicalBlock(scope: !167, file: !3, line: 178, column: 5)
!234 = !DILocation(line: 178, column: 5, scope: !167)
!235 = !DILocation(line: 179, column: 26, scope: !232)
!236 = !DILocation(line: 179, column: 20, scope: !232)
!237 = !DILocation(line: 179, column: 33, scope: !232)
!238 = !DILocation(line: 179, column: 13, scope: !232)
!239 = !DILocation(line: 179, column: 7, scope: !232)
!240 = !DILocation(line: 179, column: 18, scope: !232)
!241 = !DILocation(line: 180, column: 26, scope: !232)
!242 = !DILocation(line: 180, column: 20, scope: !232)
!243 = !DILocation(line: 180, column: 33, scope: !232)
!244 = !DILocation(line: 180, column: 7, scope: !232)
!245 = !DILocation(line: 180, column: 18, scope: !232)
!246 = !DILocation(line: 181, column: 7, scope: !232)
!247 = !DILocation(line: 181, column: 18, scope: !232)
!248 = !DILocation(line: 178, column: 28, scope: !233)
!249 = !DILocation(line: 178, column: 23, scope: !233)
!250 = distinct !{!250, !234, !251}
!251 = !DILocation(line: 182, column: 5, scope: !167)
!252 = !DILocation(line: 177, column: 26, scope: !169)
!253 = distinct !{!253, !229, !254}
!254 = !DILocation(line: 183, column: 3, scope: !165)
!255 = !DILocation(line: 72, column: 3, scope: !189, inlinedAt: !196)
!256 = !DILocation(line: 77, column: 3, scope: !189, inlinedAt: !196)
!257 = !DILocation(line: 0, scope: !174)
!258 = !DILocation(line: 187, column: 3, scope: !174)
!259 = !DILocation(line: 0, scope: !176)
!260 = !DILocation(line: 0, scope: !261)
!261 = distinct !DILexicalBlock(scope: !262, file: !3, line: 189, column: 41)
!262 = distinct !DILexicalBlock(scope: !180, file: !3, line: 189, column: 7)
!263 = !DILocation(line: 188, column: 5, scope: !176)
!264 = !DILocation(line: 187, column: 28, scope: !178)
!265 = !DILocation(line: 187, column: 21, scope: !178)
!266 = distinct !{!266, !258, !267}
!267 = !DILocation(line: 193, column: 3, scope: !174)
!268 = !DILocation(line: 0, scope: !180)
!269 = !DILocation(line: 189, column: 7, scope: !180)
!270 = !DILocation(line: 188, column: 30, scope: !182)
!271 = !DILocation(line: 188, column: 23, scope: !182)
!272 = distinct !{!272, !263, !273}
!273 = !DILocation(line: 192, column: 5, scope: !176)
!274 = !DILocation(line: 190, column: 28, scope: !261)
!275 = !DILocation(line: 190, column: 22, scope: !261)
!276 = !DILocation(line: 190, column: 54, scope: !261)
!277 = !DILocation(line: 190, column: 48, scope: !261)
!278 = !DILocation(line: 190, column: 9, scope: !261)
!279 = !DILocation(line: 189, column: 32, scope: !262)
!280 = !DILocation(line: 189, column: 25, scope: !262)
!281 = distinct !{!281, !269, !282}
!282 = !DILocation(line: 191, column: 7, scope: !180)
!283 = !DILocation(line: 72, column: 3, scope: !189, inlinedAt: !194)
!284 = !DILocation(line: 77, column: 3, scope: !189, inlinedAt: !194)
!285 = !DILocalVariable(name: "start", arg: 1, scope: !286, file: !172, line: 82, type: !171)
!286 = distinct !DISubprogram(name: "tdiff", scope: !172, file: !172, line: 82, type: !287, scopeLine: 82, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !289)
!287 = !DISubroutineType(types: !288)
!288 = !{!185, !171, !171}
!289 = !{!285, !290}
!290 = !DILocalVariable(name: "end", arg: 2, scope: !286, file: !172, line: 82, type: !171)
!291 = !DILocation(line: 0, scope: !286, inlinedAt: !292)
!292 = distinct !DILocation(line: 197, column: 20, scope: !151)
!293 = !DILocation(line: 83, column: 21, scope: !286, inlinedAt: !292)
!294 = !DILocation(line: 83, column: 10, scope: !286, inlinedAt: !292)
!295 = !DILocation(line: 83, column: 56, scope: !286, inlinedAt: !292)
!296 = !DILocation(line: 83, column: 43, scope: !286, inlinedAt: !292)
!297 = !DILocation(line: 83, column: 42, scope: !286, inlinedAt: !292)
!298 = !DILocation(line: 83, column: 36, scope: !286, inlinedAt: !292)
!299 = !DILocation(line: 198, column: 3, scope: !151)
!300 = !DILocation(line: 201, column: 17, scope: !151)
!301 = !DILocation(line: 204, column: 3, scope: !151)
!302 = !DILocation(line: 205, column: 3, scope: !151)
!303 = !DILocation(line: 206, column: 3, scope: !151)
!304 = !DILocation(line: 209, column: 10, scope: !151)
!305 = !DILocation(line: 210, column: 1, scope: !151)
!306 = distinct !DISubprogram(name: "check_correctness", scope: !3, file: !3, line: 120, type: !307, scopeLine: 121, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !309)
!307 = !DISubroutineType(types: !308)
!308 = !{!187, !55, !55, !55, !13}
!309 = !{!310, !311, !312, !313, !314, !315, !316, !318, !322, !324, !328, !332, !334}
!310 = !DILocalVariable(name: "C", arg: 1, scope: !306, file: !3, line: 120, type: !55)
!311 = !DILocalVariable(name: "A", arg: 2, scope: !306, file: !3, line: 120, type: !55)
!312 = !DILocalVariable(name: "B", arg: 3, scope: !306, file: !3, line: 121, type: !55)
!313 = !DILocalVariable(name: "n", arg: 4, scope: !306, file: !3, line: 121, type: !13)
!314 = !DILocalVariable(name: "passed", scope: !306, file: !3, line: 122, type: !187)
!315 = !DILocalVariable(name: "Ctmp", scope: !306, file: !3, line: 125, type: !6)
!316 = !DILocalVariable(name: "i", scope: !317, file: !3, line: 126, type: !13)
!317 = distinct !DILexicalBlock(scope: !306, file: !3, line: 126, column: 3)
!318 = !DILocalVariable(name: "j", scope: !319, file: !3, line: 127, type: !13)
!319 = distinct !DILexicalBlock(scope: !320, file: !3, line: 127, column: 5)
!320 = distinct !DILexicalBlock(scope: !321, file: !3, line: 126, column: 31)
!321 = distinct !DILexicalBlock(scope: !317, file: !3, line: 126, column: 3)
!322 = !DILocalVariable(name: "i", scope: !323, file: !3, line: 131, type: !13)
!323 = distinct !DILexicalBlock(scope: !306, file: !3, line: 131, column: 3)
!324 = !DILocalVariable(name: "j", scope: !325, file: !3, line: 132, type: !13)
!325 = distinct !DILexicalBlock(scope: !326, file: !3, line: 132, column: 5)
!326 = distinct !DILexicalBlock(scope: !327, file: !3, line: 131, column: 31)
!327 = distinct !DILexicalBlock(scope: !323, file: !3, line: 131, column: 3)
!328 = !DILocalVariable(name: "k", scope: !329, file: !3, line: 133, type: !13)
!329 = distinct !DILexicalBlock(scope: !330, file: !3, line: 133, column: 7)
!330 = distinct !DILexicalBlock(scope: !331, file: !3, line: 132, column: 33)
!331 = distinct !DILexicalBlock(scope: !325, file: !3, line: 132, column: 5)
!332 = !DILocalVariable(name: "i", scope: !333, file: !3, line: 138, type: !13)
!333 = distinct !DILexicalBlock(scope: !306, file: !3, line: 138, column: 3)
!334 = !DILocalVariable(name: "j", scope: !335, file: !3, line: 139, type: !13)
!335 = distinct !DILexicalBlock(scope: !336, file: !3, line: 139, column: 5)
!336 = distinct !DILexicalBlock(scope: !337, file: !3, line: 138, column: 31)
!337 = distinct !DILexicalBlock(scope: !333, file: !3, line: 138, column: 3)
!338 = !DILocation(line: 0, scope: !306)
!339 = !DILocation(line: 123, column: 11, scope: !306)
!340 = !DILocation(line: 123, column: 3, scope: !306)
!341 = !DILocation(line: 125, column: 33, scope: !306)
!342 = !DILocation(line: 125, column: 31, scope: !306)
!343 = !DILocation(line: 125, column: 37, scope: !306)
!344 = !DILocation(line: 125, column: 24, scope: !306)
!345 = !DILocation(line: 125, column: 16, scope: !306)
!346 = !DILocation(line: 0, scope: !317)
!347 = !DILocation(line: 126, column: 21, scope: !321)
!348 = !DILocation(line: 126, column: 3, scope: !317)
!349 = !DILocation(line: 0, scope: !350)
!350 = distinct !DILexicalBlock(scope: !351, file: !3, line: 127, column: 33)
!351 = distinct !DILexicalBlock(scope: !319, file: !3, line: 127, column: 5)
!352 = !DILocation(line: 0, scope: !319)
!353 = !DILocation(line: 128, column: 21, scope: !350)
!354 = distinct !{!354, !348, !355}
!355 = !DILocation(line: 130, column: 3, scope: !317)
!356 = distinct !{!356, !357}
!357 = !{!"llvm.loop.unroll.disable"}
!358 = !DILocation(line: 131, column: 3, scope: !323)
!359 = !DILocation(line: 0, scope: !329)
!360 = !DILocation(line: 0, scope: !323)
!361 = !DILocation(line: 0, scope: !325)
!362 = !DILocation(line: 0, scope: !363)
!363 = distinct !DILexicalBlock(scope: !364, file: !3, line: 133, column: 35)
!364 = distinct !DILexicalBlock(scope: !329, file: !3, line: 133, column: 7)
!365 = !DILocation(line: 132, column: 5, scope: !325)
!366 = !DILocation(line: 131, column: 26, scope: !327)
!367 = !DILocation(line: 131, column: 21, scope: !327)
!368 = distinct !{!368, !358, !369}
!369 = !DILocation(line: 137, column: 3, scope: !323)
!370 = !DILocation(line: 134, column: 23, scope: !363)
!371 = !DILocation(line: 133, column: 7, scope: !329)
!372 = !DILocation(line: 134, column: 32, scope: !363)
!373 = !DILocation(line: 134, column: 26, scope: !363)
!374 = !DILocation(line: 134, column: 42, scope: !363)
!375 = !DILocation(line: 134, column: 45, scope: !363)
!376 = !DILocation(line: 134, column: 39, scope: !363)
!377 = !DILocation(line: 134, column: 37, scope: !363)
!378 = !DILocation(line: 133, column: 30, scope: !364)
!379 = distinct !{!379, !357}
!380 = !DILocation(line: 132, column: 28, scope: !331)
!381 = !DILocation(line: 132, column: 23, scope: !331)
!382 = distinct !{!382, !365, !383}
!383 = !DILocation(line: 136, column: 5, scope: !325)
!384 = distinct !{!384, !371, !385}
!385 = !DILocation(line: 135, column: 7, scope: !329)
!386 = !DILocation(line: 0, scope: !333)
!387 = !DILocation(line: 0, scope: !335)
!388 = !DILocation(line: 0, scope: !389)
!389 = distinct !DILexicalBlock(scope: !390, file: !3, line: 140, column: 11)
!390 = distinct !DILexicalBlock(scope: !391, file: !3, line: 139, column: 33)
!391 = distinct !DILexicalBlock(scope: !335, file: !3, line: 139, column: 5)
!392 = !DILocation(line: 0, scope: !393)
!393 = distinct !DILexicalBlock(scope: !389, file: !3, line: 140, column: 53)
!394 = !DILocation(line: 139, column: 5, scope: !335)
!395 = !DILocation(line: 140, column: 31, scope: !389)
!396 = !DILocation(line: 140, column: 25, scope: !389)
!397 = !DILocation(line: 140, column: 37, scope: !389)
!398 = !DILocalVariable(name: "x", arg: 1, scope: !399, file: !3, line: 100, type: !7)
!399 = distinct !DISubprogram(name: "close_enough", scope: !3, file: !3, line: 100, type: !400, scopeLine: 100, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !402)
!400 = !DISubroutineType(types: !401)
!401 = !{!187, !7, !7}
!402 = !{!398, !403, !404, !407}
!403 = !DILocalVariable(name: "y", arg: 2, scope: !399, file: !3, line: 100, type: !7)
!404 = !DILocalVariable(name: "tmp", scope: !405, file: !3, line: 105, type: !7)
!405 = distinct !DILexicalBlock(scope: !406, file: !3, line: 104, column: 14)
!406 = distinct !DILexicalBlock(scope: !399, file: !3, line: 104, column: 7)
!407 = !DILocalVariable(name: "diff", scope: !399, file: !3, line: 110, type: !7)
!408 = !DILocation(line: 0, scope: !399, inlinedAt: !409)
!409 = distinct !DILocation(line: 140, column: 12, scope: !389)
!410 = !DILocation(line: 103, column: 10, scope: !399, inlinedAt: !409)
!411 = !DILocation(line: 103, column: 7, scope: !399, inlinedAt: !409)
!412 = !DILocation(line: 104, column: 9, scope: !406, inlinedAt: !409)
!413 = !DILocation(line: 104, column: 7, scope: !399, inlinedAt: !409)
!414 = !DILocation(line: 110, column: 17, scope: !399, inlinedAt: !409)
!415 = !DILocation(line: 112, column: 11, scope: !399, inlinedAt: !409)
!416 = !DILocation(line: 112, column: 16, scope: !399, inlinedAt: !409)
!417 = !DILocation(line: 112, column: 24, scope: !399, inlinedAt: !409)
!418 = !DILocation(line: 112, column: 33, scope: !399, inlinedAt: !409)
!419 = !DILocation(line: 112, column: 28, scope: !399, inlinedAt: !409)
!420 = !DILocation(line: 112, column: 37, scope: !399, inlinedAt: !409)
!421 = !DILocation(line: 140, column: 11, scope: !390)
!422 = !DILocation(line: 142, column: 17, scope: !393)
!423 = !DILocation(line: 144, column: 23, scope: !393)
!424 = !DILocation(line: 144, column: 35, scope: !393)
!425 = !DILocation(line: 142, column: 9, scope: !393)
!426 = !DILocation(line: 145, column: 7, scope: !393)
!427 = !DILocation(line: 139, column: 28, scope: !391)
!428 = !DILocation(line: 139, column: 23, scope: !391)
!429 = distinct !{!429, !394, !430}
!430 = !DILocation(line: 146, column: 5, scope: !335)
!431 = !DILocation(line: 138, column: 26, scope: !337)
!432 = !DILocation(line: 138, column: 21, scope: !337)
!433 = !DILocation(line: 138, column: 3, scope: !333)
!434 = distinct !{!434, !433, !435}
!435 = !DILocation(line: 147, column: 3, scope: !333)
!436 = !DILocation(line: 0, scope: !437)
!437 = distinct !DILexicalBlock(scope: !306, file: !3, line: 148, column: 7)
!438 = !DILocation(line: 148, column: 7, scope: !306)
!439 = !DILocation(line: 148, column: 8, scope: !437)
!440 = !DILocation(line: 149, column: 5, scope: !437)
!441 = !DILocation(line: 151, column: 5, scope: !437)
!442 = !DILocation(line: 153, column: 3, scope: !306)
!443 = !DILocation(line: 154, column: 3, scope: !306)
