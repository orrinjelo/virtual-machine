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

print MOV  R1  FP
      ADI  R1  -8
      LDR  R2  (R1)
      LDR  R3  (R2)

  ps_ LDB  R0  EOT
      CMP  R0  R3
      BRZ  R0  eps_
      TRP  3
      ADI  R2  1
      LDB  R3  (R2)
      JMP  ps_

 eps_ MOV  SP  FP        ; Test for underflow
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
      LDA  R0  hw
      STR  R0  (R1)
      JMP  print

      TRP  0
