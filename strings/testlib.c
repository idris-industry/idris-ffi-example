#include <stdio.h>
#include <stdlib.h>

char *var = "A variable string";

char *var_wrapper()
{
	return var;
}

char *not_null()
{
	return "Hello, world!";
}

char *null()
{
	return NULL;
}

char *next()
{
	static int n = 0;
	char *res = malloc(256);
	sprintf(res, "%d", n++);
	return res;
}
