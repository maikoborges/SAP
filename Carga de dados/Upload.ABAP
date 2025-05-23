*&---------------------------------------------------------------------*
*& Report ZEXERCICIOS_GERAIS022
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERCICIOS_GERAIS022.

*( Subindo arquivo do computador (upload) )

* - Declaração das estrutura, tabelas e work areas
* - Declaração da tela de seleção contendo o parametro que recebe o local de destino do arquivo e o objeto que definir o tipo de arquivo
* - Declaração do ponteiro de memória
* - Declaração da função que habilitar o metcode
* - Declaração do evento que permite a seleção do arquivo
* - Realização da validação do tipo de arquivo (txt ou csv) e associação deste ao ponteiro de memória
* - Declaração do função que realiza o upload do arquivo
* - Caso o arquivo seja do tipo csv, aplica rotina de tratamento para convertelo em txt
* - Aplicar rotina de leitura do arquivo

***************************************************
* ESTRUTURAS
***************************************************
* Estrutura base para o arquivo em txt
types: begin of ty_txt,
         cod  type c length 10,
         nome type c length 30,
         cel  type c length 14,
       end of ty_txt.

* Estrutura base para o arquivo em cvs
types: begin of ty_csv,
         line type c length 100,
       end of ty_csv.

***************************************************
* TABELAS E WORK AREAS
***************************************************
* Tabelas internas e work areas para o TXT e o CSV
data: w_txt type ty_txt,
      t_txt type table of ty_txt,
      w_csv type ty_csv,
      t_csv type table of ty_csv.

***************************************************
* TELA DE SELEÇÃO
***************************************************
* Tela de seleção dos parametros de entrada
selection-screen begin of block b01 with frame title text-001.
parameters: p_file type localfile,            " Parametro de entrada baseado no elemento que recebe o local de origem do arquivo
            p_txt  radiobutton group gr1,     " Radiobutton para seleção do tipo arquivo
            p_csv  radiobutton group gr1.
selection-screen end of block b01.

***************************************************
* ROTINA DO PROGRAMA
***************************************************
* Declaração do PONTEIRO DE MEMÓRIA (Elemento com função de camaleão, se tranformar em outros objetos)
field-symbols <tabela> type standard table.

* Evento SELECTION-SCREEN ativado após click no metcold do elemento p_file
* Permitindo acesso a área de trabalho do computador para selecionar local do arquivo
at selection-screen on value-request for p_file.
  perform selecao_file.     " Perform de seleção dos registros  utilizando uma função específica

start-of-selection.
  perform upload_arquivo.
  perform leitura_arquivo.

form selecao_file .

* Chamando a função (KD_GET_FILENAME_ON_F4) que serve para seleção de arquivo
  call function 'KD_GET_FILENAME_ON_F4'
    exporting
*     PROGRAM_NAME  = SYST-REPID
*     DYNPRO_NUMBER = SYST-DYNNR
      field_name    = p_file      " Determinando o elemento que recebera o local de origem do arquivo
*     STATIC        = ' '
*     MASK          = ' '
*     FILEOPERATION = 'R'
*     PATH          =
    changing
      file_name     = p_file      " Definindo o elemento que recebera o local de origem no tratamento da função
*     LOCATION_FLAG = 'P'
    exceptions
      mask_too_long = 1
      others        = 2.

  if sy-subrc <> 0.
    message text-002 type 'I'.    " Mensagem de aviso no caso de erro
  endif.

endform.

form upload_arquivo .

* Convertendo o caminho do arquivo para TYPE STRING
  data: vl_file type string.
  vl_file = p_file.

* Validação do tipo de arquivo selecionado para realizar upload
  if p_txt = 'X'.
    assign t_txt to <tabela>.  " Atribuindo a tabela t_txt ao ponteiro de memória (field-symbols) caso este seja selecionado no radiobutton
  else.
    assign t_csv to <tabela>.  " Atribuindo a tabela t_cvs ao ponteiro de memória field-symbols caso este seja selecionado no radiobutton
  endif.

* Função que permite carrega os dados do computador para uma tabela interna
  call function 'GUI_UPLOAD'
    exporting
      filename                = vl_file     " Declarando o local de origem do arquivo
      filetype                = 'ASC'        " Determinando o tipo de leitura do arquivo
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
      data_tab                = <tabela>      " Tabela que receberá os dados do arquivo baixado
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

* declaração da condicional que converte o arquivo csv em arquivo txt para ser impresso
  if p_csv = 'X'.
    loop at <tabela> into w_csv.
      split w_csv at ';' into w_txt-cod w_txt-nome w_txt-cel.   " Separando os texto em trechos pelo caracter ":"
      append w_txt to t_txt.                                    " Alocando so dados separados na tabela intena t_txt
    endloop.
  endif.

endform.


* Apresentando os registros baixando do computador
form leitura_arquivo .

  loop at t_txt into w_txt.
    write: / w_txt-cod, w_txt-nome, w_txt-cel.
  endloop.


endform.