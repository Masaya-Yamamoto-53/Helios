CC=gcc

has: lex.yy.o as.tab.o as_ast.o as_symbol.o
	$(CC) -o $@ $^

lex.yy.c: as.l as.tab.h
	flex $^

as.tab.c : as.y
	bison -d $^

as.tab.h : as.y
	bison -d $^

as_ast.o : as_ast.c as_ast.h as.tab.h
	$(CC) -c $<

as_symbol.o : as_symbol.c as_symbol.h 
	$(CC) -c $<

lex.yy.o : lex.yy.c as.tab.h
	$(CC) -c $<

clean:
	$(RM) lex.yy.c
	$(RM) as.tab.c
	$(RM) as.tab.h
	$(RM) *.o
	$(RM) has
