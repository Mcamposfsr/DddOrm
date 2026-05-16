unit UDomainOS;

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
  ormbr.types.blob;


  type

  [Entity]
  [Table('ORDEM_SERVICO','')]
  [PrimaryKey('ID_OS','Chave Primária')]
  TOrdemServico = class

  private
    FID: Integer;
    FIDCliente:Integer;
    FDataOS: TDate;
    FValorOS: Currency;
    FEstadoOS: String;

  public
    procedure Validar;
    Constructor Create(AID,AIDCliente:Integer;ADataOS:TDate;AValorOS:Currency;AEstado:String); Overload;


  published
    [Restrictions([NotNull,NoUpdate,NoInsert])] //CONTROLE DA CHAVE PRIMÁRIA
    [Column('ID_OS', ftInteger)]
    property ID: Integer Read FID Write FID;

//    [Restrictions([NoUpdate])]
    [Column('ID_CLIENTE',ftInteger)]
    property IDCliente: Integer Read FIDCliente Write FIDCliente;

    [Column('DATA_OS',ftDate)]
    property DataOS: TDate Read FDataOS Write FDAtaOs;
    [Column('VALOR_OS',ftCurrency)]
    property ValorOS: Currency Read FValorOS Write FValorOS;
    [Column('ESTADO_OS',ftString,1)]
    property EstadoOS: String Read FEstadoOS Write FEstadoOs;

  end;

implementation
  //CREATE
  Constructor TOrdemServico.Create(
  AID,
  AIDCliente:Integer;
  ADataOS:TDate;
  AValorOS:Currency;
  AEstado:String);
  begin
    Self.FID := AID;
    Self.FIDCliente := AIDCliente;
    Self.FDataOS := ADataOS;
    Self.FValorOS := AValorOS;
    Self.FEstadoOS := AEstado;
  end;

  procedure TOrdemServico.Validar;
  begin

    if Self.FDataOS < IncMonth(now, -3) then
      Raise Exception.Create('DATA INVÁLIDA - LIMITE DE ATÉ 3 MESES ATRÁS');

    if Self.FValorOS = 0 then
      Raise Exception.Create('VALOR INVÁLIDO');

    if Self.FEstadoOS = '' then
      Raise Exception.Create('ESTADO NÃO PODE SER VAZIO');

  end;

end.
