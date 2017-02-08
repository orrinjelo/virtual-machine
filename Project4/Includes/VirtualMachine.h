/*
 * VirtualMachine.h
 *
 *  Created on: 30 Sep 2015
 *      Author: orrinjelo
 */

#include <iostream>
#include <vector>

#include "Assembler.h"

#ifndef VIRTUALMACHINE_H_
#define VIRTUALMACHINE_H_

//#define MEM_SIZE 1024 * 16
#define PC 8
#define FP 9
#define SP 10
#define SL 11
#define SB 12


class RuntimeException : public std::exception
{
	public:
		RuntimeException(std::string msg) : _message(msg) {};
		virtual const char* what() const throw()
		  {
			const char* msg = _message.c_str();
		    return msg;
		  }
		virtual ~RuntimeException() throw() {};
	private:
		std::string _message;
};

class VirtualMachine {
public:
	VirtualMachine( std::string,
			        bool=false,
			        int=4,
			        int=1024*1024,
			        int=0,
			        bool=false,
			        int=1024*16,
			        int=1024);
	virtual ~VirtualMachine();

	int run();

	//void debug();

private:
	// R0-R7 : General purpose registers
	// R8    : PC - program counter
	// R9    : FP - frame pointer
	// R10   : SP - stack pointer
	// R11   : SL - stack limit
	// R12   : SB - stack base
	int registers[13];
	bool running;
	bool debug;
	bool stepdebug;
	int vomitlvl;
	// STATIC DATA (Directives)
	// CODE
	// HEAP
	// STACK (Grows from the end)

	int MEM_SIZE;
	//char _memory[MEM_SIZE];
	char *memory;

	void writeInt( int, int );
	void writeChar( char, int );
	int readInt( int );
	char readChar( int );


	//char memory[MEM_SIZE];
	Assembler *assembler;

	char* data;
	int program;
	int heap;
	int stack;
	int mainend;
	int threadsize;

	struct InstructionRegister
	{
		int opCode;
		int op1;
		int op2;
	};

	void fetch();
	void flushmem();

	InstructionRegister ir;

	enum Instructions
	{
		TRP,
		JMP, JMR, BNZ, BGT, BLT, BRZ,
		MOV, LDA, STR, LDR, STB, LDB,
		ADD, ADI, SUB, MUL, DIV,
		AND, OR,
		CMP,
		STRI, LDRI, STBI, LDBI,
		RUN=30, END=31, BLK=32, LCK=33, ULK=34
	};

	/*
	int fetch();
	int decode();
	int execute();

	*/
	ANSI ansi;
	void log( std::string );
};

#endif /* VIRTUALMACHINE_H_ */
