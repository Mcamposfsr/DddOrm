unit UFormPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids,


  UDomainClientesPGTO,UDomainProdutosECF,UDomainPedidos,UDomainItensPedidos,UIRepository,UGenericRep,UDM,
  UAppProdutosECF,UAppPedidos,UAppItensPedidos,UAppClientesPGTO, UControllerPedidos,UControllerClientesPGTO,UFormBuscarPedido,UFormCadastroPedido;

type
  TFormPedidos = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    EditNumeroPedido: TEdit;
    Label2: TLabel;
    EditNomeCliente: TEdit;
    Label3: TLabel;
    EditDataPedido: TEdit;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    BitBtnBuscarPedido: TBitBtn;
    BitBtnCriarPedido: TBitBtn;
    BitBtnRemoverPedido: TBitBtn;
    Panel2: TPanel;
    GroupBox2: TGroupBox;
    BitBtnAlterarItem: TBitBtn;
    BitBtnAdicionarItem: TBitBtn;
    BitBtnExcluirItem: TBitBtn;
    DBGrid1: TDBGrid;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    BitBtnCancelCliente: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtnBuscarPedidoClick(Sender: TObject);
    procedure BitBtnCriarPedidoClick(Sender: TObject);
    procedure BitBtnRemoverPedidoClick(Sender: TObject);
    procedure BitBtnCancelClienteClick(Sender: TObject);
  private
    //ESTADOS INTERNOS
    FPedidoAtual: TPedidos;

    //FERRAMENTAS

    //REPOSITORY
    FRepositoryPedidos: IRepository<TPedidos>;
    FRepositoryItensPedidos: IRepository<TItensPedidos>;
    FRepositoryClientesPGTO: IRepository<TClientePGTO>;

    //APPS
    FAppPedidos: IAppPedidos;
    FAppItensPedidos: IAppItensPedidos;
    FAppClientes: IAppClientesPGTO;
    FAppProdutos: IAppProdutosECF;



    //CONTROLLERS
//    FControllerProdutos;
    FControllerPedidos: IControllerPedidos;
    FControllerClientes: IControllerClientesPGTO;

    //FUNÇÕES AUXÍLIARES
    procedure PreencherPedido(APedido:TPedidos);
    procedure LimparPedidos;
  public
    { Public declarations }
  end;

var
  FormPedidos: TFormPedidos;

implementation

{$R *.dfm}

  // INICIAR FORM.

  procedure TFormPedidos.FormCreate(Sender: TObject);
  begin
    //CRIAR REPOSITORY
    FRepositoryPedidos := TRepository<TPedidos>.Create(GDM.GetConnection);
    FRepositoryItensPedidos := TRepository<TItensPedidos>.Create(GDM.GetConnection);
    FRepositoryClientesPGTO := TRepository<TClientePGTO>.Create(GDM.GetConnection);


    //CRIAR APPLICATION
    FAppPedidos := TAppPedidos.Create(FRepositoryPedidos);
    FAppItensPedidos := TAppItensPedidos.Create(FRepositoryItensPedidos);
    FAppClientes := TAppClientesPGTO.Create(FRepositoryClientesPGTO);

    //CONTROLLER
    FControllerPedidos := TControllerPedidos.Create(FAppPedidos,FRepositoryPedidos,FAppItensPedidos,FRepositoryItensPedidos);
    FControllerClientes := TControllerClientesPGTO.Create(FAppClientes,FRepositoryClientesPGTO);
  end;

  // ######### EVENTOS ######### EVENTOS ######### EVENTOS ######### EVENTOS ######### EVENTOS ######### EVENTOS ######### EVENTOS ######### EVENTOS

  //BUSCAR PEDIDO
  procedure TFormPedidos.BitBtnBuscarPedidoClick(Sender: TObject);
  var LFORM: TFormBuscarPedido;
  begin
    LFORM := nil;
    try
      LFORM := TFormBuscarPedido.Create(nil,FRepositoryPedidos,FControllerPedidos);
      if LFORM.ShowModal = mrOk then
      begin
        Self.FPedidoAtual := LFORM.FPedido;
        Self.PreencherPedido(Self.FPedidoAtual);
      end;
    finally
      LFORM.Free;
    end;
  end;

  //CADASTRAR PEDIDO
  procedure TFormPedidos.BitBtnCriarPedidoClick(Sender: TObject);
  var LFORM: TFormCadastroPedido;
  begin
    LFORM := nil;
    try
      LFORM := TFormCadastroPedido.Create(nil,FRepositoryPedidos,FControllerPedidos,FRepositoryClientesPGTO,FControllerClientes);
      if LFORM.ShowModal = mrOk then
      begin
//        Self.FPedidoAtual := LFORM.FPedido;
//        Self.PreencherPedido(Self.FPedidoAtual);
      end;
    finally
      LFORM.Free;
    end;
  end;

  //CANCELAR
  procedure TFormPedidos.BitBtnCancelClienteClick(Sender: TObject);
  begin
    Self.LimparPedidos;
  end;

  //DELETAR PEDIDO
  procedure TFormPedidos.BitBtnRemoverPedidoClick(Sender: TObject);
  begin
    Self.FControllerPedidos.DeletarPedido(Self.FPedidoAtual.ID);
    Self.LimparPedidos;
  end;

// ######### FUNÇÕES AUXÍLIARES ######### FUNÇÕES AUXÍLIARES ######### FUNÇÕES AUXÍLIARES ######### FUNÇÕES AUXÍLIARES ######### FUNÇÕES AUXÍLIARES

  //PREENCHER PEDIDO NA TELA
  procedure TFormPedidos.PreencherPedido(APedido:TPedidos);
  begin
    Self.EditNomeCliente.Text := APedido.NomeCliente;
    Self.EditDataPedido.Text := FormatDateTime('dd/mm/yyyy',APedido.DataEmissao);
    Self.EditNumeroPedido.Text := IntToStr(APedido.ID);
  end;

   procedure TFormPedidos.LimparPedidos;
   begin
     Self.EditNomeCliente.Clear;
     Self.EditDataPedido.Clear;
     Self.EditNumeroPedido.Clear;
     Self.FPedidoAtual := niL;
   end;

end.
