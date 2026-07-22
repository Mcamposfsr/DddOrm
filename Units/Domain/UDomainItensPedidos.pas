unit UDomainItensPedidos;

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

  UDomainProdutosECF,

  UErros,UGenericValidator,UDocValidator,Vcl.Dialogs;

  type
    TStatusItem = (siDefault,siCreated,siAltered,siDeleted);

  type

  [Entity]
  [Table('ITENS_PEDIDO','')]
  [PrimaryKey('ID_ITEM','Chave Primária')]
  TItensPedidos = class

  private
    FID: Integer;
    FIDPedido: Integer;
    FIDProduto: Integer;
    FQuantidade: Double;
    FPrecoUnit: Currency;
    FDescontoPercent: Double;
    FDescontoValor: Currency;
    FTotal: Currency;
    FProduto: TProdutosECF;

    //CONTROLE DO ITEM
    FState: TstatusItem;
  public

    procedure Validar;
    procedure DescontarEstoque;
    procedure DevolverEstoque;

    Constructor Create(
      AID: Integer;
      AIDPedido: Integer;
      AIDProduto: Integer;
      AQuantidade: Double;
      APrecoUnit: Currency;
      ADescontoPercent: Double;
      ADescontoValor: Currency;
      ATotal: Currency;
      AState: TStatusItem = siDefault;
      AProduto: TProdutosECF = nil
      ); Overload;

  published
    //PK
    [Restrictions([NotNull,NoUpdate,NoInsert,Hidden])] //CONTROLE DA CHAVE PRIMÁRIA
    [Column('ID_ITEM', ftInteger)]
    property ID: Integer Read FID Write FID;

    //FK - ID_PEDIDO
    [Restrictions([Hidden])]
    [Column('ID_PEDIDO',ftInteger)]
    property IDPedido: Integer Read FIDPedido Write FIDPedido;

    //FK - ID_PEDIDO
    [Restrictions([Hidden])]
    [Column('ID_PRODUTO',ftInteger)]
    property IDProduto: Integer Read FIDProduto Write FIDProduto;

    property Produto: TProdutosECF Read FProduto Write FProduto;

    //QUANTIDADE
    [Column('QUANTIDADE',ftFloat)]
    property Quantidade: Double Read FQuantidade Write FQuantidade;

    //PRECO UNIDADE
    [Column('PRECO_UNIT',ftCurrency)]
    property PrecoUnit: Currency Read FPrecoUnit Write FPrecoUnit;

    //PERCENTUAL DE DESCONTO
    [Column('DESCONTO_PERCENT',ftFloat)]
    property DescontoPercent: Double Read FDescontoPercent Write FDescontoPercent;

    //VALOR DE DESCONTO
    [Column('DESCONTO_VALOR',ftCurrency)]
    property DescontoValor: Currency Read FDescontoValor Write FDescontoValor;

    //VALOR TOTAL
    [Column('TOTAL',ftCurrency)]
    property Total: Currency Read FTotal Write FTotal;

    property State: TStatusItem Read FState Write FState;
  end;

implementation
  //RECEBER VALORES
  Constructor TItensPedidos.Create(
      AID: Integer;
      AIDPedido: Integer;
      AIDProduto: Integer;
      AQuantidade: Double;
      APrecoUnit: Currency;
      ADescontoPercent: Double;
      ADescontoValor: Currency;
      ATotal: Currency;
      AState: TStatusItem = siDefault;
      AProduto: TProdutosECF = nil
      );
  begin
    FID := AID;
    FIDPedido := AIDPedido;
    FIDProduto := AIDProduto;
    FQuantidade := AQuantidade;
    FPrecoUnit := APrecoUnit;
    FDescontoPercent := ADescontoPercent;
    FDescontoValor := ADescontoValor;
    FTotal := ATotal;
    FState :=  AState;
    FProduto := AProduto;

  end;

  // ######### REGRAS NEGÓCIO ######### REGRAS NEGÓCIO ######### REGRAS NEGÓCIO ######### REGRAS NEGÓCIO ######### REGRAS NEGÓCIO ######### REGRAS NEGÓCIO ######### REGRAS NEGÓCIO

  //RETIRAR QUANTIDADE VENDIDA DO ESTOQUE -> NO FLUXO DE CADASTRO ESSE NOVO VALOR DO PRODUTO.ESTOQUE É PASSADO NO UPDATE.
  procedure TItensPedidos.DescontarEstoque;
  begin
    //PASSAR VALOR A SER ALTERADO NO ESTOQUE (OBS: O MÉTODO DE PRODUTOS SOMA VALORES SEMPRE).
    Self.FProduto.AlterarEstoque(-Self.FQuantidade);
  end;

  //DEVOLVER QUANTIDADE RETIRADA DO ESTOQUE
  procedure TItensPedidos.DevolverEstoque;
  begin
    Self.FProduto.AlterarEstoque(Self.FQuantidade);
  end;

  // ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES

  procedure TItensPedidos.Validar;
  var
  LErrorCadastro: EValidationError;
  LEstado: Boolean;
  begin
    LErrorCadastro := EValidationError.Create;
    LEstado := True;

    //VALIDAR LIMITE DE DESCONTO
    if Self.FProduto.DescontoMax < Self.FDescontoPercent then
    begin
      LEstado  := False;
      LErrorCadastro.FCampos.Add('Limite de desconto');
      LErrorCadastro.FValores.Add('Desconto maior que o limite permitido para o produto!');
    end;

    //VERIFICAR SE A VENDA DO PRODUTO É PERMITIDA
    if Self.FProduto.SitPermiteVenda = 'N' then
    begin
      LEstado  := False;
      LErrorCadastro.FCampos.Add('Venda permitida');
      LErrorCadastro.FValores.Add('A venda desse produto não é permitida!');
    end;

    //VERIFICA SE HÁ ESTOQUE DISPONÍVEL
    if Self.FProduto.Estoque < Self.Quantidade then
    begin
      LEstado  := False;
      LErrorCadastro.FCampos.Add('Quantidade');
      LErrorCadastro.FValores.Add('Quantidade é maior que estoque atual!');
    end;

    if not LEstado then
      raise LErrorCadastro
    else
      LErrorCadastro.Free;
  end;

end.
