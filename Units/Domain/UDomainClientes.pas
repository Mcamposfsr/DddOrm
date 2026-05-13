unit UDomainClientes;

interface

uses
  // VALIDADOR
  UCPFValidator,

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

  TComp = class

  private
    FID: Integer;
    FNome: String;
    FCPF: String;

  public
    Function ValidarCpf: Boolean;
    constructor Create(AID: Integer; ANome, ACPF: String); Overload;
    constructor Create; Overload;

  published

    [Restrictions([NotNull, NoUpdate, NoInsert])] //CONTROLE DA CHAVE PRIMÁRIA
    [Column('ID_CLIENTE', ftInteger)]
    property ID: Integer Read FID Write FID;

    [Column('NOME_CLIENTE', ftString, 50)]
    property Nome: String Read FNome Write FNome;

    [Column('CPF_CLIENTE', ftString, 18)]
    property CPF: String Read FCPF Write FCPF;

  end;

implementation

// CONSTRUCTOR;
constructor TComp.Create(AID: Integer; ANome, ACPF: String);
begin
  Self.FID := AID;
  Self.FNome := ANome;
  Self.CPF := ACPF;
end;

constructor TComp.Create;
begin
  Inherited
end;

Function TComp.ValidarCpf: Boolean;
begin
  Result := TCPFValidator.Validate(Self.FCPF);
end;

end.
