*&---------------------------------------------------------------------*
*& Report ZMBO_DC_004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT zmbo_dc_004.

* Variáveis
DATA: it_list    TYPE vrm_values,   " Variável tipo tabela de preenchimento de listbox (Lista de seleção)
      is_list    TYPE vrm_value,    " Variável tipo estrutua de preenchimento de listbox
      v_posic    TYPE c VALUE 1,
      v_operacao TYPE string,
      v_result   TYPE float,
      v_botao    TYPE abap_bool,    " Variável tipo verdadeiro ou falso
      v_tela     TYPE i,
      v_erro     TYPE abap_bool.

* Tela de seleção para as funções e equações
SELECTION-SCREEN: BEGIN OF BLOCK bc03 WITH FRAME TITLE TEXT-011.
*  SELECTION-SCREEN COMMENT /5(30) TEXT-003.

  PARAMETERS: p_list AS LISTBOX VISIBLE LENGTH 20 OBLIGATORY.       " Lista de seleção
  SELECTION-SCREEN: PUSHBUTTON /10(20) bottuon USER-COMMAND lock.   " Botão de confirmação

SELECTION-SCREEN: END OF BLOCK bc03.

* Tela de seleção para os campos
SELECTION-SCREEN: BEGIN OF BLOCK bc01 WITH FRAME TITLE TEXT-010.
  PARAMETERS: p_num_1  TYPE i,
              p_num_2  TYPE i,
              p_angul  TYPE i,
              p_base_l TYPE i,
              p_logar  TYPE i,
              p_raiz   TYPE i.
SELECTION-SCREEN: END OF BLOCK bc01.

* Evento para validação de entradas após interação do usuário com tela
AT SELECTION-SCREEN.

  " Condição de verificação sobre a confirmação da operação
  CASE sy-ucomm.
    WHEN 'ONLI'.
      IF v_botao = ' ' OR v_tela <> p_list.
        MESSAGE |ERRO! CONFIRME SUA OPERÇÃO.| TYPE 'I'.
        LEAVE TO SCREEN 1000.
      ENDIF.
    WHEN 'LOCK'.
      v_botao = abap_true.
      v_tela = p_list.
  ENDCASE.

* Evento de tratamento de campos após interação do usuário com tela
AT SELECTION-SCREEN OUTPUT.

  " Tratamento dos campos da tela após escolha da operação
  PERFORM valida_campo.

* Evento de tratamento de tela antes da apresentação da mesma
INITIALIZATION.

  bottuon = |Confirme|.   " Nome do botão da tela

* Seleção de dados da tabela de nomes das operações
  SELECT operacao
    FROM zmbo_operacao
    INTO TABLE @DATA(it_zmbo_operacao).

* Atribuição de nome na na lista de seleção
  is_list-key  = ' '.
  is_list-text = 'SELECIONE'.
  APPEND is_list TO it_list.

* Loop para aplicar nomes na lista de seleção (Listbox)
  LOOP AT it_zmbo_operacao INTO DATA(ls_zmbo_operacao).
    is_list-key  = v_posic.
    is_list-text = ls_zmbo_operacao.

    APPEND is_list TO it_list.
    v_posic = v_posic + 1.

  ENDLOOP.

* Função de associação da tabela de nomes a lista de seleção (Listbox)
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = 'p_list'
      values = it_list.

* Evento de início da rotina do programa
START-OF-SELECTION.

  " Rotinas para operação
  PERFORM operacao.

* Condição para exibição da tela de resultado (Caso ocorra algum erro na operação escolhida)
  IF v_erro <> 'X'.
    WRITE: | OPERAÇÃO ESCOLHIDA: { v_operacao } |,
         / | RESULTADO: { v_result } |.
  ENDIF.


FORM valida_campo.

  " Validação da confirmação da operação
  IF v_botao = 'X'.

    " Loop para bloquear campos de acordo com a escolha da operação
    LOOP AT SCREEN.
      IF p_list = '1'.
        CASE screen-name.
          WHEN 'P_ANGUL'.
            screen-input = 0.   " Bloquear campos da tela
            MODIFY SCREEN.      " Modificar tela
          WHEN 'P_BASE_L'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_LOGAR'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_RAIZ'.
            screen-input = 0.
            MODIFY SCREEN.
        ENDCASE.

      ELSEIF p_list = '2'.

        CASE screen-name.
          WHEN 'P_NUM_1'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_NUM_2'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_BASE_L'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_LOGAR'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_RAIZ'.
            screen-input = 0.
            MODIFY SCREEN.
        ENDCASE.

      ELSEIF p_list = '3'.

        CASE screen-name.
          WHEN 'P_ANGUL'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_BASE_L'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_LOGAR'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_RAIZ'.
            screen-input = 0.
            MODIFY SCREEN.
        ENDCASE.

      ELSEIF p_list = '4'.

        CASE screen-name.
          WHEN 'P_NUM_1'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_NUM_2'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_ANGUL'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_RAIZ'.
            screen-input = 0.
            MODIFY SCREEN.
        ENDCASE.

      ELSEIF p_list = '5'.

        CASE screen-name.
          WHEN 'P_ANGUL'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_BASE_L'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_LOGAR'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_RAIZ'.
            screen-input = 0.
            MODIFY SCREEN.
        ENDCASE.

      ELSEIF p_list = '6'.

        CASE screen-name.
          WHEN 'P_NUM_1'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_NUM_2'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_ANGUL'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_BASE_L'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_LOGAR'.
            screen-input = 0.
            MODIFY SCREEN.
        ENDCASE.

      ELSEIF p_list = '7'.

        CASE screen-name.
          WHEN 'P_NUM_1'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_NUM_2'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_BASE_L'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_LOGAR'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_RAIZ'.
            screen-input = 0.
            MODIFY SCREEN.
        ENDCASE.

      ELSEIF p_list = '8'.

        CASE screen-name.
          WHEN 'P_ANGUL'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_BASE_L'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_LOGAR'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_RAIZ'.
            screen-input = 0.
            MODIFY SCREEN.
        ENDCASE.

      ELSEIF p_list = '9'.

        CASE screen-name.
          WHEN 'P_NUM_1'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_NUM_2'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_BASE_L'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_LOGAR'.
            screen-input = 0.
            MODIFY SCREEN.
          WHEN 'P_RAIZ'.
            screen-input = 0.
            MODIFY SCREEN.
        ENDCASE.

      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM operacao.

  CLEAR v_erro.

  CASE p_list.
    WHEN '1'.
      v_operacao = 'ADIÇÃO'.
      v_result = p_num_1 + p_num_2.

    WHEN '2'.
      IF p_angul =< 0.
        MESSAGE |PARA O CALCULO DO COSSENO É NECESSÁRIO O ÂNGULO| TYPE 'I'.
        v_erro = 'X'.
      ELSE.
        v_operacao = 'COSSENO'.
        DATA(v_pi)  = 4 * atan( 1 ).
        DATA(v_rad) = p_angul * v_pi / 180.
        v_result = cos( v_rad ).
      ENDIF.

    WHEN '3'.
      " Tratamento de erro
      TRY .
          v_operacao = 'DIVISÃO'.
          v_result = p_num_1 / p_num_2.
        CATCH  cx_sy_zerodivide INTO DATA(erro_1).
          MESSAGE TEXT-100 TYPE 'I'.
          v_erro = 'X'.               " Variável de controle de apresentação da tela de resultado
      ENDTRY.

    WHEN '4'.
      TRY .
          v_operacao = 'LOGARITMO'.
          v_result = log( p_logar ) / log( p_base_l ).
        CATCH cx_sy_arithmetic_overflow INTO DATA(erro_2).
          MESSAGE |ERRO! Falta a BASE ou o LOG.| TYPE 'I'.
          v_erro = 'X'.
      ENDTRY.


    WHEN '5'.
      v_operacao = 'MULTIPLICAÇÃO'.
      v_result = p_num_1 * p_num_2.

    WHEN '6'.
      IF p_raiz =< 0.
        MESSAGE: |Necessário informa o número para aplicar a raiz!| TYPE 'I'.
        v_erro = 'X'.
      ELSE.
        v_operacao = 'RAIZ QUADRADA'.
        v_result = sqrt( p_raiz ).
      ENDIF.

    WHEN '7'.
      IF p_angul =< 0.
        MESSAGE |PARA O CALCULO DO SENO É NECESSÁRIO O ÂNGULO| TYPE 'I'.
        v_erro = 'X'.
      ELSE.
        v_operacao = 'SENO'.
        v_pi = 4 * atan( 1 ).
        v_rad = p_angul * v_pi / 180.
        v_result = sin( v_rad ).
      ENDIF.

    WHEN '8'.
      v_operacao = 'SUBTRAÇÃO'.
      v_result = p_num_1 - p_num_2.

    WHEN '9'.
      IF p_angul =< 0.
        MESSAGE |PARA O CALCULO DO TANGENTE É NECESSÁRIO O ÂNGULO| TYPE 'I'.
        v_erro = 'X'.
      ELSE.
        v_operacao = 'TANGENTE'.
        v_pi = 4 * atan( 1 ).
        v_rad = p_angul * v_pi / 180.
        v_result = tan( v_rad ).
      ENDIF.
    ENDCASE.

ENDFORM.