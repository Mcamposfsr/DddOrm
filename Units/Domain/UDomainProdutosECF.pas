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

  UErros,UGenericValidator,UDocValidator, Vcl.Dialogs,UEmailValidator;

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
    FPrecoVenda: Double;
    FAliqPis: Currency;
    FAliqCofins: Currency;
  public

    Constructor Create(
    ACodigo: Integer;
    ACodigoDeBarras: String;
    ANome: String;
    AUniSigla: String;
    ASitPermiteVenda: String;
    AEstoque: Double;
    APrecoVenda: Double;
    AAliqPis: Currency;
    AAliqCofins: Currency); Overload;

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
    [Column('PRO_PRECO_VENDA',ftFloat)]
    property PrecoVenda: Double Read FPrecoVenda Write FPrecoVenda;

    //ALIQ PIS
    [Column('ALIQ_PIS',ftCurrency)]
    property AliqPis: Currency Read FAliqPis Write FAliqPis;

    //ALIQ COFINS
    [Column('ALIQ_COFINS',ftCurrency)]
    property AliqCofins: Currency Read FAliqCofins Write FAliqCofins;
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
    APrecoVenda: Double;
    AAliqPis: Currency;
    AAliqCofins: Currency);
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
  end;

end.
