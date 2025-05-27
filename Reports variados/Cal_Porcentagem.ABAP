*&---------------------------------------------------------------------*
*& Report ZEXERCICIOS_GERAIS004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERCICIOS_GERAIS004.


* Tela de seleção dos dados
SELECTION-SCREEN: BEGIN OF BLOCK bloco WITH FRAME TITLE text-001.

* Parametros de entrada
  PARAMETERS: p_val   TYPE p DECIMALS 2,
              p_porc TYPE i.
SELECTION-SCREEN: END OF BLOCK bloco.

* Variável
DATA: v_tot TYPE p DECIMALS 2 LENGTH 3.

* Rotina de calculo da variável
v_tot = ( p_val * p_porc ) / 100.

* Apresentação do resultado
WRITE: 'O valor percentual é:',v_tot.