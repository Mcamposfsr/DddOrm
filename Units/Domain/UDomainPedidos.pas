unit UDomainPedidos;

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

  UDomainClientesPGTO,

  UErros,UGenericValidator,UDocValidator,Vcl.Dialogs;

  type

  [Entity]
  [Table('PEDIDOS','')]
  [PrimaryKey('ID_PEDIDO',NotInc,NoSort,False,'Chave Primária')]
  TPedidos = class

  private
    FID: Integer;
    FIDCliente: Integer;
    FDataEmissao: TDate;
    FTotalLiquido: Currency;
    FCodPedido: String;

    //JOIN MANUAL
    FCLiente: TClientePGTO;
  public



  Constructor Create(
    AID:Integer;
    AIDCliente: Integer;
    ADataEmissao: TDate;
    ATotalLiquido: Currency;
    ACodPedido: String
    ); Overload;

    Destructor Destroy;

  published

    //CÓDIGO PEDIDO
    [Restrictions([NotNull])]
    [Column('NUMERO_PEDIDO',ftString,13)]
    [Dictionary('NUMERO PEDIDO','','','','')]
    property CodPedido: String Read  FCodPedido Write FCodPedido;

     //JOINS
     property Cliente: TClientePGTO Read FCliente Write FCliente;

    //PK
    [Restrictions([NotNull,NoInsert,NoUpdate,HIDDEN])] //CONTROLE DA CHAVE PRIMÁRIA
    [Column('ID_PEDIDO', ftInteger)]
    [Dictionary('CODIGO PEDIDO','','','','')]
    property ID: Integer Read FID Write FID;

    //FK - ID_CLIENT
    [Restrictions([Hidden])]
    [Column('ID_CLIENTE',ftInteger)]
    property IDCliente: Integer Read FIDCliente Write FIDCliente;

    //DATA DE EMISSAO
    [Column('DATA_EMISSAO',ftDate,3)]
    [Dictionary('DATA DE EMISSÃO','','','','')]
    property DataEmissao: TDate Read FDataEmissao Write FDataEmissao;

    //TOTAL LIQUIDO
    [Column('TOTAL_LIQUIDO',ftCurrency)]
    [Dictionary('VALOR LÍQUIDO','','','','')]
    property TotalLiquido: Currency Read FTotalLiquido Write FTotalLiquido;

  end;

implementation
  //RECEBER VALORES
  Constructor TPedidos.Create(
      AID:Integer;
      AIDCliente: Integer;
      ADataEmissao: TDate;
      ATotalLiquido: Currency;
      ACodPedido: String
       );
  begin
    FID := AID;
    FIDCliente := AIDCliente;
    FDataEmissao := ADataEmissao;
    FTotalLiquido := ATotalLiquido;
    FCodPedido := ACodPedido;
  end;

  //LIBERAR CLIENTE JOIN MANUAL
  destructor TPedidos.Destroy;
  begin
    if assigned(Self.FCliente) then
      Self.FCliente.Free;
    inherited
  end;

  // ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES

//  procedure TProdutosECF.Validar;
//  begin
//  end;

end.
