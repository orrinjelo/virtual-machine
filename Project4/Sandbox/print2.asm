ZERO .INT 0

A   .BYT  'A'

hw	.BYT  'H'
    .BYT  'e'
    .BYT  'l'
    .BYT  'l'
    .BYT  'o'
spc .BYT  32
    .BYT  'w'
    .BYT  'o'
    .BYT  'r'
    .BYT  'l'
    .BYT  'd'
    .BYT  '!'
    .BYT  3  		; End of text

EOT .BYT  3         ; End of text

JMP START

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
; === Begin return call ===============================================
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

START LDB  R3  A
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
      LDA  R6  hw
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

      TRP 3

      TRP  0
