%{
#define YYSTYPE double
#include "calc.tab.h"
#include <stdlib.h>
%}

%option yylineno

white		[ \t]+
digit		[0-9]
integer		{digit}+
exponent	[eE][+-]?{integer}
real		{integer}("."{integer})?{exponent}?
hex		0[xX][0-9A-Fa-f]+

%%

{white}		{}
{real}		{ yylval=atof(yytext); return NUMBER; }
{hex}		{ yylval=strtol(yytext, (char **)NULL, 16); return NUMBER; }
"+"		{ return PLUS; }
"-"		{ return MINUS; }
"*"		{ return TIMES; }
"/"		{ return DIVIDE; }
"^"		{ return POWER; }
"%"		{ return MOD; }
"("		{ return LEFT; }
")"		{ return RIGHT; }
"\n"		{ return END; }
.		{ yyerror("Invalid token"); }
