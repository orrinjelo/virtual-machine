import subprocess as sp
import os

class Asm(object):
    def __init__(self, source, logfile="output.log", size=1024, debug=True):
        f = open('temp.asm', 'w')
        f.write(source)
        f.close()
        self.__logfile = logfile
        self.__size = size
        self.__debug = debug
        
    def execute(self):
        #os.execl('../vm', '--debug', 'temp.asm')
        exe = '../vm '
        args = 'temp.asm'
        memarg = '--memsize=' + str(self.__size)
        vomitarg = '--vomit=2'
        debugarg = '--debug' 
        if self.__debug:
            p = sp.Popen(['../vm', memarg, vomitarg, debugarg, 'temp.asm'], stdout=sp.PIPE, stderr=sp.STDOUT)
        else:
            p = sp.Popen(['../vm', memarg, vomitarg, 'temp.asm'], stdout=sp.PIPE, stderr=sp.STDOUT)
        f = open(os.path.join('logs',self.__logfile), 'w')
        line = p.stdout.readline()
        while line:
            f.write(line)
            line = p.stdout.readline()
        f.close()
        self.__retcode = p.returncode
        return self
    
    @property
    def hexdump(self):
        f = open('vomit.log','r')
        self.__hexdump = f.readline()
        f.close()
        return self.__hexdump
    
    @property
    def log(self):
        f = open(os.path.join('logs',self.__logfile), 'r')
        self.__log = f.readlines()
        f.close()
        return self.__log
        
    @property
    def retcode(self):
        return self.__retcode
    
    def __del__(self):
        os.remove('temp.asm')
        #os.remove('vomit.log')
        os.remove('registers.log')
        pass