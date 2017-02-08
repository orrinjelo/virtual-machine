; GLOBALS ===========================================================
SIZE        .INT    7
cnt         .INT    7
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

debug       .INT    0

; Program vars
PLUS        .BYT    '+'
MINUS       .BYT    '-'
spc         .BYT    32
ret         .BYT    10
EOT         .BYT     3         ; End of text
LTUE        .INT    -42
at          .BYT    '@'

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
            .BYT    10
            .BYT    3          ; EOT

getdataerr  .BYT    'N'
            .BYT    'u'
            .BYT    'm'
            .BYT    'b'
            .BYT    'e'
            .BYT    'r'
            .BYT    32
            .BYT    't'
            .BYT    'o'
            .BYT    'o'
            .BYT    32
            .BYT    'B'
            .BYT    'i'
            .BYT    'g'
            .BYT    10
            .BYT    3     ; END OF TEXT

goodnum     .BYT    'O'
            .BYT    'p'
            .BYT    'e'
            .BYT    'r'
            .BYT    'a'
            .BYT    'n'
            .BYT    'd'
            .BYT    32
            .BYT    'i'
            .BYT    's'
            .BYT    32
            .BYT    3     ; EOT


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

_s          .BYT    '+'
_k          .INT    1
_j          .BYT    '7'

JMP  START

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

; === reset =========================================================
; Reset c to all 0's
; Assign values to data, opdv, cnt, and flag
reset MOV  R6  FP
      ADI  R6  -36       ; Access w
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

  ef0 STR  R0  data
      STR  R1  opdv
      STR  R2  cnt
      STR  R4  flag
; === Begin return call
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
; === END reset =====================================================

; === getdata =======================================================
; Read one char at a time from the keyboard after a
;   newline ‘\n’ has been entered. If there is room
;   place the char in the array c
;   otherwise indicate the number is too big and
;   flush the keyboard input.
getdata  LDR  R0  cnt
         LDR  R1  SIZE
         CMP  R0  R1
         BLT  R0  isroom  ; Get data if there is room

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
      ADI  R6  252       ; Compute return address
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
      LDA  R6  getdataerr
      STR  R6  (SP)
; === Function call
      JMP  print
; === Restore the registers
      MOV  R6  FP
      ADI  R6  -12
      LDR  R0  (R6)
      ADI  R6  -4
      LDR  R1  (R6)
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call

; === Begin Function call
 eps2 MOV  R7  SP        ; Test for overflow
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
      JMP  flush
; === Restore the registers
      MOV  R6  FP
      ADI  R6  -12
      LDR  R0  (R6)
      ADI  R6  -4
      LDR  R1  (R6)
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call

         JMP  gdendif

  isroom LDA  R5  c
         LDR  R4  cnt
         ADD  R5  R4
         TRP  4
         STB  R3  (R5)
         ADI  R4  1
         STR  R4  cnt

 gdendif MOV  SP  FP        ; Test for underflow
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
; === END getdata ===================================================



;  Convert char j to an integer if possible.
;  If the flag is not set use the sign indicator s
;  and the tenths indicator to compute the actual
;  value of j.  Add the value to the accumulator opdv.

; ======== FUNCTION START opd =======================================
opd         MOV  SP  FP          ; Test for underflow
            MOV  R5  SP
            CMP  R5  SB
            BGT  R5  UNDERFLOW

; == Load passed params s, k, j
            MOV  R7  FP        ; Copy over the FP
            ADI  R7  -33       ; Bypass the ret addr, PFP, and Registers

            LDB  R0  (R7)        ; Load char s
            ADI  R7  -4
            LDR  R1  (R7)        ; Load int k
            ADI  R7  -1
            LDB  R2  (R7)        ; Load char j



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


     ELSEF  MOV  R3  R2
            TRP  3

            ; Start Print
            LDA  R5  opderr
            LDB  R3  (R5)
        ps1 LDB  R4  EOT
            CMP  R4  R3
            BRZ  R4  eps1
            TRP  3
            ADI  R5  1
            LDB  R3  (R5)
            JMP  ps1
            ; End Print

      eps1  LDB  R5  flag
            ADI  R5  1
            STR  R5  flag        ; flag = 1

     ENDIF  LDR  R5  flag
            BNZ  R5  ENDIFFLAG   ; if (!flag)

            LDB  R5  PLUS
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

; === FUNCTION flush ================================================
; === flush =========================================================
flush LDR  R0  ZERO
      STR  R0  data

 flw1 TRP  4
      STB  R3  c
      LDB  R0  ret
      CMP  R0  R3
      BNZ  R0  flw1
; begin return call
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
; === END FUNCTION flush ==========================================

;==== Main ==========================================================
; === Begin Function call
START MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -20       ; Vars
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  360       ; Compute return address
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
; === Function call
      JMP  reset
; === Restore the registers
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call



; === Begin Function call
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -20       ; Vars
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
      JMP  getdata
; === Restore the registers
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call





 whi1 LDB  R0  c
      LDB  R1  at
      CMP  R1  R0
      BRZ  R1  ewh1      ; While c[0] != '@'
      LDB  R1  PLUS
      LDB  R2  MINUS
      CMP  R1  R0
      CMP  R2  R0

      BRZ  R1  if2
      BRZ  R2  if2        ; if c[0] == '+' || c[0] == '-'

      JMP  el1
; === Begin Function call
  if2 MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -20       ; Vars
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
      JMP  getdata
; === Restore the registers
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call




      JMP  eif1

  el1 LDA  R1  c          ; c[1] = c[0]
      ADI  R1  1
      STB  R0  (R1)
      LDB  R1  PLUS       ; c[0] = '+'
      STB  R1  c
      LDR  R1  cnt        ; cnt++
      ADI  R1  1
      STR  R1  cnt



      JMP  eif1

 eif1 LDR  R0  data





      BRZ  R0  ewh2       ; while (data)

      LDR  R1  cnt
      ADI  R1  -1
      LDA  R2  c
      ADD  R2  R1
      LDB  R2  (R2)




      LDB  R4  ret
      CMP  R2  R4
      BNZ  R2  els2       ; if c[cnt-1] == '\n'

      LDR  R0  ZERO      ; data = 0
      STR  R0  data
      LDR  R0  I         ; tenth = 1
      STR  R0  tenth
      ADI  R1  -1        ; cnt = cnt - 2
      STR  R1  cnt



 whi3 LDR  R4  flag
      LDR  R5  cnt
      BNZ  R4  ewh3
      BRZ  R5  ewh3




; === Begin Function call
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -6        ; Vars
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  360       ; Compute return address
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
      ADI  SP  -1
      LDB  R6  c
      STB  R6  (SP)
      ADI  SP  -4
      LDR  R6  tenth
      STR  R6  (SP)
      ADI  SP  -1
      LDA  R6  c
      LDR  R7  cnt
      ADD  R6  R7
      LDB  R6  (R6)
      STB  R6  (SP)
; === Function call
      JMP  opd
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
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call



      LDR  R1  cnt       ; cnt--
      ADI  R1  -1
      STR  R1  cnt
      LDR  R1  tenth
      LDR  R2  X
      MUL  R1  R2
      STR  R1  tenth
      JMP  whi3

 ewh3 LDR  R0  flag


      BRZ  R0  prf
      JMP  eprf
; === Begin Function call
  prf MOV  R7  SP        ; Test for overflow
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
      ADI  R6  252       ; Compute return address
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
      LDA  R6  goodnum
      STR  R6  (SP)
; === Function call
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
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call
      LDR  R3  opdv
      TRP  1
      LDB  R3  ret
      TRP  3


 eprf JMP  eif1          ; end while

; === Begin Function call
 els2 MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -20       ; Vars
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
      JMP  getdata
; === Restore the registers
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call  ; else



      JMP  eif1          ; end while



; === Begin Function call
ewh2   MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -20       ; Vars
      CMP  R7  SL
      BLT  R7  OVERFLOW
; === Store Ret and PFP
      MOV  R7  FP        ; Save FP in R1, this will be PFP
      MOV  FP  SP        ; Point at current activation record
      ADI  SP  -4        ; Adjust SP for ret address
      MOV  R6  PC        ; PC incremented by 1 instruction
      ADI  R6  360       ; Compute return address
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
; === Function call
      JMP  reset
; === Restore the registers
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call

; === Begin Function call
      MOV  R7  SP        ; Test for overflow
      ADI  R7  -8        ; Adjust for Rtn address & PFP
      ADI  R7  -24       ; Registers
      ADI  R7  -20       ; Vars
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
      JMP  getdata
; === Restore the registers
; === Roll back SP and FP
      MOV  SP  FP
      ADI  FP  -8
      LDR  FP  (FP)
; === End function call

      JMP  whi1

 ewh1 ADI  R0  0   ; NOP place holder. :)
;      LDR  R3  LTUE
;      TRP  1

nodbz TRP  0

UNDERFLOW  TRP 0
OVERFLOW   TRP 0
