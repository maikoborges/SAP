@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Ordem Vendas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    
}
define view entity ZI_ITENS_OV
  as select from I_SalesOrderItem
  association to parent ZI_CABEC_OV as _SalesOrder on $projection.SalesOrder = _SalesOrder.SalesOrder
{
  key SalesOrder             as SalesOrder,
  key SalesOrderItem         as SalesOrderItem,
      SalesOrderItemCategory as SalesOrderItemCategory,
      SalesOrderItemType     as SalesOrderItemType,
      IsReturnsItem          as IsReturnsItem, 
      CreatedByUser          as CreatedByUser,
      CreationDate           as CreationDate,
      CreationTime           as CreationTime,
      LastChangeDate         as LastChangeDate,
      Division               as Division,
      Material               as Material,
      Batch                  as Batch,
      Plant                  as Plant,
      StorageLocation        as StorageLocation,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      OrderQuantity          as OrderQuantity,
      OrderQuantityUnit      as OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      ItemGrossWeight        as ItemGrossWeight,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      ItemNetWeight          as ItemNetWeight,
      ItemWeightUnit         as ItemWeightUnit,
      @Semantics.quantity.unitOfMeasure: 'ItemVolumeUnit'
      ItemVolume             as ItemVolume,
      ItemVolumeUnit         as ItemVolumeUnit,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      NetAmount              as NetAmount,
      TransactionCurrency    as TransactionCurrency,

      _SalesOrder

      
}
