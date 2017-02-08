A     .BYT  'A'

JMP   START

FN1   MOV  R1  FP
      ADI  R1  -8
      LDB  R3  (R1)
      ;LDB  R3  A
      TRP  3
      MOV  SP  FP        ; Test for underflow
      MOV  R5  SP
      CMP  R5  SB
      BGT  R5  UNDERFLOW

      MOV  R5  FP        ; Return address pointed to by FP
      ADI  R5  -4
      LDR  R5  (R5)
      JMR  R5

START MOV  R1  SP        ; Test for overflow
      ADI  R1  -8        ; Adjust for Rtn address & PFP
      CMP  R1  SL
      BLT  R1  OVERFLOW

      MOV  R1  FP        ; Save FP in R1, this will be  PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -8        ; Adjust SP for ret address
      STR  R1  (SP)      ; PFP to top of stack
      MOV  R0  PC        ; PC incremented by 1 instruction
      ADI  R0  120       ; Compute return address ; 20 * lines below
      ADI  R1  -4        ; FP - 4
      STR  R0  (R1)      ; Return address to the beginning of the frame
      ; Add any other vars you need here
      ADI  R1  -4
      LDB  R0  A
      STR  R0  (R1)
      JMP  FN1

      MOV  R1  SP        ; Test for overflow
      ADI  R1  -8        ; Adjust for Rtn address & PFP
      CMP  R1  SL
      BLT  R1  OVERFLOW

      MOV  R1  FP        ; Save FP in R1, this will be  PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -8        ; Adjust SP for ret address
      STR  R1  (SP)      ; PFP to top of stack
      MOV  R0  PC        ; PC incremented by 1 instruction
      ADI  R0  120       ; Compute return address
      ADI  R1  -4        ; FP - 4
      STR  R0  (R1)      ; Return address to the beginning of the frame
      ; Add any other vars you need here
      ADI  R1  -4
      LDB  R0  A
      ADI  R0  2
      STR  R0  (R1)
      JMP  FN1

      MOV  R1  SP        ; Test for overflow
      ADI  R1  -8        ; Adjust for Rtn address & PFP
      CMP  R1  SL
      BLT  R1  OVERFLOW

      MOV  R1  FP        ; Save FP in R1, this will be  PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -8        ; Adjust SP for ret address
      STR  R1  (SP)      ; PFP to top of stack
      MOV  R0  PC        ; PC incremented by 1 instruction
      ADI  R0  120        ; Compute return address
      ADI  R1  -4        ; FP - 4
      STR  R0  (R1)      ; Return address to the beginning of the frame
      ; Add any other vars you need here
      ADI  R1  -4
      LDB  R0  A
      ADI  R0  3
      STR  R0  (R1)
      JMP  FN1


OVERFLOW   TRP  0
UNDERFLOW  TRP  0


