%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double
extern char *yytext;
extern int yylineno;
extern FILE *yyin;
%}

%token NUMBER
%token PLUS MINUS TIMES DIVIDE POWER MOD
%token LEFT RIGHT
%token END

%left PLUS MINUS
%left TIMES DIVIDE MOD
%left NEG
%right POWER

%start Input

%%

Input:
	| Input Line
;

Line:
	END
	| Expression END { printf("Result: %f\n", $1); }
;

Expression:
	NUMBER { $$ = $1; }
	| Expression PLUS Expression { $$ = $1 + $3; }
	| Expression MINUS Expression { $$ = $1 - $3; }
	| Expression TIMES Expression { $$ = $1 * $3; }
	| Expression DIVIDE Expression { $$ = $1 / $3; }
	| Expression MOD Expression { $$ = (long)$1 % (long)$3; }
	| MINUS Expression %prec NEG { $$ = -$2; }
	| Expression POWER Expression { $$ = pow($1, $3); }
	| LEFT Expression RIGHT { $$ = $2; }
;

%%

int yyerror(char *s)
{
	printf("%s on line %d - %s\n", s, yylineno, yytext);
}

int yywrap(void)
{
	fprintf(stdout, "End of input reached\n");
	return 1;
}

int main(int argc, char **argv)
{
	/* if any input file has been specified read from that */
	if (argc >= 2) {
		yyin = fopen(argv[1], "r");
		if (!yyin) {
			fprintf(stderr, "Failed to open input file\n");
		}
		return EXIT_FAILURE;
	}

	if (yyparse()) {
		fprintf(stdout, "Successful parsing\n");
	}

	fclose(yyin);
	fprintf(stdout, "End of processing\n");
	return EXIT_SUCCESS;
}
