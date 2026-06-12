unit UDomainFormasPGTO;

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

  Vcl.Dialogs,

  UErros;


  type

  [Entity]
  [Table('FORMAS_PAGAMENTO','')]
  [PrimaryKey('FIN_CODIGO','Chave Primária')]
  TFormasPGTO = class

  private
    FCodigo: Integer;
    FNome: String;
    FParcelas: Integer;
    FJuros: Currency;

  public
     procedure ValidarCampos;

    Constructor Create(ACodigo:Integer;ANome:String;AParcelas:Integer;AJuros:Currency); Overload;

  published
    [Restrictions([NotNull,NoUpdate,NoInsert])] //CONTROLE DA CHAVE PRIMÁRIA
    [Column('FIN_CODIGO', ftInteger)]
    property Codigo: Integer Read FCodigo Write FCodigo;

    [Restrictions([NotNull])]
    [Column('FIN_NOME',ftString,30)]
    property Nome: String Read FNome Write FNome;

    [Restrictions([NotNull])]
    [Column('FIN_PARCELAS',ftInteger)]
    property Parcelas: Integer Read FParcelas Write FParcelas;

    [Restrictions([NotNull])]
    [Column('FIN_JUROS',ftFloat)]
    property Juros: Currency Read FJuros Write FJuros;

  end;

implementation
  //CREATE
  Constructor TFormasPGTO.Create(
  ACodigo:Integer;
  ANome:String;
  AParcelas:Integer;
  AJuros:Currency);
  begin
    Self.FCodigo := ACodigo;
    Self.FNome := ANome;
    Self.FParcelas := AParcelas;
    Self.FJuros := AJuros;
  end;

  //VALIDAR VALORES
   procedure TFormasPGTO.ValidarCampos;
   var
   I: Integer;
   LTelefones: TStringList;
   LEmails: TStringList;
   LDocumento: String;
   LErrorCadastro: EErrorFormInput;
   LEstado: Boolean;

   begin
    LErrorCadastro := EErrorFormInput.Create;
    LEstado := True;

    //VALIDAÇÃO NOME
    if NOME  = '' then
      begin
        LErrorCadastro.FCampos.Add('Nome');
        LErrorCadastro.FValores.Add('Nome Vazio');
        LEstado := False;
      end;

    //VALIDAÇÃO ENDEREÇO
    if Parcelas  <= 0 then
    begin
      LErrorCadastro.FCampos.Add('Parcelas');
      LErrorCadastro.FValores.Add('Quantidade mínima de parcelas é 1');
      LEstado := False;
    end;

    if not LEstado then
      raise LErrorCadastro;

   end;

end.
