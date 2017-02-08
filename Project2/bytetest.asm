DAGS    .BYT    'D'
        .BYT    'A'
        .BYT    'G'
        .BYT    'S'

I       .INT    1
II      .INT    2
INT     .INT    4		; Size of an integer

SP      .BYT    32		; Space
RET	    .BYT    10  	; Line carry

          LDA   R0   DAGS       ; Loads the address of D
          MOV   R1   R0         ; R1 <- R0

          LDR   R2   I          ; Byte Size
          LDR   R6   INT        ; Int Size

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

          ADD   R1   R2
          LDB   R3   (R1)
          TRP   3

          ADD   R1   R2
          LDB   R3   (R1)
          TRP   3

          ADD   R1   R2
          LDB   R3   (R1)
          TRP   3

          LDB   R3   SP
          TRP   3

          SUB   R1   R6
          ADI   R1   1
          LDR   R3   (R1)       ; I'm getting lazy with commenting
          TRP   1

          LDB   R3   RET
          TRP   3

          LDR   R3   (R1)
          SUB   R7   R3
          MOV   R3   R7
          TRP   1

          TRP   0
