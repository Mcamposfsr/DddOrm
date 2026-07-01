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

  UErros,UGenericValidator,UDocValidator,Vcl.Dialogs;

  type

  [Entity]
  [Table('PEDIDOS','')]
  [PrimaryKey('ID_PEDIDO',AutoInc,NoSort,False,'Chave Primária')]
  TPedidos = class

  private
    FID: Integer;
    FIDCliente: Integer;
    FDataEmissao: TDate;
    FTotalLiquido: Currency;
    //JOIN
    FNomeCliente: String;
    FCPFCliente: String;


  public

//    procedure Validar;

    Constructor Create(
      AID:Integer;
      AIDCliente: Integer;
      ADataEmissao: TDate;
      ATotalLiquido: Currency
      ); Overload;

  published
    //PK
    [Restrictions([NotNull])] //CONTROLE DA CHAVE PRIMÁRIA
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

    //JOINS:
    [Restrictions([NoInsert,NoUpdate])]
    [Column('CLI_NOME',ftString,50)]
    [Dictionary('NOME CLIENTE','','','','')]
    [JoinColumn('ID_CLIENTE','CLIENTES_PGTO','CLI_CODIGO','CLI_NOME')]
    property NomeCliente: String Read FNomeCliente Write FNomeCliente;

    [Restrictions([NoInsert,NoUpdate])]
    [Column('CLI_DOCUMENTO',ftString,18)]
    [Dictionary('DOCUMENTO CLIENTE','','','','')]
    [JoinCOlumn('ID_CLIENTE','CLIENTES_PGTO','CLI_CODIGO','CLI_DOCUMENTO')]
    property CpfCliente: String Read FCPFCliente Write FCPFCliente;

  end;

implementation
  //RECEBER VALORES
  Constructor TPedidos.Create(
      AID:Integer;
      AIDCliente: Integer;
      ADataEmissao: TDate;
      ATotalLiquido: Currency);
  begin
    FID := AID;
    FIDCliente := AIDCliente;
    FDataEmissao := ADataEmissao;
    FTotalLiquido := ATotalLiquido;
  end;

  // ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES

//  procedure TProdutosECF.Validar;
//  begin
//  end;

end.
