ret .BYT 10
str .BYT '*'

rep TRP 4
    TRP 3
    LDB R0 ret
    CMP R0 R3
    BRZ R0 end
    LDB R3 str
    TRP 3
    JMP rep

end TRP 0
