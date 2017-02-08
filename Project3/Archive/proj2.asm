; = Project 2: proj2.asm =============================================
; ========================= Tyler Park ===============================
; ======================================== CS 4380 ===================

; == PART ONE ========================================================

SIZE    .INT    10

ARR     .INT    10
        .INT    2
        .INT    3
        .INT    4
        .INT    15
        .INT    -6
        .INT    7
        .INT    8
        .INT    9
        .INT    10

S       .BYT    'S'		; Ascii codes for S, u, & m
u       .BYT    'u'
m       .BYT    'm'

SP      .BYT    32		; Space
RET	    .BYT    10  	; Line carry

_i      .BYT    'i'		; Ascii codes for i, & s
_s      .BYT    's'

I       .INT    1
II      .INT    2
INT     .INT    4		; Size of an integer

e       .BYT    'e'
v       .BYT    'v'
n       .BYT    'n'
o       .BYT    'o'
d       .BYT    'd'

; === VARIABLES ===

i_      .INT    0
sum     .INT    0
temp    .INT    0
result  .INT    0

; ==== PART TWO ====

DAGS    .BYT    'D'
        .BYT    'A'
        .BYT    'G'
        .BYT    'S'

; === CODE ========

; R0 - SIZE, SIZE - i,
; R1 - i
; R3 - Reserved for I/O

START     LDR   R0   SIZE
          LDR   R1   i_
          SUB   R0   R1
          BRZ   R0   ENDWHILE   ; while (i < SIZE)

; R0 - i * INTSIZE
; R1 - i
; R2 - INTSIZE
; R3 - Reserved for I/O
; R7 - ARR[ i * INTSIZE ]

          LDA   R7   ARR        ; Load address of ARR in R7
          MOV   R0   R1
          LDR   R2   INT
          MUL   R0   R2
          ADD   R7   R0

; R0 - sum + (ARR[ i * INTSIZE]) = 10 12 15 19 34 28 35 43 52 62
; R1 - i
; R2 - ARR[ i * INTSIZE ] = = 10 2 3 4 15 -6 7 8 9 10
; R3 - Reserved for I/O
; R7 - (ARR[ i * INTSIZE ])

          LDR   R0   sum
          LDR   R2   (R7)
          ADD   R0   R2
          STR   R0   sum        ; sum += arr[i]

; R0 -
; R1 - i
; R2 - 2
; R3 - Reserved for I/O
; R4 - (x / 2) * 2 or "Result"
; R5 - Value located at R7 - R4
; R6 - Value located at R7
; R7 - (ARR[ i * INTSIZE ]) = 10 2 3 4 15 -6 7 8 9 10

          LDR   R6   (R7)
          LDR   R2   II
          MOV   R4   R6
          DIV   R4   R2         ; (10 / 2) * 2 (Result)
          MUL   R4   R2
          MOV   R5   R6
          SUB   R5   R4         ; Should give 0 or 1

          MOV   R3   R6         ; Print arr[i]
          TRP   1

          LDR   R3   SP         ; Space
          TRP   3

          LDR   R3   _i         ; Print is
          TRP   3
          LDR   R3   _s
          TRP   3

          LDR   R3   SP         ; Space
          TRP   3

          BRZ   R5   EVEN       ; Branch if even

          ; It's odd
          LDR   R3   o
          TRP   3

          LDR   R3   d
          TRP   3
          TRP   3

          JMP   ENDIF

          ; It's even
EVEN      LDR   R3   e
          TRP   3

          LDR   R3   v
          TRP   3

          LDR   R3   e
          TRP   3

          LDR   R3   n
          TRP   3

ENDIF     LDR   R3   RET
          TRP   3

          LDR   R4   I
          ADD   R1   R4
          STR   R1   i_			; i++

          JMP START

ENDWHILE  LDR   R3   S          ; Print Sum
          TRP   3
          LDR   R3   u
          TRP   3
          LDR   R3   m
          TRP   3

          LDR   R3   SP         ; Space
          TRP   3

          LDR   R3   _i         ; Print is
          TRP   3
          LDR   R3   _s
          TRP   3

          LDR   R3   SP         ; Space
          TRP   3

          LDR   R3   Sum
          TRP   1

          LDR   R3   RET		; Return
          TRP   3

; == PART TWO ========================================================

          LDA   R0   DAGS       ; Loads the address of D
          MOV   R1   R0         ; R1 <- R0

          ;LDR   R2   I          ; Byte Size
          ;LDR   R6   INT        ; Int Size

          LDB   R3   (R0)
          TRP   3

          ADD   R0   R2
          LDB   R3   (R0)
          TRP   3

          ADD   R0   R2
          LDB   R3   (R0)
          TRP   3

          ADD   R0   R2
          LDB   R3   (R0)
          TRP   3                ; Prints out DAGS

          LDR   R3   SP
          TRP   3

          LDR   R3   (R1)        ; Print out DAGS as an INT
          MOV   R7   R3
          TRP   1

          LDR   R3   RET
          TRP   3

          LDB   R4   (R1)       ; Loads byte 'D' into R4
          ADD   R1   R2
          ADD   R1   R2         ; Moves address to G in DAGS
          LDB   R5   (R1)       ; Loads 'G' into R5
          STB   R4   (R1)       ; Stores 'D' where 'G' used to be
          SUB   R1   R2
          SUB   R1   R2         ; Return to beginning of string
          STB   R5   (R1)       ; Stores 'G' where 'D' used to be

          LDB   R3   (R1)
          TRP   3

          ADI   R1   1
          LDB   R3   (R1)
          TRP   3

          ADI   R1   1
          LDB   R3   (R1)
          TRP   3

          ADI   R1   1
          LDB   R3   (R1)
          TRP   3

          LDB   R3   SP
          TRP   3

          ;SUB   R1   R6
          ADI   R1   -3         ; Hack to make things better
          ;ADI   R1   1          ; Hack to get it on the right byte.
          LDR   R3   (R1)       ; I'm getting lazy with commenting
          TRP   1

          LDB   R3   RET
          TRP   3

          LDR   R3   (R1)
          SUB   R7   R3
          MOV   R3   R7
          TRP   1

          TRP   0
