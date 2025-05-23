*&---------------------------------------------------------------------*
*& Report ZEXERCICIOS_GERAIS025
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERCICIOS_GERAIS025.


***************************************************
* ESTRUTURAS
***************************************************
types: begin of ty_forn,
         forne like zt004-forne,
         denom like zt004-denom,
         ender like zt004-ender,
         telel like zt004-telef,
         email like zt004-email,
         cnpj  like zt004-cnpj,
       end of ty_forn.

***************************************************
* TABELAS E WORK AREAS
***************************************************
data: t_forn    type standard table of ty_forn,
      w_forn    type ty_forn,
      t_bdcdata type standard table of bdcdata,       " Tabela interna baseada em uma tabela do sistema (Tabela para BDC)
      w_bdcdata type bdcdata,
      t_message type standard table of bdcmsgcoll,    " Tabela interna baseada em uma tabela do sistema (Tabela para mensagens do BDC)
      w_message type bdcmsgcoll.

***************************************************
* TELA DE SELEÇÃO
***************************************************
selection-screen begin of block b01 with frame title text-001.
parameters: p_file type localfile,          " Parametro de entrada baseado no elemento que permite definir o local de origem ou destino do arquivo
            p_mode type c default 'A'.      " Parametro de entrada para definir se a carga de dados será executada passo a passo na tela ('A' sem exibir)
selection-screen end of block b01.

***************************************************
* ROTINA DO PROGRAMA
***************************************************
* Evento de Pop-up
at selection-screen on value-request for p_file.
  perform seleciona. " Seleção do local do arquivo

*Evento de Inicio de tela
start-of-selection.
  perform upload.     " Upload do arquivo
  perform monta_bdc.  " Montagem do bdc

form seleciona .

* Função que permite abrir um pou pap para acessa a area de trabalho do computador
  call function 'KD_GET_FILENAME_ON_F4'
    exporting
*     PROGRAM_NAME  = SYST-REPID
*     DYNPRO_NUMBER = SYST-DYNNR
      field_name    = p_file      " Parametro com o locaal de origem do arquivo no computador
*     STATIC        = ' '
*     MASK          = ' '
*     FILEOPERATION = 'R'
*     PATH          =
    changing
      file_name     = p_file      " Parametro que recebe o local de arquivo já com o tratamento pela função
*     LOCATION_FLAG = 'P'
    exceptions
      mask_too_long = 1
      others        = 2.
  if sy-subrc <> 0.
    message text-002 type 'I'.
  endif.

endform.

form upload .

* Variável do tipo string que recebe o local de origem do arquivo e converterá ele em um elemento string
  data: vl_file type string.
  vl_file = p_file.

* Função que executa o upload do arquivo do computador e inclui na tabela interna
  call function 'GUI_UPLOAD'
    exporting
      filename                = vl_file     " Parametro com o local de origem do arquivo
      filetype                = 'ASC'
*     HAS_FIELD_SEPARATOR     = ' '
*     HEADER_LENGTH           = 0
*     READ_BY_LINE            = 'X'
*     DAT_MODE                = ' '
*     CODEPAGE                = ' '
*     IGNORE_CERR             = ABAP_TRUE
*     REPLACEMENT             = '#'
*     CHECK_BOM               = ' '
*     VIRUS_SCAN_PROFILE      =
*     NO_AUTH_CHECK           = ' '
* IMPORTING
*     FILELENGTH              =
*     HEADER                  =
    tables
      data_tab                = t_forn      " Tabela interna que recebe o upload do arquivo
* CHANGING
*     ISSCANPERFORMED         = ' '
    exceptions
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      others                  = 17.
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.

endform.

form monta_bdc .

* Leitura da taebla interna que contém os arquivos para a carga de dados
  loop at t_forn into w_forn.

*   Montagem da carga de dados baseado no mapeamento da transação zcad004 pela transação de BDC (SHDB)
    perform monta_tela  using 'SAPLZTABELAS' '0004'.
    perform monta_dados using 'BDC_CURSOR'   'ZT004-DENOM(01)'.
    perform monta_dados using 'BDC_OKCODE'   '=NEWL'.

    perform monta_tela  using 'SAPLZTABELAS' '0005'.
    perform monta_dados using 'BDC_CURSOR'   'ZT004-CNPJ'.
    perform monta_dados using 'BDC_OKCODE'   '=SAVE'.
    perform monta_dados using 'ZT004-FORNE'  w_forn-forne.    " Passagem dos parametros com base na work area que contém os dados da tabela interna
    perform monta_dados using 'ZT004-DENOM'  w_forn-denom.
    perform monta_dados using 'ZT004-ENDER'  w_forn-ender.
    perform monta_dados using 'ZT004-TELEF'  w_forn-telel.
    perform monta_dados using 'ZT004-EMAIL'  w_forn-email.
    perform monta_dados using 'ZT004-CNPJ'   w_forn-cnpj.

    perform monta_tela  using 'SAPLZTABELAS' '0005'.
    perform monta_dados using 'BDC_CURSOR'   'ZT004-DENOM'.
    perform monta_dados using 'BDC_OKCODE'   '=ENDE'.


* Execução da carga de dados
    call transaction 'ZCAD004'  " Chamando a Transação a ser executada
    using t_bdcdata             " Tabela interna que contém os dados para a carga
    mode p_mode                 " Definição do modo de execução do processamento (A background ou foreground)
    update 'A'                  " Definição de asicrico ou sicrico (primeiro ou segundo plano)
    messages into t_message.    " Tabela que receberar as mensagens de execução

    perform imprimi_messagem .

* Leitura das tabelas internas e work areas
    clear t_bdcdata[].
    clear w_bdcdata.
    clear t_message.

  endloop.
endform.

form monta_tela  using    p_program
                          p_screen.

* Introdução dos dados na tabela interna
  clear w_bdcdata.
  w_bdcdata-program  = p_program.
  w_bdcdata-dynpro   = p_screen.
  w_bdcdata-dynbegin = 'X'.
  append w_bdcdata to t_bdcdata.

endform.

form monta_dados  using    p_name
                           p_value.

* Introdução dos dados na tabela interna
  clear w_bdcdata.
  w_bdcdata-fnam = p_name.
  w_bdcdata-fval = p_value.
  append w_bdcdata to t_bdcdata.

endform.

form imprimi_messagem .

* Declaração das variáveis convertidas no tipo igual ao da bapi
  data: vl_id      type bapiret2-id,
        vl_number  type bapiret2-number,
        vl_mess1   type bapiret2-message_v1,
        vl_mess2   type bapiret2-message_v2,
        vl_mess3   type bapiret2-message_v3,
        vl_mess4   type bapiret2-message_v4,
        vl_message type bapiret2-message.

  loop at t_message into w_message where msgtyp = 'E' or msgtyp = 'S'.

    vl_id     = w_message-msgid.
    vl_number = w_message-msgnr.
    vl_mess1  = w_message-msgv1.
    vl_mess1  = w_message-msgv2.
    vl_mess3  = w_message-msgv3.
    vl_mess4  = w_message-msgv4.

* Bapi que recebe as mensagens do processo de carga de dados
    call function 'BAPI_MESSAGE_GETDETAIL'
      exporting
        id         = vl_id      " Identificador da classe de mensagem
        number     = vl_number  " Número da mensagem gerada
*       LANGUAGE   = SY-LANGU
        textformat = 'asc'      " Tipo de leitura da mensagem
*       linkpattern =
        message_v1 = vl_mess1   " Mensagem geradas
        message_v2 = vl_mess1
        message_v3 = vl_mess3
        message_v4 = vl_mess4
*       LANGUAGE_ISO       =
*       LINE_SIZE  =
      importing
        message    = vl_message " Leitura das mensagens
*       RETURN     =
*     TABLES
*       TEXT       =
      .

   WRITE: vl_message.

  endloop.
endform.