; RUN: opt %loadNPMPolly -polly-invariant-load-hoisting=true '-passes=print<polly-function-scops>' -disable-output < %s 2>&1 | FileCheck %s
; RUN: opt %loadNPMPolly -polly-invariant-load-hoisting=true -polly-overflow-tracking=never -passes=polly-codegen -S < %s | FileCheck %s --check-prefix=IR
;
; As (p + q) can overflow we have to check that we load from
; I[p + q] only if it does not.
;
; CHECK:         Invariant Accesses: {
; CHECK-NEXT:            ReadAccess :=	[Reduction Type: NONE] [Scalar: 0]
; CHECK-NEXT:                [N, p, q] -> { Stmt_for_body[i0] -> MemRef_I[p + q] };
; CHECK-NEXT:            Execution Context: [N, p, q] -> {  : N > 0 and -2147483648 - p <= q <= 2147483647 - p }
; CHECK-NEXT:            ReadAccess :=	[Reduction Type: NONE] [Scalar: 0]
; CHECK-NEXT:                [N, p, q] -> { Stmt_for_body[i0] -> MemRef_tmp1[0] };
; CHECK-NEXT:            Execution Context: [N, p, q] -> {  : N > 0 }
; CHECK-NEXT:    }
;
; IR:      polly.preload.merge:
; IR-NEXT:   %polly.preload.tmp1.merge = phi ptr [ %polly.access.I.load, %polly.preload.exec ], [ null, %polly.preload.cond ]
; IR-NEXT:   store ptr %polly.preload.tmp1.merge, ptr %tmp1.preload.s2a
; IR-NEXT:   %12 = sext i32 %N to i64
; IR-NEXT:   %13 = icmp sge i64 %12, 1
; IR-NEXT:   %14 = sext i32 %q to i64
; IR-NEXT:   %15 = sext i32 %p to i64
; IR-NEXT:   %16 = add nsw i64 %15, %14
; IR-NEXT:   %17 = icmp sle i64 %16, 2147483647
; IR-NEXT:   %18 = and i1 %13, %17
; IR-NEXT:   %19 = sext i32 %q to i64
; IR-NEXT:   %20 = sext i32 %p to i64
; IR-NEXT:   %21 = add nsw i64 %20, %19
; IR-NEXT:   %22 = icmp sge i64 %21, -2147483648
; IR-NEXT:   %23 = and i1 %18, %22
; IR-NEXT:   %polly.preload.cond.result1 = and i1 %23, true
; IR-NEXT:   br label %polly.preload.cond2
;
; IR:      polly.preload.cond2:
; IR-NEXT:   br i1 %polly.preload.cond.result1
;
; IR:      polly.preload.exec4:
; IR-NEXT:   %polly.access.polly.preload.tmp1.merge = getelementptr i32, ptr %polly.preload.tmp1.merge, i64 0
; IR-NEXT:   %polly.access.polly.preload.tmp1.merge.load = load i32, ptr %polly.access.polly.preload.tmp1.merge, align 4
;
;    void f(int **I, int *A, int N, int p, int q) {
;      for (int i = 0; i < N; i++)
;        A[i] = *(I[p + q]);
;    }
;
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define void @f(ptr %I, ptr %A, i32 %N, i32 %p, i32 %q) {
entry:
  %tmp = sext i32 %N to i64
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.inc ], [ 0, %entry ]
  %cmp = icmp slt i64 %indvars.iv, %tmp
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %add = add i32 %p, %q
  %idxprom = sext i32 %add to i64
  %arrayidx = getelementptr inbounds ptr, ptr %I, i64 %idxprom
  %tmp1 = load ptr, ptr %arrayidx, align 8
  %tmp2 = load i32, ptr %tmp1, align 4
  %arrayidx2 = getelementptr inbounds i32, ptr %A, i64 %indvars.iv
  store i32 %tmp2, ptr %arrayidx2, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}
