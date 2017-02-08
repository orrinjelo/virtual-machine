/*
 * VirtualMachine.cpp
 *
 *  Created on: 30 Sep 2015
 *      Author: orrinjelo
 */

#include <iostream>
#include <fstream>

#include "VirtualMachine.h"
#include "AnsiSource.h"

VirtualMachine::VirtualMachine( std::string filename, bool _debug, int _bytsize, int _memsize, int _vomitlvl ) {
	debug = _debug;
	MEM_SIZE = _memsize;
	vomitlvl = _vomitlvl;
	log("Initializing virtual machine.");
	const int memsize = _memsize;
	memory = new char[memsize];
	flushmem();
	assembler = new Assembler(memory,
							  MEM_SIZE,
							  &program,
							  &heap,
							  debug,
							  _bytsize,
							  vomitlvl);

	log("Loading file and sending to the assembler.");
	assembler->load(filename);

	data = 0;					// Start of memory
	registers[PC] = program;	// End of data, start of instructions
	stack = MEM_SIZE-1;			// End of memory

	log("Assembler finished, running machine.");
	int ret = run();

	if (ret == 0)
		log(ansi.ansify("Successful execution.", ansi.BOLD, ansi.GREEN));
	else
		log(ansi.ansify("Errors encountered during execution.", ansi.BOLD, ansi.RED));
}

VirtualMachine::~VirtualMachine() {
	delete [] memory;
	delete assembler;
}

void VirtualMachine::writeInt( int data, int address )
{
  int max_addr = MEM_SIZE - sizeof(data);
  if (address >= max_addr || address < 0)
    // Out of the range, should be 0-MEMSIZE/4-1
    throw MemoryException("Unaddressable address. " + std::to_string(address));  // Unaddressable
  char* ptr = memory;
  ptr += address;
  (*(int*)ptr) = data;
}

void VirtualMachine::writeChar( char data, int address )
{
  int max_addr = MEM_SIZE;
  if (address >= max_addr || address < 0)
    // Out of the range, should be 0-MEMSIZE/4-1
    throw MemoryException("Unaddressable address. " + std::to_string(address));  // Unaddressable
  memory[address] = data;
}

int VirtualMachine::readInt( int address )
{
  int max_addr = MEM_SIZE;
  if (address >= max_addr || address < 0)
    // Out of the range, should be 0-MEMSIZE/4-1
    throw MemoryException("Unaddressable address. " + std::to_string(address) );  // Unaddressable
  char* ptr = memory;
  ptr += address;
  return (*(int*)ptr);
}

char VirtualMachine::readChar( int address )
{
  int max_addr = MEM_SIZE;
  if (address >= max_addr || address < 0)
    // Out of the range, should be 0-MEMSIZE/4-1
    throw MemoryException("Unaddressable address."  + std::to_string(address));  // Unaddressable
  return memory[address];
}

void VirtualMachine::fetch()
{
	log("VirtualMachine::fetch(): entered.");
	log("VirtualMachine::fetch(); PC = " + std::to_string(registers[PC]));
	ir.opCode =  readInt( registers[PC]              );
	ir.op1    =  readInt( registers[PC] + INT_SIZE   );
	ir.op2    =  readInt( registers[PC] + 2*INT_SIZE );
	log("VirtualMachine::fetch(); ir.opCode: " + std::to_string(ir.opCode) + "; ir.op1: " + std::to_string(ir.op1) + "; ir.op2: " + std::to_string(ir.op2));
}

void VirtualMachine::flushmem()
{
	for (int i=0; i<MEM_SIZE; i++)
		memory[i] = 0;
}

int VirtualMachine::run()
{
	bool running = true;

	try {
		while ( running )
		{
			// Fetch, decode, execute
			log("Fetching instruction.");
			fetch();
			log("Decoding instruction.");
			switch (ir.opCode)
			{
			// = TRAPS ==============================================
				case TRP:
					switch (ir.op1)
					{
						case 0:
							running = false;
							break;
						case 1:
							std::cout << (int)registers[3];
							break;
						case 2:
							int itemp;
							std::cin >> itemp;
							registers[3] = itemp;
							break;
						case 3:
							std::cout << (char)registers[3];
							break;
						case 4:
							char ctemp;
							std::cin >> ctemp;
							registers[3] = ctemp;
							break;
						case 10:
							registers[3] -= 48;
							break;
						case 11:
							registers[3] += 48;
							break;
						default:
							throw RuntimeException("This trap code is not yet implemented.");
					}
					registers[PC] += INST_SIZE;
					break;
			// = JUMPS ==============================================
				case JMP:
					registers[PC] = ir.op1;
					log("JMP opcode: " + std::to_string(ir.opCode));
					log("JMP operand: " + std::to_string(ir.op1));

					break;
				case JMR:
					registers[PC] = readInt(registers[ir.op1]);
					break;
				case BNZ:
					if (registers[ir.op1] != 0)
						registers[PC] = ir.op2;
					else
						registers[PC] += INST_SIZE;
					break;
				case BGT:
					if (registers[ir.op1] > 0)
						registers[PC] = ir.op2;
					else
						registers[PC] += INST_SIZE;
					break;
				case BLT:
					if (registers[ir.op1] < 0)
						registers[PC] = ir.op2;
					else
						registers[PC] += INST_SIZE;
					break;
				case BRZ:
					if (registers[ir.op1] == 0)
						registers[PC] = ir.op2;
					else
						registers[PC] += INST_SIZE;
					break;
			// = MOVES ==============================================
				case MOV:
					registers[ir.op1] = registers[ir.op2];
					registers[PC] += INST_SIZE;
					break;
				case LDA:
					registers[ir.op1] = ir.op2;
					registers[PC] += INST_SIZE;
					break;
				case STR:
					writeInt(registers[ir.op1], ir.op2);
					registers[PC] += INST_SIZE;
					break;
				case LDR:
					registers[ir.op1] = readInt(ir.op2);
					registers[PC] += INST_SIZE;
					break;
				case STB:
					writeChar(registers[ir.op1], ir.op2);
					registers[PC] += INST_SIZE;
					break;
				case LDB:
					registers[ir.op1] = readChar(ir.op2);
					registers[PC] += INST_SIZE;
					break;
			// = Arithmetic =========================================
				case ADD:
					registers[ir.op1] += registers[ir.op2];
					registers[PC] += INST_SIZE;
					break;
				case ADI:
					registers[ir.op1] += ir.op2;
					registers[PC] += INST_SIZE;
					break;
				case SUB:
					registers[ir.op1] -= registers[ir.op2];
					registers[PC] += INST_SIZE;
					break;
				case MUL:
					registers[ir.op1] *= registers[ir.op2];
					registers[PC] += INST_SIZE;
					break;
				case DIV:
					if (registers[ir.op2] == 0)
						throw RuntimeException("Divide by zero.");
					registers[ir.op1] /= registers[ir.op2];
					registers[PC] += INST_SIZE;
					break;
			// = Logical ============================================
				case AND:
					registers[ir.op1] = registers[ir.op1] && registers[ir.op1];
					registers[PC] += INST_SIZE;
					break;
				case OR:
					registers[ir.op1] = registers[ir.op1] || registers[ir.op1];
					registers[PC] += INST_SIZE;
					break;
			// = Compare ============================================
				case CMP:
					if (registers[ir.op1] == registers[ir.op2])
						registers[ir.op1] = 0;
					else if (registers[ir.op1] > registers[ir.op2])
						registers[ir.op1] = 1;
					else registers[ir.op1] = -1;
					registers[PC] += INST_SIZE;
					break;
			// = Indirect Loads =====================================
				case STRI:
					writeInt(registers[ir.op1], registers[ir.op2]);
					registers[PC] += INST_SIZE;
					break;
				case LDRI:
					registers[ir.op1] = readInt(registers[ir.op2]);
					registers[PC] += INST_SIZE;
					break;
				case STBI:
					writeChar(registers[ir.op1], registers[ir.op2]);
					registers[PC] += INST_SIZE;
					break;
				case LDBI:
					registers[ir.op1] = readChar(registers[ir.op2]);
					registers[PC] += INST_SIZE;
					break;


				default:
					throw RuntimeException("This instruction is not yet implemented.");
			};
			log("If you are reading this, the instruction was successfully executed.");

			if (vomitlvl >= 0)
			{
				std::ofstream fout;
				fout.open("registers.log");
				for (int i=0; i<9; i++)
					fout << "REGISTER " << i << " = " << registers[i] << std::endl;
				fout.close();
			}
		}
	}
	catch (RuntimeException &e)
	{
		std::cout << ansi.ansify("[VM] Failed during runtime.", ansi.COLOUR, ansi.RED) << std::endl;
		std::cout << ansi.ansify("[VM] " + std::string(e.what()), ansi.COLOUR, ansi.RED) << std::endl;
		return -1;
	}
	catch (MemoryException &e)
	{
		std::cout << ansi.ansify("[VM] Encountered a memory failure.", ansi.COLOUR, ansi.RED) << std::endl;
		std::cout << ansi.ansify("[VM] " + std::string(e.what()), ansi.COLOUR, ansi.RED) << std::endl;
		return -1;
	} catch (std::exception &e )
	{
		std::cout << ansi.ansify("[VM] Failed.", ansi.COLOUR, ansi.RED) << std::endl;
		std::cout << ansi.ansify("[VM] " + std::string(e.what()), ansi.COLOUR, ansi.RED) << std::endl;
		return -1;
	} catch (...)
	{
		std::cout << ansi.ansify("[VM] Unknown machine failure.", ansi.COLOUR, ansi.RED) << std::endl;
		return -1;
	}
	return 0;
}


void VirtualMachine::log( std::string info )
{
    if (debug)
    	std::cout << ansi.ansify("[VM] " + info, ansi.COLOUR, ansi.YELLOW) << std::endl;
}
