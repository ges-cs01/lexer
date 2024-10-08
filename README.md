flex lexer.l
gcc lex.yy.c -o lexer -lfl
./lexer < input_file.c-
