unit UFormPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Vcl.StdCtrls,UDM,
  Vcl.Buttons,

  // ***FORMS***
  UFormFormasPGTO,
  UFormProdutosECF,
  UFormClientesPGTO,
  UFormPedidos,

  // ***BOOTSTRAPS***
  UBootsTrapFormasPGTO,
  UBootsTrapClientesPGTO,
  UBootstrapProdutosECF,
  UBootstrapPedidos;

type
  TFormPrincipal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    MainMenu1: TMainMenu;
    CADASTROS1: TMenuItem;
    CLIENTES1: TMenuItem;
    PAGAMENTOS1: TMenuItem;
    BitBtnCadastrarCliente: TBitBtn;
    BitBtnCadastrarPagamento: TBitBtn;
    BitBtnCadastrarProduto: TBitBtn;
    BitBtnCadastrarPedido: TBitBtn;
    PRODUTOS1: TMenuItem;
    PEDIDOS1: TMenuItem;
    procedure FormCreate(Sender: TObject);

    //EVENTOS
    procedure OpenFormFormasPGTO(Sender: TObject);
    procedure OpenFormClientesPGTO(Sender: TObject);
    procedure OpenFormProdutosECF(Sender: TObject);
    procedure OpenFormPedidos(Sender: TObject);
  private
    //BOOTSTRAPS
    FBootstrapFormasPGTO: IBootstrapFormasPGTO;
    FBootstrapClientesPGTO: IBootstrapClientesPGTO;
    FBootstrapProdutosECF: IBootstrapProdutosEFC;
    FBootstrapPedidos: IBootstrapPedidos;
    procedure ConfigurarBotoes;
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

  procedure TFormPrincipal.FormCreate(Sender: TObject);
  var LDM: TDM;
  begin
    Self.ConfigurarBotoes;
    //CRIAR BOOTSTRAP PASSANDO CONEXÃO GLOBAL
    FBootstrapFormasPGTO := TBootstrapFormasPGTO.Create(GDM);
    FBootstrapClientesPGTO := TBootstrapClientesPGTO.Create(GDM);
    FBootstrapProdutosECF := TBootstrapProdutosEFC.Create(GDM);
    FBootstrapPedidos :=  TBootstrapPedidos.Create(GDM);
  end;

// ############### EVENTOS ############### EVENTOS ############### EVENTOS ############### EVENTOS ############### EVENTOS ############### EVENTOS ############### EVENTOS

  //ABERTURA FORMAS DE PAGAMENTOS
  procedure TFormPrincipal.OpenFormFormasPGTO(Sender: TObject);
  var
  LFORM: TFormFormasPGTO;
  begin
    try
      LFORM := TFormFormasPGTO.Create(nil,FBootstrapFormasPGTO.Controller);
      LFORM.ShowModal;
    finally
      LFORM.Free;
    end;
  end;

  //ABERTURA CLIENTES
  procedure TFormPrincipal.OpenFormClientesPGTO(Sender: TObject);
  var
  LFORM: TFormClientesPGTO;
  begin
    try
      LFORM := TFormClientesPGTO.Create(nil,FBootstrapClientesPGTO.Controller);
      LFORM.ShowModal;
    finally
      LFORM.Free;
    end;
  end;

  //ABERTURA PRODUTOS
  procedure TFormPrincipal.OpenFormProdutosECF(Sender: TObject);
  var
  LFORM: TFormProdutosECF;
  begin
    try
      LFORM := TFormProdutosECF.Create(nil,FBootstrapProdutosECF.Controller);
      LFORM.ShowModal;
    finally
      LFORM.Free;
    end;
  end;

  //ABERTURA PEDIDOS
  procedure TFormPrincipal.OpenFormPedidos(Sender: TObject);
  var
  LFORM: TFormPedidos;
  begin
    try
      LFORM := TFormPedidos.Create(nil,
      FBootstrapPedidos.ControllerClientes,
      FBootstrapPedidos.ControllerProdutosECF,
      FBootstrapPedidos.ControllerPedidos
      );
      LFORM.ShowModal;
    finally
      LFORM.Free;
    end;
  end;

  // ############### FORM AUX ############### FORM AUX ############### FORM AUX ############### FORM AUX ############### FORM AUX ############### FORM AUX ############### FORM AUX
  procedure TFormPrincipal.ConfigurarBotoes;
  begin
    Self.BitBtnCadastrarCliente.Caption := 'Cadastrar' + sLineBreak + 'Cliente';
    Self.BitBtnCadastrarPagamento.Caption := 'Cadastrar' + sLineBreak + 'Pagamento';
    Self.BitBtnCadastrarProduto.Caption := 'Cadastrar' + sLineBreak + 'Produto';
    Self.BitBtnCadastrarPedido.Caption := 'Novo' + sLineBreak + 'Pedido';
  end;

end.



