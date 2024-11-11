# Compilador e flags
CC = gcc
BISON = bison
FLEX = flex

# Arquivos de entrada e saída
BISON_FILE = parse.y
LEXER_FILE = lexer.l
BISON_OUTPUT = parse.tab.c
LEXER_OUTPUT = lex.yy.c
EXEC = parser

all: $(EXEC)

$(EXEC): $(BISON_OUTPUT) $(LEXER_OUTPUT)
	$(CC) $(BISON_OUTPUT) $(LEXER_OUTPUT) -o $(EXEC) -lfl

$(BISON_OUTPUT): $(BISON_FILE)
	$(BISON) -d $(BISON_FILE)

$(LEXER_OUTPUT): $(LEXER_FILE)
	$(FLEX) $(LEXER_FILE)

clean:
	rm -f $(BISON_OUTPUT) parse.tab.h $(LEXER_OUTPUT) $(EXEC)
