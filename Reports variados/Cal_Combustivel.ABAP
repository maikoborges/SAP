*&---------------------------------------------------------------------*
*& Report ZEXERCICIOS_GERAIS005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERCICIOS_GERAIS005.


* Tela de seleção dos dados
SELECTION-SCREEN: BEGIN OF BLOCK bloco WITH FRAME TITLE text-001.

* Parametros de entrada com decimais
  PARAMETERS: p_dist     TYPE p DECIMALS 2,
              p_vl_lt TYPE p DECIMALS 2,
              p_km_lt    TYPE p DECIMALS 2.
SELECTION-SCREEN: END OF BLOCK bloco.

* Variáveis com decimais e tamanho definidos
DATA: v_qtd_lt TYPE p DECIMALS 2 LENGTH 3,
      v_valor  TYPE p DECIMALS 2 LENGTH 3.

* Rotina de calculos
v_qtd_lt = p_dist / p_km_lt.
v_valor  = v_qtd_lt * p_vl_lt.

* Apresentação dos dados
WRITE: / 'Quantidade de Combustível gasto:', v_qtd_lt,
       / 'Valor total Gasto:',v_valor.