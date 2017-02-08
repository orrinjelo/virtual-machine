import unittest
import os
from TestUtils import Asm

class Proj1Test(unittest.TestCase):
    def test_proj1(self):
        f = open('../Archive/proj1.asm','r')
        asml = ''.join(f.readlines())
        a = Asm(asml, 'asm_test_proj1.log', 4192, False)
        hex = a.execute().hexdump
        ret = a.retcode
        log = a.log
        self.assert_(hex == '54796c65 7250616b 2ca201 0002 0003 0004 0005 0006 0002c 100ffffff96 00032 00014 000a 000fffffff4 100a 0003 0005 0000 0003 0000 000a 0003 0006 0000 0003 0000 000a 0003 0004 0000 0003 0000 000a 0003 0007 0000 0003 0000 000a 0003 0008 0000 0003 0000 000a 0003 000a 0000 0003 0000 000a 0003 0000 0000 0003 0000 000a 0003 0001 0000 0003 0000 000a 0003 0002 0000 0003 0000 000a 0003 0003 0000 0003 0000 000a 0003 0004 0000 0003 0000 000a 0003 0009 0000 0003 0000 0000 0003 0000 000a 0000 00023 000a 0001 00027 000d 0000 0001 0007 0003 0000 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 000a 0001 0002b 000d 0000 0001 0007 0003 0000 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 000a 0001 0002f 000d 0000 0001 0007 0003 0000 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 000a 0001 00033 000d 0000 0001 0007 0003 0000 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 000a 0001 0001b 000d 0000 0001 0007 0003 0000 0000 0001 0000 000a 0003 0009 0000 0003 0000 0000 0003 0000 000a 0001 000b 000a 0002 000f 00010 0001 0002 0007 0003 0001 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 000a 0002 00013 00010 0001 0002 0007 0003 0001 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 000a 0002 00017 00010 0001 0002 0007 0003 0001 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 000a 0002 0001b 00010 0001 0002 0007 0003 0001 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 000a 0002 0001f 00010 0001 0002 0007 0003 0001 0000 0001 0000 000a 0003 0009 0000 0003 0000 0000 0003 0000 0007 0003 0000 000a 0004 00023 00011 0003 0004 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 0007 0003 0000 000a 0004 00027 00011 0003 0004 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 0007 0003 0000 000a 0004 0002b 00011 0003 0004 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 0007 0003 0000 000a 0004 0002f 00011 0003 0004 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 0007 0003 0000 000a 0004 00033 00011 0003 0004 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 0007 0003 0000 000a 0004 0001b 00011 0003 0004 0000 0001 0000 000a 0003 0009 0000 0003 0000 0000 0003 0000 0007 0003 0001 000a 0004 00037 000f 0003 0004 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 0007 0003 0001 000a 0004 000f 000f 0003 0004 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 0007 0003 0001 000a 0004 0001b 000f 0003 0004 0000 0001 0000 000a 0003 000a 0000 0003 0000 0000 0003 0000 0007 0003 0001 000a 0004 00033 000f 0003 0004 0000 0001 0000 000a 0003 0009 0000 0003 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000', 'Hex dump on Proj1Test failed')
        self.assert_(ret == 0 or ret == None, 'Ret code on Proj1Test test failed.')
        self.assert_(log == ['Park, Tyler\n', '\n', '450  500  520  530  535\n', '\n', '2  6  24  120  720\n', '\n', '1  3  10  26  53  107\n', '\n', '220  718  715  710\n'] )
  
if __name__ == '__main__':
    unittest.main()