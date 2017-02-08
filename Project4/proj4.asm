; Program values
spc         .BYT    32
ret         .BYT    10
EOT         .BYT     3         ; End of text
LTUE        .INT    -42

; Other things
ARRAY       .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0
            .INT  0

CNT         .INT  0

; Program strings
facmsg1  .BYT  'F'
         .BYT  'a'
         .BYT  'c'
         .BYT  't'
         .BYT  'o'
         .BYT  'r'
         .BYT  'i'
         .BYT  'a'
         .BYT  'l'
         .BYT  32
         .BYT  'o'
         .BYT  'f'
         .BYT  32
         .BYT  3
facmsg2  .BYT  32
         .BYT  'i'
         .BYT  's'
         .BYT  32
         .BYT  3

begin    .BYT  'E'
         .BYT  'n'
         .BYT  't'
         .BYT  'e'
         .BYT  'r'
         .BYT  32
         .BYT  'a'
         .BYT  32
         .BYT  'n'
         .BYT  'u'
         .BYT  'm'
         .BYT  'b'
         .BYT  'e'
         .BYT  'r'
         .BYT  32
         .BYT  'f'
         .BYT  'o'
         .BYT  'r'
         .BYT  32
         .BYT  'f'
         .BYT  'a'
         .BYT  'c'
         .BYT  't'
         .BYT  'o'
         .BYT  'r'
         .BYT  'i'
         .BYT  'a'
         .BYT  'l'
         .BYT  '.'
         .BYT  32
         .BYT  '0'
         .BYT  32
         .BYT  't'
         .BYT  'o'
         .BYT  32
         .BYT  'e'
         .BYT  'x'
         .BYT  'i'
         .BYT  't'
         .BYT  '.'
         .BYT  10
         .BYT  3

midmsg   .BYT  10
         .BYT  'N'
         .BYT  'o'
         .BYT  'w'
         .BYT  32
         .BYT  'l'
         .BYT  'e'
         .BYT  't'
         .BYT  39
         .BYT  's'
         .BYT  32
         .BYT  't'
         .BYT  'r'
         .BYT  'y'
         .BYT  32
         .BYT  't'
         .BYT  'h'
         .BYT  'i'
         .BYT  's'
         .BYT  32
         .BYT  'b'
         .BYT  'y'
         .BYT  32
         .BYT  'm'
         .BYT  'u'
         .BYT  'l'
         .BYT  't'
         .BYT  'i'
         .BYT  't'
         .BYT  'h'
         .BYT  'r'
         .BYT  'e'
         .BYT  'a'
         .BYT  'd'
         .BYT  'i'
         .BYT  'n'
         .BYT  'g'
         .BYT  '.'
         .BYT  32
         .BYT  'E'
         .BYT  'x'
         .BYT  'p'
         .BYT  'e'
         .BYT  'c'
         .BYT  't'
         .BYT  32
         .BYT  'M'
         .BYT  'I'
         .BYT  'S'
         .BYT  'H'
         .BYT  'M'
         .BYT  'O'
         .BYT  'O'
         .BYT  'S'
         .BYT  'H'
         .BYT  '!'

         .BYT  10
         .BYT  3

; Other useful values
ZERO        .INT    0
I           .INT    1
II          .INT    2
III         .INT    3
IV          .INT    4
V           .INT    5
VI          .INT    6
VII         .INT    7
VIII        .INT    8
IX          .INT    9
X           .INT    10



JMP MAIN

; === print =========================================================
print MOV  R1  FP        ; Copy over the FP
      ADI  R1  -36       ; Bypass the ret addr, PFP, and Registers
      LDR  R2  (R1)      ; Load in the value at the 3rd slot up in AR
      LDB  R3  (R2)      ; R2 = addr of argument

  ps_ LDB  R0  EOT
      CMP  R0  R3
      BRZ  R0  eps_
      TRP  3
      ADI  R2  1
      LDB  R3  (R2)
      JMP  ps_
; === Begin return call
 eps_ MOV  SP  FP        ; Test for underflow
      MOV  R5  SP
      CMP  R6  SB
      BGT  R6  UNDERFLOW
; === Store Ret value
      LDR  R7  ZERO      ; Return value
; === Return to last location
      MOV  R6  FP        ; Return address pointed to by FP
      ADI  R6  -4
      LDR  R6  (R6)
      JMR  R6
; === END print =====================================================

;======== FUNCTION START factorial ==================================
factorial   MOV  R5  SP
            CMP  R5  SB
            BGT  R5  UNDERFLOW

; Load the parameter
            MOV  R1  FP        ; Copy over the FP
            ADI  R1  -36       ; Bypass the ret addr, PFP, and Registers
            LDR  R2  (R1)      ; Load in the value at the 3rd slot up in AR
            MOV  R0  R2

;            LDR  R0  (R2)      ; R2 = addr of argument

; Factorial code
            BRZ  R0  froot
            ; Call factorial again with R0 - 1
            MOV  R1  R0
            ADI  R1  -1

; === Begin Function call
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -4        ; Vars
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  240       ; Compute return address
      STR  R6  (SP)      ; Push return address
      ADI  SP  -4        ; Adjust for PFP
      STR  R7  (SP)      ; Push PFP to top of stack
; === Store registers
      ADI  SP  -4        ; R0
      STR  R0  (SP)
      ADI  SP  -4        ; R1
      STR  R1  (SP)
      ADI  SP  -4        ; R2
      STR  R2  (SP)
      ADI  SP  -4        ; R3
      STR  R3  (SP)
      ADI  SP  -4        ; R4
      STR  R4  (SP)
      ADI  SP  -4        ; R5
      STR  R5  (SP)
; === Store variables
      ADI  SP  -4
      STR  R1  (SP)
; === Function call
      JMP  factorial
; === Restore the registers
      MOV  R6  FP
      ADI  R6  -12
      LDR  R0  (R6)
      ADI  R6  -4
      LDR  R1  (R6)
      ADI  R6  -4
      LDR  R2  (R6)
      ADI  R6  -4
      LDR  R3  (R6)
      ADI  R6  -4
      LDR  R4  (R6)
      ADI  R6  -4
      LDR  R5  (R6)
; === Get return value
      MOV  R6  FP
      ADI  R6  -4
      LDR  R4  (R6)
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call
;            MOV  R3  R0
;            TRP  1

            JMP  endfroot
     froot  LDR  R4  I
            LDR  R0  I

; === Begin return call
  endfroot  MOV  SP  FP        ; Test for underflow
            MOV  R5  SP
            CMP  R6  SB
            BGT  R6  UNDERFLOW
; === Store Ret value
            MUL  R4  R0        ; Return value
; === Return to last location
            MOV  R6  FP        ; Return address pointed to by FP
            ADI  R6  -4
            MOV  R7  R6
            LDR  R6  (R6)
            STR  R4  (R7)      ; Store return value
            JMR  R6
; === END factorial =====================================================

;=== Threading FUNCTION START factorial2 ============================
; R0 = X
factorial2  LDR  R7  ltue

; === Begin Function call
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -4        ; Vars
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  240       ; Compute return address
      STR  R6  (SP)      ; Push return address
      ADI  SP  -4        ; Adjust for PFP
      STR  R7  (SP)      ; Push PFP to top of stack
; === Store registers
      ADI  SP  -4        ; R0
      STR  R0  (SP)
      ADI  SP  -4        ; R1
      STR  R1  (SP)
      ADI  SP  -4        ; R2
      STR  R2  (SP)
      ADI  SP  -4        ; R3
      STR  R3  (SP)
      ADI  SP  -4        ; R4
      STR  R4  (SP)
      ADI  SP  -4        ; R5
      STR  R5  (SP)
; === Store variables
      ADI  SP  -4
      STR  R0  (SP)
; === Function call
      JMP  factorial
; === Restore the registers
      MOV  R6  FP
      ADI  R6  -12
      LDR  R0  (R6)
      ADI  R6  -4
      LDR  R1  (R6)
      ADI  R6  -4
      LDR  R2  (R6)
      ADI  R6  -4
      LDR  R3  (R6)
      ADI  R6  -4
      LDR  R4  (R6)
      ADI  R6  -4
      LDR  R5  (R6)
; === Get return value
      MOV  R6  FP
      ADI  R6  -4
      LDR  R4  (R6)
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call

; R0 = X
; R4 = Y

; Update values, print result
      LCK  ARRAY
      LCK  CNT
      LDR  R1  CNT
      LDR  R3  IV
      MUL  R1  R3
      LDA  R2  ARRAY
      ADD  R2  R1
      STR  R0  (R2)
      ADI  R2  4
      STR  R4  (R2)
      LDR  R1  CNT
      ADI  R1  2
      STR  R1  CNT
      ULK  ARRAY
      ULK  CNT


; === Begin Function call ============================================
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -4        ; Vars
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP ==============================================
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  252       ; Compute return address
      STR  R6  (SP)      ; Push return address
      ADI  SP  -4        ; Adjust for PFP
      STR  R7  (SP)      ; Push PFP to top of stack
; === Store registers ================================================
      ADI  SP  -4        ; R0
      STR  R0  (SP)
      ADI  SP  -4        ; R1
      STR  R1  (SP)
      ADI  SP  -4        ; R2
      STR  R2  (SP)
      ADI  SP  -4        ; R3
      STR  R3  (SP)
      ADI  SP  -4        ; R4
      STR  R4  (SP)
      ADI  SP  -4        ; R5
      STR  R5  (SP)
; === Store variables ================================================
      ADI  SP  -4
      LDA  R6  facmsg1
      STR  R6  (SP)
; === Function call ==================================================
      JMP  print
; === Restore the registers
      MOV  R6  FP
      ADI  R6  -12
      LDR  R0  (R6)
      ADI  R6  -4
      LDR  R1  (R6)
      ADI  R6  -4
      LDR  R2  (R6)
      ADI  R6  -4
      LDR  R3  (R6)
      ADI  R6  -4
      LDR  R4  (R6)
      ADI  R6  -4
      LDR  R5  (R6)
      ADI  R6  -4
; === Roll back SP and FP ============================================
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call ==============================================

	  MOV  R3  R0
      TRP  1

; === Begin Function call ============================================
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -4        ; Vars
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP ==============================================
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  252       ; Compute return address
      STR  R6  (SP)      ; Push return address
      ADI  SP  -4        ; Adjust for PFP
      STR  R7  (SP)      ; Push PFP to top of stack
; === Store registers ================================================
      ADI  SP  -4        ; R0
      STR  R0  (SP)
      ADI  SP  -4        ; R1
      STR  R1  (SP)
      ADI  SP  -4        ; R2
      STR  R2  (SP)
      ADI  SP  -4        ; R3
      STR  R3  (SP)
      ADI  SP  -4        ; R4
      STR  R4  (SP)
      ADI  SP  -4        ; R5
      STR  R5  (SP)
; === Store variables ================================================
      ADI  SP  -4
      LDA  R6  facmsg2
      STR  R6  (SP)
; === Function call ==================================================
      JMP  print
; === Restore the registers
      MOV  R6  FP
      ADI  R6  -12
      LDR  R0  (R6)
      ADI  R6  -4
      LDR  R1  (R6)
      ADI  R6  -4
      LDR  R2  (R6)
      ADI  R6  -4
      LDR  R3  (R6)
      ADI  R6  -4
      LDR  R4  (R6)
      ADI  R6  -4
      LDR  R5  (R6)
      ADI  R6  -4
; === Roll back SP and FP ============================================
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call ==============================================

	  MOV  R3  R4
	  TRP  1



      END
; === END factorial2 =====================================================



; === BEGIN procArr =================================================
procArr     MOV  R5  SP
            CMP  R5  SB
            BGT  R5  UNDERFLOW

; === Load CNT
            LDR  R2  CNT
            LDR  R4  IV
            MUL  R2  R4
            LDA  R1  ARRAY

            ADD  R1  R2
            LDA  R0  ARRAY

      wh1   ADI  R1  -4
            LDR  R3  (R0)
            TRP  1
            LDB  R3  spc
            TRP  3
            LDR  R3  (R1)
            TRP  1
            LDB  R3  spc
            TRP  3
            ADI  R0  4
            MOV  R2  R0
            CMP  R2  R1
            BLT  R2  wh1

; === Begin return call
            MOV  SP  FP        ; Test for underflow
            MOV  R5  SP
            CMP  R6  SB
            BGT  R6  UNDERFLOW
; === Store Ret value
; === Return to last location
            MOV  R6  FP        ; Return address pointed to by FP
            ADI  R6  -4
            MOV  R7  R6
            LDR  R6  (R6)
            JMR  R6
; === END procArr ===================================================

MAIN  LDA  R0  ARRAY

; === Begin Function call ============================================
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -4        ; Vars
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP ==============================================
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  252       ; Compute return address
      STR  R6  (SP)      ; Push return address
      ADI  SP  -4        ; Adjust for PFP
      STR  R7  (SP)      ; Push PFP to top of stack
; === Store registers ================================================
      ADI  SP  -4        ; R0
      STR  R0  (SP)
      ADI  SP  -4        ; R1
      STR  R1  (SP)
      ADI  SP  -4        ; R2
      STR  R2  (SP)
      ADI  SP  -4        ; R3
      STR  R3  (SP)
      ADI  SP  -4        ; R4
      STR  R4  (SP)
      ADI  SP  -4        ; R5
      STR  R5  (SP)
; === Store variables ================================================
      ADI  SP  -4
      LDA  R6  begin
      STR  R6  (SP)
; === Function call ==================================================
      JMP  print
; === Restore the registers
      MOV  R6  FP
      ADI  R6  -12
      LDR  R0  (R6)
      ADI  R6  -4
      LDR  R1  (R6)
      ADI  R6  -4
      LDR  R2  (R6)
      ADI  R6  -4
      LDR  R3  (R6)
      ADI  R6  -4
      LDR  R4  (R6)
      ADI  R6  -4
      LDR  R5  (R6)
      ADI  R6  -4
; === Roll back SP and FP ============================================
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call ==============================================


  whl TRP  2
      STR  R3  (R0)
      MOV  R4  R3
      ADI  R0  4
      BRZ  R3  ewhl

; === Begin Function call
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -4        ; Vars
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  240       ; Compute return address
      STR  R6  (SP)      ; Push return address
      ADI  SP  -4        ; Adjust for PFP
      STR  R7  (SP)      ; Push PFP to top of stack
; === Store registers
      ADI  SP  -4        ; R0
      STR  R0  (SP)
      ADI  SP  -4        ; R1
      STR  R1  (SP)
      ADI  SP  -4        ; R2
      STR  R2  (SP)
      ADI  SP  -4        ; R3
      STR  R3  (SP)
      ADI  SP  -4        ; R4
      STR  R4  (SP)
      ADI  SP  -4        ; R5
      STR  R5  (SP)
; === Store variables
      ADI  SP  -4
      STR  R3  (SP)
; === Function call
      JMP  factorial
; === Restore the registers
      MOV  R6  FP
      ADI  R6  -12
      LDR  R0  (R6)
      ADI  R6  -4
      LDR  R1  (R6)
      ADI  R6  -4
      LDR  R2  (R6)
      ADI  R6  -4
      LDR  R3  (R6)
      ADI  R6  -4
      LDR  R4  (R6)
      ADI  R6  -4
      LDR  R5  (R6)
; === Get return value
      MOV  R6  FP
      ADI  R6  -4
      LDR  R5  (R6)
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call

; === Begin Function call ============================================
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -4        ; Vars
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP ==============================================
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  252       ; Compute return address
      STR  R6  (SP)      ; Push return address
      ADI  SP  -4        ; Adjust for PFP
      STR  R7  (SP)      ; Push PFP to top of stack
; === Store registers ================================================
      ADI  SP  -4        ; R0
      STR  R0  (SP)
      ADI  SP  -4        ; R1
      STR  R1  (SP)
      ADI  SP  -4        ; R2
      STR  R2  (SP)
      ADI  SP  -4        ; R3
      STR  R3  (SP)
      ADI  SP  -4        ; R4
      STR  R4  (SP)
      ADI  SP  -4        ; R5
      STR  R5  (SP)
; === Store variables ================================================
      ADI  SP  -4
      LDA  R6  facmsg1
      STR  R6  (SP)
; === Function call ==================================================
      JMP  print
; === Restore the registers
      MOV  R6  FP
      ADI  R6  -12
      LDR  R0  (R6)
      ADI  R6  -4
      LDR  R1  (R6)
      ADI  R6  -4
      LDR  R2  (R6)
      ADI  R6  -4
      LDR  R3  (R6)
      ADI  R6  -4
      LDR  R4  (R6)
      ADI  R6  -4
      LDR  R5  (R6)
      ADI  R6  -4
; === Roll back SP and FP ============================================
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call ==============================================

	  MOV  R3  R4
      TRP  1

; === Begin Function call ============================================
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -4        ; Vars
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP ==============================================
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  252       ; Compute return address
      STR  R6  (SP)      ; Push return address
      ADI  SP  -4        ; Adjust for PFP
      STR  R7  (SP)      ; Push PFP to top of stack
; === Store registers ================================================
      ADI  SP  -4        ; R0
      STR  R0  (SP)
      ADI  SP  -4        ; R1
      STR  R1  (SP)
      ADI  SP  -4        ; R2
      STR  R2  (SP)
      ADI  SP  -4        ; R3
      STR  R3  (SP)
      ADI  SP  -4        ; R4
      STR  R4  (SP)
      ADI  SP  -4        ; R5
      STR  R5  (SP)
; === Store variables ================================================
      ADI  SP  -4
      LDA  R6  facmsg2
      STR  R6  (SP)
; === Function call ==================================================
      JMP  print
; === Restore the registers
      MOV  R6  FP
      ADI  R6  -12
      LDR  R0  (R6)
      ADI  R6  -4
      LDR  R1  (R6)
      ADI  R6  -4
      LDR  R2  (R6)
      ADI  R6  -4
      LDR  R3  (R6)
      ADI  R6  -4
      LDR  R4  (R6)
      ADI  R6  -4
      LDR  R5  (R6)
      ADI  R6  -4
; === Roll back SP and FP ============================================
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call ==============================================

      MOV  R3  R5
      TRP  1
      STR  R3  (R0)
      LDB  R3  spc
      TRP  3
      ADI  R0  4

      LDR  R3  CNT          ; Update count
      ADI  R3  2
      ;TRP  1
      STR  R3  CNT
      LDB  R3  ret
      TRP  3
      JMP  whl

 ewhl ADI  R0  0


; === Begin Function call
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  216       ; Compute return address
      STR  R6  (SP)      ; Push return address
      ADI  SP  -4        ; Adjust for PFP
      STR  R7  (SP)      ; Push PFP to top of stack
; === Store registers
      ADI  SP  -4        ; R0
      STR  R0  (SP)
      ADI  SP  -4        ; R1
      STR  R1  (SP)
      ADI  SP  -4        ; R2
      STR  R2  (SP)
      ADI  SP  -4        ; R3
      STR  R3  (SP)
      ADI  SP  -4        ; R4
      STR  R4  (SP)
      ADI  SP  -4        ; R5
      STR  R5  (SP)
; === Store variables
; === Function call
      JMP  procArr
; === Restore the registers
      MOV  R6  FP
      ADI  R6  -12
      LDR  R0  (R6)
      ADI  R6  -4
      LDR  R1  (R6)
      ADI  R6  -4
      LDR  R2  (R6)
      ADI  R6  -4
      LDR  R3  (R6)
      ADI  R6  -4
      LDR  R4  (R6)
      ADI  R6  -4
      LDR  R5  (R6)
; === Get return value
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call


; === Begin Function call ============================================
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -4        ; Vars
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP ==============================================
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  252       ; Compute return address
      STR  R6  (SP)      ; Push return address
      ADI  SP  -4        ; Adjust for PFP
      STR  R7  (SP)      ; Push PFP to top of stack
; === Store registers ================================================
      ADI  SP  -4        ; R0
      STR  R0  (SP)
      ADI  SP  -4        ; R1
      STR  R1  (SP)
      ADI  SP  -4        ; R2
      STR  R2  (SP)
      ADI  SP  -4        ; R3
      STR  R3  (SP)
      ADI  SP  -4        ; R4
      STR  R4  (SP)
      ADI  SP  -4        ; R5
      STR  R5  (SP)
; === Store variables ================================================
      ADI  SP  -4
      LDA  R6  midmsg
      STR  R6  (SP)
; === Function call ==================================================
      JMP  print
; === Restore the registers
      MOV  R6  FP
      ADI  R6  -12
      LDR  R0  (R6)
      ADI  R6  -4
      LDR  R1  (R6)
      ADI  R6  -4
      LDR  R2  (R6)
      ADI  R6  -4
      LDR  R3  (R6)
      ADI  R6  -4
      LDR  R4  (R6)
      ADI  R6  -4
      LDR  R5  (R6)
      ADI  R6  -4
; === Roll back SP and FP ============================================
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call ==============================================

	  LDR  R0  ZERO
	  STR  R0  CNT      ; Reset CNT

	  ; === Begin Function call ============================================
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -4        ; Vars
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP ==============================================
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  252       ; Compute return address
      STR  R6  (SP)      ; Push return address
      ADI  SP  -4        ; Adjust for PFP
      STR  R7  (SP)      ; Push PFP to top of stack
; === Store registers ================================================
      ADI  SP  -4        ; R0
      STR  R0  (SP)
      ADI  SP  -4        ; R1
      STR  R1  (SP)
      ADI  SP  -4        ; R2
      STR  R2  (SP)
      ADI  SP  -4        ; R3
      STR  R3  (SP)
      ADI  SP  -4        ; R4
      STR  R4  (SP)
      ADI  SP  -4        ; R5
      STR  R5  (SP)
; === Store variables ================================================
      ADI  SP  -4
      LDA  R6  begin
      STR  R6  (SP)
; === Function call ==================================================
      JMP  print
; === Restore the registers
      MOV  R6  FP
      ADI  R6  -12
      LDR  R0  (R6)
      ADI  R6  -4
      LDR  R1  (R6)
      ADI  R6  -4
      LDR  R2  (R6)
      ADI  R6  -4
      LDR  R3  (R6)
      ADI  R6  -4
      LDR  R4  (R6)
      ADI  R6  -4
      LDR  R5  (R6)
      ADI  R6  -4
; === Roll back SP and FP ============================================
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call ==============================================


       LCK  ltue

 whl2  TRP  2
       MOV  R0  R3
       BRZ  R3  ewhl2
       RUN  R7  factorial2
       JMP  whl2
 ewhl2 ULK  ltue
       BLK

       LDB  R3  ret
       TRP  3
; === Begin Function call
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  216       ; Compute return address
      STR  R6  (SP)      ; Push return address
      ADI  SP  -4        ; Adjust for PFP
      STR  R7  (SP)      ; Push PFP to top of stack
; === Store registers
      ADI  SP  -4        ; R0
      STR  R0  (SP)
      ADI  SP  -4        ; R1
      STR  R1  (SP)
      ADI  SP  -4        ; R2
      STR  R2  (SP)
      ADI  SP  -4        ; R3
      STR  R3  (SP)
      ADI  SP  -4        ; R4
      STR  R4  (SP)
      ADI  SP  -4        ; R5
      STR  R5  (SP)
; === Store variables
; === Function call
      JMP  procArr
; === Restore the registers
      MOV  R6  FP
      ADI  R6  -12
      LDR  R0  (R6)
      ADI  R6  -4
      LDR  R1  (R6)
      ADI  R6  -4
      LDR  R2  (R6)
      ADI  R6  -4
      LDR  R3  (R6)
      ADI  R6  -4
      LDR  R4  (R6)
      ADI  R6  -4
      LDR  R5  (R6)
; === Get return value
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call



      TRP  0

UNDERFLOW  TRP  0
OVERFLOW   TRP  0
