managed implementation in class zbp_i_product_root unique;
strict ( 2 );

define behavior for ZI_PRODUCT_ROOT alias Products
persistent table ztb_product_zmbo     /* Tabela para trablho no beravior 
lock master                           /* Objeto de bloqueio
authorization master ( instance )     /* Objeto de autorização 
etag master LocalLastChangedAt        /* Bloqueio de modificação antes da atualização da versão da tabela 
{
  create;
  update;
  delete;

  /* Classe de determinação de valores do campo com modificação na criação */
  determination setProduct on modify { create; }  
  
  /* Classe de validação de valores do campo durante a salvação para criação e atualicação */
  validation checkNetWeight on save { field NetWeight; create; update; }

  field ( numbering : managed, readonly ) ProductUuid;      /* Geração de valores ao campo pelo sistema */
  field ( readonly ) Product;                               /* Campo apenas Leitura */
  field ( mandatory ) ProductDescription, Plant;            /* Campos obrigatório */

  /* Atrela um campo da CDS de interface a um campo da tabela do behavior */
  mapping for ztb_product_zmbo
    {
      ProductUuid        = product_uuid;
      Product            = matnr;
      Plant              = werks;
      ProductDescription = maktx;
      NetWeight          = ntgew;
      WeightUnit         = gewei;
      LastChangedBy      = last_changed_by;
      LastChangedAt      = last_changed_at;
      LocalLastChangedAt = local_last_changed_at;

    }
}