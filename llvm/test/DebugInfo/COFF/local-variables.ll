; RUN: llc -mtriple=x86_64-windows-msvc < %s | FileCheck %s --check-prefix=ASM
; RUN: llc -mtriple=x86_64-windows-msvc < %s -filetype=obj | llvm-readobj --codeview - | FileCheck %s --check-prefix=OBJ

; This LL file was generated by running 'clang -g -gcodeview' on the
; following code:
;  1: extern "C" volatile int x;
;  2: extern "C" void capture(int *p);
;  3: static __forceinline inline void will_be_inlined() {
;  4:   int v = 3;
;  5:   capture(&v);
;  6: }
;  7: extern "C" void f(int param) {
;  8:   if (param) {
;  9:     int a = 42;
; 10:     will_be_inlined();
; 11:     capture(&a);
; 12:   } else {
; 13:     int b = 42;
; 14:     will_be_inlined();
; 15:     capture(&b);
; 16:   }
; 17: }

; ASM: f:                                      # @f
; ASM:         .cv_func_id 0
; ASM:         .cv_file        1 "D:\\src\\llvm\\build\\t.cpp"
; ASM:         .cv_loc 0 1 7 0       # t.cpp:7:0
; ASM: .seh_proc f
; ASM: # %bb.0:                                 # %entry
; ASM:         subq    $56, %rsp
; ASM:         movl    %ecx, 52(%rsp)
; ASM: [[prologue_end:\.Ltmp.*]]:
; ASM:         .cv_loc 0 1 8 7                 # t.cpp:8:7
; ASM:         testl   %ecx, %ecx
; ASM:         je      .LBB0_2
; ASM: # %bb.1:                                 # %if.then
; ASM: [[if_start:\.Ltmp.*]]:
; ASM:         .cv_loc 0 1 9 9                 # t.cpp:9:9
; ASM:         movl    $42, 40(%rsp)
; ASM: [[inline_site1:\.Ltmp.*]]:
; ASM:         .cv_inline_site_id 1 within 0 inlined_at 1 10 5
; ASM:         .cv_loc 1 1 4 7                 # t.cpp:4:7
; ASM:         movl    $3, 44(%rsp)
; ASM:         leaq    44(%rsp), %rcx
; ASM:         .cv_loc 1 1 5 3                 # t.cpp:5:3
; ASM:         callq   capture
; ASM:         leaq    40(%rsp), %rcx
; ASM: [[end_inline_1:\.Ltmp.*]]:
; ASM:         .cv_loc 0 1 11 5                # t.cpp:11:5
; ASM:         jmp     .LBB0_3
; ASM: [[else_start:\.Ltmp.*]]:
; ASM: .LBB0_2:                                # %if.else
; ASM:         .cv_loc 0 1 13 9                # t.cpp:13:9
; ASM:         movl    $42, 36(%rsp)
; ASM: [[inline_site2:\.Ltmp.*]]:
; ASM:         .cv_inline_site_id 2 within 0 inlined_at 1 14 5
; ASM:         .cv_loc 2 1 4 7                 # t.cpp:4:7
; ASM:         movl    $3, 48(%rsp)
; ASM:         leaq    48(%rsp), %rcx
; ASM:         .cv_loc 2 1 5 3                 # t.cpp:5:3
; ASM:         callq   capture
; ASM:         leaq    36(%rsp), %rcx
; ASM: [[else_end:\.Ltmp.*]]:
; ASM: .LBB0_3:                                # %if.end
; ASM:         .cv_loc 0 1 17 1                # t.cpp:17:1
; ASM:         callq   capture
; ASM:         nop
; ASM:         addq    $56, %rsp
; ASM:         retq
; ASM: [[param_end:\.Ltmp.*]]:

; ASM: .short  4414                    # Record kind: S_LOCAL
; ASM: .long   116                     # TypeIndex
; ASM: .short  1                       # Flags
; ASM: .asciz  "param"
; ASM: .cv_def_range    [[prologue_end]] [[param_end]], frame_ptr_rel, 52
; ASM: .short  4414                    # Record kind: S_LOCAL
; ASM: .long   116                     # TypeIndex
; ASM: .short  0                       # Flags
; ASM: .asciz  "a"
; ASM: .cv_def_range    [[if_start]] [[else_start]], frame_ptr_rel, 40
; ASM: .short  4414                    # Record kind: S_LOCAL
; ASM: .long   116                     # TypeIndex
; ASM: .short  0                       # Flags
; ASM: .asciz  "b"
; ASM: .cv_def_range    [[else_start]] [[else_end]], frame_ptr_rel, 36
; ASM: .short  4429                    # Record kind: S_INLINESITE
; ASM: .short  4414                    # Record kind: S_LOCAL
; ASM: .long   116                     # TypeIndex
; ASM: .short  0                       # Flags
; ASM: .asciz  "v"
; ASM: .cv_def_range    [[inline_site1]] [[end_inline_1]], frame_ptr_rel, 44
; ASM: .short  4430                    # Record kind: S_INLINESITE_END
; ASM: .short  4429                    # Record kind: S_INLINESITE
; ASM: .short  4414                    # Record kind: S_LOCAL
; ASM: .long   116                     # TypeIndex
; ASM: .short  0                       # Flags
; ASM: .asciz  "v"
; ASM: .cv_def_range    [[inline_site2]] [[else_end]], frame_ptr_rel, 48
; ASM: .short  4430                    # Record kind: S_INLINESITE_END

; OBJ:  Subsection [
; OBJ:    SubSectionType: Symbols (0xF1)
; OBJ:    {{.*}}Proc{{.*}}Sym {
; OBJ:      DisplayName: f
; OBJ:      LinkageName: f
; OBJ:    }
; OBJ:    LocalSym {
; OBJ:      Type: int (0x74)
; OBJ:      Flags [ (0x1)
; OBJ:        IsParameter (0x1)
; OBJ:      ]
; OBJ:      VarName: param
; OBJ:    }
; OBJ:    DefRangeFramePointerRelSym {
; OBJ:      Offset: 52
; OBJ:      LocalVariableAddrRange {
; OBJ:        OffsetStart: .text+0x8
; OBJ:        ISectStart: 0x0
; OBJ:        Range: 0x4F
; OBJ:      }
; OBJ:    }
; OBJ:    LocalSym {
; OBJ:      Type: int (0x74)
; OBJ:      Flags [ (0x0)
; OBJ:      ]
; OBJ:      VarName: a
; OBJ:    }
; OBJ:    DefRangeFramePointerRelSym {
; OBJ:      Offset: 40
; OBJ:      LocalVariableAddrRange {
; OBJ:        OffsetStart: .text+0xC
; OBJ:        ISectStart: 0x0
; OBJ:        Range: 0x21
; OBJ:      }
; OBJ:    }
; OBJ:    LocalSym {
; OBJ:      Type: int (0x74)
; OBJ:      Flags [ (0x0)
; OBJ:      ]
; OBJ:      VarName: b
; OBJ:    }
; OBJ:    DefRangeFramePointerRelSym {
; OBJ:      Offset: 36
; OBJ:      LocalVariableAddrRange {
; OBJ:        OffsetStart: .text+0x2D
; OBJ:        ISectStart: 0x0
; OBJ:        Range: 0x1F
; OBJ:      }
; OBJ:    }
; OBJ:    InlineSiteSym {
; OBJ:      PtrParent: 0x0
; OBJ:      PtrEnd: 0x0
; OBJ:      Inlinee: will_be_inlined (0x1002)
; OBJ:      BinaryAnnotations [
; OBJ:        ChangeLineOffset: 1
; OBJ:        ChangeCodeOffset: 0x14
; OBJ:        ChangeCodeOffsetAndLineOffset: {CodeOffset: 0xD, LineOffset: 1}
; OBJ:        ChangeCodeLength: 0xA
; OBJ:      ]
; OBJ:    }
; OBJ:    LocalSym {
; OBJ:      Type: int (0x74)
; OBJ:      Flags [ (0x0)
; OBJ:      ]
; OBJ:      VarName: v
; OBJ:    }
; OBJ:    DefRangeFramePointerRelSym {
; OBJ:      Offset: 44
; OBJ:      LocalVariableAddrRange {
; OBJ:        OffsetStart: .text+0x14
; OBJ:        ISectStart: 0x0
; OBJ:        Range: 0x17
; OBJ:      }
; OBJ:    }
; OBJ:    InlineSiteEnd {
; OBJ:    }
; OBJ:    InlineSiteSym {
; OBJ:      PtrParent: 0x0
; OBJ:      PtrEnd: 0x0
; OBJ:      Inlinee: will_be_inlined (0x1002)
; OBJ:      BinaryAnnotations [
; OBJ:        ChangeLineOffset: 1
; OBJ:        ChangeCodeOffset: 0x35
; OBJ:        ChangeCodeOffsetAndLineOffset: {CodeOffset: 0xD, LineOffset: 1}
; OBJ:        ChangeCodeLength: 0xA
; OBJ:      ]
; OBJ:    }
; OBJ:    LocalSym {
; OBJ:      Type: int (0x74)
; OBJ:      Flags [ (0x0)
; OBJ:      ]
; OBJ:      VarName: v
; OBJ:    }
; OBJ:    DefRangeFramePointerRelSym {
; OBJ:      Offset: 48
; OBJ:      LocalVariableAddrRange {
; OBJ:        OffsetStart: .text+0x35
; OBJ:        ISectStart: 0x0
; OBJ:        Range: 0x17
; OBJ:      }
; OBJ:    }
; OBJ:    InlineSiteEnd {
; OBJ:    }
; OBJ:    ProcEnd
; OBJ:  ]

; ModuleID = 't.cpp'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc18.0.0"

; Function Attrs: nounwind uwtable
define void @f(i32 %param) #0 !dbg !4 {
entry:
  %v.i1 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata ptr %v.i1, metadata !15, metadata !16), !dbg !17
  %v.i = alloca i32, align 4
  call void @llvm.dbg.declare(metadata ptr %v.i, metadata !15, metadata !16), !dbg !21
  %param.addr = alloca i32, align 4
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  store i32 %param, ptr %param.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %param.addr, metadata !24, metadata !16), !dbg !25
  %0 = load i32, ptr %param.addr, align 4, !dbg !26
  %tobool = icmp ne i32 %0, 0, !dbg !26
  br i1 %tobool, label %if.then, label %if.else, !dbg !27

if.then:                                          ; preds = %entry
  call void @llvm.dbg.declare(metadata ptr %a, metadata !28, metadata !16), !dbg !29
  store i32 42, ptr %a, align 4, !dbg !29
  store i32 3, ptr %v.i, align 4, !dbg !21
  call void @capture(ptr %v.i) #3, !dbg !30
  call void @capture(ptr %a), !dbg !31
  br label %if.end, !dbg !32

if.else:                                          ; preds = %entry
  call void @llvm.dbg.declare(metadata ptr %b, metadata !33, metadata !16), !dbg !34
  store i32 42, ptr %b, align 4, !dbg !34
  store i32 3, ptr %v.i1, align 4, !dbg !17
  call void @capture(ptr %v.i1) #3, !dbg !35
  call void @capture(ptr %b), !dbg !36
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void, !dbg !37
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @capture(ptr) #2

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "frame-pointer"="none" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "frame-pointer"="none" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!11, !12, !13}
!llvm.ident = !{!14}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 3.9.0 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2)
!1 = !DIFile(filename: "t.cpp", directory: "D:\5Csrc\5Cllvm\5Cbuild")
!2 = !{}
!4 = distinct !DISubprogram(name: "f", scope: !1, file: !1, line: 7, type: !5, isLocal: false, isDefinition: true, scopeLine: 7, flags: DIFlagPrototyped, isOptimized: false, unit: !0, retainedNodes: !2)
!5 = !DISubroutineType(types: !6)
!6 = !{null, !7}
!7 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!8 = distinct !DISubprogram(name: "will_be_inlined", linkageName: "\01?will_be_inlined@@YAXXZ", scope: !1, file: !1, line: 3, type: !9, isLocal: true, isDefinition: true, scopeLine: 3, flags: DIFlagPrototyped, isOptimized: false, unit: !0, retainedNodes: !2)
!9 = !DISubroutineType(types: !10)
!10 = !{null}
!11 = !{i32 2, !"CodeView", i32 1}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"PIC Level", i32 2}
!14 = !{!"clang version 3.9.0 "}
!15 = !DILocalVariable(name: "v", scope: !8, file: !1, line: 4, type: !7)
!16 = !DIExpression()
!17 = !DILocation(line: 4, column: 7, scope: !8, inlinedAt: !18)
!18 = distinct !DILocation(line: 14, column: 5, scope: !19)
!19 = distinct !DILexicalBlock(scope: !20, file: !1, line: 12, column: 10)
!20 = distinct !DILexicalBlock(scope: !4, file: !1, line: 8, column: 7)
!21 = !DILocation(line: 4, column: 7, scope: !8, inlinedAt: !22)
!22 = distinct !DILocation(line: 10, column: 5, scope: !23)
!23 = distinct !DILexicalBlock(scope: !20, file: !1, line: 8, column: 14)
!24 = !DILocalVariable(name: "param", arg: 1, scope: !4, file: !1, line: 7, type: !7)
!25 = !DILocation(line: 7, column: 23, scope: !4)
!26 = !DILocation(line: 8, column: 7, scope: !20)
!27 = !DILocation(line: 8, column: 7, scope: !4)
!28 = !DILocalVariable(name: "a", scope: !23, file: !1, line: 9, type: !7)
!29 = !DILocation(line: 9, column: 9, scope: !23)
!30 = !DILocation(line: 5, column: 3, scope: !8, inlinedAt: !22)
!31 = !DILocation(line: 11, column: 5, scope: !23)
!32 = !DILocation(line: 12, column: 3, scope: !23)
!33 = !DILocalVariable(name: "b", scope: !19, file: !1, line: 13, type: !7)
!34 = !DILocation(line: 13, column: 9, scope: !19)
!35 = !DILocation(line: 5, column: 3, scope: !8, inlinedAt: !18)
!36 = !DILocation(line: 15, column: 5, scope: !19)
!37 = !DILocation(line: 17, column: 1, scope: !4)
