%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_ID_LEN 100
#define MAX_SYMBOLS 100

typedef union {
    int number;  // Para números
    char id[MAX_ID_LEN]; // Para identificadores
} YYSTYPE;

enum {
    IF = 256,
    THEN,
    ELSE,
    ID,
    NUMBER,
    LT,
    LE,
    EQ,
    NE,
    GT,
    GE,
    ADD, // +
    SUB, // -
    MUL, // *
    DIV, // /
    SEMICOLON, // ;
    LBRACE, // {
    RBRACE, // }
    LPAREN, // (
    RPAREN, // )
    INT, // Tipo de dado
    ERROR
};

YYSTYPE yylval;

char symbolTable[MAX_SYMBOLS][MAX_ID_LEN];
int symbolCount = 0;

void addSymbol(char *id) {
    if (symbolCount < MAX_SYMBOLS) {
        strcpy(symbolTable[symbolCount++], id);
    } else {
        fprintf(stderr, "Tabela de símbolos cheia!\n");
    }
}

%}

%option noyywrap

%%
[ \t\n]+                  ; // Ignorar espaços em branco
"if"                     { return IF; }
"then"                   { return THEN; }
"else"                   { return ELSE; }
"int"                    { return INT; } // Exemplo de tipo de dado
[0-9]+                   { yylval.number = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*  { strcpy(yylval.id, yytext); addSymbol(yytext); return ID; }
"<"                      { return LT; }
"<="                     { return LE; }
"="                      { return EQ; }
"<>"                     { return NE; }
">"                      { return GT; }
">="                     { return GE; }
"+"                      { return ADD; }
"-"                      { return SUB; }
"*"                      { return MUL; }
"/"                      { return DIV; }
";"                      { return SEMICOLON; }
"{"                      { return LBRACE; }
"}"                      { return RBRACE; }
"("                      { return LPAREN; }
")"                      { return RPAREN; }
.                        { return ERROR; } // Retornar erro para caracteres inválidos
%%

int main() {
    int token;
    while ((token = yylex()) != 0) {
        printf("Token: %d, Lexeme: %s\n", token, yytext);
        if (token == NUMBER) {
            printf("Valor: %d\n", yylval.number);
        } else if (token == ID) {
            printf("ID: %s\n", yylval.id);
        }
    }
    return 0;
}

