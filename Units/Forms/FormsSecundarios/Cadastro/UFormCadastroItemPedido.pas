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
    procedure VerificarProduto;
  public
    //VAR CONTROLE

    FIDPedido: Integer;
    FIndiceItemPedido: Integer;
    FItemPedido: TItensPedidos;
    FItensPedido: TObjectList<TItensPedidos>;
    FProduto: TProdutosECF;

    FOperacao: String;

    constructor Create(
    AOwner:TComponent;
    AIDPedido:Integer;
    AIndiceItem:Integer;
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
    AIndiceItem:Integer;
    AOperacao:String;
    ARepositoryItensPedido: IRepository<TItensPedidos>;
    AControllerItensPedido: IControllerPedidos;
    ARepositoryProdutosECF:IRepository<TProdutosECF>;
    AControllerProdutosECF:IControllerProdutosECF;
    AItensPedido: TObjectList<TItensPedidos> = nil
    );
  begin
    inherited Create(AOwner);
    FIDPedido := AIDPedido;
    FIndiceItemPedido := AIndiceItem;
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
      Self.FItemPedido := FItensPedido.Items[FIndiceItemPedido];

      //PASSAR ITEM PARA FORMULÁRIO
      Self.FProduto := Self.FItemPedido.Produto;

      //PASAR VALORES PARA EDIT.
      Self.PreencherProduto(Self.FProduto);
      Self.EditDesconto.Text := FloatToStr(Self.FItemPedido.DescontoPercent);
      Self.EditQuantidade.Text :=  FloatToStr(Self.FItemPedido.Quantidade);

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

        //TRABALHAR A MESMA REFERÊNCIA DA LISTA
        Self.VerificarProduto;

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
    if not assigned(Self.FProduto) then
    begin
      ShowMessage('Selecione um Produto');
      Exit;
    end;

    if FOperacao = 'INSERT' then
    begin
      //CADASTRAR EM MEMÓRIA
      Self.FControllerItensPedido.CriarItemPedidoEmMemoria(
      Self.FItensPedido,
      Self.FIDPedido,
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
      //ALTERAR EM MEMÓRIA
      Self.FControllerItensPedido.AtualizarItemPedidoEmMemoria(
        //ITEM ATIGO
        Self.FIndiceItemPedido,
        Self.FItensPedido,
        //ITEM NOVO
        Self.FItemPedido.ID,
        Self.FIDPedido,
        Self.FProduto.Codigo,
        Self.EditQuantidade.Text,
        Self.EditPrecoUnitario.Text,
        Self.EditDesconto.Text,
        Self.EditValorDescontado.Text,
        Self.EditValorTotal.Text,
        Self.FProduto
      );

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

  //VERIFICAR SE PRODUTO JÁ ESTÁ PRESENTE NA LISTA(PARA TRABALHAR COM A MESMA REFERÊNCIA DO PRODUTO)
  procedure TFormItensPedido.VerificarProduto;
  var
  //VAR AUX PARA GARANTIR CONTROLE DE ESTOQUE
  LItem: TItensPedidos;
  begin
    //VERIFICAR SE HÁ ITEM REPETIDO.
    for LItem in FItensPedido do
    begin
      //VERIFICAR SE O PRODUTO BUSCADO NO BANCO JÁ NÃO ESTÁ NA LISTA - SE ESTIVER, OS ITENS DEVEM APONTAR PARA A MESMA REFERÊNCIA DO PRODUTO
      if LItem.Produto.CodigoDeBarras = Self.FProduto.CodigoDeBarras then
      begin
        //PASSAR REFERÊNCIA JÁ EXISTENTE / LIMPAR REFERÊNCIA QUE VEIO DO BANCO.
        Self.FProduto.Free;
        Self.FProduto := LItem.Produto;
        Break;
      end;
    end;
  end;

end.
