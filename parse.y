%{
#include <stdio.h>
#include <stdlib.h>


// Estrutura para nós da árvore de sintaxe abstrata (AST)
typedef struct ASTNode {
    char *type;
    struct ASTNode *left;
    struct ASTNode *right;
    char *value;
} ASTNode;

// Função para criar nós da AST
ASTNode* createNode(char *type, ASTNode *left, ASTNode *right, char *value) {
    ASTNode *node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = type;
    node->left = left;
    node->right = right;
    node->value = value ? strdup(value) : NULL;
    return node;
}

// Função para imprimir a AST (pré-ordem)
void printAST(ASTNode *node, int level) {
    if (node == NULL) return;
    for (int i = 0; i < level; i++) printf("  ");
    printf("%s", node->type);
    if (node->value) printf(" (%s)", node->value);
    printf("\n");
    printAST(node->left, level + 1);
    printAST(node->right, level + 1);
}

%}

%union {
    ASTNode *node;
    char *string;
}

%token INT VOID IF ELSE WHILE RETURN ID NUM LE GE EQ NE
%type <node> programa declaracao_lista declaracao var_declaracao tipo_especificador fun_declaracao
%type <node> statement_lista statement expressao_decl selecao_decl iteracao_decl retorno_decl
%type <node> expressao var simples_expressao termo fator ativacao args

%%
programa: declaracao_lista ;

declaracao_lista: declaracao_lista declaracao
                | declaracao ;

declaracao: var_declaracao
          | fun_declaracao ;

var_declaracao: tipo_especificador ID ';'
              | tipo_especificador ID '[' NUM ']' ';' ;

tipo_especificador: INT
                  | VOID ;

fun_declaracao: tipo_especificador ID '(' params ')' composto_decl ;

params: param_lista
      | VOID ;

param_lista: param_lista ',' param
           | param ;

param: tipo_especificador ID
     | tipo_especificador ID '[' ']' ;

composto_decl: '{' local_declaracoes statement_lista '}' ;

local_declaracoes: local_declaracoes var_declaracao
                 | /* vazio */ ;

statement_lista: statement_lista statement
               | /* vazio */ ;

statement: expressao_decl
         | composto_decl
         | selecao_decl
         | iteracao_decl
         | retorno_decl ;

expressao_decl: expressao ';'
              | ';' ;

selecao_decl: IF '(' expressao ')' statement
            | IF '(' expressao ')' statement ELSE statement ;

iteracao_decl: WHILE '(' expressao ')' statement ;

retorno_decl: RETURN ';'
            | RETURN expressao ';' ;

expressao: var '=' expressao
         | simples_expressao ;

var: ID
   | ID '[' expressao ']' ;

simples_expressao: soma_expressao relacional soma_expressao
                 | soma_expressao ;

relacional: LE
           | GE
           | EQ
           | NE
           | '<'
           | '>';

soma_expressao: soma_expressao soma termo
              | termo ;

soma: '+'
    | '-' ;

termo: termo mult fator
     | fator ;

mult: '*'
    | '/' ;

fator: '(' expressao ')'
     | var
     | ativacao
     | NUM ;

ativacao: ID '(' args ')' ;

args: arg_lista
    | /* vazio */ ;

arg_lista: arg_lista ',' expressao
         | expressao ;

%%
