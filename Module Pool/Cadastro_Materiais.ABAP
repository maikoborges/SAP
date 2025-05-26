*&---------------------------------------------------------------------*
*& Module Pool      ZEXERCICIOS_GERAIS027
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

include zgeraistop                              .  " Global Data
include zgeraiso01                              .  " PBO-Modules
include zgeraisi01                              .  " PAI-Modules
include zgeraisf01                              .  " FORM-Routines


*&---------------------------------------------------------------------*
*& Include ZGERAISTOP                               - Module Pool      ZEXERCICIOS_GERAIS027
*&---------------------------------------------------------------------*
PROGRAM ZEXERCICIOS_GERAIS027.

* Tabelas transparentes
TABLES: zt006, zt007.

* Declaração da work area
data w_zt006 type zt006.

* Estrutura que será a base para a tabela interna aplicada na tabela de controle, incluindo um campo
types begin of ty_zt007.
include structure zt007.    " Inclusão de uma estrutura já pronta
types mark.                 " Inclusão do campo que servirá como campo de marcação
types end of ty_zt007.

* Tabela interna com work area baseada na estrutura, que será aplicada na tabela de controle
data t_zt007 type table of ty_zt007 with header line.

* Tabela de controle que será aplicada na tela 0100
controls tc_0100 type tableview using screen 0100.

* Variáveis que servirão como campos invisiveis de entrada de dados na tela principal
data: v_bukrs type ze002,
      v_forne type ze002,
      v_compr type ze002.

* Estrutura contendo constantes para servir como valor de cada tabstrip
constants: begin of c_tb_0100,
             tab1 type sy-ucomm value 'TB_0100_TB_CF1', " Tabstrip 1 que recebe o valor TB_0100_TB_CF1 so ser acessada
             tab2 type sy-ucomm value 'TB_0100_TB_CF2',
           end of c_tb_0100.
*
* Tabela para controle de entrada de dados mestres
controls tb_0100 type tabstrip.

* Work area da tabsstrip contendo campos específicos
data: begin of w_tb_0100,
        subscreen  type sy-dynnr,                                  " Campo que armazena o número da tela
        prog       type sy-repid value 'ZEXERCICIOS_GERAIS027',    " Campo que armazena o nome do programa
        pressed_tb type sy-ucomm value c_tb_0100-tab1,  " Campo que armazena o valor da tela (qual tela esta em uso)
      end of w_tb_0100.



*&---------------------------------------------------------------------*
*& Include          ZGERAISO01
*&---------------------------------------------------------------------*

* Modulo de botões e titulo
module status_0100 output.
  set pf-status 'PF-100'.   " Definindo os botões para a tela
  set titlebar 'TITLE'.     " Definindo o título para a tela

endmodule.

* Modulo de calculos do valor bruto
module calcular_total output.

  clear w_zt006-vlbru.    " Limpa a work area que rececerá o valor bruto
  " Realiza a leitura da tabela e calculo para permite que o campo valor bruto receba o dado necessário
  loop at t_zt007.
    w_zt006-vlbru = w_zt006-vlbru + ( t_zt007-quant * t_zt007-vlunt ).
  endloop.

endmodule.

* Rotina de tratamaneto para fecha os campos da tela de dados mestres após o seus preenchimento
module fecha_campos_0101 output.

  loop at screen. " Lendo a tabela de tela, na tela de tabstrip na area de subscren 0101

* Caso o campo nome da tabela tela receba W_ZT006-NUMPD e seja diferente de vazio
    if screen-name = 'W_ZT006-NUMPD' and w_zt006-numpd <> space.
      screen-input = 0. " Fechando o campo número do pedido para a entrada de dados caso omemso esteja preenchido
    endif.

    if screen-name = 'W_ZT006-BUKRS' and w_zt006-bukrs <> space.
      screen-input = 0.
    endif.

    if screen-name = 'W_ZT006-FORNE' and w_zt006-forne <> space.
      screen-input = 0.
    endif.

    if screen-name = 'W_ZT006-COMPR' and w_zt006-compr <> space.
      screen-input = 0.
    endif.

    modify screen.  " Modificando a tabela de tela

  endloop.

endmodule.

* Rotina de tratamento para fechamento dos campos da tela de valores após o seu preenchimento
module fecha_campo_0102 output.

* Lendo a tabela de tela
  loop at screen.
    if screen-name = 'W_ZT006-WAERS' and w_zt006-waers <> space.
      screen-input = 0. " Fechando o campo moeda caso o mesmo esteja preenchido
    endif.

    if screen-name = 'W_ZT006-PRAZO' and w_zt006-prazo <> space.
      screen-input = 0. " Fechando o campo prazo caso o mesmo esteja preenchido
    endif.

    modify screen. " Modificando a tabela de tela
  endloop.

endmodule.

* Módule de tratamento antes de aparecer na tela do usuário
module tb_0100 output.

  " Campo da tabstrip que recebe o valor da tela, ou seja, recebe qual tela está em uso
  tb_0100-activetab = w_tb_0100-pressed_tb.   " Campo recebendo valor da tela

* Condicional para definir qual número de tela o campo tela da work area de tabstrip receberá
  case w_tb_0100-pressed_tb.
      "break-point.
    when c_tb_0100-tab1.
      w_tb_0100-subscreen = 0101. " Adicionando o número da tela ao campo da work area
    when c_tb_0100-tab2.
      w_tb_0100-subscreen = 0102.
  endcase.

endmodule.



*&---------------------------------------------------------------------*
*& Include          ZGERAISI01
*&---------------------------------------------------------------------*

module exit_0100 input.
  leave program.      " Sair da tela 0100
endmodule.

module mark input.

* Rotina para desmarca o campo mark
  loop at t_zt007 where mark = 'X'. " Lendo a linha da tabela interna quando o campo mark estiver selecionado
    clear t_zt007-mark.             " Limpando o campo mark
    modify t_zt007 index sy-tabix transporting mark.  " Modificando o campo mark de acordo com o número que está na leitura da linha
  endloop.

* Rotina de verificação do campo que foi selecionado na table controls
  " Lendo campo da tabela interna, passado como paramentro o campo da table controls que indica qual linha esta selecinada
  read table t_zt007 index tc_0100-current_line.
  if sy-subrc is initial.
    t_zt007-mark = 'X'.        " Marcado o campo mark com x
    " Modificando o campo mark de acordo com o número da linha que foi selecionado na table controls
    modify t_zt007 index sy-tabix transporting mark.
  endif.

endmodule.

module user_command_0100 input.

* Rotina de tratamento para os botões de inserir e deletar da tela 0100
  case sy-ucomm.
    when 'INSERT'.
      call screen 0200 starting at 5 5 ending at 60 13. " Chama a tela 0200 de tamanho 5x60 e 5x13
    when 'DELETE'.
      delete t_zt007 where mark = 'X'. " Deleta o registro que está sendo selecionado no campo mark
    when 'SAVE'.
      perform salva_dados.             " Chamando o perform que salva os dados da tela auxiliar direto na tabela
  endcase.

endmodule.

* Módulo de tratamento para os botões para da tela 0200
module USER_COMMAND_0200 input.

  if sy-ucomm = 'OK'.
    t_zt007-waers = w_zt006-waers." Atribuindo o tipo de moeda contido na tela principal ao campo moeda da tela auxiliar
    append t_zt007.   " Realizando a inclusão dos dados da tela auxiliar na tabela interna t_zt007
    call screen 0100. " Retornando para a tela principal
  elseif sy-ucomm = 'CANCELAR'.
    call screen 0100. " Retorna para a tela principal
  endif.

endmodule.

module valida_bukrs input.

* Realizando uma seleção simple no campo denom da tabela zt002 e incluindo o dado na variável v_bukrs
* quando o campo bukrs da tabela zt002 for igual ao campo bukrs da work area que aparece na tela de dados mestres
  select single denom from zt002
    into v_bukrs
    where bukrs = w_zt006-bukrs.

  if sy-subrc <> 0.
    message text-001 type 'E'.
  endif.

endmodule.

module valida_forne input.

  select single denom from zt004
      into v_forne
      where forne = w_zt006-forne.

  if sy-subrc <> 0.
    message text-002 type 'E'.
  endif.

endmodule.

module valida_compr input.

  select single denom from zt003
    into v_compr
    where compr = w_zt006-compr.

  if sy-subrc <> 0.
    message text-003 type 'E'.
  endif.

endmodule.

* Módulo de tratamento após aparecer na tela do usuário
module tb_0100 input.

* Rotina de validação que definir qual area da tabstrip será utilizada, se a de dados mestres ou a de valores
  case sy-ucomm.
    when c_tb_0100-tab1.
      " Campo da work area de tabstrip recebendo o valor equivalente a area de dados mestres
      w_tb_0100-pressed_tb = c_tb_0100-tab1.
    when c_tb_0100-tab2.
      " Campo da work area de tabstrip recebendo o valor equivalente a area de valores
      w_tb_0100-pressed_tb = c_tb_0100-tab2.
  endcase.

endmodule.



*&---------------------------------------------------------------------*
*& Include          ZGERAISF01
*&---------------------------------------------------------------------*

* Rotina de tratamento para salvar os dados das tabelas internas da tela principal nas tabelas transparentes
form salva_dados .

    clear: zt006, zt007.  " Limpando qualquer sujeira de memória nas tabelas transparentes
  
  " Copiando os dados da work area na tela principal para a tabela transparente
    move-corresponding w_zt006 to zt006.
  
    modify zt006.       " Modificando a tabela transparente
  
  " Lendo os dados da tabela interna contindos na planilha da tela principal
    loop at t_zt007.
      " Incluindo no campo número do pedido da tabela interna o valor contido no campo número do pedido da tela principal
      t_zt007-numpd = w_zt006-numpd.
  
      " Copiando os dados da tabela interna na planilha da tela principal para a tabela transparente
      move-corresponding t_zt007 to zt007.
  
      modify zt007.       " Modificando a tabela transparente
    endloop.
  
    commit work.    " Confirmando as modificações no banoc de dados
  
    if sy-subrc is initial.
      message text-004 type 'I'.
      clear w_zt006.    " Limpando os campos da work area na tela principal
      refresh t_zt007.  " Limpando a tabela interna continda na planilha da tela principal
    endif.
  
  endform.



* Telas Necessárias 
  " Screen = 0100, 0101, 0102, 0200

* Trasação necessária
  " Transactions = ZTEXERCICIO_GERAL