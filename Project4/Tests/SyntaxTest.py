import unittest
import subprocess as sp
import os
from TestUtils import Asm

class SyntaxTest(unittest.TestCase):
    def test_byt_directives(self):
        a = Asm(
'''LETTER    .BYT    65
   ARR       .BYT    65
             .BYT    66
             .BYT    67
              TRP    0''', 'asm_test_byt_directives.log', 24, True)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '41414243 0000 0000 0000 0000 0000', 'Hex dump on byte directives failed')
        self.assert_(not ret, 'Ret code on byte directives test failed.')
         
    def test_int_directives(self):
        a = Asm(
'''ONE       .INT    65
   ARR       .INT    65
             .INT    66
             .INT    67
              TRP    0''', 'asm_test_int_directives.log', 32, True)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '41000 41000 42000 43000 0000 0000 0000 0000', 'Hex dump on int directives failed')
        self.assert_(not ret, 'Ret code on int directives test failed.')
         
    def test_byt_directives_char(self):
        a = Asm(
'''A         .BYT    'A'
              TRP    0''', 'asm_test_int_directives.log', 16, True)
        hex = a.execute().hexdump
        ret = a.retcode
        self.assert_(hex == '41000 0000 0000 0000', 'Hex dump on int directives failed')
        self.assert_(not ret, 'Ret code on int directives test failed.')
if __name__ == '__main__':
    unittest.main()
    