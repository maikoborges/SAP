@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Produto - ZMBO'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define root view entity ZC_PRODUCT_ZMBO
  provider contract transactional_query
  as projection on ZI_PRODUCT_ROOT
{
  key ProductUuid        as ProductUuid,
      Product            as Product,
      Plant              as Plant,
      ProductDescription as ProductDescription,
      NetWeight          as NetWeight,
      WeightUnit         as WeightUnit,
      LastChangedBy      as LastChangedBy,
      LastChangedAt      as LastChangedAt,
      LocalLastChangedAt as LocalLastChangedAt
      
}
