# Makefile para Compilador Simples com Flex e Bison

# Compilador e Flags
CC = gcc
CFLAGS = -Wall -Wextra -g

# Ferramentas
BISON = bison
FLEX = flex

# Arquivos
BISON_SRC = parse.y
FLEX_SRC = lexer.l
BISON_OUTPUT = parse.tab.c
BISON_HEADER = parse.tab.h
FLEX_OUTPUT = lex.yy.c
EXEC = compilador

# Objetos
OBJS = parse.tab.o lex.yy.o

# Regra padrão
all: $(EXEC)

# Compilação do Executável
$(EXEC): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ -lfl

# Compilação do Bison
$(BISON_OUTPUT) $(BISON_HEADER): $(BISON_SRC)
	$(BISON) -d $(BISON_SRC)

# Compilação do Flex
$(FLEX_OUTPUT): $(FLEX_SRC) $(BISON_HEADER)
	$(FLEX) $(FLEX_SRC)

# Compilação dos Objetos
parse.tab.o: $(BISON_OUTPUT)
	$(CC) $(CFLAGS) -c $(BISON_OUTPUT)

lex.yy.o: $(FLEX_OUTPUT)
	$(CC) $(CFLAGS) -c $(FLEX_OUTPUT)

# Limpeza dos arquivos gerados
clean:
	rm -f $(EXEC) $(OBJS) $(BISON_OUTPUT) $(BISON_HEADER) $(FLEX_OUTPUT)

# Regra para reconstruir completamente
rebuild: clean all

# Informações
.PHONY: all clean rebuild
