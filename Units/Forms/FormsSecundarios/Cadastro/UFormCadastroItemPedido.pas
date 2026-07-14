unit UFormCadastroItemPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,System.Generics.Collections,

  UFormBuscarProdutos,
  UDomainProdutosECF,UGenericRep,UIRepository,UControllerProdutosECF, UDomainItensPedidos,UControllerPedidos;

type
  TFormItensPedido = class(TForm)
    TPanel: TPanel;
    Label6: TLabel;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    BitBtnBuscarProduto: TBitBtn;
    EditNomeProduto: TEdit;
    EditPrecoUnitario: TEdit;
    EditLimiteDesconto: TEdit;
    EditQuantidade: TEdit;
    ButtonCancelar: TButton;
    ButtonConfirmar: TButton;
    EditEstoque: TEdit;
    Label2: TLabel;
    EditVendaPermitida: TEdit;
    Label3: TLabel;
    EditDesconto: TEdit;
    Label4: TLabel;
    EditValorTotal: TEdit;
    Label5: TLabel;
    EditValorDescontado: TEdit;
    Label7: TLabel;
    procedure BitBtnBuscarProdutoClick(Sender: TObject);
    procedure EditQuantidadeChange(Sender: TObject);
    procedure EditDescontoChange(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure ButtonConfirmarClick(Sender: TObject);
  private
    //FERRAMENTAS
    FRepositoryItensPedido: IRepository<TItensPedidos>;
    FControllerItensPedido: IControllerPedidos;
    FRepositoryProdutosECF: IRepository<TProdutosECF>;
    FControllerProdutosECF: IControllerProdutosECF;


    procedure PreencherProduto(AProduto: TProdutosECF);
    procedure CalcularTotal;
  public
    //VAR CONTROLE

    FIDPedido: Integer;
    FIDItemPedido: Integer;
    FItemPedido: TItensPedidos;
    FItensPedido: TObjectList<TItensPedidos>;

    FProduto: TProdutosECF;

    FOperacao: String;

    constructor Create(
    AOwner:TComponent;
    AIDPedido:Integer;
    AIDItem:Integer;
    AOperacao:String;
    ARepositoryItensPedido: IRepository<TItensPedidos>;
    AControllerItensPedido: IControllerPedidos;
    ARepositoryProdutosECF:IRepository<TProdutosECF>;
    AControllerProdutosECF:IControllerProdutosECF;
    AItensPedido: TObjectList<TItensPedidos> = nil
    );
  end;

var
  FormItensPedido: TFormItensPedido;

implementation

{$R *.dfm}

constructor TFormItensPedido.Create(
    AOwner:TComponent;
    AIDPedido:Integer;
    AIDItem:Integer;
    AOperacao:String;
    ARepositoryItensPedido: IRepository<TItensPedidos>;
    AControllerItensPedido: IControllerPedidos;
    ARepositoryProdutosECF:IRepository<TProdutosECF>;
    AControllerProdutosECF:IControllerProdutosECF;
    AItensPedido: TObjectList<TItensPedidos> = nil
    );
  var LItemPedido :TItensPedidos;
  begin
    inherited Create(AOwner);
    FIDPedido := AIDPedido;
    FIDItemPedido := AIDItem;
    FOperacao := AOperacao;
    FRepositoryItensPedido := ARepositoryItensPedido;
    FControllerItensPedido := AControllerItensPedido;
    FRepositoryProdutosECF := ARepositoryProdutosECF;
    FControllerProdutosECF := AControllerProdutosECF;
    FItensPedido := AItensPedido;

    if FOperacao = 'INSERT' then
    begin
      //NADA A FAZER
    end
    else if FOperacao = 'UPDATE' then
    begin
      //AUXÍLIO NO USO DO ITEM
      LItemPedido := FItensPedido.Items[FIDItemPedido];

      //PASSAR ITEM PARA FORMULÁRIO
      Self.FProduto := LItemPedido.Produto;

      //PASAR VALORES PARA EDIT.
      Self.PreencherProduto(Self.FProduto);
      Self.EditDesconto.Text := FloatToStr(LItemPedido.DescontoPercent);
      Self.EditQuantidade.Text :=  FloatToStr(LItemPedido.Quantidade);

      //CALCULAR VALOR TOTAL
      Self.CalcularTotal;
    end;
  end;

  // ############# PRODUTOS ############# PRODUTOS ############# PRODUTOS ############# PRODUTOS ############# PRODUTOS ############# PRODUTOS ############# PRODUTOS

  //BUSCAR PRODUTO
  procedure TFormItensPedido.BitBtnBuscarProdutoClick(Sender: TObject);
  var LFORM: TFormBuscarProdutos;
  begin
    LFORM := nil;
    try
      LFORM := TFormBuscarProdutos.Create(nil,FRepositoryProdutosECF,FControllerProdutosECF);
      if LFORM.ShowModal = mrOk then
      begin
        //RECEBER PRODUTO SELECIONADO
        Self.FProduto := LFORM.FProduto;

        Self.PreencherProduto(Self.FProduto);
        Self.CalcularTotal;
      end;
    finally
      LFORM.Free;
    end;
  end;

  //EVENTO PARA CALCULAR TOTAL:
  procedure TFormItensPedido.EditDescontoChange(Sender: TObject);
  begin
    Self.CalcularTotal;
  end;

  //EVENTO PARA CALCULAR TOTAL:
  procedure TFormItensPedido.EditQuantidadeChange(Sender: TObject);
  begin
    Self.CalcularTotal;
  end;

  //CANCELAR
  procedure TFormItensPedido.ButtonCancelarClick(Sender: TObject);
  begin
    ModalResult := mrCancel;
  end;

  //CONFIRMAR
  procedure TFormItensPedido.ButtonConfirmarClick(Sender: TObject);
  begin
    if FOperacao = 'INSERT' then
    begin
      //CADASTRAR
//      Self.FControllerItensPedido.CadastrarItemPedido(
//      Self.FIDPedido,
//      Self.FProduto.Codigo,
//      Self.EditQuantidade.Text,
//      Self.EditPrecoUnitario.Text,
//      Self.EditDesconto.Text,
//      Self.EditValorDescontado.Text,
//      Self.EditValorTotal.Text
//      );

      FItemPedido := Self.FControllerItensPedido.CriarItemPedido(
      Self.FIDPedido,
      Self.FProduto.Codigo,
      Self.EditQuantidade.Text,
      Self.EditPrecoUnitario.Text,
      Self.EditDesconto.Text,
      Self.EditValorDescontado.Text,
      Self.EditValorTotal.Text,
      Self.FProduto
      );
    end
    else if FOperacao = 'UPDATE' then
    begin
      //ALTERAR
//      Self.FControllerItensPedido.AlterarItemPedido(
//      FIDItemPedido,
//      Self.FIDPedido,
//      Self.FProduto.Codigo,
//      Self.EditQuantidade.Text,
//      Self.EditPrecoUnitario.Text,
//      Self.EditDesconto.Text,
//      Self.EditValorDescontado.Text,
//      Self.EditValorTotal.Text
//      );

      FItemPedido := Self.FControllerItensPedido.CriarItemPedido(
      Self.FIDPedido,
      Self.FProduto.Codigo,
      Self.EditQuantidade.Text,
      Self.EditPrecoUnitario.Text,
      Self.EditDesconto.Text,
      Self.EditValorDescontado.Text,
      Self.EditValorTotal.Text,
      Self.FProduto
      );

      Self.FItensPedido.Items[FIDItemPedido] := FItemPedido;
    end;
    ModalResult := mrOk;
  end;

// ############ MÉTODOS AUXÍLIARES ############ MÉTODOS AUXÍLIARES ############ MÉTODOS AUXÍLIARES ############ MÉTODOS AUXÍLIARES

  //PREENCHER FORM COM PRODUTO
  procedure TFormItensPedido.PreencherProduto(AProduto: TProdutosECF);
  begin
    Self.EditNomeProduto.Text := AProduto.Nome;
    Self.EditPrecoUnitario.Text := CurrToStr(AProduto.PrecoVenda);
    Self.EditLimiteDesconto.Text := FloatToStr(AProduto.DescontoMax);
    Self.EditEstoque.Text := FloatToStr(Aproduto.Estoque);
    Self.EditVendaPermitida.Text := Aproduto.SitPermiteVenda;
  end;

  //CALCULAR VALOR TOTAL
  procedure TFormItensPedido.CalcularTotal;
  var
  LTotal: Currency;
  LValorUnitario: Currency;
  LQuantidade: Double;
  LPercentualDesconto: Double;
  LValorUnitarioDesconto: Currency;
  LValorTotalDesconto: Currency;
  begin
    //QUANTIDADE DO ITEM
    LQuantidade := StrToFloatDef(Self.EditQuantidade.Text,0);

    //VALOR UNITÁRIO DO ITEM
    LValorUnitario := StrToCurrDef(Self.EditPrecoUnitario.Text,0);

    // % DE DESCONTO
    LPercentualDesconto := (StrToFloatDef(self.EditDesconto.Text,0) / 100);

    //VALOR DESCONTADO UNITÁRIO
    LValorUnitarioDesconto := LValorUnitario * LPercentualDesconto;

    //VALOR TOTAL DESCONTADO
    LValorTotalDesconto :=  LValorUnitarioDesconto * LQuantidade;

    //VALOR LÍQUIDO TOTAL
    LTotal := (LValorUnitario - LValorUnitarioDesconto) * LQuantidade;

    //PASSAGEM DE VALORES PARA FORMULÁRIO
    Self.EditValorDescontado.Text := CurrToStr(LValorTotalDesconto);
    Self.EditValorTotal.Text := CurrToStr(LTotal);
  end;

end.
