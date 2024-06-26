# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver3 -instruction-tables < %s | FileCheck %s

andn        %eax, %ebx, %ecx
andn        (%rax), %ebx, %ecx

andn        %rax, %rbx, %rcx
andn        (%rax), %rbx, %rcx

bextr       %eax, %ebx, %ecx
bextr       %eax, (%rbx), %ecx

bextr       %rax, %rbx, %rcx
bextr       %rax, (%rbx), %rcx

blsi        %eax, %ecx
blsi        (%rax), %ecx

blsi        %rax, %rcx
blsi        (%rax), %rcx

blsmsk      %eax, %ecx
blsmsk      (%rax), %ecx

blsmsk      %rax, %rcx
blsmsk      (%rax), %rcx

blsr        %eax, %ecx
blsr        (%rax), %ecx

blsr        %rax, %rcx
blsr        (%rax), %rcx

tzcnt       %ax, %cx
tzcnt       (%rax), %cx

tzcnt       %eax, %ecx
tzcnt       (%rax), %ecx

tzcnt       %rax, %rcx
tzcnt       (%rax), %rcx

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.25                        andnl	%eax, %ebx, %ecx
# CHECK-NEXT:  1      5     0.33    *                   andnl	(%rax), %ebx, %ecx
# CHECK-NEXT:  1      1     0.25                        andnq	%rax, %rbx, %rcx
# CHECK-NEXT:  1      5     0.33    *                   andnq	(%rax), %rbx, %rcx
# CHECK-NEXT:  1      1     0.50                        bextrl	%eax, %ebx, %ecx
# CHECK-NEXT:  2      5     0.50    *                   bextrl	%eax, (%rbx), %ecx
# CHECK-NEXT:  1      1     0.50                        bextrq	%rax, %rbx, %rcx
# CHECK-NEXT:  2      5     0.50    *                   bextrq	%rax, (%rbx), %rcx
# CHECK-NEXT:  2      2     0.50                        blsil	%eax, %ecx
# CHECK-NEXT:  3      6     0.50    *                   blsil	(%rax), %ecx
# CHECK-NEXT:  2      2     0.50                        blsiq	%rax, %rcx
# CHECK-NEXT:  3      6     0.50    *                   blsiq	(%rax), %rcx
# CHECK-NEXT:  2      2     0.50                        blsmskl	%eax, %ecx
# CHECK-NEXT:  3      6     0.50    *                   blsmskl	(%rax), %ecx
# CHECK-NEXT:  2      2     0.50                        blsmskq	%rax, %rcx
# CHECK-NEXT:  3      6     0.50    *                   blsmskq	(%rax), %rcx
# CHECK-NEXT:  2      2     0.50                        blsrl	%eax, %ecx
# CHECK-NEXT:  3      6     0.50    *                   blsrl	(%rax), %ecx
# CHECK-NEXT:  2      2     0.50                        blsrq	%rax, %rcx
# CHECK-NEXT:  3      6     0.50    *                   blsrq	(%rax), %rcx
# CHECK-NEXT:  2      2     1.00                        tzcntw	%ax, %cx
# CHECK-NEXT:  2      6     0.50    *                   tzcntw	(%rax), %cx
# CHECK-NEXT:  2      2     0.50                        tzcntl	%eax, %ecx
# CHECK-NEXT:  2      6     0.50    *                   tzcntl	(%rax), %ecx
# CHECK-NEXT:  2      2     0.50                        tzcntq	%rax, %rcx
# CHECK-NEXT:  2      6     0.50    *                   tzcntq	(%rax), %rcx

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn3AGU0
# CHECK-NEXT: [1]   - Zn3AGU1
# CHECK-NEXT: [2]   - Zn3AGU2
# CHECK-NEXT: [3]   - Zn3ALU0
# CHECK-NEXT: [4]   - Zn3ALU1
# CHECK-NEXT: [5]   - Zn3ALU2
# CHECK-NEXT: [6]   - Zn3ALU3
# CHECK-NEXT: [7]   - Zn3BRU1
# CHECK-NEXT: [8]   - Zn3FP0
# CHECK-NEXT: [9]   - Zn3FP1
# CHECK-NEXT: [10]  - Zn3FP2
# CHECK-NEXT: [11]  - Zn3FP3
# CHECK-NEXT: [12.0] - Zn3FP45
# CHECK-NEXT: [12.1] - Zn3FP45
# CHECK-NEXT: [13]  - Zn3FPSt
# CHECK-NEXT: [14.0] - Zn3LSU
# CHECK-NEXT: [14.1] - Zn3LSU
# CHECK-NEXT: [14.2] - Zn3LSU
# CHECK-NEXT: [15.0] - Zn3Load
# CHECK-NEXT: [15.1] - Zn3Load
# CHECK-NEXT: [15.2] - Zn3Load
# CHECK-NEXT: [16.0] - Zn3Store
# CHECK-NEXT: [16.1] - Zn3Store

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1]
# CHECK-NEXT: 4.33   4.33   4.33   8.00   12.50  12.50  8.00    -      -      -      -      -      -      -      -     4.33   4.33   4.33   4.33   4.33   4.33    -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     andnl	%eax, %ebx, %ecx
# CHECK-NEXT: 0.33   0.33   0.33   0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     andnl	(%rax), %ebx, %ecx
# CHECK-NEXT:  -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     andnq	%rax, %rbx, %rcx
# CHECK-NEXT: 0.33   0.33   0.33   0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     andnq	(%rax), %rbx, %rcx
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     bextrl	%eax, %ebx, %ecx
# CHECK-NEXT: 0.33   0.33   0.33    -     0.50   0.50    -      -      -      -      -      -      -      -      -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     bextrl	%eax, (%rbx), %ecx
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     bextrq	%rax, %rbx, %rcx
# CHECK-NEXT: 0.33   0.33   0.33    -     0.50   0.50    -      -      -      -      -      -      -      -      -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     bextrq	%rax, (%rbx), %rcx
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     blsil	%eax, %ecx
# CHECK-NEXT: 0.33   0.33   0.33   0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     blsil	(%rax), %ecx
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     blsiq	%rax, %rcx
# CHECK-NEXT: 0.33   0.33   0.33   0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     blsiq	(%rax), %rcx
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     blsmskl	%eax, %ecx
# CHECK-NEXT: 0.33   0.33   0.33   0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     blsmskl	(%rax), %ecx
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     blsmskq	%rax, %rcx
# CHECK-NEXT: 0.33   0.33   0.33   0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     blsmskq	(%rax), %rcx
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     blsrl	%eax, %ecx
# CHECK-NEXT: 0.33   0.33   0.33   0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     blsrl	(%rax), %ecx
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     blsrq	%rax, %rcx
# CHECK-NEXT: 0.33   0.33   0.33   0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     blsrq	(%rax), %rcx
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     tzcntw	%ax, %cx
# CHECK-NEXT: 0.33   0.33   0.33    -     0.50   0.50    -      -      -      -      -      -      -      -      -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     tzcntw	(%rax), %cx
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     tzcntl	%eax, %ecx
# CHECK-NEXT: 0.33   0.33   0.33    -     0.50   0.50    -      -      -      -      -      -      -      -      -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     tzcntl	(%rax), %ecx
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     tzcntq	%rax, %rcx
# CHECK-NEXT: 0.33   0.33   0.33    -     0.50   0.50    -      -      -      -      -      -      -      -      -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     tzcntq	(%rax), %rcx
