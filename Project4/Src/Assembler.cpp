/*
 * Assembler.cpp
 *
 *  Created on: 30 Sep 2015
 *      Author: orrinjelo
 */
#include <fstream>
#include <string>
#include <stdlib.h>
#include <sstream>
#include <algorithm>
#include <exception>
#include <iostream>
#include "Assembler.h"
#include "AnsiSource.h"


Assembler::Assembler(char*	_memory,
					 int	_MEMSIZE,
					 int*	_program,
					 int*	_heap,
					 bool	_debug,
					 int    _BYTSIZE,
					 int    _vomitlvl )
{
	debug = _debug;
	vomitlvl = _vomitlvl;
	log("Assembler Init");

	memory = _memory;
	MEMSIZE = _MEMSIZE;
	BYT_SIZE = _BYTSIZE;
	filename = "";

	// Jump Instructions
	syntaxTable["JMP"] = 1;
	syntaxTable["JMR"] = 2;
	syntaxTable["BNZ"] = 3;
	syntaxTable["BGT"] = 4;
	syntaxTable["BLT"] = 5;
	syntaxTable["BRZ"] = 6;

	// Move Instructions
	syntaxTable["MOV"] = 7;
	syntaxTable["LDA"] = 8;
	syntaxTable["STR"] = 9;
	syntaxTable["LDR"] = 10;
	syntaxTable["STB"] = 11;
	syntaxTable["LDB"] = 12;

	// Arithmetic Instructions
	syntaxTable["ADD"] = 13;
	syntaxTable["ADI"] = 14;
	syntaxTable["SUB"] = 15;
	syntaxTable["MUL"] = 16;
	syntaxTable["DIV"] = 17;

	// Logical Instructions
	syntaxTable["AND"] = 18;
	syntaxTable["OR"] = 19;

	// Compare Instructions
	syntaxTable["CMP"] = 20;

	// Register Indirect Addressing
	syntaxTable["__9__"] = 21;
	syntaxTable["__10__"] = 22;
	syntaxTable["__11__"] = 23;
	syntaxTable["__12__"] = 24;

	// Multithreading
	syntaxTable["RUN"] = 30;
	syntaxTable["END"] = 31;
	syntaxTable["BLK"] = 32;
	syntaxTable["LCK"] = 33;
	syntaxTable["ULK"] = 34;



	// Traps
	syntaxTable["TRP"] = 0;


	// Registers
	symbolTable["R0"] = 0;
	symbolTable["R1"] = 1;
	symbolTable["R2"] = 2;
	symbolTable["R3"] = 3;
	symbolTable["R4"] = 4;
	symbolTable["R5"] = 5;
	symbolTable["R6"] = 6;
	symbolTable["R7"] = 7;
	symbolTable["(R0)"] = 0;
	symbolTable["(R1)"] = 1;
	symbolTable["(R2)"] = 2;
	symbolTable["(R3)"] = 3;
	symbolTable["(R4)"] = 4;
	symbolTable["(R5)"] = 5;
	symbolTable["(R6)"] = 6;
	symbolTable["(R7)"] = 7;
	symbolTable["PC"] = 8;
	symbolTable["FP"] = 9;
	symbolTable["SP"] = 10;
	symbolTable["SL"] = 11;
	symbolTable["SB"] = 12;
	symbolTable["(FP)"] = 9;
	symbolTable["(SP)"] = 10;
	symbolTable["(SL)"] = 11;
	symbolTable["(SB)"] = 12;

	program = _program;
	*program = 0;
	heap = _heap;
	*heap = 0;

	//counter = 0;
	log("Assembler Init Ended.");
}

Assembler::~Assembler() {
}

bool Assembler::file_ok(const char *fileName)
{
    std::ifstream infile(fileName);
    return infile.good();
}

// Setter function for filename
void Assembler::load(std::string fileName)
{
	filename = fileName;
	log("Loaded file " + fileName);
	if (!file_ok(fileName.c_str()))
	{
		std::cout << "[Error] Given bad file:" << fileName
				  <<" Will now exit." << std::endl;
		exit(1);
	}
	log("Now entering first pass.");
	firstPass();
	log("Now entering second pass.");
	secondPass();
	//if (vomitlvl >= 0) vomit("vomit.log");
}

std::list<std::string> Assembler::tokenize( const std::string &tstr,
											const std::string &delimiters = " 	,")
{
	std::list<std::string> strlist;
	log("Tokenizing string: " + tstr);
	// Skip delimiters at beginning
	std::string::size_type lastPos = tstr.find_first_not_of(delimiters, 0);
	// Find first non-delimiter
	std::string::size_type pos = tstr.find_first_of(delimiters, lastPos);

	while (std::string::npos != pos || std::string::npos != lastPos)
	{
		// Found a token, add it to the list
		strlist.push_back(tstr.substr(lastPos, pos - lastPos));
		// Skip delimiters
		lastPos = tstr.find_first_not_of(delimiters, pos);
		// Find next non-delimiter
		pos = tstr.find_first_of(delimiters, lastPos);
	}
	return strlist;
}

void Assembler::synthesize(std::list<std::string> strlist, int &bytecount)
{
	log("Starting to synthesize.");
	//int len = strlist.size();
	// Parse First argument
	// Let's assume directives won't be by themselves
	//  and that directives come first in the program
	// Ex:
	//	LABEL		.INT		<Integer>
	//  LABEL		.BYT		<Integer>
	//	[LABEL]		<Operator>	<Op1>	[<Op2>]
	std::string first, second, third;

	first = strlist.front();
	strlist.pop_front();

	if (!strlist.empty())
	{
		second = strlist.front();
		strlist.pop_front();
	}
	else
		second = "";

	if (!strlist.empty())
	{
		third = strlist.front();
		strlist.pop_front();
	}
	else
		third = "";

	log("First: " + first + "; Second: " + second + "; Third: " + third);

	if (first.substr(0,1) == ";")
		return;
	if (syntaxTable.find(first) != syntaxTable.end())	// This is an instruction
	{
		log("First is an instruction.");
		bytecount += INST_SIZE;
	} else if (first.substr(0,1) == ".")  // This will be a directive
	{
		log("First is a directive.");
		if (first == ".INT")
			bytecount += INT_SIZE;
		else if (first == ".BYT")
			bytecount += BYT_SIZE;
	} else // Label
	{
		log("First is a label.");
		if (syntaxTable.find(second) != syntaxTable.end())
		// This is an instruction
		{
			log("Second is an instruction.");
			if (symbolTable.find(second) != symbolTable.end())
				throw LabelException("Label '" + second + "' already exists in table!");
				// Label already exists in table!
			symbolTable[first] = bytecount;
			bytecount += INST_SIZE;
		} else if (second.substr(0,1) == ".")	// This will be a directive
		{
			log("Second is a directive.");
			if (symbolTable.find(first) != symbolTable.end())
				throw LabelException("Label '" + first + "' already exists in table!");
				// Label already exists in table!

			symbolTable[first] = bytecount;

			if (second == ".INT")
				bytecount += INT_SIZE;
			else if (second == ".BYT")
				bytecount += BYT_SIZE;
		} else
		{
			throw SyntaxException("I really have no idea what's going on here.");
		}
	}
}

void Assembler::generateByteCode( std::list<std::string> strlist,
								  int &linecount,
								  int &bytecount )
{
	log("Generating byte code.");
	//int len = strlist.size();
	// Parse First argument
	// Let's assume directives won't be by themselves
	//  and that directives come first in the program
	// Ex:
	//	LABEL		.INT		<Integer>
	//  LABEL		.BYT		<Integer>
	//	[LABEL]		<Operator>	<Op1>	[<Op2>]

	// Assign each their own variable
	std::string first, second, third, fourth, fifth;

	bool commentFlag = false;

	first = strlist.front();
	strlist.pop_front();

	if (first.substr(0,1) == ";")
		commentFlag = true;

	if (!strlist.empty() && !commentFlag)
	{
		second = strlist.front();
		strlist.pop_front();
	}
	else
		second = "";

	if (!strlist.empty() && !commentFlag)
	{
		third = strlist.front();
		strlist.pop_front();
		if (third.substr(0,1) == ";")
		{
			commentFlag = true;
			third = "";
		}
	}
	else
		third = "";

	if (!strlist.empty() && !commentFlag)
	{
		fourth = strlist.front();
		strlist.pop_front();
		if (fourth.substr(0,1) == ";")
		{
			commentFlag = true;
			fourth = "";
		}
	}
	else
		fourth = "";

	if (!strlist.empty() && !commentFlag)
	{
		fifth = strlist.front();
		if (fifth.substr(0,1) != ";")
			throw SyntaxException("Expression too long.");
		else
		{
			commentFlag = true;
			fifth = "";
		}
	}

	bool labelFlag = false;

	// == Parse first =====================================
	int opcode = -1;
	int oppos = 0;
	if (first.substr(0,1) == ";") return;
	if (syntaxTable.find(first) != syntaxTable.end())
	// This is an instruction
	{
		log("First is an instruction.");
		writeInt(syntaxTable[first], bytecount);
		log(first);
		log(std::to_string(syntaxTable[first]));
		opcode = syntaxTable[first];
		oppos = 1;
		bytecount += INT_SIZE;
		if (syntaxTable[first] == 31 || syntaxTable[first] == 32)
		{
			writeInt(0, bytecount);
			bytecount += INT_SIZE;
			writeInt(0, bytecount);
			bytecount += INT_SIZE;
			return;
		}
	} else if (symbolTable.find(first) != symbolTable.end())
	// Label
	{
		log("First is a label.");
		writeInt(symbolTable[first],
				 bytecount);
		//bytecount += INT_SIZE;
		labelFlag = true;
	}
	else if (first.substr(0,1) == ".")
	{
		log("First is a directive.");
		if (first == ".INT")
		{
			log("It is an integer.");
			if (second == "")
				throw SyntaxException("Directive without value.");
			writeInt(std::strtol(second.c_str(), NULL, 10),
					 bytecount);
			bytecount += INT_SIZE;
			if (third != "" && third.substr(0,1) != ";")
				throw SyntaxException("Unknown parameter at end of directive.");
			*program = bytecount;
			return;
		}
		else if (first == ".BYT")
		{
			log("It is a byte.");
			if (second == "")
				throw SyntaxException("Directive without value.");
			if (second.length() == 3)
				if (second.substr(0,1) == "'" && second.substr(second.length()-1,1) == "'")
					writeChar(*second.substr(1,1).c_str(), bytecount);
				else
					writeChar((char)std::strtol(second.c_str(), NULL, 10), bytecount);
			else
				writeChar((char)std::strtol(second.c_str(), NULL, 10), bytecount);
			bytecount += BYT_SIZE;
			if (third != "" && third.substr(0,1) != ";")
				throw SyntaxException("Unknown parameter at end of directive.");
			*program = bytecount;
			return;
		} else
		{
			throw SyntaxException("Unknown directive.");
		}

	} else
	{
		throw SyntaxException("Cannot interpret '"
								+ first
								+ "'.");
	}

	// == Parse second ====================================
	bool operandFlag = false;
	log("Parsing second.");
	if (second.substr(0,1) == ";")
	{
		throw SyntaxException("Incomplete expression.");
	}
	if (second.substr(0,1) == ".") // Directive
	{
		log("Second is a directive.");
		if (!labelFlag)
			throw SyntaxException("Directive out of place.");
		if (second == ".INT")
		{
			log("It is an integer.");
			if (third == "")
				throw SyntaxException("Directive without value.");
			writeInt(std::strtol(third.c_str(), NULL, 10),
					 bytecount);
			bytecount += INT_SIZE;
			if (fourth != "" && fourth.substr(0,1) != ";")
				throw SyntaxException("Unknown parameter at end of directive.");
			*program = bytecount;
			return;
		}
		else if (second == ".BYT")
		{
			log("It is a byte.");
			if (third == "")
				throw SyntaxException("Directive without value.");
			if (third.length() == 3)
				if (third.substr(0,1) == "'" && third.substr(third.length()-1,1) == "'")
					writeChar(*third.substr(1,1).c_str(),
										 bytecount);
				else
					writeChar((char)std::strtol(third.c_str(), NULL, 10),
										 bytecount);
			else
				writeChar((char)std::strtol(third.c_str(), NULL, 10),
					 bytecount);
			bytecount += BYT_SIZE;
			if (fourth != "" && fourth.substr(0,1) != ";")
				throw SyntaxException("Unknown parameter at end of directive.");
			*program = bytecount;
			return;
		} else
		{
			throw SyntaxException("Unknown directive.");
		}

	} else if (symbolTable.find(second) != symbolTable.end())
	// Label
	{
		log("Second is a label.");
		writeInt(symbolTable[second],
				 bytecount);
		bytecount += INT_SIZE;
		operandFlag = true;
	} else if (syntaxTable.find(second) != syntaxTable.end())
	// Instruction
	{
		log("Second is an instruction.");
		writeInt(syntaxTable[second], bytecount);
		opcode = syntaxTable[second];
		oppos = 2;
		bytecount += INT_SIZE;
/*	}
	else if (second.substr(0,1) == "R" )	// Register
	{
		log("Second is a register.");
		const char *r = second.substr(1,1).c_str();
		writeInt(std::strtol(r, NULL, 10),
				 bytecount);
		bytecount += INT_SIZE;
		operandFlag = true;
*/	} else if (second == "")
	{
		throw SyntaxException("Incorrect number of parameters.");
	} else // Immediate
	{
		log("Second is an immediate.");
		writeInt(std::strtol(second.c_str(), NULL, 10),
				 bytecount);
		bytecount += INT_SIZE;
		operandFlag = true;
	}

	// == Parse third =====================================
	log("Parsing third.");
	if (third == "")
	{
		if (operandFlag)
		{
			writeInt(0, bytecount);
			bytecount += INT_SIZE;
			return;
		}
		//throw SyntaxException("Incorrect number of parameters.");
	}
	if (third.substr(0,1) == ";")
	{
		log("How nice, a comment.");
		writeInt(0, bytecount);
		bytecount += INT_SIZE;
		return;
	}
	if (symbolTable.find(third) != symbolTable.end())
	// Label
	{
		log("Third is a label.");

		// Checking to see if we have an indirect

		if ((third == "FP" || third == "SP" || third == "SB" || third == "SL" ||
				third == "(FP)" || third == "(SP)" || third == "(SB)" || third == "(SL)") &&
				(oppos == 1 && (opcode >= syntaxTable["STR"] && opcode <= syntaxTable["LDB"])))
		{
			log("This is a special case!");
			writeInt(opcode + INDIRECT, bytecount - 2*INT_SIZE);
		} else if (third == "FP" || third == "SP" || third == "SB" || third == "SL" ||
				third == "(FP)" || third == "(SP)" || third == "(SB)" || third == "(SL)")
		{
			log("Special use register...");
		} else
		{
			try
			{
				int itemp = 0;
				if (third.length() >= 1 && third.length() <= 2)
					itemp = std::stoi(third.substr(1,1), nullptr);
				else if (third.length() >= 3 && third.length() <= 4)
					itemp = std::stoi(third.substr(2,1), nullptr);
				if ((third.substr(0,1) == "R" && itemp >= 0 && itemp <= 7) ||
						(third.substr(0,2) == "(R" && itemp >= 0 && itemp <= 7))
				{
					log("Detecting a register...");
					if (oppos == 1 && (opcode >= syntaxTable["STR"] && opcode <= syntaxTable["LDB"]))
					{
						log("This is a special case!");
						writeInt(opcode + INDIRECT, bytecount - 2*INT_SIZE);
					}
				}
			}
			catch (...)
			{
				log("Some weird error occured.");
				//throw SyntaxException("Cannot interpret third label.");
			}
		}
		writeInt(symbolTable[third],
				 bytecount);
		bytecount += INT_SIZE;
		operandFlag = !operandFlag;
/*	}
	else if (third.substr(0,1) == "R" || third.substr(0,2) == "(R")	// Register
	{
		log("Third is a register.");
		const char *r = third.substr(1,1).c_str();
		if (*r == 'R') r = third.substr(2,1).c_str();
		if (oppos == 1 && (opcode >= symbolTable["STR"] && opcode <= symbolTable["LDB"]) )
			writeInt(opcode + INDIRECT, bytecount - 2*INT_SIZE);
		writeInt(std::strtol(r, NULL, 10),
			         bytecount);
		bytecount += INT_SIZE;
		operandFlag = !operandFlag;
*/	} else // Immediate
	{
		log("Third is an immediate.");
		writeInt(std::strtol(third.c_str(), NULL, 10),
				 bytecount);
		bytecount += INT_SIZE;
		operandFlag = !operandFlag;
	}

	// == Parse fourth ====================================
	log("Parsing fourth.");
	if (fourth.substr(0,1) == ";")
	{
		log("How nice, a comment.  Or something.");
		if (operandFlag)
		{
			writeInt(0, bytecount);
			bytecount += INT_SIZE;
		}
		return;
	}

	if (fourth != "" && !operandFlag)
		throw SyntaxException("Unexpected additional parameters.");
	if (fourth == "")
	{
		if (oppos == 2)
		{
			writeInt(0, bytecount);
			bytecount += INT_SIZE;
		}
		return;
	}
	if (symbolTable.find(fourth) != symbolTable.end())
	// Label
	{
		if ((fourth == "FP" || fourth == "SP" || fourth == "SB" || fourth == "SL" ||
							fourth == "(FP)" || fourth == "(SP)" || fourth == "(SB)" || fourth == "(SL)")
		 && (oppos == 2 && (opcode >= syntaxTable["STR"] && opcode <= syntaxTable["LDB"])))
		{
				log("This is a special case!");
				writeInt(opcode + INDIRECT, bytecount - 2*INT_SIZE);

		} else if (fourth == "FP" || fourth == "SP" || fourth == "SB" || fourth == "SL" ||
				fourth == "(FP)" || fourth == "(SP)" || fourth == "(SB)" || fourth == "(SL)")
		{
			log("Special use register...");
		} else
		{
			try
			{
				int itemp = 0;
				if (fourth.length() >= 1 && fourth.length() <= 2)
					itemp = std::stoi(fourth.substr(1,1), nullptr);
				else if (fourth.length() >= 3 && fourth.length() <= 4)
					itemp = std::stoi(fourth.substr(2,1), nullptr);
				if ((fourth.substr(0,1) == "R" && itemp >= 0 && itemp <= 7) ||
						(fourth.substr(0,2) == "(R" && itemp >= 0 && itemp <= 7))
					if (oppos == 2 && (opcode >= syntaxTable["STR"] && opcode <= syntaxTable["LDB"]))
						writeInt(opcode + INDIRECT, bytecount - 2*INT_SIZE);
			}
			catch (...)
			{
				log("Some weird error happened.");
			}
		}
		log("Fourth is a label.");
		writeInt(symbolTable[fourth],
				 bytecount);
		bytecount += INT_SIZE;
		operandFlag = !operandFlag;
/*	}
	else if (fourth.substr(0,1) == "R" || fourth.substr(0,2) == "(R")	// Register
	{
		log("Fourth is a register.");
		const char *r = fourth.substr(1,1).c_str();
		if (*r == 'R') r = fourth.substr(2,1).c_str();
		if (oppos == 2 && (opcode >= symbolTable["STR"] && opcode <= symbolTable["LDB"]) )
			writeInt(opcode + INDIRECT, bytecount - 2*INT_SIZE);
		writeInt(std::strtol(r, NULL, 10),
				 bytecount);
		bytecount += INT_SIZE;
		operandFlag = !operandFlag;
*/	} else  // Immediate
	{
		log("Fourth is an immediate.");
		writeInt(std::strtol(fourth.c_str(), NULL, 10),
				 bytecount);
		bytecount += INT_SIZE;
		operandFlag = !operandFlag;
	}

}


// ================================================
// First Pass: Open up the file, read line by line
//  Tokenize; Check syntax of instructions;
//  When you have a known label, load the defined
//  label into the symbol table
void Assembler::firstPass()
{
	// Begin with opening the ASM file
	int linecount = 0;
	int bytecount = 0;
	std::ifstream in;
	try
	{
		in.open(filename.c_str());

		// Read in line at a time
		std::string line;
		while (std::getline(in, line))
		{
			linecount++;
			if (line == "")
				continue;
			// Try parsing
			//std::transform(line.begin(), line.end(),
			//			   line.begin(), ::toupper);
			synthesize(tokenize(line), bytecount);
		}

	} catch (LabelException &e)
	{
		std::cout << ansi.ansify("[Assembler] Failed on second pass.", ansi.COLOUR, ansi.RED) << std::endl;
		std::cout << ansi.ansify("[Assembler] Failed parsing label on line " + std::to_string(linecount),
				ansi.COLOUR, ansi.RED) << std::endl;
		std::cout << ansi.ansify("[Assembler] " + std::string(e.what()), ansi.COLOUR, ansi.RED) << std::endl;
		exit(1);
	} catch (SyntaxException & e)
	{
		std::cout << ansi.ansify("[Assembler] Failed on first pass.", ansi.COLOUR, ansi.RED) << std::endl;
		std::cout << ansi.ansify("[Assembler] Failed with syntax on line " + std::to_string(linecount) + ".",
				ansi.COLOUR, ansi.RED) << std::endl;
		std::cout << ansi.ansify("[Assembler] " + std::string(e.what()), ansi.COLOUR, ansi.RED) << std::endl;
		exit(1);
	} catch (std::exception &e )
	{
		std::cout << ansi.ansify("[Assembler] Failed on second pass.\n", ansi.COLOUR, ansi.RED);
		std::cout << ansi.ansify("[Assembler] Failed on line " + std::to_string(linecount) + "\n", ansi.COLOUR, ansi.RED);
		std::cout << ansi.ansify("[Assembler] " + std::string(e.what()) + "\n", ansi.COLOUR, ansi.RED);

		exit(1);
	} catch (...)
	{
		std::cout << ansi.ansify("[Assembler] Failed on second pass.\n", ansi.COLOUR, ansi.RED);
		std::cout << ansi.ansify("[Assembler] Failed on line " + std::to_string(linecount) + "\n", ansi.COLOUR, ansi.RED);
		exit(1);
	}
	in.close();

}

// ================================================
// Second Pass: Check that referenced labels are
//  defined in the symbol table; generate byte code
void Assembler::secondPass()
{
	// Begin with opening the ASM file
	int linecount = 0;
	int bytecount = 0;
	std::ifstream in;
	try
	{
		in.open(filename.c_str());

		// Read in line at a time
		std::string line;
		while (std::getline(in, line))
		{
			linecount++;
			if (line == "")
				continue;
			//std::transform(line.begin(), line.end(),
			//			   line.begin(), ::toupper);
			generateByteCode(tokenize(line), linecount, bytecount);
		}
		*heap = bytecount;
	} catch (LabelException &e)
	{
		std::cout << ansi.ansify("[Assembler] Failed on second pass.", ansi.COLOUR, ansi.RED) << std::endl;
		std::cout << ansi.ansify("[Assembler] Failed parsing label on line " + std::to_string(linecount),
				ansi.COLOUR, ansi.RED) << std::endl;
		std::cout << ansi.ansify("[Assembler] " + std::string(e.what()), ansi.COLOUR, ansi.RED) << std::endl;
		exit(1);
	} catch (MemoryException &e)
	{
		std::cout << ansi.ansify("[Assembler] Failed on second pass.", ansi.COLOUR, ansi.RED) << std::endl;
		std::cout << ansi.ansify("[Assembler] Failed writing or accessing memory, line " + std::to_string(linecount),
				ansi.COLOUR, ansi.RED) << std::endl;
		std::cout << ansi.ansify("[Assembler] " + std::string(e.what()), ansi.COLOUR, ansi.RED) << std::endl;
		exit(1);
	} catch (std::exception &e )
	{
		std::cout << ansi.ansify("[Assembler] Failed on second pass.", ansi.COLOUR, ansi.RED) << std::endl;
		std::cout << ansi.ansify("[Assembler] Failed on line " + std::to_string(linecount), ansi.COLOUR, ansi.RED) << std::endl;
		std::cout << ansi.ansify("[Assembler] " + std::string(e.what()), ansi.COLOUR, ansi.RED) << std::endl;

		exit(1);
	} catch (...)
	{
		std::cout << ansi.ansify("[Assembler] Failed on second pass.", ansi.COLOUR, ansi.RED) << std::endl;
		std::cout << ansi.ansify("[Assembler] Failed on line " + std::to_string(linecount), ansi.COLOUR, ansi.RED) << std::endl;
		exit(1);
	}
	in.close();
}

void Assembler::getSymbolTable(std::map<std::string, int> &st)
{
	st = symbolTable;
}

void Assembler::writeInt( int data, int address )
{
  int max_addr = MEMSIZE - sizeof(data);
  if (address >= max_addr || address < 0)
    // Out of the range, should be 0-MEMSIZE-1
    throw MemoryException("Unaddressable address given.");  // Unaddressable
  char* ptr = memory;
  ptr += address;
  (*(int*)ptr) = data;
}

void Assembler::writeChar( char data, int address )
{
  int max_addr = MEMSIZE;
  if (address >= max_addr || address < 0)
    // Out of the range, should be 0-MEMSIZE-1
    throw MemoryException("Unaddressable address given.");  // Unaddressable
  memory[address] = data;
}

void Assembler::log( std::string info )
{
	if (debug)
		std::cout << ansi.ansify("[Assembler]" + info, ansi.COLOUR, ansi.YELLOW) << std::endl;
}

void Assembler::vomit( std::string filename )
{
	std::ofstream fout;
	fout.open(filename.c_str());
	for (int i=0; i<MEMSIZE; i++)
	{
		switch (vomitlvl)
		{
		case 0:
			fout << (char)memory[i];
			break;
		case 1:
			if (i % 4 == 0) fout << "*";
			else fout << " ";
			fout << (int)memory[i] << std::endl;
			break;
		case 2:
			if (i%4 == 0 && i != 0) fout << ' ';
			fout << std::hex << (int)memory[i];
			break;
		};
	}
	fout.close();
}
