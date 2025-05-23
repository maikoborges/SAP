*&---------------------------------------------------------------------*
*& Report ZEXERCICIOS_GERAIS026
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERCICIOS_GERAIS026.

* Tabelas Transparentes
tables zt005.

* Tabelas internas e Work area
data: t_zt005    type standard table of zt005,
      t_zt001    type standard table of zt001,
      t_saida    type standard table of zs001,
      t_fieldcat type slis_t_fieldcat_alv,      " Baseada em estrutura de fieldcat
      t_sort     type slis_t_sortinfo_alv,      " Baseada em estrutura de ordenação para ordenar a apresentação do ALV
      t_header   type slis_t_listheader.        " Baseada em estrutura de cabeçalho para o cabeçalho do ALV

* Works areas
data: w_zt005    type zt005,
      w_zt001    type zt001,
      w_saida    type zs001,
      w_fieldcat type slis_fieldcat_alv,    " Baseada em uma estrutura de fieldcat
      w_sort     type slis_sortinfo_alv,    " Baseada em uma estrutura de ordenação da lista de dados
      w_layout   type slis_layout_alv,      " Baseada em uma estrutura de layout do ALV
      w_header   type slis_listheader,      " Baseada em uma estrutura de cabeçalho do ALV
      w_variant  type disvariant.           " Baseada em uma estrutura de variante


* Telas de seleção com parametros de entrada do tipo intervalo de valores
selection-screen begin of block blc01 with frame title text-001.
select-options: so_tpmat for zt005-tpmat,
                so_mater for zt005-mater.
selection-screen end of block blc01.

* Tela de seleão com parametro de entrada para definição da variante
selection-screen begin of block blc02 with frame title text-002.
parameters p_vari type slis_vari.     " Parametro de entrada baseado na estrutura de variante
selection-screen end of block blc02.

* Evento de ajuda de pesquisa
at selection-screen on value-request for p_vari. " Evento de criação de ajuda de pesquisa

  perform variant using p_vari. " Definição da localização e aplicação da variante

* Inicio rotina de execução
start-of-selection.

  perform seleciona_dados. " Seleção dos registros das tabelas transparentes

  perform tabela_saida.    " Montagem da tabela de saida dos registros

  perform monta_alv.       " Montagem do ALV

form seleciona_dados .

* Seleção dos registros na tabela transparentes zt005
  select * from zt005
    into table t_zt005
   where tpmat in so_tpmat
     and mater in so_mater.

* Validando a execução da rotina e realizando nova seleção de dados agora na tbtransparente zt001 de acordo com a tb interna t_zt001
  if sy-subrc is initial.
    select * from zt001
      into table t_zt001
       for all entries in t_zt005
     where tpmat = t_zt005-tpmat.
  else.
    message text-003 type 'I'.
    stop.
  endif.

endform.

form tabela_saida .

* Lendo os registros e colocado em outra tabela que será responsável pela saida deste no ALV
  loop at t_zt005 into w_zt005.

    w_saida-mater  = w_zt005-mater.
    w_saida-denom  = w_zt005-denom.
    w_saida-tpmat  = w_zt005-tpmat.
    w_saida-brgew  = w_zt005-brgew.
    w_saida-ntgew  = w_zt005-ntgew.
    w_saida-status = w_zt005-status.
    w_saida-gewei  = w_zt005-gewei.

    read table t_zt001 into w_zt001 with key tpmat = w_zt005-tpmat.

    w_saida-denom_tp = w_zt001-denom.

    append w_saida to t_saida.

  endloop.

endform.

form monta_alv .

  perform monta_fieldcat.     " Definição do fieldcat (tabela de registros do alv)

  perform ordena.             " Ordenando o ALV

  perform layout.             " Layout do ALV

  perform imprimi_alv.        " Impressão do ALV

endform.

form monta_fieldcat .

* Função responsável pela formatação do ALV
  call function 'REUSE_ALV_FIELDCATALOG_MERGE'
    exporting
      i_program_name         = sy-repid    " Nome do programa
      i_internal_tabname     = 't_saida'   " Tabela interna com os registros para a apresentação no ALV
      i_structure_name       = 'zs001'     " Estrutura que servirá como base para o ALV
*     I_CLIENT_NEVER_DISPLAY = 'X'
*     I_INCLNAME             =
*     I_BYPASSING_BUFFER     =
*     I_BUFFER_ACTIVE        =
    changing
      ct_fieldcat            = t_fieldcat  " Tabela de fieldcat do ALV ( Tabela formatada para a apresentação )
    exceptions
      inconsistent_interface = 1
      program_error          = 2
      others                 = 3.

  if sy-subrc <> 0.
    message text-004 type 'I'.
    stop.
  else.

* Alteração das características de alguns campos
    loop at t_fieldcat into w_fieldcat.

      case w_fieldcat-fieldname.
        when 'BRGEW'.
          w_fieldcat-seltext_l = w_fieldcat-seltext_m = w_fieldcat-seltext_s = w_fieldcat-reptext_ddic = text-005.
        when 'NTGEW'.
          w_fieldcat-seltext_l = w_fieldcat-seltext_m = w_fieldcat-seltext_s = w_fieldcat-reptext_ddic = text-006.
        when 'MATER'.
          w_fieldcat-hotspot = 'X'. " Ativar o aceeso para transferência de ambiente
        when others.
      endcase.

      modify t_fieldcat from w_fieldcat index sy-tabix transporting seltext_l seltext_m seltext_s reptext_ddic hotspot.

    endloop.
  endif.

endform.

form ordena .

* Ordenando a tabela interna pelo campo material (Permitindo mudança)
  clear w_sort.
  w_sort-spos      = 1.
  w_sort-fieldname = 'MATER'.
  w_sort-tabname   = 't_saida'.
  w_sort-up        = 'X'.

  append w_sort to t_sort.

endform.

form layout .

* Formatando o layout do ALV
  w_layout-zebra             = 'X'.     " Aplincando formato de zebra na apresentação
  w_layout-colwidth_optimize = 'X'.     " Otimizando os espaçamentos das colunas

endform.

form imprimi_alv .

* Passando a variável
  w_variant-variant = p_vari.

* Função de apresentação do ALV
  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = sy-repid        " Nome do programa
*     I_CALLBACK_PF_STATUS_SET    = ' '
      i_callback_user_command = 'USER_COMMAND'  " Ativando a opção de comandos do usuário
      i_callback_top_of_page  = 'CABECALHO'     " Ativando a opção de cabeçalho
*     i_callback_html_top_of_page = ' '
*     I_CALLBACK_HTML_END_OF_LIST = ' '
      i_structure_name        = 'zs001'         " Estrutura base para o ALV
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      is_layout               = w_layout        " Aplicando os parametros de layout
      it_fieldcat             = t_fieldcat      " Informando a tabela de fieldcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
      it_sort                 = t_sort          " Aplicando a ordenação na apresentação seguindo a t_sort
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'X'             " Salvando os dados
      is_variant              = w_variant       " Apliacando a variante
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER  =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    tables
      t_outtab                = t_saida     " Informando a tabela que contem os dados para a apresentação
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
    message text-007 type 'I'.
    stop.
  endif.

endform.

* Definindo o cabeçalho do ALV
form cabecalho.

  clear w_header.                 " Limpando a work area de cabeçalho
  refresh t_header.               " Atualizando a tabela interna de cabeçalho

  w_header-typ  = 'H'.            " Aplicando o tipo de cabeçalho ( H = Neglito grande / S = Neglito pequeno / A = Italíco )
  w_header-info = text-008.       " Passando o nome do texto
  append w_header to t_header.    " Incluindo na tabela de cabeçalho

  w_header-typ  = 'S'.
  w_header-key  = text-009.         " Passando o nome do texto como chave
  write sy-datum to w_header-info.  " Lendo a data no cabeçalho
  append w_header to t_header.

  w_header-typ  = 'S'.
  w_header-key  = text-010.         " Passando o nome do texto como chave
  write sy-uzeit to w_header-info.  " Passando a hora no cabeçalhos
  append w_header to t_header.

* Função que aplica uma logo no programa
  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary = t_header             " Tabela base para o cabeçalho
      i_logo             = 'ENJOYSAP_LOGO'      " Nome da logo
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .


endform.

form variant using p_p_vari.

* Variével baseada na estrutura de variante  para converte o id do programa
  data: wl_variant type disvariant.

  wl_variant-report = sy-repid.

* Função de aplicação da variante
  call function 'REUSE_ALV_VARIANT_F4'
    exporting
      is_variant    = wl_variant      " Definição da variant de entrada
*     I_TABNAME_HEADER          =
*     I_TABNAME_ITEM            =
*     IT_DEFAULT_FIELDCAT       =
      i_save        = 'A'
*     I_DISPLAY_VIA_GRID        = ' '
    importing
*     E_EXIT        =
      es_variant    = wl_variant      " Recebimento da variant de saida após tratamento pela função
    exceptions
      not_found     = 1
      program_error = 2
      others        = 3.

  if sy-subrc <> 0.
    message text-011 type 'I'.
    stop.
  else.
    p_p_vari = wl_variant-variant.    " Parâmetro de entrada recebendo a os dados da varinate de saida
  endif.

endform.


* Form de tratamento para a seleção da manuntenção de tabela
form user_command using ucomm     like sy-ucomm          " Parametro do form que salva o botão que foi clicado
                        selfield  type slis_selfield.    " Parametro do form que armazena os dados do campo cricado

  data: tl_vimsellist type table of vimsellist, " Tabela interna para definição dos campos de apresentados baseada em estrutura do tipo manutenção de tabela
        wl_vimsellist type vimsellist.          " Work area baseada em estrutura do tipo manutenção de tabela

* Rotina de validação para permite que ao clicar na tabela apenas a coluna (material) exiba a manutenção de tabela
  if selfield-sel_tab_field = 't_saida-MATER'.

    wl_vimsellist-viewfield = 'MATER'.          " Atribuindo a work area o nome do campo
    wl_vimsellist-operator  = 'EQ'.             " Atribuindo a work area o operador de igual
    wl_vimsellist-value     = selfield-value.   " Atribuindo a work area o valor do campo clicado
    append wl_vimsellist to tl_vimsellist.      " Incluido os dados da work area na tabela interna para manutenção


* Função que permite a exibição da manutenção de tabela
    call function 'VIEW_MAINTENANCE_CALL'
      exporting
        action                       = 'S'      " Exibir a manutenção de tabela
*       CORR_NUMBER                  = ' '
*       GENERATE_MAINT_TOOL_IF_MISSING       = ' '
*       SHOW_SELECTION_POPUP         = ' '
        view_name                    = 'ZT005'  " Estrutura base para a manutenção de tabela
*       NO_WARNING_FOR_CLIENTINDEP   = ' '
*       RFC_DESTINATION_FOR_UPGRADE  = ' '
*       CLIENT_FOR_UPGRADE           = ' '
*       VARIANT_FOR_SELECTION        = ' '
*       COMPLEX_SELCONDS_USED        = ' '
*       CHECK_DDIC_MAINFLAG          = ' '
*       SUPPRESS_WA_POPUP            = ' '
      tables
        dba_sellist                  = tl_vimsellist   " Tabela contendo os campos desejados
*       EXCL_CUA_FUNCT               =
      exceptions
        client_reference             = 1
        foreign_lock                 = 2
        invalid_action               = 3
        no_clientindependent_auth    = 4
        no_database_function         = 5
        no_editor_function           = 6
        no_show_auth                 = 7
        no_tvdir_entry               = 8
        no_upd_auth                  = 9
        only_show_allowed            = 10
        system_failure               = 11
        unknown_field_in_dba_sellist = 12
        view_not_found               = 13
        maintenance_prohibited       = 14
        others                       = 15.
    if sy-subrc <> 0.
* Implement suitable error handling here
    endif.

  endif.


endform.