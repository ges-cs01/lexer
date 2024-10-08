# Analisador Léxico da Linguagem C-

## Convenções léxicas de C-

| Conceito                  | Descrição                                                                                                                                      |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| **Palavras-chave**        | As palavras-chave da linguagem são: `else`, `if`, `int`, `return`, `void`, `while`. Todas as palavras-chave são reservadas e devem ser escritas em caixa baixa. |
| **Símbolos especiais**    | Os símbolos especiais são: `+` `-` `*` `/` `<`  `<=` `>` `>=` `==` `!=` `=` `,` `{` `}` `;` `(` `)` `[` `]` `/*` `*/`                                                                        |
| **Marcadores**            | - **ID =** `letra letra*` <br> - **NUM =** `digito digito*` <br> - **letra =** `a \| .. \| z \| A \| .. \| Z)` <br> - **digito =** `0 \| .. \| 9` |
| **Diferenciação de caixa**| A linguagem diferencia entre caixa baixa e caixa alta.                                                                                      |
| **Espaço em branco**      | O espaço em branco é composto por espaços, quebras de linha e tabulações. É ignorado, exceto como separador de IDs, NUMs e palavras-chave.   |
| **Comentários**           | Os comentários são cercados pela notação de C (`/*...*/`). Podem ser colocados em qualquer lugar onde poderia haver espaço em branco, mas não podem ser aninhados. |
| **Declaração de variável**| Uma declaração de variável é feita usando um tipo-especificador seguido por um ID, finalizando com `;`. Para arrays, pode incluir `ID[]` ou `ID[NUM]`. |
| **Declaração de função**  | Uma declaração de função consiste em um tipo-especificador, um ID (nome da função), seguido por `params` (lista de parâmetros) e um bloco de declaração composta (`{ ... }`). |
| **Parâmetros**            | Os parâmetros podem ser uma lista de parâmetros ou `void`. Parâmetros de matriz são passados por referência e devem casar com uma variável do tipo matriz durante a ativação. |
| **Atribuições**           | As expressões de atribuição são feitas usando a sintaxe `var = expressao`, onde `var` pode ser um ID ou `ID[expressao]`.                    |
| **Estruturas de controle**| A estrutura de controle `if` segue a semântica usual: `if (expressao) statement` ou `if (expressao) statement else statement`. A estrutura de iteração é realizada com `while (expressao) statement`. |
| **Retorno**               | A declaração de retorno pode retornar um valor ou não. Funções do tipo `void` não devem retornar valores.                                    |



## Requisitos do Lexer

### 1. Regras de Tokenização
- **Tokens a serem reconhecidos**: incluem palavras-chave, identificadores, números e operadores da linguagem C-.
- **Formato de Saída**: O lexer deve retornar, para cada token identificado, três informações:
  - **Lexeme**: A cadeia de caracteres que representa o token.
  - **Nome do Token**: A classificação do token (por exemplo, `if`, `id`, `number`, `relop`).
  - **Atributo do Token**: Um atributo adicional quando aplicável (por exemplo, ponteiros para a tabela de símbolos para identificadores e constantes).

### 2. Tabela de Símbolos
- Implementar uma tabela de símbolos para armazenar identificadores e constantes identificadas pelo lexer. A tabela deve permitir o armazenamento eficiente e a recuperação dos valores correspondentes.

### 3. Tratamento de Erros
- O lexer deve ser capaz de identificar e lidar com erros lexicais. Isso inclui:
  - Retornar um token de erro especial chamado `ERROR` quando um erro fatal ocorrer.
  - Lidar com situações como um EOF (fim de arquivo) dentro de comentários, retornando a linha do erro.
  - Retornar caracteres inválidos como tokens de erro e continuar a análise léxica.

### 4. Funcionalidade Geral
- O lexer deve ser robusto, não parando no primeiro erro encontrado, mas continuando a análise de toda a entrada.
- Não deve imprimir mensagens de erro diretamente. Em vez disso, as informações sobre os tokens identificados ou erros devem ser passadas para um parser, que será responsável por imprimir os resultados. O parser, por enquanto, é um programa (e.g., main()) que chama o lexer.

### 5. Testes
- Criar testes utilizando exemplos da descrição do C- e desenvolver programas adicionais que contenham erros lexicais.
- Garantir que o lexer funcione corretamente com várias entradas e consiga reportar erros de forma adequada.



# Exemplo de lexemas, tokens e atributos
| Lexeme               | Nome do Token | Atributo       |
|----------------------|---------------|----------------|
| Qualquer ws          | -             | -              |
| `if`                 | `if`          | -              |
| `then`               | `then`        | -              |
| `else`               | `else`        | -              |
| Qualquer identificador| `id`          | Ponteiro TS    |
| Qualquer número      | `number`      | Ponteiro TS    |
| `<`                  | `relop`       | LT             |
| `<=`                 | `relop`       | LE             |
| `=`                  | `relop`       | EQ             |
| `<>`                 | `relop`       | NE             |
| `>`                  | `relop`       | GT             |
| `>=`                 | `relop`       | GE             |


# Compilação e Execução

flex lexer.l

gcc lex.yy.c -o lexer -lfl

./lexer < input_file.c-
