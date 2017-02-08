/*
 * VirtualMachine.cpp
 *
 *  Created on: 30 Sep 2015
 *      Author: orrinjelo
 */

#include <iostream>

#include "VirtualMachine.h"
#include "AnsiSource.h"

VirtualMachine::VirtualMachine( std::string filename, bool _debug ) {
	debug = _debug;
	log("Initializing virtual machine.");
	//memory = new char[MEM_SIZE];
	assembler = new Assembler(memory,
							  MEM_SIZE,
							  &program,
							  &heap,
							  debug);

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
	delete assembler;
}

void VirtualMachine::writeInt( int data, int address )
{
  int max_addr = MEM_SIZE - sizeof(data);
  if (address >= max_addr || address < 0)
    // Out of the range, should be 0-MEMSIZE/4-1
    throw MemoryException("Unaddressable address.");  // Unaddressable
  char* ptr = memory;
  ptr += address;
  (*(int*)ptr) = data;
}

void VirtualMachine::writeChar( char data, int address )
{
  int max_addr = MEM_SIZE;
  if (address >= max_addr || address < 0)
    // Out of the range, should be 0-MEMSIZE/4-1
    throw MemoryException("Unaddressable address.");  // Unaddressable
  memory[address] = data;
}

int VirtualMachine::readInt( int address )
{
  int max_addr = MEM_SIZE;
  if (address >= max_addr || address < 0)
    // Out of the range, should be 0-MEMSIZE/4-1
    throw MemoryException("Unaddressable address.");  // Unaddressable
  char* ptr = memory;
  ptr += address;
  return (*(int*)ptr);
}

char VirtualMachine::readChar( int address )
{
  int max_addr = MEM_SIZE;
  if (address >= max_addr || address < 0)
    // Out of the range, should be 0-MEMSIZE/4-1
    throw MemoryException("Unaddressable address.");  // Unaddressable
  return memory[address];
}

void VirtualMachine::fetch()
{
	ir.opCode =  readInt( registers[PC]              );
	ir.op1    =  readInt( registers[PC] + INT_SIZE   );
	ir.op2    =  readInt( registers[PC] + 2*INT_SIZE );
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
				case LDR:
					registers[ir.op1] = readInt(ir.op2);
					registers[PC] += INST_SIZE;
					break;
				case TRP:
					switch (ir.op1)
					{
						case 0:
							running = false;
							break;
						case 1:
							std::cout << (int)registers[3];
							break;
						case 3:
							std::cout << (char)registers[3];
							break;
						default:
							throw RuntimeException("This trap code is not yet implemented.");
					}
					registers[PC] += INST_SIZE;
					break;
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
				case MOV:
					registers[ir.op1] = registers[ir.op2];
					registers[PC] += INST_SIZE;
					break;

				default:
					throw RuntimeException("This instruction is not yet implemented.");
			};
			log("If you are reading this, the instruction was successfully executed.");
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
    	std::cout << ansi.ansify("[VM]" + info, ansi.COLOUR, ansi.YELLOW) << std::endl;
}
