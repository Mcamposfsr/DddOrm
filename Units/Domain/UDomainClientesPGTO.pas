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
  ormbr.types.blob,

  UErros,UTelefoneValidator,UDocValidator, Vcl.Dialogs,UEmailValidator;

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
    procedure ValidarCampos;

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
  //RECEBER VALORES
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


  //VALIDAR VALORES
   procedure TClientePGTO.ValidarCampos;
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
    if Endereco  = '' then
    begin
      LErrorCadastro.FCampos.Add('Endereço');
      LErrorCadastro.FValores.Add('Endereço Vazio');
      LEstado := False;
    end;

    //VALIDAÇÃO NUMERO
    if Numero  = '' then
    begin
      LErrorCadastro.FCampos.Add('Numero');
      LErrorCadastro.FValores.Add('Numero Vazio');
      LEstado := False;
    end;

    //VAIDAR TELEFONES
    if Telefone <> '' then
      try
        LTelefones :=  TStringList.Create;
        LTelefones.AddStrings(Telefone.Split([';']));

        for I := 0 to LTelefones.Count -1 do
        begin
          if not ValidarTelefone(LTelefones[I]) then
          begin
            LErrorCadastro.FCampos.Add('Telefone');
            LErrorCadastro.FValores.Add(LTelefones[I]);
            LEstado := False;
          end;
        end;
      finally
        LTelefones.Free;
      end;

    //VAIDAR PESSOA
    if Pessoa  = '' then
    begin
      LErrorCadastro.FCampos.Add('Pessoa');
      LErrorCadastro.FValores.Add('Pessoa Vazio');
      LEstado := False;
    end;

    //VAIDAR DOCUMENTO
    LDocumento := TDocValidator.NormalizarDocumento(Documento);
    if LDocumento = '' then
    begin
      LErrorCadastro.FCampos.Add('Documento');
      LErrorCadastro.FValores.Add('Documento Vazio');
      LEstado := False;
    end
    else if (LDocumento.Length > 14) or (LDocumento.Length < 11) then
    begin
      LErrorCadastro.FCampos.Add('Documento');
      LErrorCadastro.FValores.Add(Documento);
      LEstado := False;
    end
    else if not TDocValidator.ValidarDOC(LDocumento) then
    begin
      LErrorCadastro.FCampos.Add('Documento');
      LErrorCadastro.FValores.Add(Documento);
      LEstado := False;
    end;

    //VAIDAR ATIVO
    if Ativo  = '' then
    begin
      LErrorCadastro.FCampos.Add('Cliente ativo');
      LErrorCadastro.FValores.Add('Cliente Ativo Vazio');
      LEstado := False;
    end;

    //VAIDAR EMAIL
    if Email <> '' then
      try
        LEmails := TStringList.Create;
        LEmails.AddStrings(Email.Split([';']));
        for I := 0 to LEmails.Count -1 do
        begin
          if not ValidarEmail(LEmails[I]) then
          begin
            LErrorCadastro.FCampos.Add('Emails');
            LErrorCadastro.FValores.Add(LEmails[I]);
            LEstado := False;
          end;
        end;
      finally
        LEmails.Free;
      end;

    if not LEstado then
      raise LErrorCadastro;

   end;
end.
