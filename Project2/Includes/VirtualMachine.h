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
	VirtualMachine(std::string, bool=false, int=4, int=1024*16, int=0);
	virtual ~VirtualMachine();

	int run();

	//void debug();

private:
	int registers[9];	// Last one is PC
	bool running;
	bool debug;
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
		STRI, LDRI, STBI, LDBI
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
