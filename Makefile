all:
	bison -d calc.y
	flex -o calc.lex.c calc.lex
	gcc -o calc calc.lex.c calc.tab.c -lfl -lm

clean:
	rm -rf calc.lex.c calc.tab.c calc.tab.h calc

