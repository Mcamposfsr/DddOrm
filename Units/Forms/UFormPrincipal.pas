unit UFormPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Vcl.StdCtrls,
  Vcl.Buttons,

  UFormFormasPGTO,UFormClientesPGTO,UFormClienteTest,UFormProdutosEFC;

type
  TDDDORM = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    MainMenu1: TMainMenu;
    CADASTROS1: TMenuItem;
    CLIENTES1: TMenuItem;
    PAGAMENTOS1: TMenuItem;
    BitBtnCadastrarCliente: TBitBtn;
    BitBtnCadastrarPagamento: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtnCadastrarProduto: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtnCadastrarClienteClick(Sender: TObject);
    procedure CLIENTES1Click(Sender: TObject);
    procedure BitBtnCadastrarPagamentoClick(Sender: TObject);
    procedure PAGAMENTOS1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtnCadastrarProdutoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DDDORM: TDDDORM;

implementation

{$R *.dfm}


procedure TDDDORM.FormCreate(Sender: TObject);
  begin
    Self.BitBtnCadastrarCliente.Caption := 'Cadastrar' + sLineBreak + 'Cliente';
    Self.BitBtnCadastrarPagamento.Caption := 'Cadastrar' + sLineBreak + 'Pagamento';
  end;


// ############### EVENTOS

  //ABERTURA CADASTRO CLIENTES

procedure TDDDORM.BitBtnCadastrarClienteClick(Sender: TObject);
  begin
    FormClientesPGTO.Show;
  end;


procedure TDDDORM.CLIENTES1Click(Sender: TObject);
  begin
    FormClientesPGTO.Show;
  end;

  //ABERTURA CADASTRO FORMAS PAGAMENTO
  procedure TDDDORM.BitBtnCadastrarPagamentoClick(Sender: TObject);
  begin
    FormFormasPGTO.Show;
  end;




procedure TDDDORM.PAGAMENTOS1Click(Sender: TObject);
  begin
    FormFormasPGTO.Show;
  end;

  //FORM TESTE
  procedure TDDDORM.BitBtn1Click(Sender: TObject);
  begin
     FormClienteTest.Show;
  end;

  //ABERTURA CADASTRO PRODUTOS
  procedure TDDDORM.BitBtnCadastrarProdutoClick(Sender: TObject);
  begin
    FormProdutosEFC.Show;
  end;

  end.
