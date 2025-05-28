@Metadata.layer: #CORE

@UI.headerInfo: { 
                  typeNamePlural: 'SalesOrders'}
 
@UI.presentationVariant: [{ sortOrder: [{by: 'TotalNetAmount', direction: #DESC }] }]

annotate entity ZC_CABEC_OV
    with 
    
{

  @UI.facet: [{ id: 'SalesOrder',
              label: 'Ordem de venda',
              position: 10,
              type: #IDENTIFICATION_REFERENCE },
              
            { id: '_SalesOrdem_Item',
              label: 'Itens da ordem',
              position: 10,
              type: #LINEITEM_REFERENCE,
              targetElement: '_SalesOrderItem' }] 

   //@Consumption.filter.mandatory: true
  @UI.lineItem: [{ position : 10 }]
  @UI.selectionField: [{ position : 10 }]
  //@EndUserText.label: 'Teste'
  @Consumption.valueHelpDefinition: [{ entity.name: 'I_MM_SalesOrderItemVH', entity.element: 'SalesOrder' }]
  @UI.identification: [{ position: 10 }]
  SalesOrder;
  @UI.lineItem: [{ position : 20 }]
  @UI.selectionField: [{ position : 20 }]
  @Consumption.valueHelpDefinition: [{ entity.name: 'I_SalesOrderType', entity.element: 'SalesOrderType' }]
  @UI.identification: [{ position: 20 }]
  SalesOrderType;
  @UI.lineItem: [{ position : 30 }]
  @UI.identification: [{ position: 30 }]
  CreatedByUser;
  @UI.lineItem: [{ position : 40 }]
  @UI.identification: [{ position: 40 }]
  LastChangedByUser;
  @UI.lineItem: [{ position : 50 }]
  @UI.selectionField: [{ position : 50 }]
  @Consumption.filter: { selectionType: #INTERVAL}
  @UI.identification: [{ position: 50 }]
  CreationDate;
  @UI.lineItem: [{ position : 60 }]
  @UI.identification: [{ position: 60 }]
  SalesOrganization;
  @UI.lineItem: [{ position : 70 }]
  @UI.identification: [{ position: 70 }]
  DistributionChannel;
  @UI.lineItem: [{ position : 80 }]
  @UI.identification: [{ position: 80 }]
  OrganizationDivision;
  @UI.lineItem: [{ position : 90 }]
  @UI.identification: [{ position: 90 }] 
  SalesGroup;
  @UI.lineItem: [{ position : 100 }]
  @UI.identification: [{ position: 100 }]
  SalesOffice;
  @UI.lineItem: [{ position : 110 }, { criticality: 'teste' }]
  //@UI.hidden: true
  @UI.identification: [{ position: 110 }]
  TotalNetAmount;
  @UI.lineItem: [{ position : 120 }]
  @UI.identification: [{ position: 120 }]
  TransactionCurrency;
 
}