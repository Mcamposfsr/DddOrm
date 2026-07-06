unit UFormCadastroItemPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,System.Generics.Collections,

  UFormBuscarProdutos,
  UDomainProdutosECF,UGenericRep,UIRepository,UControllerProdutosECF, UDomainItensPedidos,UControllerPedidos;

type
  TFormInserirItem = class(TForm)
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
    AControllerProdutosECF:IControllerProdutosECF
    );
  end;

var
  FormInserirItem: TFormInserirItem;

implementation

{$R *.dfm}



constructor TFormInserirItem.Create(
    AOwner:TComponent;
    AIDPedido:Integer;
    AIDItem:Integer;
    AOperacao:String;
    ARepositoryItensPedido: IRepository<TItensPedidos>;
    AControllerItensPedido: IControllerPedidos;
    ARepositoryProdutosECF:IRepository<TProdutosECF>;
    AControllerProdutosECF:IControllerProdutosECF
    );
  begin
    inherited Create(AOwner);
    FIDPedido := AIDPedido;
    FIDItemPedido := AIDItem;
    FOperacao := AOperacao;
    FRepositoryItensPedido := ARepositoryItensPedido;
    FControllerItensPedido := AControllerItensPedido;
    FRepositoryProdutosECF := ARepositoryProdutosECF;
    FControllerProdutosECF := AControllerProdutosECF;


    if FOperacao = 'INSERT' then
    begin
      //NADA A FAZER
    end
    else if FOperacao = 'UPDATE' then
    begin
      FItemPedido := Self.FControllerItensPedido.BuscarItemPedido(FIDItemPedido);
      FProduto := Self.FControllerProdutosECF.BuscarProdutoECF(FItemPedido.IDProduto);

      //PASAR VALORES PARA EDIT.
      Self.PreencherProduto(FProduto);
      Self.EditDesconto.Text := FloatToStr(FItemPedido.DescontoPercent);
      Self.EditQuantidade.Text :=  FloatToStr(FItemPedido.Quantidade);

      //CALCULAR VALOR TOTAL
      Self.CalcularTotal;
    end;
  end;



procedure TFormInserirItem.BitBtnBuscarProdutoClick(Sender: TObject);
  var LFORM: TFormBuscarProdutos;
  begin
    LFORM := nil;
    try
      LFORM := TFormBuscarProdutos.Create(nil,FRepositoryProdutosECF,FControllerProdutosECF);
      if LFORM.ShowModal = mrOk then
      begin
        Self.PreencherProduto(LFORM.FProduto);
        //RECEBER PRODUTO SELECIONADO
        Self.FProduto := LFORM.FProduto;
        Self.CalcularTotal;
      end;
    finally
      LFORM.Free;
    end;
  end;


  //EVENTO PARA CALCULAR TOTAL:
  procedure TFormInserirItem.EditDescontoChange(Sender: TObject);
  begin
    Self.CalcularTotal;
  end;

  //EVENTO PARA CALCULAR TOTAL:
  procedure TFormInserirItem.EditQuantidadeChange(Sender: TObject);
  begin
    Self.CalcularTotal;
  end;

  //CANCELAR
  procedure TFormInserirItem.ButtonCancelarClick(Sender: TObject);
  begin
    ModalResult := mrCancel;
  end;

  //CONFIRMAR
  procedure TFormInserirItem.ButtonConfirmarClick(Sender: TObject);
  begin
    if FOperacao = 'INSERT' then
    begin
      //CADASTRAR
      Self.FControllerItensPedido.CadastrarItemPedido(
      Self.FIDPedido,
      Self.FProduto.Codigo,
      Self.EditQuantidade.Text,
      Self.EditPrecoUnitario.Text,
      Self.EditDesconto.Text,
      Self.EditValorDescontado.Text,
      Self.EditValorTotal.Text
      );
    end
    else if FOperacao = 'UPDATE' then
    begin
      //ALTERAR
      Self.FControllerItensPedido.AlterarItemPedido(
      FIDItemPedido,
      Self.FIDPedido,
      Self.FProduto.Codigo,
      Self.EditQuantidade.Text,
      Self.EditPrecoUnitario.Text,
      Self.EditDesconto.Text,
      Self.EditValorDescontado.Text,
      Self.EditValorTotal.Text
      );
    end;
    ModalResult := mrOk;
  end;

// ############ MÉTODOS AUXÍLIARES ############ MÉTODOS AUXÍLIARES ############ MÉTODOS AUXÍLIARES ############ MÉTODOS AUXÍLIARES

  //PREENCHER FORM COM PRODUTO
  procedure TFormInserirItem.PreencherProduto(AProduto: TProdutosECF);
  begin
    Self.EditNomeProduto.Text := AProduto.Nome;
    Self.EditPrecoUnitario.Text := CurrToStr(AProduto.PrecoVenda);
    Self.EditLimiteDesconto.Text := FloatToStr(AProduto.DescontoMax);
    Self.EditEstoque.Text := FloatToStr(Aproduto.Estoque);
    Self.EditVendaPermitida.Text := Aproduto.SitPermiteVenda;
  end;

  //CALCULAR VALOR TOTAL
  procedure TFormInserirItem.CalcularTotal;
  var
  LTotal: Currency;
  LValorUnitario: Currency;
  LQuantidade: Double;
  LPercentualDesconto: Double;
  LValorDesconto: Currency;
  begin
    LQuantidade := StrToFloatDef(Self.EditQuantidade.Text,0);
    LValorUnitario := StrToCurrDef(Self.EditPrecoUnitario.Text,0);
    LPercentualDesconto := (StrToFloatDef(self.EditDesconto.Text,0) / 100);
    LValorDesconto := LValorUnitario * LPercentualDesconto;
    LTotal := (LValorUnitario - LValorDesconto) * LQuantidade;

    Self.EditValorDescontado.Text := CurrToStr(LValorDesconto);
    Self.EditValorTotal.Text := CurrToStr(LTotal);
  end;

end.
