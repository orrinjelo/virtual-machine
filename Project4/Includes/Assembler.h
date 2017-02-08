/*
 * Assembler.h
 *
 *  Created on: 30 Sep 2015
 *      Author: orrinjelo
 */

#ifndef ASSEMBLER_H_
#define ASSEMBLER_H_

#include <map>
#include <string>
#include <list>
#include "AnsiSource.h"

#define INST_SIZE 12
#define INT_SIZE 4
//#define BYT_SIZE 1
#define INDIRECT 12

class LabelException : public std::exception
{
	public:
		LabelException(std::string msg) : _message(msg) {};
		virtual const char* what() const throw()
		  {
			const char* msg = _message.c_str();
		    return msg;
		  }
		virtual ~LabelException() throw() {};
	private:
		std::string _message;
};

class SyntaxException : public std::exception
{
	public:
		SyntaxException(std::string msg) : _message(msg) {};
		virtual const char* what() const throw()
		  {
			const char* msg = _message.c_str();
		    return msg;
		  }
		virtual ~SyntaxException() throw() {};
	private:
		std::string _message;
};

class MemoryException : public std::exception
{
	public:
		MemoryException(std::string msg) : _message(msg) {};
		virtual const char* what() const throw()
		  {
			const char* msg = _message.c_str();
		    return msg;
		  }
		virtual ~MemoryException() throw() {};
	private:
		std::string _message;
};


class Assembler {
	public:
		Assembler(char*, int, int*, int*, bool=false, int=1, int=-1);
		~Assembler();
		void load(std::string);

		void getSymbolTable(std::map<std::string, int>&);

		void vomit( std::string filename );
		//void debug();
	private:
		char* memory;
		int* program;
		int* heap;

		int MEMSIZE;
		int BYT_SIZE;
		int vomitlvl;

		bool debug;
		ANSI ansi;

		std::string filename;
		std::map<std::string, int> syntaxTable;
		std::map<std::string, int> symbolTable;

		void loadFile();
		//std::list<std::string> tokenize(std::string, char);
		std::list<std::string> tokenize(const std::string&, const std::string&);
		void synthesize( std::list<std::string>, int& );
		void generateByteCode( std::list<std::string>, int&, int& );

		// ================================================
		// First Pass: Open up the file, read line by line
		//  Tokenize; Check syntax of instructions;
		//  When you have a known label, load the defined
		//  label into the symbol table
		void firstPass();

		// ================================================
		// Second Pass: Check that referenced labels are
		//  defined in the symbol table; generate byte code
		void secondPass();

		void writeInt( int, int );
		void writeChar( char, int );

		bool file_ok( const char* );

		void log( std::string info );

};

#endif /* ASSEMBLER_H_ */
