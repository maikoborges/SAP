*&---------------------------------------------------------------------*
*& Report ZEXERCICIOS_GERAIS024
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERCICIOS_GERAIS024.


***************************************************
* ESTRUTURA
***************************************************
types: begin of ty_dados,
         forn  like zt004-forne,
         deno  like zt004-denom,
         ende  like zt004-ender,
         celu  like zt004-telef,
         email like zt004-email,
         cnpj  like zt004-cnpj,
       end of ty_dados.

***************************************************
* TABELAS E WORK AREAS
***************************************************
* Tabela interna e Work area
data: t_forn    type standard table of ty_dados,
      w_forn    type ty_dados,
      t_bdcdata type standard table of bdcdata,     " Tabela interna basseada em uma tabela do sistema (Tabela de BDC)
      w_bdcdata type bdcdata.

***************************************************
* TELA DE SELEÇÃO 
***************************************************
* Tela de seleção do arquivo com um parametro que permite definir o  local de destino ou origem do arquivo
selection-screen begin of block b01 with frame title text-001.
parameters: p_file type localfile.        " Parametro de entrada baseado no elemento que permite definir o local de destino ou origem
selection-screen end of block b01.

***************************************************
* ROTINA DO PROGRAMA
***************************************************
* Pop-up para localizar arquivo
at selection-screen on value-request for p_file.  " Evento para liberação do pop-up que da acesso a area de trabalho do computador
  perform selecao_arquivo.                        " Perform contento a função de pop-up

* Inicio das rotinas
start-of-selection.
  perform upload.       " Perform contendo a função de upload do arquivo
  perform monta_bdc.    " Perform contendo o BDC

form selecao_arquivo .

" Função para abri pop-up para dar acesso ao local de destino ou origem do arquivo
  call function 'KD_GET_FILENAME_ON_F4'
    exporting
*     PROGRAM_NAME  = SYST-REPID
*     DYNPRO_NUMBER = SYST-DYNNR
      field_name    = p_file              " Objeto contendo o local de origem do arquivo
*     STATIC        = ' '
*     MASK          = ' '
*     FILEOPERATION = 'R'
*     PATH          =
    changing
      file_name     = p_file              " Objeto que recebe o local de origem do arquivo após o tratamento pela função
*     LOCATION_FLAG = 'P'
    exceptions
      mask_too_long = 1
      others        = 2.
  if sy-subrc <> 0.
    message text-002 type 'I'.
  endif.

endform.

form upload .

* Variável do tipo string que receberá o local de destino do arquivo e convertera ele em string
  data vl_file type string.
  vl_file = p_file.

* Função que permite realizar o upload do arquivo do computador para a tabela interna
  call function 'GUI_UPLOAD'
    exporting
      filename                = vl_file       " Local de origem do arquivo
      filetype                = 'ASC'         " Tipo de leitura do arquivo
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
      data_tab                = t_forn        " Tabela interna que receberá os dados vindos do computador
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
    message text-003 type 'I'.
  endif.


endform.

form monta_bdc .

" Perform contendo abertura de pasta BDC
  perform abre_pasta.

* Leitura da tabela interna
  loop at t_forn into w_forn.

    " Montagem da carga de dados baseada no mapeamento da BDC na transação (SHDB)
    perform monta_tela  using 'SAPLZTABELAS' '0004'.            " Perform c/ parâmetros de entrada da transação mapeada ( Nome do programa e N° da tela)
    perform monta_dados using 'BDC_CURSOR'   'ZT004-DENOM(01)'. " Perform c/ parâmetros de entrada da transação mapeada ( Nome campo e Valor campo)
    perform monta_dados using 'BDC_OKCODE'   '=NEWL'.

    perform monta_tela  using 'SAPLZTABELAS' '0005'.
    perform monta_dados using 'BDC_CURSOR'   'ZT004-CNPJ'.
    perform monta_dados using 'BDC_OKCODE'   '=SAVE'.
    perform monta_dados using 'ZT004-FORNE'  w_forn-forn. " Perform com os parametros de entrada vindos da work area que contém os dados vindo do computador
    perform monta_dados using 'ZT004-DENOM'  w_forn-deno.
    perform monta_dados using 'ZT004-ENDER'  w_forn-ende.
    perform monta_dados using 'ZT004-TELEF'  w_forn-celu.
    perform monta_dados using 'ZT004-EMAIL'  w_forn-email.
    perform monta_dados using 'ZT004-CNPJ'   w_forn-cnpj.

    perform monta_tela  using 'SAPLZTABELAS' '0005'.
    perform monta_dados using 'BDC_CURSOR'   'ZT004-DENOM'.
    perform monta_dados using 'BDC_OKCODE'   '=ENDE'.

    perform inseri_bdc.                             " Perform contendo a inserção os dados no BDC

  endloop.

  perform fecha_pasta.                              " Perform contendo o fechamento da pasta BDC

  IF sy-subrc = 0.
    MESSAGE text-004 TYPE 'S'.
  ENDIF.

endform.

* Form com os elementos necessários para montar a tela de BDC
form monta_tela  using    p_program
                          p_screen.
  clear w_bdcdata.                    " Limpando a work area do BDC
  w_bdcdata-program  = p_program.     " Work area recebendo o nome do programa
  w_bdcdata-dynpro   = p_screen.      " Work area recebendo o número da tela
  w_bdcdata-dynbegin = 'X'.           " Work area recebendo a informação que é o início da tela
  append w_bdcdata to t_bdcdata.      " Incluindo os dados da work area para a tabela interna de BDC
endform.

* Form com os elementos necessários para definir o campo e o valor a ser atribuido ao mesmo
form monta_dados  using    p_name
                           p_value.
  clear w_bdcdata.                  " limpando a work area de BDC
  w_bdcdata-fnam = p_name.          " Work area recebendo o nome do campo a ser preenchido
  w_bdcdata-fval = p_value.         " Work area recebendo o valor a preencher o campo definido anterior
  append w_bdcdata to t_bdcdata.    " Incluindo os dados na tabela interna de BDC
endform.

form abre_pasta .

* Função que abri a pasta BDC para realizar o upload dos dados em massa
  call function 'BDC_OPEN_GROUP'
    exporting
      client              = sy-mandt          " Mandatario que abri a pasta
*     DEST                = FILLER8
      group               = 'CARGA_FORNEC'    " Nome dado para pasta que receberá os dados
*     HOLDDATE            = FILLER8
      keep                = 'X'               " Não permitir que a pasta seja apagada
      user                = sy-uname          " Usuário que abri a pasta
*     RECORD              = FILLER1
*     PROG                = SY-CPROG
*     DCPFM               = '%'
*     DATFM               = '%'
* IMPORTING
*     QID                 =
    exceptions
      client_invalid      = 1
      destination_invalid = 2
      group_invalid       = 3
      group_is_locked     = 4
      holddate_invalid    = 5
      internal_error      = 6
      queue_error         = 7
      running             = 8
      system_lock_error   = 9
      user_invalid        = 10
      others              = 11.

  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.

endform.

form inseri_bdc .
* Função que inseri os dados da BDC na transação que receberá a carga de dados (Criando um elemento na transação SM35 para ser executado)
  call function 'BDC_INSERT'
    exporting
      tcode            = 'zcad004'      " Código do pragrama responsável por receber os dados
*     POST_LOCAL       = NOVBLOCAL
*     PRINTING         = NOPRINT
*     SIMUBATCH        = ' '
*     CTUPARAMS        = ' '
    tables
      dynprotab        = t_bdcdata      " Tabela interna contendo os dados
    exceptions
      internal_error   = 1
      not_open         = 2
      queue_error      = 3
      tcode_invalid    = 4
      printing_invalid = 5
      posting_invalid  = 6
      others           = 7.
  if sy-subrc <> 0.
* Implement suitable error handling here
  else.
    CLEAR t_bdcdata.
  endif.


endform.

form fecha_pasta .

* Função que fecha a pasta BDC
  call function 'BDC_CLOSE_GROUP'
    exceptions
      not_open    = 1
      queue_error = 2
      others      = 3.
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.

endform.