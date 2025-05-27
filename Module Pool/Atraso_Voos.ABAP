*&---------------------------------------------------------------------*
*& Modulpool ZEXERCICIOS_GERAIS028
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

include zgerais028top.    " Include contendo as declarações gerais
include zgerais028PBO.    " Include contendo as rotinas do PBO
include zgerais028PAI.    " Include contendo as rotinas do PAI
include zgerais028form.   " Include contendo as rotinas dos performs


*&---------------------------------------------------------------------*
*& Include          ZGERAIS028TOP
*&---------------------------------------------------------------------*
program zexercicios_gerais028.

* Declaração da tabela transparente de voos
tables: spfli, zatraso_voo_estrutura, zatraso_voo.

* Declaração dos objetos de custo container e alv
data: custom_container        type ref to cl_gui_custom_container,
      alv                     type ref to cl_gui_alv_grid,
      fieldacat               type lvc_t_fcat,
      t_zatraso_voo_estrutura type standard table of zatraso_voo_estrutura,
      w_zatraso_voo_estrutura like line of t_zatraso_voo_estrutura,
      w_zatraso_voo           type zatraso_voo.

* Bloco de tela na subscreen e bloco de tela com os paramentros de entradas
selection-screen: begin of screen 0001 as subscreen.
selection-screen: begin of block bc01 with frame title text-001.
select-options: s_carrid for spfli-carrid no intervals, " Parametro de entrada sem intervalo de valores
                s_connid for spfli-connid no intervals,
                s_cityfr for spfli-cityfrom no intervals,
                s_cityto for spfli-cityto no intervals.

selection-screen: end of block bc01.
selection-screen: end of screen 0001.



*&---------------------------------------------------------------------*
*& Include          ZGERAIS028PBO
*&---------------------------------------------------------------------*

module cc_alv output.

  perform cc_alv_perfom.    " Perform com a rotiande criação do custom _container e do ALV

  perform trava_campo.      " Performa contendo a rotina de fechamaneto do campo de resgistro de atraso de voo

endmodule.

module status_0100 output.
  set pf-status 'PF-100'.
* SET TITLEBAR 'xxx'.
endmodule.



*&---------------------------------------------------------------------*
*& Include          ZGERAIS028PAI
*&---------------------------------------------------------------------*

module botoes input.

* Condicional que apliaca a rotinas diferentes de acordo com cada botão clicado
  case sy-ucomm.
    when 'BACK' or 'EXIT' or 'CANCEL'.
      leave program.                      " Sair do programa

    when 'EXECUTAR'.
      PERFORM selecionar_registros.       " Perform de selecão dos registros de voos

    when 'ADD'.
      PERFORM inserir_registros.          " Perform de inserção dos atrasos dos voos na tabela transparente
      PERFORM selecionar_registros.

  endcase.
endmodule.



*&---------------------------------------------------------------------*
*& Include          ZGERAIS028FORM
*&---------------------------------------------------------------------*

form cc_alv_perfom .

* Rotina condicional que criar os objetos caso os mesmos existam
      if custom_container is not bound.
    
* Criação do objeto de custom_container
        create object custom_container
          exporting
*       parent         =
            container_name = 'CC_ALV'         " Nome da area de custom_container contida na tela principal
*       style          =
*       lifetime       = lifetime_default
*       repid          =
*       dynnr          =
*       no_autodef_progid_dynnr     =
*   exceptions
*       cntl_error     = 1
*       cntl_system_error           = 2
*       create_error   = 3
*       lifetime_error = 4
*       lifetime_dynpro_dynpro_link = 5
*       others         = 6
          .
        if sy-subrc <> 0.
*  message id sy-msgid type sy-msgty number sy-msgno
*    with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        endif.
    
* Criação do objeto de ALV
        create object alv
          exporting
*       i_shellstyle      = 0
*       i_lifetime        =
            i_parent = custom_container          " Nome do Custom_Container onde esta contido o ALV
*       i_appl_events     = space
*       i_parentdbg       =
*       i_applogparent    =
*       i_graphicsparent  =
*       i_name   =
*       i_fcat_complete   = space
*    exceptions
*       error_cntl_create = 1
*       error_cntl_init   = 2
*       error_cntl_link   = 3
*       error_dp_create   = 4
*       others   = 5
          .
        if sy-subrc <> 0.
*   message id sy-msgid type sy-msgty number sy-msgno
*     with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        endif.
    
* Chamando a função que permite a criação do fieldcat
        call function 'LVC_FIELDCATALOG_MERGE'
          exporting
*       I_BUFFER_ACTIVE  =
            i_structure_name = 'ZATRASO_VOO_ESTRUTURA'     " Estrutura base para o fieldact
*       I_CLIENT_NEVER_DISPLAY       = 'X'
*       I_BYPASSING_BUFFER           =
*       I_INTERNAL_TABNAME           =
          changing
            ct_fieldcat      = fieldacat        " Fieldcat proto para aplicação na tela
*     EXCEPTIONS
*       INCONSISTENT_INTERFACE       = 1
*       PROGRAM_ERROR    = 2
*       OTHERS           = 3
          .
        if sy-subrc <> 0.
* Implement suitable error handling here
        endif.
    
* Setando o ALV para permite sua apresentação na tela
        alv->set_table_for_first_display(
      changing
        it_outtab                     = t_zatraso_voo_estrutura  " Passando a tabela interna que contém os dados
        it_fieldcatalog               = fieldacat                " Passando a estrutura de fieldacat utilizada para apresentação
        ).
    
      endif.
    
* Atualizando o ALV
      alv->refresh_table_display( ).
    endform.
    
    
    form trava_campo .
    
* Rotina condicional de fechamento do campo atraso caso a atebaç interna de voos esteja vazia
      if t_zatraso_voo_estrutura is not initial.
        loop at screen.                   " Leitura da tabela de tela
          if screen-group1 = 'GR1'.       " Condicional que verifica se algum campo pertece ao grupo(GR1)
            screen-input = 1.             " Aplicando o fechamento do mesmo
            modify screen.                " Modificando a tabela de tela
          endif.
    
        endloop.
    
      else.
        loop at screen.
          if screen-group1 = 'GR1'.
            screen-input = 0.
            modify screen.
          endif.
    
        endloop.
    
      endif.
    endform.
    
    form selecionar_registros .
    
* Rotina condiucional para selecioanr os registros de voos e apliar na tabela interna que será apresentada na tela
      if zatraso_voo-data_voo is initial.
        select carrid connid countryfr cityfrom airpfrom
                countryto cityto airpto fltime deptime arrtime
          from spfli
          into table t_zatraso_voo_estrutura
         where carrid in s_carrid
           and connid in s_connid
           and cityfrom in s_cityfr
           and cityto in s_cityto.
    
      else.
        select spfli~carrid spfli~connid spfli~countryfr spfli~cityfrom
        spfli~airpfrom spfli~countryto spfli~cityto spfli~airpto spfli~fltime
        spfli~deptime spfli~arrtime zatraso_voo~data_voo zatraso_voo~atraso
          from spfli
         inner join zatraso_voo
            on spfli~carrid = zatraso_voo~carrid
           and spfli~connid = zatraso_voo~connid
          into table t_zatraso_voo_estrutura
         where spfli~carrid in s_carrid
           and spfli~connid in s_connid
           and spfli~carrid in s_cityfr
           and spfli~cityto in s_cityto
           and zatraso_voo~data_voo = zatraso_voo-data_voo.
    
* Condicional que adiciona os atrasos dos voos na tabela interna, sendo refletido diretamente na tela
        if sy-subrc = 0.
          loop at t_zatraso_voo_estrutura into w_zatraso_voo_estrutura.
            if w_zatraso_voo_estrutura-atraso is not initial.
              w_zatraso_voo_estrutura-arrtime = w_zatraso_voo_estrutura-arrtime + w_zatraso_voo_estrutura-atraso.
            endif.
            modify t_zatraso_voo_estrutura from w_zatraso_voo_estrutura.
          endloop.
    
        endif.
    
      endif.
    
    endform.
    
    form inserir_registros .
    
* Leitura da tabela interna de voos e aplicação dos atrasos
      loop at t_zatraso_voo_estrutura into w_zatraso_voo_estrutura.
        w_zatraso_voo-carrid = w_zatraso_voo_estrutura-carrid.
        w_zatraso_voo-connid = w_zatraso_voo_estrutura-connid.
        w_zatraso_voo-data_voo = zatraso_voo-data_voo.
        w_zatraso_voo-atraso   = zatraso_voo-atraso.
    
        insert zatraso_voo from w_zatraso_voo.      " Adição do atraso na tabela transparente
    
        if sy-subrc = 0.
          commit work.                    " Confirmação da modificação da tabela de banco de dados
          message text-002 type 'S'.
    
        else.
          rollback work.                  " Desfazendo a modificação na tabela de banco de dados
          message text-003 type 'S' display like 'E'.
        endif.
      endloop.
    endform.

* Tela necessárias
    " Screen do próprio report e a screen 0100