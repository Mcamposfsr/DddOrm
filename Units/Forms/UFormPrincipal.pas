unit UFormPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Vcl.StdCtrls,
  Vcl.Buttons,

  UFormFormasPGTO,UFormClientesPGTO,UFormPedidos,UFormProdutosEFC;

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
    procedure BitBtnCadastrarClienteClick(Sender: TObject);
    procedure CLIENTES1Click(Sender: TObject);
    procedure BitBtnCadastrarPagamentoClick(Sender: TObject);
    procedure PAGAMENTOS1Click(Sender: TObject);
    procedure BitBtnCadastrarProdutoClick(Sender: TObject);
    procedure BitBtnCadastrarPedidoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}


procedure TFormPrincipal.FormCreate(Sender: TObject);
  begin
    Self.BitBtnCadastrarCliente.Caption := 'Cadastrar' + sLineBreak + 'Cliente';
    Self.BitBtnCadastrarPagamento.Caption := 'Cadastrar' + sLineBreak + 'Pagamento';
    Self.BitBtnCadastrarProduto.Caption := 'Cadastrar' + sLineBreak + 'Produto';
    Self.BitBtnCadastrarPedido.Caption := 'Novo' + sLineBreak + 'Pedido';
  end;


// ############### EVENTOS

  //ABERTURA CADASTRO CLIENTES

procedure TFormPrincipal.BitBtnCadastrarClienteClick(Sender: TObject);
  begin
    FormClientesPGTO.Show;
  end;


procedure TFormPrincipal.CLIENTES1Click(Sender: TObject);
  begin
    FormClientesPGTO.Show;
  end;

  //ABERTURA CADASTRO FORMAS PAGAMENTO
  procedure TFormPrincipal.BitBtnCadastrarPagamentoClick(Sender: TObject);
  begin
    FormFormasPGTO.Show;
  end;

  procedure TFormPrincipal.BitBtnCadastrarPedidoClick(Sender: TObject);
  begin
    FormPedidos.Show;
  end;

procedure TFormPrincipal.PAGAMENTOS1Click(Sender: TObject);
  begin
    FormFormasPGTO.Show;
  end;

  //ABERTURA CADASTRO PRODUTOS
  procedure TFormPrincipal.BitBtnCadastrarProdutoClick(Sender: TObject);
  begin
    FormProdutosEFC.Show;
  end;

  end.
