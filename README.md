# Analisador Léxico (Lexer) da Linguagem C-

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


### Exemplo de lexemas, tokens e atributos
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


## Compilação e Execução

```
flex lexer2.l
```
```
gcc lex.yy.c -o lexer -lfl
```
```
./lexer < input_file.c-
```

# Analisador Sintático (Parser) da Linguagem C-

## Requisitos do Parser
- Utilizar o analisador léxico (lexer) pré-existente para a linguagem C-.
- Construir uma **árvore de sintaxe abstrata (AST)** usando ações semânticas do Bison.
- A saída do analisador será uma AST contendo os elementos essenciais do programa.
- Utilizar a descrição da linguagem C- para criar o analisador sintático e gerar a AST.

### 1. Saída do Parser
- **Para Programas Bem-Sucedidos**:
   - As ações semânticas do parser devem construir uma **Árvore de Sintaxe Abstrata (AST)** que representa a estrutura do programa analisado.
   - A **raiz da AST** deve ser exclusivamente do tipo `programa`. A AST é abstrata e contém apenas os elementos essenciais do programa, diferentemente de uma árvore sintática completa, que incluiria todos os detalhes gramaticais.
   - A saída final do analisador para um programa analisado com sucesso será uma **lista estruturada da AST**, mostrando os elementos e suas hierarquias dentro do programa.

- **Para Programas com Erros**:
   - Caso o parser encontre construções incorretas no código, ele deverá gerar **mensagens de erro descritivas** que indiquem cada erro identificado.
   - Para construções que se estendem por várias linhas (por exemplo, uma expressão ou um bloco de código), qualquer linha pertencente à construção pode ser escolhida como ponto de referência para a linha de erro. É recomendável selecionar a linha que melhor representa a localização do problema para facilitar a compreensão do usuário.
   - Utilizar o pseudo-não terminal `error` do Bison permite ao parser continuar a análise após um erro, gerando uma lista completa de erros, em vez de parar no primeiro erro encontrado.

- **Regras Gerais de Saída**:
   - A AST gerada deve estar contida em um único arquivo, pois o parser só precisa ser capaz de processar programas em um arquivo de código-fonte.
   - Para a exibição da AST ou das mensagens de erro, é recomendável seguir um formato consistente, que facilite a leitura e o entendimento dos resultados.


### 2. Tratamento de Erros

O tratamento de erros no parser é realizado utilizando o **pseudo-não terminal `error`** do Bison, que permite que o analisador continue a análise mesmo após detectar um erro, possibilitando uma recuperação parcial. Abaixo estão as diretrizes para implementar o tratamento de erros:

- **Uso do `error` para Recuperação**:
   - O **pseudo-não terminal `error`** permite ao parser antecipar e lidar com erros sintáticos previsíveis, evitando que a análise seja interrompida ao primeiro erro encontrado.
   - Inserir `error` em pontos estratégicos da gramática ajuda o parser a ignorar tokens problemáticos e a retomar a análise no próximo ponto seguro, permitindo a detecção de múltiplos erros em uma única execução.

- **Limitações do `error`**:
   - O `error` não é uma solução completa para todos os problemas de recuperação, pois, em algumas situações, o parser pode se confundir completamente e produzir mensagens de erro menos precisas.
   - Consulte a documentação do Bison para entender os melhores locais para inserir `error` e as práticas recomendadas para recuperação, uma vez que seu uso excessivo ou inadequado pode comprometer a clareza dos erros reportados.

- **Numeração de Linhas nas Mensagens de Erro**:
   - Não é necessário se preocupar excessivamente com a precisão da numeração das linhas nas mensagens de erro.
   - Se o parser estiver funcionando corretamente, a linha reportada geralmente será a linha onde o erro ocorreu, mas em construções que se estendem por várias linhas, o número da linha pode ser o da última linha da construção incorreta.

- **Recuperação em Construções Multilinha**:
 - Para construções erradas que abrangem múltiplas linhas, o parser pode reportar a linha onde o erro foi detectado, mas essa linha geralmente será a última linha da construção.
   - Esta abordagem facilita a identificação da posição do erro, ainda que a linha exata possa variar em alguns casos.

# Geração de Código na linguagem
## Compilação e Execução
- Dependências: python3, pandas.
  
Dentro da pasta source:
```
make
```
```
./cminus input.txt
```
