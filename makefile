# Makefile para compilar e rodar o lexer

LEX = flex
CC = gcc
CFLAGS = -Wall
LFLAGS = -lfl
TARGET = lexer
LEX_FILE = lexer.l
INPUT = codigo.c

all: $(TARGET)

$(TARGET): lex.yy.c
	$(CC) lex.yy.c -o $(TARGET) $(LFLAGS)

lex.yy.c: $(LEX_FILE)
	$(LEX) $(LEX_FILE)

run: $(TARGET)
	./$(TARGET) < $(INPUT)

clean:
	rm -f lex.yy.c $(TARGET)
