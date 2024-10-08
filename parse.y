%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declarações das estruturas e funções do lexer
extern struct Token current_token;
extern int yylex();
extern int yyparse();
extern void yyerror(const char *s);

// Definição da tabela de símbolos
struct SymbolTable {
    int count;
    char* symbols[100]; // Suporte para até 100 símbolos
};

// Inicializando a tabela de símbolos
struct SymbolTable symbol_table;

// Função para inicializar a tabela de símbolos
void initialize_symbol_table() {
    symbol_table.count = 0;
}

// Função para adicionar símbolos à tabela de símbolos
void add_symbol(const char* symbol) {
    if (symbol_table.count < 100) {
        symbol_table.symbols[symbol_table.count] = strdup(symbol);
        symbol_table.count++;
    } else {
        fprintf(stderr, "Tabela de símbolos cheia.\n");
    }
}

%}

// Definição de tokens correspondentes aos definidos no lexer
%token T_IF T_ELSE T_INT T_RETURN T_VOID T_WHILE
%token T_ID T_NUM T_RELOP T_SPECIAL T_ERROR T_EOF

// Precedência e associatividade (opcional, útil para expressões)
%left '+' '-'
%left '*' '/'
%left T_RELOP

// Tipos de valores associados aos não-terminais
%union {
    int num;
    char* id;
}

// Associando tokens a tipos no union
%type <num> T_NUM
%type <id> T_ID
%type <num> expression

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
    type_specifier T_ID T_SPECIAL { add_symbol($2); /* Adiciona o identificador à tabela de símbolos */ }
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
    T_NUM { $$ = $1; }               // Expressão numérica
    | T_ID { $$ = 0; }               // Identificador (opcionalmente podemos associar a um valor)
    | expression '+' expression { $$ = $1 + $3; } // Operações aritméticas
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression { $$ = $1 / $3; }
    | expression T_RELOP expression { $$ = $1; } // Operação relacional (ajustar conforme necessário)
    | '(' expression ')' { $$ = $2; } // Expressão entre parênteses
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