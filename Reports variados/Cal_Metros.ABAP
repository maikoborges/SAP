*&---------------------------------------------------------------------*
*& Report ZEXERCICIOS_GERAIS003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERCICIOS_GERAIS003.


* Tela de seleção dos dados
SELECTION-SCREEN: BEGIN OF BLOCK bloco WITH FRAME TITLE text-001.

* Parametros de entrada com permissão de decimais
  PARAMETERS: med1 TYPE p DECIMALS 2,
              med2 TYPE p DECIMALS 2.
SELECTION-SCREEN: END OF BLOCK bloco.

* Variável com permissão de decimais
DATA: tot TYPE p DECIMALS 2.

* Rotina de calculo dos metros quadrados
tot = med1 * med2.

* Apresentação dos dados
WRITE: / 'A metragem Quadrada é',tot.