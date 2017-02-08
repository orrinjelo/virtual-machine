# Build first for Linux g++
CC = g++
WCC = i686-w64-mingw32-g++
#WCC64 = x86_64-w64-mingw32-g++ 

# libraries
LIB = -lstdc++
WLIB = -lstdc++
BLIB = -lboost_program_options -lstdc++
DIR = -L/usr/lib/x86_64-linux-gnu
WDIR = -L/usr/lib/i386-linux-gnu -L/usr/i686-w64-mingw32/lib
INCLUDES = -I ./Includes 
WINCLUDES = -I ./Includes -I/usr/i686-w64-mingw32/include

# compiler flags:
#  -g		adds debugging information to the executable file
#  -Wall	turns on most, but not all, compiler warnings
CFLAGS = -std=c++11 -g -static -Wall $(INCLUDES) $(DIR) $(LIB) 
WCFLAGS = -std=c++11 -g -static -Wall -DNOANSI $(WINCLUDES) $(WDIR) $(WLIB)
BCFLAGS = -std=c++11 -g -static -Wall -DBOOST $(INCLUDES) $(DIR) $(BLIB)
WBCFLAGS = -std=c++11 -g -static -Wall -DNOANSI -DBOOST $(WINCLUDES) $(WDIR) $(BLIB)

# the build target executable
SRC = Src
TARGET = vm

# class objects
COBJ = Src/Assembler.cpp Src/VirtualMachine.cpp

all: $(TARGET)

$(TARGET): $(SRC)/$(TARGET).cpp linuxboost win32boost
	
linux:
	$(CC) -o $(TARGET) $(SRC)/$(TARGET).cpp $(COBJ) $(CFLAGS)

linuxboost:
	$(CC) -o $(TARGET) $(SRC)/$(TARGET).cpp $(COBJ) $(BCFLAGS)

win32:
	$(WCC) -o $(TARGET).exe $(SRC)/$(TARGET).cpp $(COBJ) $(WCFLAGS)
	
win32boost:
	$(WCC) -o $(TARGET).exe $(SRC)/$(TARGET).cpp $(COBJ) $(WBCFLAGS)


# I haven't gotten x64 to work
#win64:
#	$(WCC64) $(WCFLAGS) -o $(TARGET)_x64.exe $(TARGET).cpp $(COBJ)

clean: 
	$(RM) $(TARGET) *.o *.exe
