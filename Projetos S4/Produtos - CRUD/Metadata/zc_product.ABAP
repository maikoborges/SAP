@Metadata.layer: #CORE

@UI.headerInfo: { typeNamePlural: 'Produto'}
                  
annotate entity ZC_PRODUCT_ZMBO with
{
  @UI.facet: [{ id: 'Product',
               // purpose: #STANDARD,
                type: #IDENTIFICATION_REFERENCE,
                label: 'Produto',
                position: 10 }]

  @UI.hidden: true
  ProductUuid;

  @UI.lineItem: [{ position: 10  }]
  @UI.selectionField: [{ position : 10 }]
  @UI.identification: [{ position: 10 }]
 // @EndUserText.label: 'Produto'
  Product;

  @UI.lineItem: [{ position: 20  }]
  @UI.selectionField: [{ position : 20 }]
  @UI.identification: [{ position: 20 }]
  Plant;

  @UI.lineItem: [{ position: 30  }]
  @UI.identification: [{ position: 30 }]
  @EndUserText.label: 'Descrição do Produto'
  ProductDescription;

  @UI.lineItem: [{ position: 40  }]
  @UI.identification: [{ position: 40 }]
  NetWeight;

  @UI.lineItem: [{ position: 50  }]
  @UI.identification: [{ position: 50 }]
  WeightUnit;

  @UI.hidden: true
  LastChangedBy;

  @UI.hidden: true
  LastChangedAt;

  @UI.hidden: true
  LocalLastChangedAt;

}