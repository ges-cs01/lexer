# Convenções léxicas de C-

| Conceito                  | Descrição                                                                                                                                      |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| **Palavras-chave**        | As palavras-chave da linguagem são: `else`, `if`, `int`, `return`, `void`, `while`. Todas as palavras-chave são reservadas e devem ser escritas em caixa baixa. |
| **Símbolos especiais**    | Os símbolos especiais são: `+` `-` `*` `/` `<`  `<=` `>` `>=` `==` `!=` `=` `,` `{` `}` `;` `,` `(` `)` `[` `]` `/*` `*/`                                                                        |
| **Marcadores**            | - **ID:** Identificadores definidos como `letra letra*`. <br> - **NUM:** Números definidos como `digito digito*`. <br> - **letra:** Alfabeto (a..z ou A..Z). <br> - **digito =** 0 \| . . \| 9 |
| **Diferenciação de caixa**| A linguagem diferencia entre caixa baixa e caixa alta.                                                                                      |
| **Espaço em branco**      | O espaço em branco é composto por espaços, quebras de linha e tabulações. É ignorado, exceto como separador de IDs, NUMs e palavras-chave.   |
| **Comentários**           | Os comentários são cercados pela notação de C (`/*...*/`). Podem ser colocados em qualquer lugar onde poderia haver espaço em branco, mas não podem ser aninhados. |
| **Declaração de variável**| Uma declaração de variável é feita usando um tipo-especificador seguido por um ID, finalizando com `;`. Para arrays, pode incluir `ID[]` ou `ID[NUM]`. |
| **Declaração de função**  | Uma declaração de função consiste em um tipo-especificador, um ID (nome da função), seguido por `params` (lista de parâmetros) e um bloco de declaração composta (`{ ... }`). |
| **Parâmetros**            | Os parâmetros podem ser uma lista de parâmetros ou `void`. Parâmetros de matriz são passados por referência e devem casar com uma variável do tipo matriz durante a ativação. |
| **Atribuições**           | As expressões de atribuição são feitas usando a sintaxe `var = expressao`, onde `var` pode ser um ID ou `ID[expressao]`.                    |
| **Estruturas de controle**| A estrutura de controle `if` segue a semântica usual: `if (expressao) statement` ou `if (expressao) statement else statement`. A estrutura de iteração é realizada com `while (expressao) statement`. |
| **Retorno**               | A declaração de retorno pode retornar um valor ou não. Funções do tipo `void` não devem retornar valores.                                    |

# Lexemas, tokens e atributos
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
