/*
 * testmain.cpp
 *
 *  Created on: 3 Oct 2015
 *      Author: orrinjelo
 */

#include <iostream>
#include <stdio.h>
#include "Assembler.h"
#include "VirtualMachine.h"

#define MEMSIZE 256

int main(int argc, char* argv[])
{

	VirtualMachine vm("test1.asm");
/*
	int prog, heap;
	char* mem = new char[MEMSIZE];
	//char mem[MEMSIZE];
	Assembler asmblr(mem, MEMSIZE, &prog, &heap);

	asmblr.load("test1.asm");

	asmblr.debug();

	std::cout << "Prog: " << prog << ", Heap: " << heap << std::endl;
	for (int i=0; i<MEMSIZE; i++)
	{
		if (i%4 == 0) std::cout << std::endl << "\033[35m";
		std::cout << "[" << i << "] " << (int)mem[i];
		std::cout << "\033[m ";
		//std::cout << std::endl;
	}
	printf("\n");
*/
	return 0;
}

void Assembler::debug()
{
#if DEBUG
	printf("Debug...\n");
	for (std::map<std::string, int>::iterator it=symbolTable.begin(); it!=symbolTable.end(); it++)
		std::cout << it->first << ":" << it->second << std::endl;
	printf("End debug...\n");
#endif

}

void VirtualMachine::debug()
{
#if DEBUG

#endif
}

