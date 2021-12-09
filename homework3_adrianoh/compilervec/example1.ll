; ModuleID = 'example1.c'
source_filename = "example1.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: norecurse nounwind uwtable
define dso_local void @test(i8* noalias %a, i8* noalias %b) local_unnamed_addr #0 !dbg !7 {
entry:
  call void @llvm.dbg.value(metadata i8* %a, metadata !18, metadata !DIExpression()), !dbg !24
  call void @llvm.dbg.value(metadata i8* %b, metadata !19, metadata !DIExpression()), !dbg !24
  %ptrint = ptrtoint i8* %a to i64, !dbg !25
  %maskedptr = and i64 %ptrint, 31, !dbg !25
  %maskcond = icmp eq i64 %maskedptr, 0, !dbg !25
  tail call void @llvm.assume(i1 %maskcond), !dbg !25
  %ptrint1 = ptrtoint i8* %b to i64, !dbg !26
  %maskedptr2 = and i64 %ptrint1, 31, !dbg !26
  %maskcond3 = icmp eq i64 %maskedptr2, 0, !dbg !26
  tail call void @llvm.assume(i1 %maskcond3), !dbg !26
  call void @llvm.dbg.value(metadata i64 0, metadata !20, metadata !DIExpression()), !dbg !24
  br label %vector.body, !dbg !27

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next.1, %vector.body ], !dbg !29
  %0 = getelementptr inbounds i8, i8* %b, i64 %index, !dbg !31
  %1 = bitcast i8* %0 to <32 x i8>*, !dbg !31
  %wide.load = load <32 x i8>, <32 x i8>* %1, align 32, !dbg !31, !tbaa !33
  %2 = getelementptr inbounds i8, i8* %0, i64 32, !dbg !31
  %3 = bitcast i8* %2 to <32 x i8>*, !dbg !31
  %wide.load17 = load <32 x i8>, <32 x i8>* %3, align 32, !dbg !31, !tbaa !33
  %4 = getelementptr inbounds i8, i8* %0, i64 64, !dbg !31
  %5 = bitcast i8* %4 to <32 x i8>*, !dbg !31
  %wide.load18 = load <32 x i8>, <32 x i8>* %5, align 32, !dbg !31, !tbaa !33
  %6 = getelementptr inbounds i8, i8* %0, i64 96, !dbg !31
  %7 = bitcast i8* %6 to <32 x i8>*, !dbg !31
  %wide.load19 = load <32 x i8>, <32 x i8>* %7, align 32, !dbg !31, !tbaa !33
  %8 = getelementptr inbounds i8, i8* %a, i64 %index, !dbg !36
  %9 = bitcast i8* %8 to <32 x i8>*, !dbg !37
  %wide.load20 = load <32 x i8>, <32 x i8>* %9, align 32, !dbg !37, !tbaa !33
  %10 = getelementptr inbounds i8, i8* %8, i64 32, !dbg !37
  %11 = bitcast i8* %10 to <32 x i8>*, !dbg !37
  %wide.load21 = load <32 x i8>, <32 x i8>* %11, align 32, !dbg !37, !tbaa !33
  %12 = getelementptr inbounds i8, i8* %8, i64 64, !dbg !37
  %13 = bitcast i8* %12 to <32 x i8>*, !dbg !37
  %wide.load22 = load <32 x i8>, <32 x i8>* %13, align 32, !dbg !37, !tbaa !33
  %14 = getelementptr inbounds i8, i8* %8, i64 96, !dbg !37
  %15 = bitcast i8* %14 to <32 x i8>*, !dbg !37
  %wide.load23 = load <32 x i8>, <32 x i8>* %15, align 32, !dbg !37, !tbaa !33
  %16 = add <32 x i8> %wide.load20, %wide.load, !dbg !37
  %17 = add <32 x i8> %wide.load21, %wide.load17, !dbg !37
  %18 = add <32 x i8> %wide.load22, %wide.load18, !dbg !37
  %19 = add <32 x i8> %wide.load23, %wide.load19, !dbg !37
  store <32 x i8> %16, <32 x i8>* %9, align 32, !dbg !37, !tbaa !33
  store <32 x i8> %17, <32 x i8>* %11, align 32, !dbg !37, !tbaa !33
  store <32 x i8> %18, <32 x i8>* %13, align 32, !dbg !37, !tbaa !33
  store <32 x i8> %19, <32 x i8>* %15, align 32, !dbg !37, !tbaa !33
  %index.next = or i64 %index, 128, !dbg !29
  %20 = getelementptr inbounds i8, i8* %b, i64 %index.next, !dbg !31
  %21 = bitcast i8* %20 to <32 x i8>*, !dbg !31
  %wide.load.1 = load <32 x i8>, <32 x i8>* %21, align 32, !dbg !31, !tbaa !33
  %22 = getelementptr inbounds i8, i8* %20, i64 32, !dbg !31
  %23 = bitcast i8* %22 to <32 x i8>*, !dbg !31
  %wide.load17.1 = load <32 x i8>, <32 x i8>* %23, align 32, !dbg !31, !tbaa !33
  %24 = getelementptr inbounds i8, i8* %20, i64 64, !dbg !31
  %25 = bitcast i8* %24 to <32 x i8>*, !dbg !31
  %wide.load18.1 = load <32 x i8>, <32 x i8>* %25, align 32, !dbg !31, !tbaa !33
  %26 = getelementptr inbounds i8, i8* %20, i64 96, !dbg !31
  %27 = bitcast i8* %26 to <32 x i8>*, !dbg !31
  %wide.load19.1 = load <32 x i8>, <32 x i8>* %27, align 32, !dbg !31, !tbaa !33
  %28 = getelementptr inbounds i8, i8* %a, i64 %index.next, !dbg !36
  %29 = bitcast i8* %28 to <32 x i8>*, !dbg !37
  %wide.load20.1 = load <32 x i8>, <32 x i8>* %29, align 32, !dbg !37, !tbaa !33
  %30 = getelementptr inbounds i8, i8* %28, i64 32, !dbg !37
  %31 = bitcast i8* %30 to <32 x i8>*, !dbg !37
  %wide.load21.1 = load <32 x i8>, <32 x i8>* %31, align 32, !dbg !37, !tbaa !33
  %32 = getelementptr inbounds i8, i8* %28, i64 64, !dbg !37
  %33 = bitcast i8* %32 to <32 x i8>*, !dbg !37
  %wide.load22.1 = load <32 x i8>, <32 x i8>* %33, align 32, !dbg !37, !tbaa !33
  %34 = getelementptr inbounds i8, i8* %28, i64 96, !dbg !37
  %35 = bitcast i8* %34 to <32 x i8>*, !dbg !37
  %wide.load23.1 = load <32 x i8>, <32 x i8>* %35, align 32, !dbg !37, !tbaa !33
  %36 = add <32 x i8> %wide.load20.1, %wide.load.1, !dbg !37
  %37 = add <32 x i8> %wide.load21.1, %wide.load17.1, !dbg !37
  %38 = add <32 x i8> %wide.load22.1, %wide.load18.1, !dbg !37
  %39 = add <32 x i8> %wide.load23.1, %wide.load19.1, !dbg !37
  store <32 x i8> %36, <32 x i8>* %29, align 32, !dbg !37, !tbaa !33
  store <32 x i8> %37, <32 x i8>* %31, align 32, !dbg !37, !tbaa !33
  store <32 x i8> %38, <32 x i8>* %33, align 32, !dbg !37, !tbaa !33
  store <32 x i8> %39, <32 x i8>* %35, align 32, !dbg !37, !tbaa !33
  %index.next.1 = add nuw nsw i64 %index, 256, !dbg !29
  %40 = icmp eq i64 %index.next.1, 65536, !dbg !29
  br i1 %40, label %for.end, label %vector.body, !dbg !29, !llvm.loop !38

for.end:                                          ; preds = %vector.body
  ret void, !dbg !41
}

; Function Attrs: nounwind willreturn
declare void @llvm.assume(i1) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { norecurse nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="haswell" "target-features"="+avx,+avx2,+bmi,+bmi2,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+rdrnd,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind willreturn }
attributes #2 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 10.0.1 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "example1.c", directory: "/home/ubuntu/git/homework3_adrianoh/compilervec")
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
!25 = !DILocation(line: 12, column: 7, scope: !7)
!26 = !DILocation(line: 13, column: 7, scope: !7)
!27 = !DILocation(line: 15, column: 3, scope: !28)
!28 = distinct !DILexicalBlock(scope: !7, file: !1, line: 15, column: 3)
!29 = !DILocation(line: 15, column: 26, scope: !30)
!30 = distinct !DILexicalBlock(scope: !28, file: !1, line: 15, column: 3)
!31 = !DILocation(line: 16, column: 13, scope: !32)
!32 = distinct !DILexicalBlock(scope: !30, file: !1, line: 15, column: 30)
!33 = !{!34, !34, i64 0}
!34 = !{!"omnipotent char", !35, i64 0}
!35 = !{!"Simple C/C++ TBAA"}
!36 = !DILocation(line: 16, column: 5, scope: !32)
!37 = !DILocation(line: 16, column: 10, scope: !32)
!38 = distinct !{!38, !27, !39, !40}
!39 = !DILocation(line: 17, column: 3, scope: !28)
!40 = !{!"llvm.loop.isvectorized", i32 1}
!41 = !DILocation(line: 18, column: 1, scope: !7)
