unit UFormPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids,


  UDomainClientesPGTO,UDomainProdutosECF,UDomainPedidos,UDomainItensPedidos,UIRepository,UGenericRep,UDM,
  UAppProdutosECF,UAppPedidos,UAppItensPedidos,UAppClientesPGTO, UControllerPedidos,UControllerClientesPGTO,UControllerProdutosECF,
  UFormBuscarPedido,UFormCadastroPedido,UFormCadastroItemPedido,UDataSetColumnSum,


  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFormPedidos = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    EditCodigoPedido: TEdit;
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
    EditTotalLiquido: TEdit;
    Label6: TLabel;
    BitBtnCancelCliente: TBitBtn;
    DataSource: TDataSource;
    FDMemTable: TFDMemTable;
    procedure FormCreate(Sender: TObject);
    procedure BitBtnBuscarPedidoClick(Sender: TObject);
    procedure BitBtnCriarPedidoClick(Sender: TObject);
    procedure BitBtnRemoverPedidoClick(Sender: TObject);
    procedure BitBtnCancelClienteClick(Sender: TObject);
    procedure BitBtnAdicionarItemClick(Sender: TObject);
    procedure BitBtnExcluirItemClick(Sender: TObject);
    procedure BitBtnAlterarItemClick(Sender: TObject);
    procedure FDMemTableAfterRefresh(DataSet: TDataSet);
  private
    //ESTADOS INTERNOS
    FPedidoAtual: TPedidos;

    //FERRAMENTAS

    //REPOSITORY
    FRepositoryPedidos: IRepository<TPedidos>;
    FRepositoryItensPedidos: IRepository<TItensPedidos>;
    FRepositoryClientesPGTO: IRepository<TClientePGTO>;
    FRepositoryProdutos: IRepository<TProdutosECF>;

    //APPS
    FAppPedidos: IAppPedidos;
    FAppItensPedidos: IAppItensPedidos;
    FAppClientes: IAppClientesPGTO;
    FAppProdutos: IAppProdutosECF;



    //CONTROLLERS
    FControllerPedidos: IControllerPedidos;
    FControllerClientes: IControllerClientesPGTO;
    FControllerProdutos: IControllerProdutosECF;

    //FUNÇÕES AUXÍLIARES
    procedure PreencherPedido(APedido:TPedidos);
    procedure LimparPedidos;
    procedure AtualizarDataSet;
    procedure PassarValorTotal;
    procedure ConfigurarDataset;
    procedure EstadoControlesItens(AState:Boolean);
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
    FRepositoryProdutos := TRepository<TProdutosECF>.Create(GDM.GetConnection);

    //CRIAR APPLICATION
    FAppPedidos := TAppPedidos.Create(FRepositoryPedidos,FRepositoryClientesPGTO);
    FAppItensPedidos := TAppItensPedidos.Create(FRepositoryItensPedidos,FRepositoryProdutos);
    FAppClientes := TAppClientesPGTO.Create(FRepositoryClientesPGTO);
    FAppProdutos := TAppProdutosECF.Create(FRepositoryProdutos);

    //CONTROLLER
    FControllerPedidos := TControllerPedidos.Create(FAppPedidos,FRepositoryPedidos,FAppItensPedidos,FRepositoryItensPedidos);
    FControllerClientes := TControllerClientesPGTO.Create(FAppClientes,FRepositoryClientesPGTO);
    FControllerProdutos := TControllerProdutosECF.Create(FAppProdutos,FRepositoryProdutos);

    //*PASSAR DATASET ITENS PEDIDOS*
    FRepositoryItensPedidos.ReceberDataSetFirebirdLegado(Self.FDMemTable);
    Self.AtualizarDataSet;
  end;

  // ######### EVENTOS ######### EVENTOS ######### EVENTOS ######### EVENTOS ######### EVENTOS ######### EVENTOS ######### EVENTOS ######### EVENTOS

  // ********** PEDIDOS **********

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
        Self.EstadoControlesItens(True);
        //BUSCAR PEDIDOS
        Self.AtualizarDataSet;
      end;
    finally
      LFORM.Free;
    end;
  end;

  //CADASTRAR PEDIDO
  procedure TFormPedidos.BitBtnCriarPedidoClick(Sender: TObject);
  var 
  LFORM: TFormCadastroPedido;
  begin
    LFORM := nil;
    try
      LFORM := TFormCadastroPedido.Create(nil,FRepositoryPedidos,FControllerPedidos,FRepositoryClientesPGTO,FControllerClientes);
      if LFORM.ShowModal = mrOk then
      begin
        Self.FPedidoAtual := Self.FControllerPedidos.BuscarPedidoPeloCodigo(LForm.FCodigoPedido);

        Self.PreencherPedido(Self.FPedidoAtual);
        Self.EstadoControlesItens(True);
        //BUSCAR PEDIDOS
        Self.AtualizarDataSet;
      end;
    finally
      LFORM.Free;
    end;
  end;

//CANCELAR
  procedure TFormPedidos.BitBtnCancelClienteClick(Sender: TObject);
  begin
    Self.EstadoControlesItens(False);
    Self.LimparPedidos;
  end;

  //DELETAR PEDIDO
  procedure TFormPedidos.BitBtnRemoverPedidoClick(Sender: TObject);
  begin
    if not Assigned(FPedidoAtual) then
    begin
      ShowMessage('Selecione um pedido!');
      Exit;
    end;

    Self.EstadoControlesItens(False);
    Self.FControllerPedidos.DeletarPedido(Self.FPedidoAtual.ID);
    Self.LimparPedidos;
  end;

// ********** ITENS **********

  //ADICIONAR PRODUTO
  procedure TFormPedidos.BitBtnAdicionarItemClick(Sender: TObject);
  var LFORM: TFormInserirItem;
  begin
    LFORM := nil;
    try
      LFORM := TFormInserirItem.Create(
      nil,
      Self.FPedidoAtual.ID,
      -1,
      'INSERT',
      FRepositoryItensPedidos,
      FControllerPedidos,
      FRepositoryProdutos,
      FControllerProdutos
      );
      if LFORM.ShowModal = mrOk then
      begin
        Self.AtualizarDataSet;
        Self.PassarValorTotal;
        ShowMessage('Produto adicionado');
      end;
    finally
      LFORM.Free;
    end;
  end;

  //ALTERAR PRODUTO
  procedure TFormPedidos.BitBtnAlterarItemClick(Sender: TObject);
  var
  LFORM: TFormInserirItem;
  LID: Integer;
  begin
    LID := Self.FDMemTable.FieldByName('ID_ITEM').AsInteger;
    LFORM := nil;
    try
      LFORM := TFormInserirItem.Create(
      nil,
      Self.FPedidoAtual.ID,
      LID,
      'UPDATE',
      FRepositoryItensPedidos,
      FControllerPedidos,
      FRepositoryProdutos,
      FControllerProdutos
      );
      if LFORM.ShowModal = mrOk then
      begin
        Self.AtualizarDataSet;
        Self.PassarValorTotal;
        ShowMessage('Produto alterado');
      end;
    finally
      LFORM.Free;
    end;
  end;

  //REMOVER PRODUTO
  procedure TFormPedidos.BitBtnExcluirItemClick(Sender: TObject);
  var LID: Integer;
  begin
    LID := Self.FDMemTable.FieldByName('ID_ITEM').AsInteger;
    Self.FControllerPedidos.DeletarItemPedido(LID);

    Self.AtualizarDataSet;
    Self.PassarValorTotal;
    ShowMessage('Produto excluído');
  end;


  //CALCULAR TOTAL
  procedure TFormPedidos.FDMemTableAfterRefresh(DataSet: TDataSet);
  var LValorTotal: Currency;
  begin
    LValorTotal := SomarColunaDataSet(Self.FDMemTable,'TOTAL');
    Self.EditTotalLiquido.Text := CurrToStr(LValorTotal);
  end;

// ######### FUNÇÕES AUXÍLIARES ######### FUNÇÕES AUXÍLIARES ######### FUNÇÕES AUXÍLIARES ######### FUNÇÕES AUXÍLIARES ######### FUNÇÕES AUXÍLIARES

  //PREENCHER PEDIDO NA TELA
  procedure TFormPedidos.PreencherPedido(APedido:TPedidos);
  begin
    Self.EditNomeCliente.Text := APedido.Cliente.Nome;
    Self.EditDataPedido.Text := FormatDateTime('dd/mm/yyyy',APedido.DataEmissao);
    Self.EditCodigoPedido.Text := APedido.CodPedido;
  end;

  //LIMPAR PEDIDOS
  procedure TFormPedidos.LimparPedidos;
  begin
     Self.EditNomeCliente.Clear;
     Self.EditDataPedido.Clear;
     Self.EditCodigoPedido.Clear;
     Self.FPedidoAtual := niL;

    Self.AtualizarDataSet;
  end;

  //ATUALIZAR DATASET
  procedure TFormPedidos.AtualizarDataSet;
  var LID: Integer;
  begin
    if not Assigned(FPedidoAtual) then
      LID:= -1
    else
      LID := FPedidoAtual.ID;
    Self.FControllerPedidos.ExibirItensPedidos(LID);
    Self.ConfigurarDataset;
    Self.FDMemTable.Refresh;
  end;

  //ATUALIZAR VALOR TOTAL DO REGISTRO DE PEDIDOS
  procedure TFormPedidos.PassarValorTotal;
  begin
    Self.FControllerPedidos.AtualizarValorTotalPedido(
      Self.FPedidoAtual.ID,
      Self.EditTotalLiquido.Text
    );
  end;

  //ATUALIZAR VALOR TOTAL DO REGISTRO DE PEDIDOS
  procedure TFormPedidos.ConfigurarDataset;
  begin
    Self.FDMemTable.FieldByName('ID_ITEM').Visible := False;
    Self.FDMemTable.FieldByName('ID_PEDIDO').Visible := False;
    Self.FDMemTable.FieldByName('ID_PRODUTO').Visible := False;
    Self.FDMemTable.FieldByName('DESCONTO_PERCENT').Visible := False;

    Self.FDMemTable.FieldByName('PRO_NOME').DisplayLabel := 'NOME PRODUTO';
    Self.FDMemTable.FieldByName('PRO_NOME').DisplayWidth := 40;
    Self.FDMemTable.FieldByName('PRECO_UNIT').DisplayLabel := 'PREÇO UNITÁRIO';
    Self.FDMemTable.FieldByName('DESCONTO_VALOR').DisplayLabel := 'VALOR DESCONTADO';
  end;

  //CONTROLAR BOTÕES
  procedure TFormPedidos.EstadoControlesItens(AState:Boolean);
  begin
    Self.BitBtnAdicionarItem.Enabled := AState;
    Self.BitBtnAlterarItem.Enabled := AState;
    Self.BitBtnExcluirItem.Enabled := AState;
  end;


end.

