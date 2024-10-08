%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 100
#define MAX_ID_LEN 32

typedef struct {
    char id[MAX_ID_LEN];
    int value;
} Symbol;

Symbol symbolTable[MAX_SYMBOLS];
int symbolCount = 0;

enum {
    IF = 256, THEN, ELSE, ID, NUMBER, LT, LE, EQ, NE, GT, GE, ERROR
};

union {
    int number;
    char id[MAX_ID_LEN];
} yylval;

void addSymbol(char* id);
void reportError(const char* message);

%}

%option noyywrap

%%

[ \t\n]+       ;

"if"            { return IF; }
"then"          { return THEN; }
"else"          { return ELSE; }
[0-9]+          { yylval.number = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { strncpy(yylval.id, yytext, MAX_ID_LEN); addSymbol(yylval.id); return ID; }
"<"             { return LT; }
"<="            { return LE; }
"="             { return EQ; }
"<>"            { return NE; }
">"             { return GT; }
">="            { return GE; }
.               { reportError("Caractere inválido"); return ERROR; }

%%

int main(void) {
    int token;
    while ((token = yylex()) != 0) {
        // Exibe o token, o lexema e o atributo
        switch (token) {
            case IF:
                printf("Lexeme: %s, Token: if, Atributo: -\n", yytext);
                break;
            case THEN:
                printf("Lexeme: %s, Token: then, Atributo: -\n", yytext);
                break;
            case ELSE:
                printf("Lexeme: %s, Token: else, Atributo: -\n", yytext);
                break;
            case ID:
                printf("Lexeme: %s, Token: id, Atributo: Ponteiro TS\n", yylval.id);
                break;
            case NUMBER:
                printf("Lexeme: %s, Token: number, Atributo: Ponteiro TS\n", yytext);
                break;
            case LT:
                printf("Lexeme: %s, Token: relop, Atributo: LT\n", yytext);
                break;
            case LE:
                printf("Lexeme: %s, Token: relop, Atributo: LE\n", yytext);
                break;
            case EQ:
                printf("Lexeme: %s, Token: relop, Atributo: EQ\n", yytext);
                break;
            case NE:
                printf("Lexeme: %s, Token: relop, Atributo: NE\n", yytext);
                break;
            case GT:
                printf("Lexeme: %s, Token: relop, Atributo: GT\n", yytext);
                break;
            case GE:
                printf("Lexeme: %s, Token: relop, Atributo: GE\n", yytext);
                break;
            case ERROR:
                printf("Lexeme: %s, Token: ERROR, Atributo: -\n", yytext);
                break;
        }
    }
    return 0;
}

void addSymbol(char* id) {
    if (symbolCount < MAX_SYMBOLS) {
        strncpy(symbolTable[symbolCount].id, id, MAX_ID_LEN);
        symbolTable[symbolCount].value = 0; // Inicializa o valor como zero
        symbolCount++;
    } else {
        reportError("Tabela de símbolos cheia");
    }
}

void reportError(const char* message) {
    fprintf(stderr, "Erro: %s\n", message);
}


