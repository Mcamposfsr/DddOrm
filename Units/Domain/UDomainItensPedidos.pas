unit UDomainItensPedidos;

interface

uses
  Classes,
  DB,
  SysUtils,
  Generics.Collections,

  /// ORM
  dbcbr.mapping.attributes,
  ormbr.types.nullable,
  dbcbr.types.mapping,
  dbcbr.mapping.register,
  ormbr.types.blob,

  UErros,UGenericValidator,UDocValidator,Vcl.Dialogs;

  type

  [Entity]
  [Table('ITENS_PEDIDO','')]
  [PrimaryKey('ID_ITEM','Chave Primária')]
  TItensPedidos = class

  private
    FID: Integer;
    FIDPedido: Integer;
    FIDProduto: Integer;
    FNomeProduto: String;
    FQuantidade: Double;
    FPrecoUnit: Currency;
    FDescontoPercent: Double;
    FDescontoValor: Currency;
    FTotal: Currency;
  public

    Constructor Create(
      AID: Integer;
      AIDPedido: Integer;
      AIDProduto: Integer;
      AQuantidade: Double;
      APrecoUnit: Currency;
      ADescontoPercent: Double;
      ADescontoValor: Currency;
      ATotal: Currency
      ); Overload;

  published
    //PK
    [Restrictions([NotNull,NoUpdate,NoInsert,Hidden])] //CONTROLE DA CHAVE PRIMÁRIA
    [Column('ID_ITEM', ftInteger)]
    property ID: Integer Read FID Write FID;

    //FK - ID_PEDIDO
    [Restrictions([Hidden])]
    [Column('ID_PEDIDO',ftInteger)]
    property IDPedido: Integer Read FIDPedido Write FIDPedido;

    //FK - ID_PEDIDO
    [Restrictions([Hidden])]
    [Column('ID_PRODUTO',ftInteger)]
    property IDProduto: Integer Read FIDProduto Write FIDProduto;

    //NOME PRODUTO - JOIN
    [Restrictions([noInsert,NoUpdate])]
    [Column('PRO_NOME',ftString,50)]
    [Dictionary('NOME PRODUTO','','','','')]
    [JoinColumn('ID_PRODUTO','PRODUTOS_ECF','PRO_CODIGO','PRO_NOME')]
    property NomeProduto: String Read FNomeProduto Write FNomeProduto;

    //QUANTIDADE
    [Column('QUANTIDADE',ftFloat)]
    property Quantidade: Double Read FQuantidade Write FQuantidade;

    //PRECO UNIDADE
    [Column('PRECO_UNIT',ftCurrency)]
    property PrecoUnit: Currency Read FPrecoUnit Write FPrecoUnit;

    //PERCENTUAL DE DESCONTO
    [Column('DESCONTO_PERCENT',ftFloat)]
    property DescontoPercent: Double Read FDescontoPercent Write FDescontoPercent;

    //VALOR DE DESCONTO
    [Column('DESCONTO_VALOR',ftCurrency)]
    property DescontoValor: Currency Read FDescontoValor Write FDescontoValor;

    //VALOR TOTAL
    [Column('TOTAL',ftCurrency)]
    property ATotal: Currency Read FTotal Write FTotal;
  end;

implementation
  //RECEBER VALORES
  Constructor TItensPedidos.Create(
      AID: Integer;
      AIDPedido: Integer;
      AIDProduto: Integer;
      AQuantidade: Double;
      APrecoUnit: Currency;
      ADescontoPercent: Double;
      ADescontoValor: Currency;
      ATotal: Currency
      );
  begin
    FID := AID;
    FIDPedido := AIDPedido;
    FIDProduto := AIDProduto;
    FQuantidade := AQuantidade;
    FPrecoUnit := APrecoUnit;
    FDescontoPercent := ADescontoPercent;
    FDescontoValor := ADescontoValor;
    FTotal := ATotal;
  end;

  // ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES


end.
