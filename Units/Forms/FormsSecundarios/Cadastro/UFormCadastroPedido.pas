unit UFormCadastroPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,System.Generics.Collections,

  UErros,

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
    procedure FormShow(Sender: TObject);
  private

    //FERRAMENTAS
    FControllerPedidos: IControllerPedidos;
    FControllerClientes: IControllerClientesPGTO;

    procedure PreencherPedido(ACliente:TClientePGTO);
  public

    //VAR CONTROLE
    FClienteAtual: TClientePGTO;
    FPedido: TPedidos;


    constructor Create(
    AOwner: TComponent;
    AControllerPedidos: IControllerPedidos;
    AControllerClientes: IControllerClientesPGTO
    ); Reintroduce;
  end;

var
  FormCadastroPedido: TFormCadastroPedido;

implementation

{$R *.dfm}


  constructor TFormCadastroPedido.Create(
  AOwner: TComponent;
  AControllerPedidos: IControllerPedidos;
  AControllerClientes: IControllerClientesPGTO
  );
  begin
    Inherited Create(AOwner);
    FControllerPedidos := AControllerPedidos;
    FControllerClientes := AControllerClientes;

    //PASSAR DATA ATUAL PARA EDIT
    Self.EditDataPedido.Text := FormatDateTime('dd/mm/yyyy',now);
  end;

  procedure TFormCadastroPedido.FormShow(Sender: TObject);
  begin
    TTratamentoDeErros.ExecutarOnForm(
      procedure
      begin
        Self.EditNumeroPedido.Text := Self.FControllerPedidos.GerarCodPedido;
      end
    );
  end;


// ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS

  procedure TFormCadastroPedido.BitBtnBuscarClienteClick(Sender: TObject);
  var LFORM: TFormBuscarClientePGTO;
  begin
    LFORM := nil;
    try
      LFORM := TFormBuscarClientePGTO.Create(nil,FControllerClientes);
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
    if not Assigned(Self.FClienteAtual) then
      begin
        ShowMessage('Selecione um Cliente');
        Exit;
      end;

    TTratamentoDeErros.ExecutarOnForm(
      procedure
      begin
        //CRIAR PEDIDO EM MEMÓRIA
        Self.FPedido :=  Self.FControllerPedidos.CriarPedidoEmMemoria(
        Self.FClienteAtual.Codigo,
        Self.EditDataPedido.Text,
        '',
        Self.EditNumeroPedido.Text,
        Self.FClienteAtual);

        ModalResult := mrOk
      end
    );
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
