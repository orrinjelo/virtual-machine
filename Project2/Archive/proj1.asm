; FIRST NAME =======================================================
T	.BYT	84
y 	.BYT 	121	; Note: There is no difference between a y and a Y.
l 	.BYT 	108 ; I have designed my assembly to be case insensitive
e 	.BYT 	101	; and whitespace apathetic.  Directives must be de-
r 	.BYT 	114 ; clared at the beginning.  Byte directives at the
				; moment do not support the single-quote representa-
P	.BYT	80	; tion ('c') and ASCII codes must be used.
a	.BYT	97
; r is declared above
k	.BYT	107

COM	.BYT	44	; Comma
RET	.BYT	10	; Line carry
SP	.BYT	32	; Space

; LIST A ============================================================
I	.INT	1
II	.INT	2
III	.INT	3
IV	.INT	4
V	.INT	5
VI	.INT	6

; LIST B ============================================================
CCC	.INT	300
CL	.INT	150
LL	.INT	50
XX	.INT	20
X	.INT	10
; Five is as declared in LIST A

; LIST C ============================================================
D	.INT	500
; Two is as declared in LIST A
; Five is as declared in LIST A
; Ten is as declared in LIST B

	; START OF PROGRAM ==================================================
	; = Printing out my name, yo ========================================
START	LDR  R3  P
		TRP  3          ; Print P
		LDR  R3  a
		TRP  3          ; Print a
		LDR  R3  r
		TRP  3          ; Print r
		LDR  R3  k
		TRP  3          ; Print k

		LDR  R3  COM
		TRP  3          ; Print ,
		LDR  R3  SP
		TRP	 3          ; Print SPACE

		LDR  R3  T
		TRP  3          ; Print T
		LDR  R3  y
		TRP  3          ; Print y
		LDR  R3  l
		TRP  3          ; Print l
		LDR  R3  e
		TRP  3          ; Print e
		LDR  R3  r
		TRP  3          ; Print r

		LDR  R3	 RET
		TRP	 3
		TRP  3          ; Prints ENDLINE twice

	; = Adding all the elements of LIST B together, yo. =================
		LDR  R0  CCC
		;MOV  R3  R0
		;TRP  1          ; Expecting 300
		                 ; I guess we don't need to show the first value
		;LDR  R3	 SP
		;TRP  3
		;TRP  3			; Two Spaces

		LDR  R1  CL
		ADD  R0  R1
		MOV  R3  R0
		TRP  1          ; Expecting 450

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		LDR  R1  LL
		ADD  R0  R1
		MOV  R3  R0
		TRP  1          ; Expecting 500

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		LDR  R1  XX
		ADD  R0  R1
		MOV  R3  R0
		TRP  1          ; Expecting 520

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		LDR  R1  X
		ADD  R0  R1
		MOV  R3  R0
		TRP  1          ; Expecting 530

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		LDR  R1  V
		ADD  R0  R1
		MOV  R3  R0
		TRP  1          ; Expecting 535

		LDR  R3	 RET
		TRP	 3
		TRP  3          ; Prints ENDLINE twice

	; "Hacking" the assembly code may be a real thing the way I implement
	; it.  Take for instance a register value, R3.  If we put an
	; immediate value there, LDR will still consider it a register value.
	; Not all the instructions are implemented, so I can't experiment
	; to see it's most crazy potential.  Restricting some of this weird
	; ability may come later on once I feel my assembler/vm code is working
	; well enough.

	; = Multiplying all the elements of LIST A together, yo! ============
	; Leaving R0 be, because we'll need it later.

		LDR  R1  I
		;MOV  R3  R1
		;TRP  1          ; Expecting 1
		                 ; I don't think we need to print the first value
		;LDR  R3	 SP
		;TRP  3
		;TRP  3			; Two Spaces

		LDR  R2  II
		MUL  R1  R2
		MOV  R3  R1
		TRP  1          ; Expecting 2

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		LDR  R2  III
		MUL  R1  R2
		MOV  R3  R1
		TRP  1          ; Expecting 6

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		LDR  R2  IV
		MUL  R1  R2
		MOV  R3  R1
		TRP  1          ; Expecting 24

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		LDR  R2  V
		MUL  R1  R2
		MOV  R3  R1
		TRP  1          ; Expecting 120

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		LDR  R2  VI
		MUL  R1  R2
		MOV  R3  R1
		TRP  1          ; Expecting 720

		LDR  R3	 RET
		TRP	 3
		TRP  3          ; Prints ENDLINE twice

	; = Dividing some stuff, yo =========================================
	; R0 contains the value we need for this step (should be 535)
	; Leaving R1 be, because we'll need it for the next step too.

		MOV  R3  R0
		LDR  R4  CCC
		DIV  R3  R4
		TRP  1          ; Expecting 1

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		MOV  R3  R0
		LDR  R4  CL
		DIV  R3  R4
		TRP  1          ; Expecting 3

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		MOV  R3  R0
		LDR  R4  LL
		DIV  R3  R4
		TRP  1          ; Expecting 10

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		MOV  R3  R0
		LDR  R4  XX
		DIV  R3  R4
		TRP  1          ; Expecting 26

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		MOV  R3  R0
		LDR  R4  X
		DIV  R3  R4
		TRP  1          ; Expecting 53

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		MOV  R3  R0
		LDR  R4  V
		DIV  R3  R4
		TRP  1          ; Expecting 107

		LDR  R3	 RET
		TRP	 3
		TRP  3          ; Prints ENDLINE twice

	; = Subtracting some stuff, yo ======================================
	; R1 should contain the value 720

		MOV  R3  R1
		LDR  R4  D
		SUB  R3  R4
		TRP  1          ; Expecting 220

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		MOV  R3  R1
		LDR  R4  II
		SUB  R3  R4
		TRP  1          ; Expecting 719

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		MOV  R3  R1
		LDR  R4  V
		SUB  R3  R4
		TRP  1          ; Expecting 715

		LDR  R3	 SP
		TRP  3
		TRP  3			; Two Spaces

		MOV  R3  R1
		LDR  R4  X
		SUB  R3  R4
		TRP  1          ; Expecting 710

		LDR  R3	 RET
		TRP  3          ; Prints ENDLINE once

		TRP  0          ; End Program
