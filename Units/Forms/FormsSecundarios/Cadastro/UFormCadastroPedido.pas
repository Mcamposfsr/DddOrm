unit UFormCadastroPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,System.Generics.Collections,

  dbebr.factory.interfaces,

  UDomainPedidos,UDomainClientesPGTO,UControllerPedidos,UIRepository,UControllerClientesPGTO,

  UFormBuscarClientePGTO;

type
  TFormCadastroPedido = class(TForm)
    GroupBox3: TGroupBox;
    BitBtnBuscarCliente: TBitBtn;
    Label1: TLabel;
    EditNomeCliente: TEdit;
    EditClienteAtivo: TEdit;
    Label10: TLabel;
    EditDataPedido: TEdit;
    Label6: TLabel;
    ButtonCancelar: TButton;
    ButtonConfirmar: TButton;
    TPanel: TPanel;
    Label9: TLabel;
    EditDocumentoCliente: TEdit;
    EditNumeroPedido: TEdit;
    Label2: TLabel;
    procedure BitBtnBuscarClienteClick(Sender: TObject);
    procedure ButtonConfirmarClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private


    //FERRAMENTAS
    FRepositoryPedidos: IRepository<TPedidos>;
    FControllerPedidos: IControllerPedidos;
    FRepositoryClientes: IRepository<TClientePGTO>;
    FControllerClientes: IControllerClientesPGTO;

    procedure PreencherPedido(ACliente:TClientePGTO);
  public
    //VAR CONTROLE
    FClienteAtual: TClientePGTO;
    FCodigoPedido: String;

    constructor Create(
    AOwner: TComponent;
    ARepositoryPedidos: IRepository<TPedidos>;
    AControllerPedidos: IControllerPedidos;
    ARepositoryClientes: IRepository<TClientePGTO>;
    AControllerClientes: IControllerClientesPGTO
    ); Reintroduce;
  end;

var
  FormCadastroPedido: TFormCadastroPedido;

implementation

{$R *.dfm}


constructor TFormCadastroPedido.Create(
    AOwner: TComponent;
    ARepositoryPedidos: IRepository<TPedidos>;
    AControllerPedidos: IControllerPedidos;
    ARepositoryClientes: IRepository<TClientePGTO>;
    AControllerClientes: IControllerClientesPGTO
    );
    var LTESTE: IDBResultSet;
    begin
      Inherited Create(AOwner);
      FRepositoryPedidos := ARepositoryPedidos;
      FControllerPedidos := AControllerPedidos;
      FRepositoryClientes := ARepositoryClientes;
      FControllerClientes := AControllerClientes;


      //PASSAR DATA ATUAL PARA EDIT
      Self.EditDataPedido.Text := FormatDateTime('dd/mm/yyyy',now);
      Self.EditNumeroPedido.Text := Self.FControllerPedidos.GerarCodPedido;
    end;


// ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS

  procedure TFormCadastroPedido.BitBtnBuscarClienteClick(Sender: TObject);
  var LFORM: TFormBuscarClientePGTO;
  begin
    LFORM := nil;
    try
      LFORM := TFormBuscarClientePGTO.Create(nil,FRepositoryClientes,FControllerClientes);
      if LFORM.ShowModal = mrOk then
      begin
        Self.FClienteAtual := LFORM.FCliente;
        Self.PreencherPedido(Self.FClienteAtual);
      end;
    finally
      LFORM.Free;
    end;
  end;


  //CONFIRMAR
  procedure TFormCadastroPedido.ButtonConfirmarClick(Sender: TObject);
  begin
    Self.FControllerPedidos.CadastrarPedido(
    Self.FClienteAtual.Codigo,
    Self.EditDataPedido.Text,
    //TOTAL COMEÇA VAZIO
    '',
    Self.EditNumeroPedido.Text);

    //PASSAR CÓDIGO PEDIDO PARA ACESSO EXTERNO
    FCodigoPedido := Self.EditNumeroPedido.Text;
    ModalResult := mrOk
  end;

  //CANCELAR
  procedure TFormCadastroPedido.ButtonCancelarClick(Sender: TObject);
  begin
    ModalResult := mrCancel;
  end;

  procedure TFormCadastroPedido.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin
    if key = VK_ESCAPE then
      ModalResult := mrCancel;
  end;

  //  ######## FUNÇÕES AUXÍLIARES  ######## FUNÇÕES AUXÍLIARES  ######## FUNÇÕES AUXÍLIARES  ######## FUNÇÕES AUXÍLIARES  ######## FUNÇÕES AUXÍLIARES  ######## FUNÇÕES AUXÍLIARES

  procedure TFormCadastroPedido.PreencherPedido(ACliente:TClientePGTO);
  begin
    Self.EditNomeCliente.Text := ACliente.Nome;
    Self.EditDocumentoCliente.Text := ACliente.Documento;
    Self.EditClienteAtivo.Text := ACliente.Ativo;
  end;

end.
