unit UFormPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids,System.generics.collections,


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
    DataSource: TDataSource;
    FDMemTable: TFDMemTable;
    BtnConfirmar: TButton;
    BtnCancelar: TButton;
    BitBtnAlterarPedido: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtnBuscarPedidoClick(Sender: TObject);
    procedure BitBtnCriarPedidoClick(Sender: TObject);
    procedure BitBtnRemoverPedidoClick(Sender: TObject);
    procedure BitBtnAlterarPedidoClick(Sender: TObject);
    procedure BitBtnAdicionarItemClick(Sender: TObject);
    procedure BitBtnExcluirItemClick(Sender: TObject);
    procedure BitBtnAlterarItemClick(Sender: TObject);
    procedure FDMemTableAfterRefresh(DataSet: TDataSet);
    procedure BtnConfirmarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    //ESTADOS INTERNOS
    FPedidoAtual: TPedidos;
    FItensPedido: TObjectList<TItensPedidos>;
    FOperacao: String;

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
    procedure RestarEstadoForm;
  public
    { Public declarations }
  end;

var
  FormPedidos: TFormPedidos;

implementation

{$R *.dfm}

  // CONSTRUCTOR
  procedure TFormPedidos.FormCreate(Sender: TObject);
  begin
    //SEM OPERAÇÃO INICIAL
    FOperacao := '';

    //LISTA DE ITENS INTERNA
    FItensPedido := TObjectList<TItensPedidos>.Create(True);

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
    FControllerPedidos := TControllerPedidos.Create(
    GDM.GetConnection,
    FAppPedidos,
    FRepositoryPedidos,
    FAppItensPedidos,
    FRepositoryItensPedidos,
    FAppProdutos,
    FRepositoryProdutos
    );

    FControllerClientes := TControllerClientesPGTO.Create(FAppClientes,FRepositoryClientesPGTO);
    FControllerProdutos := TControllerProdutosECF.Create(FAppProdutos,FRepositoryProdutos);

    //CONFIGURAR EXIBIÇÃO DO DATASET
    Self.ConfigurarDataset;
  end;

  //DESTRUCTOR
  procedure TFormPedidos.FormDestroy(Sender: TObject);
  begin
    if Assigned(Self.FItensPedido) then
      Self.FItensPedido.Free;

    if Assigned(Self.FPedidoAtual) then
      Self.FPedidoAtual.Free;
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
      Self.RestarEstadoForm;
      if LFORM.ShowModal = mrOk then
      begin
        Self.FPedidoAtual := LFORM.FPedido;
        Self.PreencherPedido(Self.FPedidoAtual);

        FreeAndNil(Self.FItensPedido);
        Self.FItensPedido := Self.FControllerPedidos.BuscarItensPedidos(Self.FPedidoAtual.ID);

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
        Self.RestarEstadoForm;
        Self.FOperacao := 'INSERT';
        Self.BtnConfirmar.Enabled := True;

        Self.FPedidoAtual := LForm.FPedido;

        Self.PreencherPedido(Self.FPedidoAtual);
        Self.EstadoControlesItens(True);
      end;
    finally
      LFORM.Free;
    end;
  end;

  //ALTERAR PEDIDO
  procedure TFormPedidos.BitBtnAlterarPedidoClick(Sender: TObject);
  begin
    if not Assigned(FPedidoAtual) then
    begin
      ShowMessage('Selecione um pedido!');
      Exit;
    end;

    Self.FOperacao := 'UPDATE';
    Self.BtnConfirmar.Enabled := True;
    Self.EstadoControlesItens(True);
  end;

  //DELETAR PEDIDO
  procedure TFormPedidos.BitBtnRemoverPedidoClick(Sender: TObject);
  begin
    if not Assigned(FPedidoAtual) then
    begin
      ShowMessage('Selecione um pedido!');
      Exit;
    end;

    Self.FControllerPedidos.DeletarPedido(Self.FPedidoAtual.ID);

    Self.FOperacao := '';
    Self.RestarEstadoForm;

    ShowMessage('Pedido Excluído!');
  end;


// ********** ITENS **********

  //ADICIONAR ITEM
  procedure TFormPedidos.BitBtnAdicionarItemClick(Sender: TObject);
  var LFORM: TFormItensPedido;
  begin
    LFORM := nil;
    try
      LFORM := TFormItensPedido.Create(
      nil,
      Self.FPedidoAtual.ID,
      -1,
      'INSERT',
      FRepositoryItensPedidos,
      FControllerPedidos,
      FRepositoryProdutos,
      FControllerProdutos,
      //PASSAR LISTA PARA FORM TRABALHAR NA MESMA
      Self.FItensPedido
      );
      if LFORM.ShowModal = mrOk then
      begin
        Self.AtualizarDataSet;
        Self.PassarValorTotal;
      end;
    finally
      LFORM.Free;
    end;
  end;

  //ALTERAR ITEM
  procedure TFormPedidos.BitBtnAlterarItemClick(Sender: TObject);
  var
  LFORM: TFormItensPedido;
  LIndiceItem: Integer;
  begin
    //VERIFICAR ANTES DE ALTERAR
    if Self.FDMemTable.IsEmpty then
    begin
      ShowMessage('Nenhum Produto selecionado');                           ;
      Exit;
    end;

    LIndiceItem := Self.FDMemTable.FieldByName('INDICE_ITEM').AsInteger;
    LFORM := nil;
    try
      LFORM := TFormItensPedido.Create(
      nil,
      Self.FPedidoAtual.ID,
      LIndiceItem,
      'UPDATE',
      FRepositoryItensPedidos,
      FControllerPedidos,
      FRepositoryProdutos,
      FControllerProdutos,
      //PASSAR LISTA PARA FORM TRABALHAR NA MESMA
      Self.FItensPedido
      );
      if LFORM.ShowModal = mrOk then
      begin
        Self.AtualizarDataSet;
        ShowMessage('Produto alterado');
        Self.PassarValorTotal;
      end;
    finally
      LFORM.Free;
    end;
  end;

  //REMOVER ITEM
  procedure TFormPedidos.BitBtnExcluirItemClick(Sender: TObject);
  var LIndiceItem: Integer;
  begin
    if Self.FDMemTable.IsEmpty then
    begin
      ShowMessage('Nenhum Produto selecionado');
      Exit;
    end;

    LIndiceItem := Self.FDMemTable.FieldByName('INDICE_ITEM').AsInteger;
    Self.FItensPedido.Delete(LIndiceItem);

    Self.AtualizarDataSet;
    Self.PassarValorTotal;
    ShowMessage('Produto excluído');
  end;

  // ***** FINAL DO FLUXO *****

  //CONFIRMAR AÇÕES
  procedure TFormPedidos.BtnConfirmarClick(Sender: TObject);
  begin
    if Self.FOperacao = '' then
      ShowMessage('Nenhuma operacao iniciada')
    else if Self.FOperacao = 'INSERT' then
    begin
      Self.FControllerPedidos.CriarPedidoComTransacao(Self.FPedidoAtual,Self.FItensPedido);
      ShowMessage('Pedido Cadastrado!');
    end
    else if Self.FOperacao = 'UPDATE' then
    begin
      Self.FControllerPedidos.AtualizarPedidoComTransacao(Self.FPedidoAtual,Self.FItensPedido);
      ShowMessage('Pedido Alterado!');
    end;

    //REINICIAR FORMULÁRIO
    Self.BtnConfirmar.Enabled := False;
    Self.RestarEstadoForm;
  end;

  //CANCELAR AÇÕES
  procedure TFormPedidos.BtnCancelarClick(Sender: TObject);
  begin
    Self.BtnConfirmar.Enabled := False;
    Self.RestarEstadoForm;
    Self.Close;
  end;

  // ***** EVENTO AUXILIAR *****

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
  var
  LID: Integer;
  I: Integer;
  begin
    try
      Self.FDMemTable.DisableControls;
      Self.FDMemTable.EmptyDataSet;

      //VALIDAR EXISTENCIA DA LISTA
      if not Assigned(Self.FItensPedido) then
        Exit;
      //VALIDAR EXISTENCIA DOS ITENS
      if (Self.FItensPedido.Count < 1) then
        Exit;

      for I := 0 to Self.FItensPedido.Count -1 do
      begin
        //VERIFICAR SE ITEM FOI DELETADO
        if Self.FItensPedido[I].State = siDeleted then
          continue;

        Self.FDMemTable.Append;

        Self.FDMemTable.FieldByName('INDICE_ITEM').AsInteger := I;
        Self.FDMemTable.FieldByName('ID_PEDIDO').AsInteger := Self.FItensPedido[I].IDPedido;
        Self.FDMemTable.FieldByName('ID_PRODUTO').AsInteger := Self.FItensPedido[I].IDProduto;
        Self.FDMemTable.FieldByName('DESCONTO_PERCENT').AsFloat := Self.FItensPedido[I].DescontoPercent;
        Self.FDMemTable.FieldByName('PRO_NOME').AsString := Self.FItensPedido[I].Produto.Nome;
        Self.FDMemTable.FieldByName('QUANTIDADE').AsFloat := Self.FItensPedido[I].Quantidade;
        Self.FDMemTable.FieldByName('PRECO_UNIT').AsCurrency := Self.FItensPedido[I].PrecoUnit;
        Self.FDMemTable.FieldByName('DESCONTO_VALOR').AsCurrency := Self.FItensPedido[I].DescontoValor;
        Self.FDMemTable.FieldByName('TOTAL').AsCurrency := Self.FItensPedido[I].Total;

        Self.FDMemTable.Post;
      end;
    finally
      Self.FDMemTable.EnableControls;
      Self.FDMemTable.Refresh;
    end;
  end;

  //ATUALIZAR VALOR TOTAL DO REGISTRO DE PEDIDOS
  procedure TFormPedidos.PassarValorTotal;
  begin
    Self.FPedidoAtual.TotalLiquido := StrToCurrDef(Self.EditTotalLiquido.Text,0);
  end;

  //ATUALIZAR VALOR TOTAL DO REGISTRO DE PEDIDOS
  procedure TFormPedidos.ConfigurarDataset;
  begin
    Self.FDMemTable.FieldDefs.Add('INDICE_ITEM',ftInteger);
    Self.FDMemTable.FieldDefs.Add('ID_PEDIDO',ftInteger);
    Self.FDMemTable.FieldDefs.Add('ID_PRODUTO',ftInteger);
    Self.FDMemTable.FieldDefs.Add('PRO_NOME',ftString,50);
    Self.FDMemTable.FieldDefs.Add('QUANTIDADE',ftFloat);
    Self.FDMemTable.FieldDefs.Add('PRECO_UNIT',ftFloat);
    Self.FDMemTable.FieldDefs.Add('DESCONTO_PERCENT',ftFloat);
    Self.FDMemTable.FieldDefs.Add('DESCONTO_VALOR',ftFloat);
    Self.FDMemTable.FieldDefs.Add('TOTAL',ftFloat);

    Self.FDMemTable.CreateDataSet;

    Self.FDMemTable.FieldByName('INDICE_ITEM').Visible := False;
    Self.FDMemTable.FieldByName('ID_PEDIDO').Visible := False;
    Self.FDMemTable.FieldByName('ID_PRODUTO').Visible := False;

    Self.FDMemTable.FieldByName('PRO_NOME').DisplayLabel := 'NOME PRODUTO';
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

  //RESETAR O ESTADO INICIAL DO FORM
  procedure TFormPedidos.RestarEstadoForm;
  begin
    //RESETAR OPERACAO
    FOperacao := '';
    //DESATIVAR BTN CONFIRMAR
    Self.BtnConfirmar.Enabled := False;
    //LIBERAR ESTADOS ITNERNOS
    FreeAndNil(Self.FPedidoAtual);
    Self.FItensPedido.Clear;
    //RESETAR DATASET
    Self.AtualizarDataSet;
    //DESATIVAR BOTOES DOS ITENS
    Self.EstadoControlesItens(False);
    //LIMPAR CAMPOS DE PEDIDOS
    Self.LimparPedidos;
  end;
end.

