PLUS        .BYT    '+'
spc         .BYT    32
ret         .BYT    13
EOT         .BYT     3         ; End of text

; Strings
opderr      .BYT    32
            .BYT    'i'
            .BYT    's'
            .BYT    32
            .BYT    'n'
            .BYT    'o'
            .BYT    't'
            .BYT    32
            .BYT    'a'
            .BYT    32
            .BYT    'n'
            .BYT    'u'
            .BYT    'm'
            .BYT    'b'
            .BYT    'e'
            .BYT    'r'
            .BYT    13
            .BYT    3          ; EOT



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

opdv        .INT    0
flag        .INT    0

_s          .BYT    '+'
_k          .INT    1
_j          .BYT    '4'

JMP  START

;  Convert char j to an integer if possible.
;  If the flag is not set use the sign indicator s
;  and the tenths indicator to compute the actual
;  value of j.  Add the value to the accumulator opdv.

;  Passed values:
;   R0: char s
;   R1: int k
;   R2: char j
;   R3: reserved for I/O
;   R4: t
;   R7: reserved (temporarily) for returns

; ======== FUNCTION START opd =======================================
opd         MOV  SP  FP          ; Test for underflow
            MOV  R5  SP
            CMP  R5  SB
            BGT  R5  UNDERFLOW

            MOV  R7  FP          ; Load _s
            ADI  R7  -8
            ;LDR  R7  (R1)
            LDB  R0  (R7)

            ADI  R7  -4          ; Load _k
            ;LDR  R7  (R1)
            LDR  R1  (R7)

            ADI  R7  -4          ; Load _j
            ;LDR  R7  (R1)
            LDB  R2  (R7)

            MOV  R4  FP          ; What is this doing?
            ADI  R4  -16
            LDR  R3  R4


; ======== END FUNCTION HEADING =====================================

            LDR  R4  ZERO        ; int t = 0

            LDB  R5  cZERO
            CMP  R5  R2          ; if (j == '0')
            BNZ  R5  ELSE1
            ADI  R4  0           ; t = 0
            JMP  ENDIF

     ELSE1  LDB  R5  cI
            CMP  R5  R2          ; else if (j == '1')
            BNZ  R5  ELSE2
            ADI  R4  1           ; t = 1
            JMP  ENDIF

     ELSE2  LDB  R5  cII
            CMP  R5  R2          ; else if (j == '2')
            BNZ  R5  ELSE3
            ADI  R4  2           ; t = 2
            JMP  ENDIF

     ELSE3  LDB  R5  cIII
            CMP  R5  R2          ; else if (j == '3')
            BNZ  R5  ELSE4
            ADI  R4  3           ; t = 3
            JMP  ENDIF

     ELSE4  LDB  R5  cIV
            CMP  R5  R2          ; else if (j == '4')
            BNZ  R5  ELSE5
            ADI  R4  4           ; t = 4
            JMP  ENDIF

     ELSE5  LDB  R5  cV
            CMP  R5  R2          ; else if (j == '5')
            BNZ  R5  ELSE6
            ADI  R4  5           ; t = 5
            JMP  ENDIF

     ELSE6  LDB  R5  cVI
            CMP  R5  R2          ; else if (j == '6')
            BNZ  R5  ELSE7
            ADI  R4  6           ; t = 6
            JMP  ENDIF

     ELSE7  LDB  R5  cVII
            CMP  R5  R2          ; else if (j == '7')
            BNZ  R5  ELSE8
            ADI  R4  7           ; t = 7
            JMP  ENDIF

     ELSE8  LDB  R5  cVIII
            CMP  R5  R2          ; else if (j == '8')
            BNZ  R5  ELSE9
            ADI  R4  8           ; t = 8
            JMP  ENDIF

     ELSE9  LDB  R5  cIX
            CMP  R5  R2          ; else if (j == '9')
            BNZ  R5  ELSEF
            ADI  R4  9           ; t = 9
            JMP  ENDIF

     ELSEF  LDB  R5  flag        ; Create a print function
            ADI  R5  1
            STR  R5  flag        ; flag = 1

     ENDIF  LDR  R5  flag
            BNZ  R5  ENDIFFLAG   ; if (!flag)

            LDR  R5  PLUS
            CMP  R5  R0
            BNZ  R5  SPLUSELSE   ; if (s == '+')

            MUL  R4  R1          ; t *= k
            JMP  ENDSPLUS

 SPLUSELSE  MOV  R5  R1
            SUB  R5  R1
            SUB  R5  R1          ; -k
            MUL  R4  R5          ; t *= -k

  ENDSPLUS  LDR  R7  opdv
            ADD  R7  R4          ; opdv + t
            STR  R7  opdv

 ENDIFFLAG  MOV  R5  FP        ; Return address pointed to by FP
            ADI  R5  -4
            LDR  R5  (R5)

            JMR  R5
; ======== FUNCTION END opd =========================================

; print function: will print the string that is passed to it
print MOV  R5  FP
      ADI  R5  -8
      LDR  R6  (R5)
      LDR  R7  (R6)

  ps_ LDB  R5  EOT
      CMP  R5  R7
      BRZ  R5  eps_
      TRP  3
      ADI  R6  1
      LDB  R7  (R6)
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
      ADI  R0  168       ; Compute return address ; 20 * lines below
      ADI  R1  -4        ; FP - 4
      STR  R0  (R1)      ; Return address to the beginning of the frame
      ; Add any other vars you need here
      ADI  R1  -4
      LDB  R0  _s
      STR  R0  (R1)
      ADI  R1  -4
      LDR  R0  _k
      STR  R0  (R1)
      ADI  R1  -4
      LDR  R0  _j
      STR  R0  (R1)
      JMP  opd

      LDB  R3  opdv
      TRP  1

      TRP  0
