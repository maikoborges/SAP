*&---------------------------------------------------------------------*
*& Report ZMBO_DC_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmbo_dc_001.

DATA: alv      TYPE REF TO cl_salv_table,             " Objeto de ALV
      colunas  TYPE REF TO cl_salv_columns_table,     " Objeto para ajuste de colunas do ALV
      tela     TYPE REF TO cl_salv_display_settings,  " Objeto para ajuste de layout de tela
      cor      TYPE lvc_s_scol,                       " Estrutura para tratamento das cores das linhas do ALV
      v_carrid TYPE sflight-carrid.

SELECTION-SCREEN: BEGIN OF BLOCK bc02 WITH FRAME.
  SELECT-OPTIONS: so_carri FOR v_carrid.
SELECTION-SCREEN: END OF BLOCK bc02.

SELECT carrid, connid, fldate, planetype, seatsmax, seatsocc
  FROM sflight
  INTO TABLE @DATA(it_sflight)
  WHERE carrid IN @so_carri.

TYPES: BEGIN OF ty_sflight,
         carrid    TYPE sflight-carrid,
         connid    TYPE sflight-connid,
         fldate    TYPE sflight-fldate,
         planetype TYPE sflight-planetype,
         seatsmax  TYPE sflight-seatsmax,
         seatsocc  TYPE sflight-seatsocc,
         color     TYPE lvc_t_scol,                    " Campo com tabela para tratamento das cores nas linhas do ALV
       END OF ty_sflight.

DATA: tabela_1  TYPE TABLE OF ty_sflight,
      work_area TYPE ty_sflight.

MOVE-CORRESPONDING it_sflight TO tabela_1.

LOOP AT tabela_1 INTO work_area.

  DATA valida TYPE i.
  valida = ( work_area-seatsocc * 100 ) / work_area-seatsmax.

* Verificação da taxa de acentos ocupados e aplicação de cor
  IF valida < 50 AND valida > -1.
    cor-color-col = 5.                  " Aplicação de valor da cor a estrutura
    APPEND cor TO work_area-color.      " Inserção do valor da cor ao campo destinado para este tratamento na work_area
    MODIFY tabela_1 FROM work_area.     " Modificação da tabela base de ALV

  ELSEIF valida > 50 AND valida < 71.
    cor-color-col = 3.
    APPEND cor TO work_area-color.
    MODIFY tabela_1 FROM work_area.

  ELSEIF valida > 70.
    cor-color-col = 6.
    APPEND cor TO work_area-color.
    MODIFY tabela_1 FROM work_area.

  ENDIF.
ENDLOOP.

* Instanciando o objeto de ALV
cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = alv                " Objeto de ALV
    CHANGING
      t_table        = tabela_1           " Tabela base para o fieldcat

  ).

tela = alv->get_display_settings( ).      " Atribuindo a permissão de configuração de layout

tela->set_striped_pattern( abap_true ).   " Aplicando a formatação zebrada no ALV

colunas = alv->get_columns( ).            " Atribuindo a permissão de configuração de colunas do ALV
colunas->set_color_column( 'COLOR' ).     " Definido a coluna responsável pelo controle das cores das linhas do ALV

alv->display( ).                          " Exibindo o ALV
