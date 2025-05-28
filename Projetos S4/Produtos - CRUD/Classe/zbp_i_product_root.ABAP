CLASS lhc_Products DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Products RESULT result.

    METHODS setProduct FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Products~setProduct.

    METHODS checkNetWeight FOR VALIDATE ON SAVE
      IMPORTING keys FOR Products~checkNetWeight.

ENDCLASS.

CLASS lhc_Products IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD setProduct.

    " Ler os registros do campo de produto e retorna uma lista
    READ ENTITIES OF zi_product_root IN LOCAL MODE      " Ler os dados da CDS de interface de formal local
      ENTITY Products                                   " Determinado a entidade dessa cds a ser linda
      FIELDS ( Product )                                " Determinando o campo específico a ser lido
      WITH CORRESPONDING #( keys )                      " Associa as chaves dos campos
      RESULT DATA(lt_products).                         " Retorna uma tabela interna com valores no campo Product


    " Se vazio retornar
    IF lt_products IS INITIAL.
      RETURN.
    ENDIF.


    " Seleciona o maior valor contido no campo MATNR(Product) da tabela base de CDS interface e criar uma variável
    SELECT MAX( matnr )
    FROM ztb_product_zmbo
    INTO @DATA(lv_max_matnr).


    " Ler a tabela interna de regitro do campo Product e associar a um ponteiro de memória
    LOOP AT lt_products ASSIGNING FIELD-SYMBOL(<fs_products>).
      lv_max_matnr += 1.                        " Adicionar +1 a variável
      <fs_products>-Product = lv_max_matnr.     " Adicionar o novo valor direto no campo da tabela interna via ponteiro
      CONDENSE <fs_products>-Product NO-GAPS.   " Eliminar espaços vazios
    ENDLOOP.


    " Modificar a base de dados da entidade cds interface em modo local
    MODIFY ENTITIES OF zi_product_root IN LOCAL MODE
        ENTITY Products                                         " Determinando a entidade dessa cds a ser modificada
        UPDATE                                                  " Atualizando
        FIELDS ( Product )                                      " O campo específico
        WITH VALUE #( FOR ls_product IN lt_products
                          ( %tky = ls_product-%tky
                            Product = ls_product-Product ) ).
  ENDMETHOD.


  METHOD checkNetWeight.

    " Lendo os regitros contidos no campo de peso da entidade e criando uma tabela interna
    READ ENTITIES OF zi_product_root IN LOCAL MODE
     ENTITY Products
     FIELDS ( NetWeight )
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_products).

    " Retornando caso a tabela estaja vazia
    IF lt_products IS INITIAL.
      RETURN.
    ENDIF.

    " Lendo a tabela interna e retornando ao usuário a permissão ou não de salvar
    LOOP AT lt_products INTO DATA(ls_product).
      IF ls_product-NetWeight < 1.

        " Indicar que a instância da entidade(linha) é inválida por meio da failed(estrutura padrão para rejeição de intâncai de entidades)
        APPEND VALUE #( %tky = ls_product-%tky ) TO failed-products.

        " Informa ao usuário uma mensagem de erro com tipo severo por meio do reported(estrutura padrão para retorno de mensagens)
        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = |Peso menor do que 1 invalido| ) )
                TO reported-products.

        if ls_product-Product < 0.
        ENDIF.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.