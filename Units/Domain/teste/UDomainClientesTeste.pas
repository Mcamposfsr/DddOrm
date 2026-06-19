unit UDomainClientesTeste;

interface

uses
  // VALIDADOR
  UDocValidator,

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
  [Table('CLIENTES', '')]
  [PrimaryKey('ID_CLIENTE', 'Chave primária')]

  TCliente = class

  private
    FID: Integer;
    FNome: String;
    FCPF: String;
    FEstado: String;

  public
    procedure Validar;
    procedure VerificarEstado;
    constructor Create(AID: Integer; ANome, ACPF, AState: String); Overload;
    constructor Create; Overload;

  published

    [Restrictions([NotNull, NoUpdate, NoInsert])] //CONTROLE DA CHAVE PRIMÁRIA
    [Column('ID_CLIENTE', ftInteger)]
    property ID: Integer Read FID Write FID;

    [Column('NOME_CLIENTE', ftString, 50)]
    property Nome: String Read FNome Write FNome;

    [Column('CPF_CLIENTE', ftString, 18)]
    property CPF: String Read FCPF Write FCPF;

    [Column('ESTADO_CLIENTE',ftString,1)]
    property Estado: String READ FEstado Write FEstado;

  end;

implementation

  // CONSTRUCTOR;
  constructor TCliente.Create(AID: Integer; ANome, ACPF, AState: String);
  begin
    Self.FID := AID;
    Self.FNome := ANome;
    Self.CPF := ACPF;
    Self.FEstado := AState;
  end;

  constructor TCliente.Create;
  begin
    Inherited
  end;

  //VALIDAR DOMÍNIO
  procedure TCliente.Validar;
  begin

    if Self.FNome = '' then
      Raise Exception.Create('NOME NÃO PODE SER VAZIO');

    if Self.CPF = '' then
      Raise Exception.Create('CPF NÃO PODE SER VAZIO');

    if Self.Estado = '' then
      Raise Exception.Create('ESTADO NÃO PODE SER VAZIO');

    if not TDocValidator.ValidarCPF(Self.FCPF) then
      Raise Exception.Create('CPF INVÁLIDO');
  end;

  //VERIFICAR SE CLIENTE ESTÁ IRREGULAR
  procedure TCliente.VerificarEstado;
  begin
    if Self.Estado = 'I' then
      Raise Exception.Create('CLIENTE IRREGULAR!');
  end;
end.
