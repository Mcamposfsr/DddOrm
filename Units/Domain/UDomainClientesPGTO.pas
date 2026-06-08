unit UDomainClientesPGTO;

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
  [Table('CLIENTES_PGTO','')]
  [PrimaryKey('CLI_CODIGO','Chave Primária')]
  TClientePGTO = class

  private
    FCodigo: Integer;
    FNome: String;
    FEndereco: String;
    FNumero: String;
    FTelefone: String;
    FPessoa: String;
    FDocumento: String;
    FLimiteCredito: Currency;
    FAtivo: String;
    FEmail:String;

  public
    Constructor Create(
    ACodigo:Integer;
    ANome,
    AEndereco,
    ANumero,
    ATelefone,
    APessoa,
    ADocumento,
    AAtivo,
    AEmail:String;
    ALimiteCredito:Currency); Overload;

  published
    [Restrictions([NotNull,NoUpdate,NoInsert])] //CONTROLE DA CHAVE PRIMÁRIA
    [Column('CLI_CODIGO', ftInteger)]
    property Codigo: Integer Read FCodigo Write FCodigo;

//    [Restrictions([NoUpdate])]
    [Restrictions([NotNull])]
    [Column('CLI_NOME',ftString,60)]
    property Nome: String Read FNome Write FNome;

    [Restrictions([NotNull])]
    [Column('CLI_ENDERECO',ftString,60)]
    property Endereco: String Read FEndereco Write FEndereco;

    [Restrictions([NotNull])]
    [Column('CLI_NUM',ftString,10)]
    property Numero: String Read FNumero Write FNumero;

    [Column('CLI_FONE',ftString,80)]
    property Telefone: String Read FTelefone Write FTelefone;

    [Restrictions([NotNull])]
    [Column('CLI_PESSOA',ftString,1)]
    property Pessoa: String Read FPessoa Write FPessoa;

    [Restrictions([NotNull])]
    [Column('CLI_DOCUMENTO',ftString,18)]
    property Documento: String Read FDocumento Write FDocumento;

    [Column('CLI_LIMITE_CREDITO',ftCurrency)]
    property LimiteCredito: Currency Read FLimiteCredito Write FLimiteCredito;

    [Restrictions([NotNull])]
    [Column('CLI_ATIVO',ftString,1)]
    property Ativo: String Read FAtivo Write FAtivo;

    [Column('CLI_EMAIL',ftString,80)]
    property Email: String Read FEmail Write FEmail;

  end;

implementation
  //CREATE
  Constructor TClientePGTO.Create(
    ACodigo:Integer;
    ANome,
    AEndereco,
    ANumero,
    ATelefone,
    APessoa,
    ADocumento,
    AAtivo,
    AEmail:String;
    ALimiteCredito:Currency);
  begin
    Self.FCodigo := ACodigo;
    Self.FNome := ANome;
    Self.FEndereco := AEndereco;
    Self.FNumero := ANumero;
    Self.FTelefone := ATelefone;
    Self.FPessoa := APessoa;
    Self.FDocumento := ADocumento;
    Self.FLimiteCredito := ALimiteCredito;
    Self.FAtivo := AAtivo;
    Self.FEmail := AEmail;
  end;

end.
