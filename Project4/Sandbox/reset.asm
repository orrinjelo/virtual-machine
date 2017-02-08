; GLOBALS ===========================================================
SIZE        .INT    7
cnt         .INT    0
tenth       .INT    0
c           .BYT    0
            .BYT    0
            .BYT    0
            .BYT    0
            .BYT    0
            .BYT    0
            .BYT    0
data        .INT    0
flag        .INT    0
opdv        .INT    0

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

cZERO       .BYT    48
cI          .BYT    49
cII         .BYT    50
cIII        .BYT    51
cIV         .BYT    52
cV          .BYT    53
cVI         .BYT    54
cVII        .BYT    55
cVIII       .BYT    56
cIX         .BYT    57

opd_err_msg .BYT    32
            .BYT    'i'
            .BYT    's'
            .BYT    32
            .BYT    'n'
            .BYT    'o'
            .BYT    't'
            .BYT    32
A           .BYT    'a'
            .BYT    32
            .BYT    'n'
            .BYT    'u'
            .BYT    'm'
            .BYT    'b'
            .BYT    'e'
            .BYT    'r'
            .BYT    10    ; /n
            .BYT    3     ; END OF TEXT

PLUS        .BYT    '+'
SPC         .BYT    32
EOT         .BYT    3

JMP  START

; Reset c to all 0's
; Assign values to data, opdv, cnt, and flag
reset MOV  R6  FP
      ADI  R6  -12       ; Access w
      LDR  R0  (R6)
      ADI  R6  -4        ; x
      LDR  R1  (R6)
      ADI  R6  -4        ; y
      LDR  R2  (R6)
      ADI  R6  -4        ; z
      LDR  R4  (R6)

; === End variable initiation
      LDR  R6  ZERO
      LDA  R5  c
 for0 LDR  R7  SIZE
      CMP  R7  R6
      BRZ  R7  ef0
      LDR  R7  ZERO
      STB  R7  (R5)
      ADI  R6  1
      ADI  R5  1
      JMP  for0

  ef0 LDR  R5  ZERO
      STR  R5  data
      STR  R5  opdv
      STR  R5  cnt
      STR  R5  flag
; === Begin return call ===============================================
      MOV  SP  FP        ; Test for underflow
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
      ADI  R7  -20       ; Vars
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP ==============================================
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  360       ; Compute return address
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
      LDR  R6  I
      STR  R6  (SP)      ; w
      ADI  SP  -4
      LDR  R6  ZERO
      STR  R6  (SP)      ; x
      ADI  SP  -4
      LDR  R6  ZERO
      STR  R6  (SP)      ; y
      ADI  SP  -4
      LDR  R6  ZERO
      STR  R6  (SP)      ; z
; === Function call ==================================================
      JMP  reset
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
