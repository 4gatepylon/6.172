; ModuleID = 'example3.c'
source_filename = "example3.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: argmemonly nofree norecurse nounwind uwtable
define dso_local void @test(i8* noalias nocapture %a, i8* noalias nocapture readonly %b) local_unnamed_addr #0 !dbg !7 {
entry:
  call void @llvm.dbg.value(metadata i8* %a, metadata !18, metadata !DIExpression()), !dbg !24
  call void @llvm.dbg.value(metadata i8* %b, metadata !19, metadata !DIExpression()), !dbg !24
  call void @llvm.dbg.value(metadata i64 0, metadata !20, metadata !DIExpression()), !dbg !24
  br label %vector.body, !dbg !25

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next.3, %vector.body ], !dbg !27
  %0 = getelementptr inbounds i8, i8* %b, i64 %index, !dbg !29
  %1 = bitcast i8* %0 to <16 x i8>*, !dbg !29
  %wide.load = load <16 x i8>, <16 x i8>* %1, align 1, !dbg !29, !tbaa !31
  %2 = getelementptr inbounds i8, i8* %0, i64 16, !dbg !29
  %3 = bitcast i8* %2 to <16 x i8>*, !dbg !29
  %wide.load9 = load <16 x i8>, <16 x i8>* %3, align 1, !dbg !29, !tbaa !31
  %4 = shl <16 x i8> %wide.load, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>, !dbg !34
  %5 = shl <16 x i8> %wide.load9, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>, !dbg !34
  %6 = getelementptr inbounds i8, i8* %a, i64 %index, !dbg !35
  %7 = bitcast i8* %6 to <16 x i8>*, !dbg !36
  store <16 x i8> %4, <16 x i8>* %7, align 1, !dbg !36, !tbaa !31
  %8 = getelementptr inbounds i8, i8* %6, i64 16, !dbg !36
  %9 = bitcast i8* %8 to <16 x i8>*, !dbg !36
  store <16 x i8> %5, <16 x i8>* %9, align 1, !dbg !36, !tbaa !31
  %index.next = or i64 %index, 32, !dbg !27
  %10 = getelementptr inbounds i8, i8* %b, i64 %index.next, !dbg !29
  %11 = bitcast i8* %10 to <16 x i8>*, !dbg !29
  %wide.load.1 = load <16 x i8>, <16 x i8>* %11, align 1, !dbg !29, !tbaa !31
  %12 = getelementptr inbounds i8, i8* %10, i64 16, !dbg !29
  %13 = bitcast i8* %12 to <16 x i8>*, !dbg !29
  %wide.load9.1 = load <16 x i8>, <16 x i8>* %13, align 1, !dbg !29, !tbaa !31
  %14 = shl <16 x i8> %wide.load.1, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>, !dbg !34
  %15 = shl <16 x i8> %wide.load9.1, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>, !dbg !34
  %16 = getelementptr inbounds i8, i8* %a, i64 %index.next, !dbg !35
  %17 = bitcast i8* %16 to <16 x i8>*, !dbg !36
  store <16 x i8> %14, <16 x i8>* %17, align 1, !dbg !36, !tbaa !31
  %18 = getelementptr inbounds i8, i8* %16, i64 16, !dbg !36
  %19 = bitcast i8* %18 to <16 x i8>*, !dbg !36
  store <16 x i8> %15, <16 x i8>* %19, align 1, !dbg !36, !tbaa !31
  %index.next.1 = or i64 %index, 64, !dbg !27
  %20 = getelementptr inbounds i8, i8* %b, i64 %index.next.1, !dbg !29
  %21 = bitcast i8* %20 to <16 x i8>*, !dbg !29
  %wide.load.2 = load <16 x i8>, <16 x i8>* %21, align 1, !dbg !29, !tbaa !31
  %22 = getelementptr inbounds i8, i8* %20, i64 16, !dbg !29
  %23 = bitcast i8* %22 to <16 x i8>*, !dbg !29
  %wide.load9.2 = load <16 x i8>, <16 x i8>* %23, align 1, !dbg !29, !tbaa !31
  %24 = shl <16 x i8> %wide.load.2, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>, !dbg !34
  %25 = shl <16 x i8> %wide.load9.2, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>, !dbg !34
  %26 = getelementptr inbounds i8, i8* %a, i64 %index.next.1, !dbg !35
  %27 = bitcast i8* %26 to <16 x i8>*, !dbg !36
  store <16 x i8> %24, <16 x i8>* %27, align 1, !dbg !36, !tbaa !31
  %28 = getelementptr inbounds i8, i8* %26, i64 16, !dbg !36
  %29 = bitcast i8* %28 to <16 x i8>*, !dbg !36
  store <16 x i8> %25, <16 x i8>* %29, align 1, !dbg !36, !tbaa !31
  %index.next.2 = or i64 %index, 96, !dbg !27
  %30 = getelementptr inbounds i8, i8* %b, i64 %index.next.2, !dbg !29
  %31 = bitcast i8* %30 to <16 x i8>*, !dbg !29
  %wide.load.3 = load <16 x i8>, <16 x i8>* %31, align 1, !dbg !29, !tbaa !31
  %32 = getelementptr inbounds i8, i8* %30, i64 16, !dbg !29
  %33 = bitcast i8* %32 to <16 x i8>*, !dbg !29
  %wide.load9.3 = load <16 x i8>, <16 x i8>* %33, align 1, !dbg !29, !tbaa !31
  %34 = shl <16 x i8> %wide.load.3, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>, !dbg !34
  %35 = shl <16 x i8> %wide.load9.3, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>, !dbg !34
  %36 = getelementptr inbounds i8, i8* %a, i64 %index.next.2, !dbg !35
  %37 = bitcast i8* %36 to <16 x i8>*, !dbg !36
  store <16 x i8> %34, <16 x i8>* %37, align 1, !dbg !36, !tbaa !31
  %38 = getelementptr inbounds i8, i8* %36, i64 16, !dbg !36
  %39 = bitcast i8* %38 to <16 x i8>*, !dbg !36
  store <16 x i8> %35, <16 x i8>* %39, align 1, !dbg !36, !tbaa !31
  %index.next.3 = add nuw nsw i64 %index, 128, !dbg !27
  %40 = icmp eq i64 %index.next.3, 65536, !dbg !27
  br i1 %40, label %for.end, label %vector.body, !dbg !27, !llvm.loop !37

for.end:                                          ; preds = %vector.body
  ret void, !dbg !40
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { argmemonly nofree norecurse nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="haswell" "target-features"="+bmi,+bmi2,+cx16,+cx8,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+rdrnd,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,-avx,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512er,-avx512f,-avx512ifma,-avx512pf,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-f16c,-fma,-fma4,-vaes,-vpclmulqdq,-xop,-xsave,-xsaveopt" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 10.0.1 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "example3.c", directory: "/home/ubuntu/git/homework3_adrianoh/compilervec")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 10.0.1 "}
!7 = distinct !DISubprogram(name: "test", scope: !1, file: !1, line: 9, type: !8, scopeLine: 9, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !17)
!8 = !DISubroutineType(types: !9)
!9 = !{null, !10, !10}
!10 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !11)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !13, line: 24, baseType: !14)
!13 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !15, line: 37, baseType: !16)
!15 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!16 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!17 = !{!18, !19, !20}
!18 = !DILocalVariable(name: "a", arg: 1, scope: !7, file: !1, line: 9, type: !10)
!19 = !DILocalVariable(name: "b", arg: 2, scope: !7, file: !1, line: 9, type: !10)
!20 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 10, type: !21)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !13, line: 27, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !15, line: 44, baseType: !23)
!23 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!24 = !DILocation(line: 0, scope: !7)
!25 = !DILocation(line: 12, column: 3, scope: !26)
!26 = distinct !DILexicalBlock(scope: !7, file: !1, line: 12, column: 3)
!27 = !DILocation(line: 12, column: 26, scope: !28)
!28 = distinct !DILexicalBlock(scope: !26, file: !1, line: 12, column: 3)
!29 = !DILocation(line: 13, column: 12, scope: !30)
!30 = distinct !DILexicalBlock(scope: !28, file: !1, line: 12, column: 30)
!31 = !{!32, !32, i64 0}
!32 = !{!"omnipotent char", !33, i64 0}
!33 = !{!"Simple C/C++ TBAA"}
!34 = !DILocation(line: 13, column: 17, scope: !30)
!35 = !DILocation(line: 13, column: 5, scope: !30)
!36 = !DILocation(line: 13, column: 10, scope: !30)
!37 = distinct !{!37, !25, !38, !39}
!38 = !DILocation(line: 14, column: 3, scope: !26)
!39 = !{!"llvm.loop.isvectorized", i32 1}
!40 = !DILocation(line: 15, column: 1, scope: !7)
