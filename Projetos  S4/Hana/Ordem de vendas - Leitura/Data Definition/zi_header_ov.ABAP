@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cabeçalho Ordem de vendas'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define root view entity ZC_CABEC_OV
provider contract transactional_query
  as projection on ZI_CABEC_OV
{
      @ObjectModel.text.element: [ 'SalesOrderType' ]
      @UI.textArrangement: #TEXT_SEPARATE
  key SalesOrder           as SalesOrder,
      SalesOrderType       as SalesOrderType,
      CreatedByUser        as CreatedByUser,
      LastChangedByUser    as LastChangedByUser,
      CreationDate         as CreationDate,
      SalesOrganization    as SalesOrganization,
      DistributionChannel  as DistributionChannel,
      OrganizationDivision as OrganizationDivision,
      SalesGroup           as SalesGroup,
      SalesOffice          as SalesOffice,
      TotalNetAmount       as TotalNetAmount,
      TransactionCurrency  as TransactionCurrency,
      Teste                as teste,
      
      /* Associations */
      /* Associação com redirecionamento para a filha */
      _SalesOrderItem : redirected to composition child ZC_ITENS_OV
}