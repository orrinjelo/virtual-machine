# Orrin Jelo's Virtual Machine

This is a virtual machine and assembler created and used in UVU CS4380.  This is for demo purposes only.  Any academic use is prohibited.

## TABLE OF CONTENTS

I.   PROJECT DESCRIPTION<br />
II.  COMPILING AND EXECUTION<br />
III. ASSEMBLY SYNTAX<br />
IV.  ABOUT THE AUTHOR<br />
V.  ADDITIONAL VERSION NOTES<br />

## I. Project Description

UVU CS 4380 - Advanced Computer Architecture - Curtis Welborn

This projects implements a virtual machine and assembler based on an early RISC-based architecture.  I will only supply the base source code and not the executables; obtaining BOOST or compiling the project will be on your own terms.  

### Project 1 
Project 1 is the basic virtual machine and assembler construction.  A sample assembly file can be parsed and executed.

#### Test Program
Write the following assembly program using your assembly language: <br />
Place the following list of integers in memory <br />
A = (1, 2, 3, 4, 5, 6)<br />
B = (300, 150, 50, 20, 10, 5)<br />
C = (500, 2, 5, 10)<br />
Place your full name “Last Name, First Name” in contiguous memory.<br />

#### Program Output
1) Print your name on the screen.<br />
2) Print a blank line.<br />
3) Add all the elements of list B together; print each result (intermediate and final) on screen.  Put 2 spaces between each result. (e.g., 450) <br />
4) Print a blank line. <br />
5) Multiply all the elements of list A together; print each result (intermediate and final) on screen. Put 2 spaces between each result. (e.g., 2) <br />
6) Print a blank line.<br />
7) Divide the final result from part 3, by each element in list B (the results are not cumulative). Put 2 spaces between each result. (e.g., 1)<br />
8) Print a blank line.<br />
9) Subtract from the final result of part 5 each element of list C (the results are not cumulative). Put 2 spaces between each result. (e.g., 220)<br />

Create a directive for each element of the list and letter of your name. 

### Project 2
Project 2 implements additional instructions (jump, move, compare, and register indirect addressing).  This will give us control structures in our assembly, such as if-else statements and while loops.

#### Test Program
Write the following C like program in your assembly language.  Make sure you implement your code such that arr is accessed as an array.  Your code must loop SIZE number of times.  There must be a variable named ARR and SIZE in your assembly program.

    #Part 1
    int SIZE = 10;
    int arr[] = { 10, 2, 3, 4, 15, -6, 7, 8, 9, 10 };
    int i = 0;
    int sum = 0;
    int temp;
    int result;
    
    while (i < SIZE) {
    	sum += arr[i];
    	result = arr[i] % 2;
    	if (result == 0)
    		printf("%d is even\n", arr[i]);
    	else
    		printf("%d is odd\n", arr[i]);
        i++;
    }
    
    printf("Sum is %d\n", sum);
    
#Part 2 -- Only do this if you have byte addressable memory.

Place “DAGS” into continuous memory (on an integer boundary if it matters to your VM has never matter to anyone up until now) : ‘D’, ‘A’, ‘G’, ‘S’.<br />
Print the char data (e.g., DAGS), followed by the integer value for accessing “DAGS” as an integer to the screen.  
DAGS  ??????

Swap the ‘D’ and the ‘G’ in memory and access the location in memory again as an integer. <br /> 
Print the data (e.g., GADS), followed by the integer value for “GADS”.  GADS  ?????

Subtract the two integers together (DAGS - GADS) and print the value of this integer. ?????<br />

NOTE: If working with the words “DAGS” or “GADS” will produce all positive integers if you have done everything correct. <br />
IF your project does not support byte addressable member do not attempt Part 2 just skip it.  If I discover you implement Part 2 but don’t have byte addressable memory I will give you a failing grade (30% or lower) for Project 2. 

#### Program Output
Print the integer in the array followed by “is even” if it is even.<br />
Print the integer in the array followed by “is odd” if it is odd.<br />
Print “Sum is “followed by the sum of the array.

Print “DAGS”, the integer value for "DAGS", “GADS”, the integer value for "GADS", and the result of subtracting "GADS" from “DAGS".  Put a space between each of these (don’t run them together)!

### Project 3
Project 3 implements procedure calls, introduces registers, and uses the stack.  

#### Test Program
Convert the following program to assembly; do not try to rewrite it:

    const int  SIZE = 7;
    int  cnt;
    int  tenth;
    char c[SIZE];
    int  data;
    int  flag;
    int  opdv;

    /*
      Convert char j to an integer if possible.
      If the flag is not set use the sign indicator s
      and the tenths indicator to compute the actual
      value of j.  Add the value to the accumulator opdv.
    */

    void opd(char s, int k, char j) {
        int t = 0;  // Local var

        if (j == '0')      // Convert 
            t = 0;
        else if (j == '1')
            t = 1;
        else if (j == '2')
            t = 2;
        else if (j == '3') 
            t = 3;
        else if (j == '4')
            t = 4;
        else if (j == '5')
            t = 5;
        else if (j == '6')
            t = 6;
        else if (j == '7')
            t = 7;
        else if (j == '8')
            t = 8;
        else if (j == '9')
            t = 9;
        else {
            printf("%c is not a number\n", j);
            flag = 1;
        }

        if (!flag) {
            if (s == '+')
                t *= k;	
            else
                t *= -k;

            opdv += t;
        }
    }	



    /*
      Discard keyboard input until a newline ‘\n’ is
      Encountered.
    */
    void flush() {
        data = 0;
        c[0] = getchar();
        while (c[0] != '\n')
            c[0] = getchar();
    }



    /*
       Read one char at a time from the keyboard after a
       newline ‘\n’ has been entered. If there is room
       place the char in the array c
       otherwise indicate the number is too big and
       flush the keyboard input.
    */
    void getdata() {
        if (cnt < SIZE) { // Get data if there is room
            c[cnt] = getchar();  // Your TRP 4 should work like getchar()
            cnt++;
        } else {
            printf("Number too Big\n");
            flush();
        }
    }

    /*
      Reset c to all 0’s
      Assign values to data, opdv, cnt and flag.
    */
    void reset(int w, int x, int y, int z) {
        int k;  // Local var
        for (k= 0; k < SIZE; k++)
            c[k] = 0;
        data = w;
        opdv = x;
        cnt  = y;
        flag = z;
    }

    /*
      Get input from the keyboard until the symbol ‘@’ is encountered.
      Convert the char data input from the keyboard to an integer be
      Sure to account for the sign of the number.  If no sign is used
      always assume the number is positive.
    */
    void main() {
        reset(1, 0, 0, 0); // Reset globals
        getdata();         // Get data
        while (c[0] != '@') { // Check for stop symbol '@'
            if (c[0] == '+' || c[0] == '-') { // Determine sign
                getdata(); // Get most significant byte
            } else {  // Default sign is '+'
                c[1] = c[0]; // Make room for the sign
                c[0] = '+';
                cnt++;
            }
            while(data) {  // Loop while there is data to process			
                if (c[cnt-1] == '\n') { // Process data now
                    data = 0;
                    tenth = 1;
                    cnt = cnt - 2;

                    while (!flag && cnt != 0) { // Compute a number
                        opd(c[0], tenth, c[cnt]);
                        cnt--;
                        tenth *= 10;
                    }
                    if (!flag)  //  Good number entered
                        printf("Operand is %d\n", opdv);
                } 
                else
                    getdata(); // Get next byte of data
            }		
            reset(1, 0, 0, 0);  // Reset globals
            getdata();          // Get data
        }
    }
    
### Project 4
This projects pushes the limits of our knowledge with computer architecture.  This involves a recursive function test, addressing modes, and multi-threading.

#### Implemented is the following

NOTE: You must implement parts 1 and 2 below you can't JUST embedded them in part 3 only and expect to be given credit for parts 1 and 2. Part 1 and 2 are single threaded while Part 3 uses Parts 1 and 2 and is multi-threaded.


##### Part 1 and 2 are sequential code.

1. Recursive Function Test
    Implement a recursive factorial function by using a run-time stack to both pass parameters and return a result. You must place an activation record on a run-time stack!<br />
    Repeatedly compute and printout the factorial value for an integer entered from the keyboard.   The key to stop computing values is when the value 0 is entered.  Output MUST look like:<br />
        Factorial of X is Y 
    Where X is the value entered and Y is the computed factorial value.<br />
    I don't know how to be more obvious and clear than to say this is a WHILE-Loop implemented in assembly code. That stops when 0 is entered at standard input.

2. Addressing Mode Test
    Create an array with space for 30 integer values.  Each time an integer is entered for the recursive factorial function above place it (the X value) into the array (start at the beginning location).  Place the factorial of the value (the Y value) into the array at the next available position ([X1,Y1,X2,Y2,X3,Y3,…,Xn ≤ 30,Yn ≤ 30).   When the value of 0 is entered print the integers that were entered into the array as follows, (CNT is the next free location in the array). <br />
        Array[0],  Array[CNT-1],  Array[1], Array[CNT-2], …, Array[CNT-(CNT/2 +1)], Array[CNT- (CNT/2)]

    Think about it the Array of X and Y values has to have and even number of values. You are being asked to print the one from the front then one from back until you print the 2 in the middle.<br />
    Don't redundantly re-ask for X value just let the X and Y from part #1 be used here. 

3. Multi-Threaded VM
    Note:  Students who fully understand function calls from the Project 3 indicate implementing this is not very difficult.

    Implement a multi-Threading architecture for your VM using the following instructions. Note, this is a simplified multi-Threading (not complete) architecture. 

    * RUN	REG, LABEL
        Run signals to the VM to create a new thread.  <br />
        REG will return a unique thread identifier (number) that will be associated with the thread.  The register is to be set by your VM, not by the programmer calling the RUN instruction.  You can determine what action to perform if all available identifiers are in use (throwing an exception is fine). Running out of identifiers means you have created two many threads and are out of Stack Space.<br />
        The LABEL will be jumped to by the newly created thread.  The current thread will continue execution at the statement following the RUN. 
    * END
        End will terminate the execution of a non-MAIN thread.  In functionality END is very similar to TRP 0, but only for a non-MAIN threads. END should only be used for non-MAIN threads.  END will have no effect if called in the MAIN Thread.
    * BLK
        Block will cause the MAIN thread (the initial thread created when you start executing your program) to wait for all other threads to terminate (END) before continuing to the next instruction following the block.  Block is only to be used on the MAIN thread. BLK will have no effect if called in a Thread which is not the MAIN thread.
    * LCK LABEL
        Lock will be used to implement a blocking mutex lock.  Calling lock will cause a Thread to try to place a lock on the mutex identified by Label. If the mutex is locked the Thread will block until the mutex is unlocked.  The data type for the Label is .INT 
    * ULK LABEL
        Unlock will remove the lock from a mutex.  Unlock should have no effect on a mutex if the Thread did not lock the mutex (a.k.a., only the Thread that locks a mutex should unlock the mutex).

    Once you implemented the new instructions create the following test code to CLEARLY shows that your multi-threading architecture works by reusing the code from parts 1 and 2 above to call your factorial function on multiple Threads (you must have at least 4 threads plus the main thread).<br />
    * Use locks and unlocks to access the common Array in step 2. This is an exceptional cool example program and something you can use in a job interview.  
    * You don't need to rewrite the factorial function just call it on multiple threads.
    * You will need to rewrite the code that invokes the factorial function. The diagram below gives you an outline for such a multiple threaded version. 
    * I will expect to see Mishmoosh when printing "Factorial of X is Y" 
        * By Mishmoosh I mean the print out of "Factorial of X is Y" will be interlaced between the threads.
        * This is a race condition we are test so entering X values like 1, 5, 9, 11 will get little to no Mishmoosh while X values like 5,5,5 3 should produce lots of it. 
        
## Compiling and Execution

I am using MAKE so that I can compile Windows executables and Linux executables
at the same time (among other reasons).  In order for this to work, you need to
have the g++ C++ compiler as well as i686-w64-mingw32-g++.  These compilers 
must be in the execution path ($PATH for most Linux distros).

To compile both versions (with Boost!), simply type 'make' or 'make all'.

To compile Linux only, type 'make linux' (no Boost) or 'make linuxboost' (yes 
Boost).

To compile Windows only, type 'make win32' (no Boost) or 'make win32boost (yes 
Boost).

At the time, I have been unsuccessful for compiling for 64-bit executables for
Windows.  

If you want to compile this without Make, try something like:

    > g++ -o vm Assembler.cpp VirtualMachine.cpp vm.cpp

This, by default, will not compile it with Boost.

My version of g++ (gcc) is 4.9.2 and compiles my VM under Ubuntu without hitch.
Results may vary with other compilers.

For execution, simply call the program executable and the assembly file, e.g.:

    > ./vm proj1.asm

or:

    > vm.exe proj1.asm

or if you think you're really clever:

    > wine vm.exe proj1.asm

If you have compiled with Boost, you should be able to try additional 
arguments:

    --debug				Runs debug mode (LOTS of text!) 
                         As of v. 0.2.1, this will also give a register.log file
    --help				Shows a help thingy
    --memsize=(arg)     Can use bytes (e.g. '256'), kilobytes (e.g. '3k'), or
                         Megabytes (e.g. '1M').  Memory defaults to 16k.
    --vomit=(arg)       Produces a vomit log, a memory dump.  
                         0 = Binary file, 1 = Pretty mode, 2 = Hex dump
    --step              Step debug mode (ugly and slow).
    
## III. Assembly Syntax

This version has the following commands implemented:
	
### Jump Commands
    Op Code  Description                                          Operands
    ----------------------------------------------------------------------
    JMP      Branch to Label                                      Label
    JMR      Branch to address in source register                 RS
    BNZ      Branch to Label if source register is not zero       RS, Label
    BGT      Branch to Label if source register is greater than   RS, Label
              zero                                                 
    BLT      Branch to Label if source register is less than      RS, Label 
              zero
    BRZ      Branch to Label if source register is zero           RS, Label

### Move Instructions 
    Op Code  Description                                          Operands
    ----------------------------------------------------------------------
    MOV      Move data from source register  to destination       RD, RS 
              register
    LDA      Load the Address of the label into the RD            RD, Label
              register. This instruction should ONLY work if 
              the label is associated with a DIRECTIVE. THIS 
              command must NOT be used to get the address of 
              an instruction.
    STR      Store data into Mem from source register             RS, Label
    LDR      Load destination register with data from Mem         RD, Label
    STB      Store byte into Mem from source register             RS, Label
    LDB      Load destination register with byte from Mem         RD, Label

### Arithmetic Instructions
    Op Code  Description                                          Operands
    ----------------------------------------------------------------------
    ADD      Add source register to destination register,         RD, RS
              result in destination register
    ADI      Add immediate data to destination register.          RD, IMM
    SUB      Subtract source register from destination register,  RD, RS 
              result in destination register
    MUL      Multiply source register by destination register,    RD, RS
              result in destination register
    DIV      Divide destination register by source register,      RD, RS
              result in destination register

### Logical Instructions
    Op Code  Description                                          Operands
    ----------------------------------------------------------------------
    AND      Perform a boolean AND operation, result in           RD, RS 
              destination register. This is a logical AND 
              not a bitwise AND.
    OR       Perform a boolean OR operation, result in            RD, RS 
              destination register. This is a logical OR not a 
              bitwise OR. 

### Compare Instructions
    Op Code  Description                                          Operands
    ----------------------------------------------------------------------
    CMP      Set destination register to zero if destination is   RD, RS 
              equal to source;
             Set destination register to greater than zero if 
              destination is greater than source;
             Set destination register to less than zero if 
              destination is less than source.

### Traps
    Op Code  Description                                          Operands
    ----------------------------------------------------------------------
    TRP      Execute an I/O trap routine (a type of operating     IMM 
              system or library routine) using register R3.
             IMM Values
                1, write integer to standard out
                2, read an integer from standard in
                3, write character to standard out
                4, read a character from standard in
              Read or write a value from register R3.
    TRP      Execute STOP trap routine.                           IMM
                0, stop program

    TRP      Execute a conversion trap routine. Only one char     IMM
              at a time is converted.
             IMM Values
                10, char to int
                    ‘0’ -> 0   . . .   ‘9’ -> 9
                    otherwise  -1
                11, int to char
                    0 -> ‘0’  . . .  9 -> ‘9’
                    otherwise -1
             This instruction is seldom used but could prove useful.

### Register Indirect Addressing Instructions
    Op Code  Description                                          Operands
    ----------------------------------------------------------------------
    STR      Store data at register location from source          RS, RG
              register 
    LDR      Load destination register with data at register      RD, RG
              location
    STB      Store byte at register location from source          RS, RG
              register
    LDB      Load destination register with byte at register      RD, RG
              location

### Multithreading Specific Instructions
    Op Code  Description                                          Operands
    ----------------------------------------------------------------------
    RUN      Run signals to the VM to create a new thread.        REG, LABEL  
              REG will return a unique thread identifier 
              (number) that will be associated with the thread.  
              The register is to be set by your VM, not by the 
              programmer calling the RUN instruction.  You can 
              determine what action to perform if all available 
              identifiers are in use (throwing an exception is 
              fine). Running out of identifiers means you have 
              created two many threads and are out of Stack 
              Space.
              The LABEL will be jumped to by the newly created 
              thread.  The current thread will continue execution 
              at the statement following the RUN. 
    END      End will terminate the execution of a non-MAIN       None
              thread.  In functionality END is very similar to 
              TRP 0, but only for a non-MAIN threads. END should 
              only be used for non-MAIN threads.  END will 
              have no effect if called in the MAIN Thread.
    BLK      Block will cause the MAIN thread (the initial 
              thread created when you start executing your 
              program) to wait for all other threads to 
              terminate (END) before continuing to the next 
              instruction following the block.  Block is 
              only to be used on the MAIN thread. BLK will 
              have no effect if called in a Thread which is 
              not the MAIN thread.
    LCK      Lock will be used to implement a blocking mutex      Label 
              lock.  Calling lock will cause a Thread to try to 
              place a lock on the mutex identified by Label. If 
              the mutex is locked the Thread will block until 
              the mutex is unlocked.  The data type for the Label 
              is .INT
    ULK      Unlock will remove the lock from a mutex.  Unlock    Label
              should have no effect on a mutex if the Thread 
              did not lock the mutex (a.k.a., only the 
              Thread that locks a mutex should unlock the 
              mutex).
              
There are some catches with the operands for some of the commands which 
may crash the VM.  Registers (R0-R7) are seen as labels, returning an
integer value (0-7).  That means you do not need the "R" in front of the
register operand.  Passing a pre-defined label may work if it is an 
actual register, but otherwise may enter into unexplored territory in 
memory.

Parenthesis will only work on instructions that work with indirect 
addressing modes.

Comments are beautiful.  You may use them anywhere after a command or on its
own line with a semicolon (;).  

Whitespace is beautiful too.  My assembly will handle any space or tabs, and
doesn't mind if you use commas.  Strangely, you could maybe get away with
some weird stuff like this:

    ,,,,,,,,,MOV,,,R1,,,R2

Blank lines between instructions is also acceptable.

Commands and register keywords must be uppercase.  Anything else user defined
doesn't have to be.

Functions can be a little tricky, but I managed to make a type of template for
them.  The following is a call to print:

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
          LDA  R6  hw
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

While the current version of the template shows R0-R5 being backed up
and restored, these aren't necessary unless you want them to retain 
their values. I've made R0-R5 my general purpose registers with
R6 & R7 as my special purpose registers (these will be written over
no matter what in functions).

And the following is the function print itself:

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

Although it isn't in the function above, checking for underflow at the
beginning of the function may be good practice.

## IV. About the Author

I am the lead algorithms enginner at radar and data solutions company called Fortem Technologies.  I have graduated with a MS in physics from Brigham Young University and a BS in physics at Utah Valley University (minors in computer science and mathematics).  For a short time, I considered changing my CS minor into another BS degree.

In my free time, I like doing stupid stuff like computer games (League of Legends, Minecraft, VR games), do recreational math (Go, Project Euler, Kakuro), read, listen to music, and dink around with hobby electronics like RaspberryPi and Parallax Propeller.

My aspirations are to create a quantum computing virtual machine and resurrect a wooly mammoth.

## VI. ADDITIONAL VERSION NOTES

### v. 0.1.3

Since current versions of the Windows does not support ANSI, I have removed all
ANSI tags from the Windows-side of the compiling.  By separating ANSI into a 
header file of its own, I have made it easy to disable ANSI tags (no '\033[m'
crap) and made it easier to read in the code (ansi.RED instead of '\033[31m').

### v. 0.2.1

All advised instructions/op codes are implemented.  Debug and vomit modes have
been expanded.  Python scripts in the Test folder will run unit tests on my
vm.  It is not yet complete, but basic unit tests exists.

### v. 0.2.2
  
Finalized the basic regression tests int the Tests folder.  Added the parsing
of 'k' and 'M' in the 'memsize' argument.  Implemented a binary vomit mode.
Tests have verified that assembler is writing all instructions correctly, the
question now is whether it parses everything correctly.

### v. 0.3.1

Took me all this time to get the functions sorted out (it's an assembly issue,
not a VM issue).  The only noticeable change in the VM was the code for the
TRP 4, which uses getch instead of cin as an input. 

### v. 0.4.1

Again, pressured for time, but I got things working for multithreading.  I
haven't done rigorous testing yet, but the basics are there.   As long as I 
don't try anything stupid, multithreading is a breeze.

### Future versions?

Some things I want to implement:
- instead of doing a log("message") sort of thing, I want to have it return a
 custom stream; e.g. log(ERROR) << "err" would give me a red-colored error
 message, opposed to log(WARNING) or log(DEBUG) or log(VOMIT).  

- create some more standardized ANSI framework, one that works both in Linux
 and Windows (ANSI.sys?) environments

- Condense the requirements for a function call.  Instead of having a dynamic
 return address (counting the lines between PC copy and returning line), 
 find some simpler way and possibly make it a fixed amount?  Don't have to 
 back up all the common registers?
