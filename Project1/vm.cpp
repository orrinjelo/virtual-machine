/*
 * vm.cpp
 *
 *  Created on: Oct 9, 2015
 *      Author: orrinjelo
 */


//#define BOOST

#include <iostream>
#include <stdio.h>
#ifdef BOOST
#include <boost/program_options.hpp>
#endif
#include "Assembler.h"
#include "VirtualMachine.h"
#include "AnsiSource.h"

#ifdef BOOST
namespace po = boost::program_options;

void process_program_options( const int argc, const char * const argv[] )
{
	bool debug = false;
	try {
		po::options_description desc("Usage: vm [options] [--input-file=]<filename>");
		desc.add_options()
				("help,h",     "Shows this message" )
				("debug",      "Turns on debug mode")
				("input-file", "Assembly file to feed into VM.")
		;

		po::positional_options_description p;
		p.add("input-file", -1);

		po::variables_map args;
		po::store(
				po::parse_command_line(argc, argv, desc),
				args
		);
		po::store(
				po::command_line_parser(argc, argv).
					options(desc).positional(p).run(),
				args
		);

		po::notify(args);

		if (args.count("help") || argc == 1)
		{
			std::cout << desc << std::endl;
			return;
		}

		if (args.count("debug"))
		{
			std::cout << "Debug mode turned on." << std::endl;
			debug = true;
		}

		if (args.count("input-file"))
		{
			VirtualMachine( std::string( args["input-file"].as<std::string>() ),
							debug);
		}
	}
	catch (std::exception &e)
	{
		std::cout << "Error: " << e.what() << std::endl;
	}
	catch (...)
	{
		std::cout << "VM has encountered an unknown error." << std::endl;
	}
}
#endif

int main( int argc, char* argv[] )
{

#ifdef BOOST
	process_program_options(argc, argv);
#else
	if (argc != 2)
	{
		std::cout << "Usage: " << argv[0] << " <filename>" << std::endl;
		return 1;
	}

	VirtualMachine(std::string(argv[1]));
#endif
	return 0;
}


