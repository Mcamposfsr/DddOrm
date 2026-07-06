unit UDomainProdutosECF;

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

  UErros,UGenericValidator,UDocValidator, Vcl.Dialogs,UEmailValidator,System.RegularExpressions;

  type

  [Entity]
  [Table('PRODUTOS_ECF','')]
  [PrimaryKey('PRO_CODIGO','Chave Primária')]
  TProdutosECF = class

  private
    FCodigo: Integer;
    FCodigoDeBarras: String;
    FNome: String;
    FUniSigla: String;
    FSitPermiteVenda: String;
    FEstoque: Double;
    FPrecoVenda: Currency;
    FAliqPis: Double;
    FAliqCofins: Double;
    FDescontoMax: Double;

    procedure ValidarCodBarras(AError:EErrorFormInput;var AEstado: Boolean);
  public

    procedure Validar;

    Constructor Create(
    ACodigo: Integer;
    ACodigoDeBarras: String;
    ANome: String;
    AUniSigla: String;
    ASitPermiteVenda: String;
    AEstoque: Double;
    APrecoVenda: Currency;
    AAliqPis: Double;
    AAliqCofins: Double;
    ADescontoMax: Double); Overload;

  published
    //PK
    [Restrictions([NotNull,NoUpdate,NoInsert])] //CONTROLE DA CHAVE PRIMÁRIA
    [Column('PRO_CODIGO', ftInteger)]
    property Codigo: Integer Read FCodigo Write FCodigo;

    //CODIGO DE BARRAS
    [Column('PRO_CODIGO_BARRAS',ftString,14)]
    property CodigoDeBarras: String Read FCodigoDeBarras Write FCodigoDeBarras;

    //NOME
    [Column('PRO_NOME',ftString,50)]
    property Nome: String Read FNome Write FNome;

    //SIGLA DE UNIDADE
    [Column('UNI_SIGLA',ftString,3)]
    property UniSigla: String Read FUniSigla Write FUniSigla;

    //SIT PERMITE VENDA
    [Column('SIT_PERMITE_VENDA',ftString,1)]
    property SitPermiteVenda: String Read FSitPermiteVenda Write FSitPermiteVenda;

    //QUANTIDADE ESTOQUE
    [Column('PRO_ESTOQUE',ftFloat)]
    property Estoque: Double Read FEstoque Write FEstoque;

    //PRECO DE VENDA
    [Column('PRO_PRECO_VENDA',ftCurrency)]
    property PrecoVenda: Currency Read FPrecoVenda Write FPrecoVenda;

    //ALIQ PIS
    [Column('ALIQ_PIS',ftFloat)]
    property AliqPis: Double Read FAliqPis Write FAliqPis;

    //ALIQ COFINS
    [Column('ALIQ_COFINS',ftFloat)]
    property AliqCofins: Double Read FAliqCofins Write FAliqCofins;

    //DESCONTO MÁXIMO
    [Column('DESCONTO_MAX',ftFloat)]
    property DescontoMax: Double Read FDescontoMax Write FDescontoMax;

  end;

implementation
  //RECEBER VALORES
  Constructor TProdutosECF.Create(
    ACodigo: Integer;
    ACodigoDeBarras: String;
    ANome: String;
    AUniSigla: String;
    ASitPermiteVenda: String;
    AEstoque: Double;
    APrecoVenda: Currency;
    AAliqPis: Double;
    AAliqCofins: Double;
    ADescontoMax: Double);
  begin
    FCodigo := ACodigo;
    FCodigoDeBarras := ACodigoDeBarras;
    FNome := ANome;
    FUniSigla := AUniSigla;
    FSitPermiteVenda := ASitPermiteVenda;
    FEstoque := AEstoque;
    FPrecoVenda := APrecoVenda;
    FAliqPis := AAliqPis;
    FAliqCofins := AAliqCofins;
    FDescontoMax := ADescontoMax;
  end;

  // ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES

  //VALIDAÇÃO CÓDIGO DE BARRAS
  procedure TProdutosECF.ValidarCodBarras(AError:EErrorFormInput;var AEstado: Boolean);
  begin
    //VAZIO
    if FCodigoDeBarras  = '' then
    begin
      AError.FCampos.Add('Codigo de Barras');
      AError.FValores.Add('Codigo de Barras Vazio');
      AEstado := False;
    end
    //TAMANHO CORRETO
    else if not (FCodigoDeBarras.Length in [8,12,13,14]) then
    begin
      AError.FCampos.Add('Codigo de Barras');
      AError.FValores.Add(FCodigoDeBarras);
      AEstado := False;
    end
    //APENAS DÍGITOS
    else if not TRegEx.IsMatch(FCodigoDeBarras,'^\d+$') then
    begin
      AError.FCampos.Add('Codigo de Barras');
      AError.FValores.Add(FCodigoDeBarras);
      AEstado := False;
    end;
  end;

  procedure TProdutosECF.Validar;
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

    Self.ValidarCodBarras(LErrorCadastro,LEstado);
    //VALIDAÇÃO NOME
    if FNome  = '' then
    begin
      LErrorCadastro.FCampos.Add('Nome');
      LErrorCadastro.FValores.Add('Nome Vazio');
      LEstado := False;
    end;

    //VALIDAÇÃO SIGLA DE UNIDADE
    if FUniSigla  = '' then
    begin
      LErrorCadastro.FCampos.Add('Sigla de Unidade');
      LErrorCadastro.FValores.Add('Sigla de Unidade Vazio');
      LEstado := False;
    end;

    //VALIDAÇÃO SIT PERMITE VENDA
    if FSitPermiteVenda  = '' then
    begin
      LErrorCadastro.FCampos.Add('Venda permitida');
      LErrorCadastro.FValores.Add('Venda permitida Vazio');
      LEstado := False;
    end;

    if not LEstado then
      raise LErrorCadastro;

   end;

end.
