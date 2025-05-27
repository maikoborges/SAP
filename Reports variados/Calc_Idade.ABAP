*&---------------------------------------------------------------------*
*& Report ZEXERCICIOS_GERAIS002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERCICIOS_GERAIS002.

* Tela de seleção dos dados
SELECTION-SCREEN: BEGIN OF BLOCK bloco WITH FRAME TITLE text-001.

* Parametros de entrada com tamanhos definidos
  PARAMETERS: nome TYPE c LENGTH 40,
              nasc  TYPE n LENGTH 4.
SELECTION-SCREEN: END OF BLOCK bloco.

* Variável com tamanho definido
DATA: idade TYPE n LENGTH 2.

* Rotina de definição da idade com base na data atual
idade = sy-datum(4) - nasc.

* Apresentação do resultado
WRITE: / 'O Sr.(a):',nome,
       / 'Tem',idade,'anos'.
       