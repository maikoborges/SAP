@EndUserText.label : 'Produtos - ZMBO'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztb_product_zmbo {

  key client            : abap.clnt not null;
  key product_uuid      : sysuuid_x16 not null;
  matnr                 : matnr not null;
  werks                 : werks_d;
  maktx                 : maktx;
  @Semantics.quantity.unitOfMeasure : 'ztb_product_zmbo.gewei'
  ntgew                 : ntgew;
  gewei                 : gewei;
  last_changed_by       : syuname;
  last_changed_at       : timestampl;
  local_last_changed_at : timestampl;

}