%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 100

enum TokenType {
    T_IF, T_ELSE, T_INT, T_RETURN, T_VOID, T_WHILE, // Palavras-chave
    T_ID, T_NUM,                                   // Identificadores e números
    T_RELOP, T_SPECIAL,                            // Operadores relacionais e símbolos especiais
    T_ERROR, T_EOF                                 // Erros e fim de arquivo
};

struct Token {
    char lexeme[100]; // Lexema do token (cadeia de caracteres)
    enum TokenType type; // Tipo do token (classificação)
    char attribute[10]; // Atributo adicional para operadores relacionais
};

struct SymbolTable {
    char symbols[MAX_SYMBOLS][100]; // Array para armazenar até 100 símbolos
    int count; // Número atual de símbolos na tabela
};

struct Token current_token; // Token atualmente processado
struct SymbolTable symbol_table; // Tabela de símbolos

void add_to_symbol_table(char* lexeme);
void initialize_symbol_table();
int is_in_symbol_table(char* lexeme);

%}

%%

"else"       { current_token.type = T_ELSE; strcpy(current_token.lexeme, "else"); }
"if"         { current_token.type = T_IF; strcpy(current_token.lexeme, "if"); }
"int"        { current_token.type = T_INT; strcpy(current_token.lexeme, "int"); }
"return"     { current_token.type = T_RETURN; strcpy(current_token.lexeme, "return"); }
"void"       { current_token.type = T_VOID; strcpy(current_token.lexeme, "void"); }
"while"      { current_token.type = T_WHILE; strcpy(current_token.lexeme, "while"); }

[0-9]+       { current_token.type = T_NUM; strcpy(current_token.lexeme, yytext); add_to_symbol_table(yytext); }

[a-zA-Z_][a-zA-Z0-9_]* { current_token.type = T_ID; strcpy(current_token.lexeme, yytext); add_to_symbol_table(yytext); }

"<="         { current_token.type = T_RELOP; strcpy(current_token.lexeme, "<="); strcpy(current_token.attribute, "LE"); }
">="         { current_token.type = T_RELOP; strcpy(current_token.lexeme, ">="); strcpy(current_token.attribute, "GE"); }
"=="         { current_token.type = T_RELOP; strcpy(current_token.lexeme, "=="); strcpy(current_token.attribute, "EQ"); }
"!="         { current_token.type = T_RELOP; strcpy(current_token.lexeme, "!="); strcpy(current_token.attribute, "NE"); }
"<"          { current_token.type = T_RELOP; strcpy(current_token.lexeme, "<"); strcpy(current_token.attribute, "LT"); }
">"          { current_token.type = T_RELOP; strcpy(current_token.lexeme, ">"); strcpy(current_token.attribute, "GT"); }

"+"          { current_token.type = T_SPECIAL; strcpy(current_token.lexeme, "+"); }
"-"          { current_token.type = T_SPECIAL; strcpy(current_token.lexeme, "-"); }
"*"          { current_token.type = T_SPECIAL; strcpy(current_token.lexeme, "*"); }
"/"          { current_token.type = T_SPECIAL; strcpy(current_token.lexeme, "/"); }
"="          { current_token.type = T_SPECIAL; strcpy(current_token.lexeme, "="); }
","          { current_token.type = T_SPECIAL; strcpy(current_token.lexeme, ","); }
";"          { current_token.type = T_SPECIAL; strcpy(current_token.lexeme, ";"); }
"{"          { current_token.type = T_SPECIAL; strcpy(current_token.lexeme, "{"); }
"}"          { current_token.type = T_SPECIAL; strcpy(current_token.lexeme, "}"); }
"("          { current_token.type = T_SPECIAL; strcpy(current_token.lexeme, "("); }
")"          { current_token.type = T_SPECIAL; strcpy(current_token.lexeme, ")"); }
"["          { current_token.type = T_SPECIAL; strcpy(current_token.lexeme, "["); }
"]"          { current_token.type = T_SPECIAL; strcpy(current_token.lexeme, "]"); }

[ \t\n]+     { /* Espaço em branco ignorado */ }

"/*"([^*]|\*+[^*/])*\*+"*/" { /* Ignorar comentários de bloco */ }
"//".*   { /* Ignorar comentários de linha */ }

. { 
    current_token.type = T_ERROR; 
    strcpy(current_token.lexeme, yytext); 
    fprintf(stderr, "Erro: caractere inválido '%s' na linha %d\n", yytext, yylineno); 
}

%%

void add_to_symbol_table(char* lexeme) {
    if (!is_in_symbol_table(lexeme) && symbol_table.count < MAX_SYMBOLS) {
        strcpy(symbol_table.symbols[symbol_table.count], lexeme);
        symbol_table.count++;
    }
}

int is_in_symbol_table(char* lexeme) {
    for (int i = 0; i < symbol_table.count; i++) {
        if (strcmp(symbol_table.symbols[i], lexeme) == 0) {
            return 1;
        }
    }
    return 0;
}

void initialize_symbol_table() {
    symbol_table.count = 0;
}

int main() {
    initialize_symbol_table();
    yylex(); // Inicia o processo de análise léxica
    return 0;
}
