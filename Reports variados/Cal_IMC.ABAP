*&---------------------------------------------------------------------*
*& Report ZEXERCICIOS_GERAIS006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERCICIOS_GERAIS006


* Classe de mensagens
MESSAGE-ID ZC0001.

* Tela de seleção dosc dados
SELECTION-SCREEN: BEGIN OF BLOCK bloco WITH FRAME TITLE text-001.

* Parametros de entrada com decimais
  PARAMETERS: peso TYPE p DECIMALS 2,
              alt  TYPE p DECIMALS 2.
SELECTION-SCREEN: END OF BLOCK bloco.

* Variável com decimais e tamanho definidos
DATA: result TYPE p DECIMALS 2 LENGTH 3.

* Tratamento de erro caso aconteça
TRY.
  result = peso / ( alt * 2 ).
CATCH CX_SY_ZERODIVIDE.                             " Erro possível
  MESSAGE I000. "Divisão por Zero não permitida
  STOP.                                             " Para programa
ENDTRY.

* Rotina de condicição para apresenta o resultado
IF result < '17'.
  WRITE: 'O IMC é',result,'e a situação é "MUITO ABAIXO DO PESO"'.
ELSEIF result < '18.5'.
  WRITE: 'O IMC é',result,'e a situação é "ABAIXO DO PESO"'.
ELSEIF result < '25'.
  WRITE: 'O IMC é',result,'e a situação é "PESO NORMAL"'.
ELSEIF result < '30'.
  WRITE: 'O IMC é',result,'e a situação é "ACIMA DO PESO"'.
ELSEIF result < '35'.
  WRITE: 'O IMC é',result,'e a situação é "OBESIDADE I"'.
ELSEIF result < '40'.
  WRITE: 'O IMC é',result,'e a situação é "OBESIDADE II(SEVERA)"'.
ELSE.
  WRITE: 'O IMC é',result,'e a situação é "OBESIDADE III(MÓRBIDA)"'.
ENDIF.