%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parse.tab.h"  // Inclusão do arquivo de cabeçalho gerado pelo Bison
%}

%%

// Palavras-chave
"int"        { return INT; }
"void"       { return VOID; }
"if"         { return IF; }
"else"       { return ELSE; }
"while"      { return WHILE; }
"return"     { return RETURN; }

// Identificadores
[a-zA-Z_][a-zA-Z0-9_]*   {
    yylval.string = strdup(yytext);
    return ID;
}

// Números
[0-9]+   {
    yylval.string = strdup(yytext);
    return NUM;
}

// Operadores relacionais e símbolos especiais
"<="        { return LE; }
">="        { return GE; }
"=="        { return EQ; }
"!="        { return NE; }
"<"         { return '<'; }
">"         { return '>'; }
"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
";"         { return ';'; }
","         { return ','; }
"("         { return '('; }
")"         { return ')'; }
"["         { return '['; }
"]"         { return ']'; }
"{"         { return '{'; }
"}"         { return '}'; }
"="         { return '='; }

// Espaços em branco e quebras de linha (ignorar)
[ \t\n\r]+  { /* ignorar espaços em branco */ }

// Tratamento de caracteres inválidos
.           { printf("Caractere não reconhecido: %s\n", yytext); return T_ERROR; }

%%

// Função principal para o Flex
int main(void) {
    yylex();
    return 0;
}

// Função de término do Flex
int yywrap(void) {
    return 1;
}
