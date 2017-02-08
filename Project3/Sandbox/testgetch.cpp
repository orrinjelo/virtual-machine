#include <cstdio>
#include <iostream>

using namespace std;

int main()
{
	char c = getchar();
	while (c != '@')
	{
		c = getchar();
		cout << c;
		while (c = getchar())
			cout << "|" << c << "|";
	}
	return 0;
}
