import unittest
import os
from TestUtils import Asm

class InstructionCodeTest(unittest.TestCase):
    def test_jmp(self):
        a = Asm(
'''
JMP  END
END  TRP  0''', 'asm_test_instr_jmp.log', 24, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '1000 c000 0000 0000 0000 0000', 'Hex dump on JMP failed')
        self.assert_(not ret, 'Ret code on JMP test failed.')
        self.assert_(os.stat("logs/asm_test_instr_jmp.log").st_size == 0)
             
    def test_jmr(self):
        a = Asm(
'''
JMP  END  
JMR  R1  END
END  TRP  0''', 'asm_test_instr_jmr.log', 36, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '1000 18000 0000 2000 1000 18000 0000 0000 0000', 'Hex dump on JMR failed')
        self.assert_(not ret, 'Ret code on JMR test failed.')
        self.assert_(os.stat("logs/asm_test_instr_jmr.log").st_size == 0)
        # TODO: ensure that JMR really pulls the address from R1
             
    def test_bnz(self):
        a = Asm(
'''
JMP  END
BNZ  R1  END
END  TRP  0''', 'asm_test_instr_bnz.log', 36, False) 
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '1000 18000 0000 3000 1000 18000 0000 0000 0000', "Hex dump on BNZ failed")
        self.assert_(not ret, 'Ret code on BNZ test failed.')
        self.assert_(os.stat('logs/asm_test_instr_bnz.log').st_size == 0)
            
    def test_bgt(self):
        a = Asm(
'''
JMP  END  
BGT  R1  END
END  TRP  0''', 'asm_test_instr_bgt.log', 36, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '1000 18000 0000 4000 1000 18000 0000 0000 0000', 'Hex dump on BGT failed')
        self.assert_(not ret, 'Ret code on BGT test failed.')
        self.assert_(os.stat("logs/asm_test_instr_bgt.log").st_size == 0)
             
    def test_blt(self):
        a = Asm(
'''
JMP  END  
BLT  R1  END
END  TRP  0''', 'asm_test_instr_blt.log', 36, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '1000 18000 0000 5000 1000 18000 0000 0000 0000', 'Hex dump on BLT failed')
        self.assert_(not ret, 'Ret code on BLT test failed.')
        self.assert_(os.stat("logs/asm_test_instr_blt.log").st_size == 0)
              
    def test_brz(self):
        a = Asm(
'''
JMP  END  
BRZ  R1  END
END  TRP  0''', 'asm_test_instr_brz.log', 36, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '1000 18000 0000 6000 1000 18000 0000 0000 0000', 'Hex dump on BRZ failed')
        self.assert_(not ret, 'Ret code on BRZ test failed.')
        self.assert_(os.stat("logs/asm_test_instr_brz.log").st_size == 0)
              
    def test_mov(self):
        a = Asm(
'''
MOV  R1  R2
END  TRP  0''', 'asm_test_instr_mov.log', 36, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '7000 1000 2000 0000 0000 0000 0000 0000 0000', 'Hex dump on MOV failed')
        self.assert_(not ret, 'Ret code on MOV test failed.')
        self.assert_(os.stat("logs/asm_test_instr_mov.log").st_size == 0)
               
    def test_lda(self):
        a = Asm(
'''
ONE  .BYT 0
LDA  R1  ONE  
    TRP  0''', 'asm_test_instr_lda.log', 28, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '0800 0100 0000 0000 0000 0000 0000', 'Hex dump on LDA failed')
        self.assert_(not ret, 'Ret code on LDA test failed.')
        self.assert_(os.stat("logs/asm_test_instr_lda.log").st_size == 0)
               
    def test_str(self):
        a = Asm(
'''
ONE  .BYT 0
STR  R1  ONE  
    TRP  0''', 'asm_test_instr_str.log', 36, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '0900 0100 0000 0000 0000 0000 0000 0000 0000', 'Hex dump on STR failed')
        self.assert_(not ret, 'Ret code on STR test failed.')
        self.assert_(os.stat("logs/asm_test_instr_str.log").st_size == 0)
               
    def test_ldr(self):
        a = Asm(
'''
ONE  .INT 0
LDR  R1  ONE  
    TRP  0''', 'asm_test_instr_ldr.log', 32, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '0000 a000 1000 0000 0000 0000 0000 0000', 'Hex dump on LDR failed')
        self.assert_(not ret, 'Ret code on LDR test failed.')
        self.assert_(os.stat("logs/asm_test_instr_ldr.log").st_size == 0)
            
    def test_stb(self):
        a = Asm(
'''
ONE  .INT 0
STB  R1  ONE  
    TRP  0''', 'asm_test_instr_stb.log', 32, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '0000 b000 1000 0000 0000 0000 0000 0000', 'Hex dump on STB failed')
        self.assert_(not ret, 'Ret code on STB test failed.')
        self.assert_(os.stat("logs/asm_test_instr_stb.log").st_size == 0)
          
    def test_ldb(self):
        a = Asm(
'''
ONE  .BYT 0
LDB  R1  ONE  
    TRP  0''', 'asm_test_instr_ldb.log', 32, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '0c00 0100 0000 0000 0000 0000 0000 0000', 'Hex dump on LDB failed')
        self.assert_(not ret, 'Ret code on LDB test failed.')
        self.assert_(os.stat("logs/asm_test_instr_ldb.log").st_size == 0)
               
    def test_stri(self):
        a = Asm(
'''
ONE  .INT 0
LDR  R2  ONE
STR  R1  (R2)  
    TRP  0''', 'asm_test_instr_stri.log', 44, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '0000 a000 2000 0000 15000 1000 2000 0000 0000 0000 0000', 'Hex dump on STRi failed')
        self.assert_(not ret, 'Ret code on STRi test failed.')
        self.assert_(os.stat("logs/asm_test_instr_stri.log").st_size == 0)
               
    def test_ldri(self):
        a = Asm(
'''
ONE  .INT 0
LDR  R1  ONE
LDR  R2  (R1)
    TRP  0''', 'asm_test_instr_ldri.log', 44, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '0000 a000 1000 0000 16000 2000 1000 0000 0000 0000 0000', 'Hex dump on LDRi failed')
        self.assert_(not ret, 'Ret code on LDRi test failed.')
        self.assert_(os.stat("logs/asm_test_instr_ldri.log").st_size == 0)
            
    def test_stbi(self):
        a = Asm(
'''
ONE  .INT 0
LDR  R1  ONE
STB  R1  (R1)
    TRP  0''', 'asm_test_instr_stbi.log', 44, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '0000 a000 1000 0000 17000 1000 1000 0000 0000 0000 0000', 'Hex dump on STBi failed')
        self.assert_(not ret, 'Ret code on STBi test failed.')
        self.assert_(os.stat("logs/asm_test_instr_stbi.log").st_size == 0)
           
    def test_ldbi(self):
        a = Asm(
'''
ONE  .INT 0
LDR  R1  ONE
LDB  R1  (R1)  
    TRP  0''', 'asm_test_instr_ldbi.log', 44, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '0000 a000 1000 0000 18000 1000 1000 0000 0000 0000 0000', 'Hex dump on LDBi failed')
        self.assert_(not ret, 'Ret code on LDBi test failed.')
        self.assert_(os.stat("logs/asm_test_instr_ldbi.log").st_size == 0)
           
    def test_add(self):
        a = Asm(
'''
ADD  R1  R2
TRP  0''', 'asm_test_instr_add.log', 28, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == 'd000 1000 2000 0000 0000 0000 0000', 'Hex dump on ADD failed')
        self.assert_(not ret, 'Ret code on ADD test failed.')
        self.assert_(os.stat("logs/asm_test_instr_add.log").st_size == 0)
                           
    def test_adi(self):
        a = Asm(
'''
ADI  R1  5
TRP  0''', 'asm_test_instr_adi.log', 28, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == 'e000 1000 5000 0000 0000 0000 0000', 'Hex dump on ADI failed')
        self.assert_(not ret, 'Ret code on ADI test failed.')
        self.assert_(os.stat("logs/asm_test_instr_adi.log").st_size == 0)
                           
    def test_sub(self):
        a = Asm(
'''
SUB  R1  R2
TRP  0''', 'asm_test_instr_sub.log', 28, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == 'f000 1000 2000 0000 0000 0000 0000', 'Hex dump on SUB failed')
        self.assert_(not ret, 'Ret code on SUB test failed.')
        self.assert_(os.stat("logs/asm_test_instr_sub.log").st_size == 0)
                           
    def test_mul(self):
        a = Asm(
'''
MUL  R1  R2
TRP  0''', 'asm_test_instr_mul.log', 28, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '10000 1000 2000 0000 0000 0000 0000', 'Hex dump on MUL failed')
        self.assert_(not ret, 'Ret code on MUL test failed.')
        self.assert_(os.stat("logs/asm_test_instr_mul.log").st_size == 0)
                           
    def test_div(self):
        a = Asm(
'''
DIV  R1  R2
TRP  0''', 'asm_test_instr_div.log', 28, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '11000 1000 2000 0000 0000 0000 0000', 'Hex dump on DIV failed')
        self.assert_(not ret, 'Ret code on DIV test failed.')
        self.assert_(os.stat("logs/asm_test_instr_div.log").st_size == 0)
                 
    def test_and(self):
        a = Asm(
'''
AND  R1  R2
TRP  0''', 'asm_test_instr_and.log', 28, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '12000 1000 2000 0000 0000 0000 0000', 'Hex dump on AND failed')
        self.assert_(not ret, 'Ret code on AND test failed.')
        self.assert_(os.stat("logs/asm_test_instr_and.log").st_size == 0)
                 
    def test_or(self):
        a = Asm(
'''
OR  R1  R2
TRP  0''', 'asm_test_instr_or.log', 28, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '13000 1000 2000 0000 0000 0000 0000', 'Hex dump on OR failed')
        self.assert_(not ret, 'Ret code on OR test failed.')
        self.assert_(os.stat("logs/asm_test_instr_or.log").st_size == 0)

    def test_cmp(self):
        a = Asm(
'''
CMP  R1  R2
TRP  0''', 'asm_test_instr_cmp.log', 28, False)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '14000 1000 2000 0000 0000 0000 0000', 'Hex dump on CMP failed')
        self.assert_(not ret, 'Ret code on CMP test failed.')
        self.assert_(os.stat("logs/asm_test_instr_cmp.log").st_size == 0)
                 
                 
  
if __name__ == '__main__':
    unittest.main()
    