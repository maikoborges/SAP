@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Produto - ZMBO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PRODUCT_ROOT
  as select from ztb_product_zmbo
{
  key product_uuid          as ProductUuid,
      matnr                 as Product,
      werks                 as Plant,
      maktx                 as ProductDescription,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      ntgew                 as NetWeight,
      gewei                 as WeightUnit,
      @Semantics.user.localInstanceLastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
