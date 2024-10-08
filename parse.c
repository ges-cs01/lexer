%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declarações das estruturas e funções do lexer
extern struct Token current_token;
extern int yylex();
extern int yyparse();
extern void yyerror(const char *s);

// Tabela de símbolos (opcional para uso no parser)
extern struct SymbolTable symbol_table;

%}

// Definição de tokens correspondentes aos definidos no lexer
%token T_IF T_ELSE T_INT T_RETURN T_VOID T_WHILE
%token T_ID T_NUM T_RELOP T_SPECIAL T_ERROR T_EOF

// Precedence and associativity (opcional, útil para expressões)
%left '+' '-'
%left '*' '/'
%left T_RELOP

// Tipos de valores associados aos não-terminais (opcional)
%union {
    int num;
    char* id;
}

// Associando tokens a tipos no union
%type <num> expression
%type <id> identifier

%%

// Regras de Gramática

program:
    declarations
    ;

declarations:
    declarations declaration
    | declaration
    ;

declaration:
    type_specifier T_ID T_SPECIAL { /* Declaração de variável */ }
    | type_specifier T_ID '(' parameters ')' compound_stmt
    ;

type_specifier:
    T_INT
    | T_VOID
    ;

parameters:
    /* Vazio */
    | parameter_list
    ;

parameter_list:
    parameter
    | parameter_list T_SPECIAL parameter
    ;

parameter:
    type_specifier T_ID
    ;

compound_stmt:
    T_SPECIAL /* '{' */
        declarations
        statements
        T_SPECIAL /* '}' */
    ;

statements:
    statements statement
    | /* Vazio */
    ;

statement:
    expression_stmt
    | compound_stmt
    | selection_stmt
    | iteration_stmt
    | return_stmt
    ;

expression_stmt:
    expression T_SPECIAL /* ';' */
    | T_SPECIAL /* ';' */
    ;

selection_stmt:
    T_IF '(' expression ')' statement
    | T_IF '(' expression ')' statement T_ELSE statement
    ;

iteration_stmt:
    T_WHILE '(' expression ')' statement
    ;

return_stmt:
    T_RETURN expression T_SPECIAL /* ';' */
    | T_RETURN T_SPECIAL /* ';' */
    ;

expression:
    T_ID
    | T_NUM
    | expression '+' expression
    | expression '-' expression
    | expression '*' expression
    | expression '/' expression
    | expression T_RELOP expression
    | '(' expression ')'
    ;

%%

// Função de erro
void yyerror(const char *s) {
    fprintf(stderr, "Erro de sintaxe: %s\n", s);
}

// Função principal
int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror(argv[1]);
            return 1;
        }
        extern FILE *yyin;
        yyin = file;
    }
    // Inicializa a tabela de símbolos
    initialize_symbol_table();
    
    // Inicia o parsing
    yyparse();
    
    // Opcional: Imprimir a tabela de símbolos após o parsing
    printf("\nTabela de Símbolos:\n");
    for(int i = 0; i < symbol_table.count; i++) {
        printf("%d: %s\n", i, symbol_table.symbols[i]);
    }
    
    return 0;
}
