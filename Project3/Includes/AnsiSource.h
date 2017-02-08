#ifndef __ANSISOURCE_H
#define __ANSISOURCE_H

#include <string>


class ANSI
{
	public:
		std::string PREFIX = "\033[";
		std::string SUFFIX = "m";

		// Colors
		std::string BLACK   = "31";
		std::string RED     = "32";
		std::string GREEN   = "33";
		std::string YELLOW  = "34";
		std::string BLUE    = "35";
		std::string MAGENTA = "36";
		std::string CYAN    = "37";
		std::string GRAY    = "38";

		// Modifiers
		std::string COLOUR = "0;";
		std::string BOLD = "1;";
		std::string DARK = "2;";
		std::string UNDERLINE = "4;";
		std::string BLINK = "5;";
		std::string BACKGROUND = "7;";

		std::string NORMAL = "\033[0m";

		const std::string ansify(  std::string in_str,
								   std::string control,
				                   std::string color    )
		{
#ifdef NOANSI
			return in_str;
#else
			return PREFIX + control + color + SUFFIX + in_str + NORMAL;
#endif
		}
};

#endif
