unit UControllerPedidos;

interface

uses
System.Generics.Collections,System.Classes,UFormatErrorText, System.SysUtils, Vcl.Dialogs,UErros,FireDAC.Comp.Client,

UIRepository,


UDomainPedidos,
UDomainClientesPGTO,
UDomainProdutosECF,
UAppProdutosECF,
UAppPedidos,

UAppItensPedidos,
UDomainItensPedidos,
dbebr.factory.interfaces,
dbebr.factory.firedac,
Data.DB

;

type IControllerPedidos = interface
  // ***** PEDIDOS *****

  //CRUD
  function BuscarPedido(AID:Integer):TPedidos;
  function BuscarPedidoPeloCodigo(ACod:String):TPedidos;
  procedure CadastrarPedido(AIDCliente:Integer;ADataEmissao,ATotalLiquido,ACodPedido:String);
  procedure AlterarPedido(AID,AIDCliente:Integer;ADataEmissao,ATotalLiquido,ACodPedido:String);
  procedure DeletarPedido(AID:Integer);
  //AUX CRUD
  function CriarPedidoEmMemoria(AIDCliente:Integer;ADataEmissao,ATotalLiquido,ACodPedido:String;ACliente:TClientePGTO):TPedidos;
  procedure FiltrarPedido(AFiltro:String);
  function GerarCodPedido:String;
  procedure AtualizarValorTotalPedido(AID:Integer;AValorTotal:String);
  //OPÇÃO DE EXIBIÇÃO LEGADO PARA FIREBIRD 1.5
  procedure ExibirPedidos;
  procedure ReceberDataset(ADataSet: TFDMemTable);


  // ***** ITENS PEDIDOS *****

  //CRUD
  function BuscarItemPedido(AID:Integer):TItensPedidos;
  function BuscarItensPedidos(AID:Integer):TObjectList<TItensPedidos>;
  procedure CadastrarItemPedido(AIDPedido,AIDProduto:Integer;AQuantidade,APrecoUnit,ADescontoPercent,ADescontoValor,ATotal:String);
  procedure AlterarItemPedido(AID,AIDPedido,AIDProduto:Integer;AQuantidade,APrecoUnit,ADescontoPercent,ADescontoValor,ATotal:String);
  procedure DeletarItemPedido(AID:Integer);
  procedure ExibirItensPedidos(AID: Integer);
  procedure FiltrarItemPedido(AFiltro:String);

  // CRUD EM MEMÓRIA

  //INSERT
  procedure CriarItemPedidoEmMemoria(
  AItens:TObjectList<TItensPedidos>;
  AIDPedido:Integer;
  AQuantidade,
  APrecoUnit,
  ADescontoPercent,
  ADescontoValor,
  ATotal:String;
  AProduto:TProdutosECF
  );

  //UPDATE
  procedure AtualizarItemPedidoEmMemoria(
  //ITEM ORIGINAL
  AIndiceItemOriginal:Integer;
  AItens:TObjectList<TItensPedidos>;
  //ITEM NOVO
  AIDItemPedido,
  AIDPedido,
  AIDProduto:Integer;
  AQuantidade,
  APrecoUnit,
  ADescontoPercent,
  ADescontoValor,
  ATotal:String;
  AProduto:TProdutosECF
  );

  //DELETE
  procedure DeletarItemPedidoEmMemoria(AItem:TItensPedidos);

  //CRUD COM TRANSAÇÃO
  procedure CriarPedidoComTransacao(APedido:TPedidos;AItensPedido:TOBjectList<TItensPedidos>);
  procedure AtualizarPedidoComTransacao(APedido:TPedidos;AItensPedido:TOBjectList<TItensPedidos>);

end;

//CONTROLLER FORM CLIENTES PAGAMENTO
type TControllerPedidos = class(TInterfacedObject,IControllerPedidos)
  public
    // ***** PEDIDOS *****

    //CRUD
    function BuscarPedido(AID:Integer):TPedidos;
    function BuscarPedidoPeloCodigo(ACod:String):TPedidos;
    procedure CadastrarPedido(AIDCliente:Integer;ADataEmissao,ATotalLiquido,ACodPedido:String);
    procedure AlterarPedido(AID,AIDCliente:Integer;ADataEmissao,ATotalLiquido,ACodPedido:String);
    procedure DeletarPedido(AID:Integer);
    //AUX CRUD
    function CriarPedidoEmMemoria(AIDCliente:Integer;ADataEmissao,ATotalLiquido,ACodPedido:String;ACliente:TClientePGTO):TPedidos;
    procedure FiltrarPedido(AFiltro:String);
    function GerarCodPedido:String;
    procedure AtualizarValorTotalPedido(AID:Integer;AValorTotal:String);
    //OPÇÃO DE EXIBIÇÃO LEGADO PARA FIREBIRD 1.5
    procedure ExibirPedidos;
    procedure ReceberDataset(ADataSet: TFDMemTable);


    // ***** ITENS PEDIDOS *****

    //CRUD
    function BuscarItemPedido(AID:Integer):TItensPedidos;
    function BuscarItensPedidos(AID:Integer):TObjectList<TItensPedidos>;
    procedure CadastrarItemPedido(AIDPedido,AIDProduto:Integer;AQuantidade,APrecoUnit,ADescontoPercent,ADescontoValor,ATotal:String);
    procedure AlterarItemPedido(AID,AIDPedido,AIDProduto:Integer;AQuantidade,APrecoUnit,ADescontoPercent,ADescontoValor,ATotal:String);
    procedure DeletarItemPedido(AID:Integer);
    procedure ExibirItensPedidos(AID: Integer);
    procedure FiltrarItemPedido(AFiltro:String);

    //INSERT
    procedure CriarItemPedidoEmMemoria(
    AItens:TObjectList<TItensPedidos>;
    AIDPedido:Integer;
    AQuantidade,
    APrecoUnit,
    ADescontoPercent,
    ADescontoValor,
    ATotal:String;
    AProduto:TProdutosECF
    );

    //UPDATE
    procedure AtualizarItemPedidoEmMemoria(
    //ITEM ORIGINAL
    AIndiceItemOriginal:Integer;
    AItens:TObjectList<TItensPedidos>;
    //ITEM NOVO
    AIDItemPedido,
    AIDPedido,
    AIDProduto:Integer;
    AQuantidade,
    APrecoUnit,
    ADescontoPercent,
    ADescontoValor,
    ATotal:String;
    AProduto:TProdutosECF
    );

    //DELETE
    procedure DeletarItemPedidoEmMemoria(AItem:TItensPedidos);

    //CRUD COM TRANSAÇÃO
    procedure CriarPedidoComTransacao(APedido:TPedidos;AItensPedido:TOBjectList<TItensPedidos>);
    procedure AtualizarPedidoComTransacao(APedido:TPedidos;AItensPedido:TOBjectList<TItensPedidos>);

    constructor Create(
    AConn: TFDConnection;
    AAppPedidos:IAppPedidos;
    ARepPedidos:IRepository<TPedidos>;
    AAppItensPedidos:IAppItensPedidos;
    ARepItensPedidos:IRepository<TItensPedidos>;
    AAppProdutos:IAppProdutosECF;
    ARepProdutosECF:Irepository<TProdutosECF>
    );
  private
    //CONEXÃO
    FConn: IDBConnection;
    //PEDIDOS
    FAppPedidos: IAppPedidos;
    FRepPedidos: IRepository<TPedidos>;

    //ITENS PEDIDOS
    FAppItensPedidos: IAppItensPedidos;
    FRepItensPedidos: IRepository<TItensPedidos>;

    //PRODUTOS
    FAppProdutos: IAppProdutosECF;
    FRepProdutosECF: Irepository<TProdutosECF>;
end;

implementation

  constructor TControllerPedidos.Create(
    AConn: TFDConnection;
    AAppPedidos:IAppPedidos;
    ARepPedidos:IRepository<TPedidos>;
    AAppItensPedidos:IAppItensPedidos;
    ARepItensPedidos:IRepository<TItensPedidos>;
    AAppProdutos:IAppProdutosECF;
    ARepProdutosECF:Irepository<TProdutosECF>
    );
  begin
    //CONEXÃO - TRABALHAR COM TRANSAÇÕES
    FConn := TFactoryFireDAC.Create(AConn, dnFirebird);

    //PEDIDOS
    FAppPedidos := AAppPedidos;
    FRepPedidos := ARepPedidos;

    //ITENS PEDIDOS
    FAppItensPedidos := AAppItensPedidos;
    FRepItensPedidos := ARepItensPedidos;

    //PRODUTOS
    FAppProdutos := AAppProdutos;
    FRepProdutosECF := ARepProdutosECF;
  end;

  // ################## CRUD ################## CRUD ################## CRUD ################## CRUD ################## CRUD ################## CRUD

  // ***** PEDIDOS *****

  //BUSCAR
  function TControllerPedidos.BuscarPedido(AID:Integer):TPedidos;
  begin
    Result := FAppPedidos.BuscarPedidoByID(AID);
  end;

  //RECEBER DATASET
  procedure TControllerPedidos.ReceberDataset(ADataSet: TFDMemTable);
  begin
    Self.FRepPedidos.ReceberDataSetFirebirdLegado(ADataSet);
  end;

  //EXIBIR PEDIDOS DATASET
  procedure TControllerPedidos.ExibirPedidos;
  begin
    Self.FAppPedidos.BuscarPedidosLegado;
  end;

  //BUSCAR PELO COD PEDIDO
  function TControllerPedidos.BuscarPedidoPeloCodigo(ACod:String):TPedidos;
  begin
    Result := FAppPedidos.BuscarPedidoPeloCodigo(ACod);
  end;

  //CADASTRAR
  procedure TControllerPedidos.CadastrarPedido(
  AIDCliente:Integer;
  ADataEmissao,
  ATotalLiquido,
  ACodPedido:String
  );
  var
  LTotalLiquido: Currency;
  LDataEmissao: TDate;
  begin
    //CONVERSÕES
    LTotalLiquido := StrToFloatDef(StringReplace(ATotalLiquido, '.', '', [rfReplaceAll]),0);
    LDataEmissao := StrToDate(ADataEmissao);

    Self.FAppPedidos.InserirPedido(AIDCliente,LDataEmissao,LTotalLiquido,ACodPedido);
  end;

  //ALTERAR
  procedure TControllerPedidos.AlterarPedido(
  AID,
  AIDCliente:Integer;
  ADataEmissao,
  ATotalLiquido,
  ACodPedido:String
  );
  var
  LTotalLiquido: Currency;
  LDataEmissao: TDate;
  begin
    LTotalLiquido := StrToFloatDef(StringReplace(ATotalLiquido, '.', '', [rfReplaceAll]),0);
    LDataEmissao := StrToDate(ADataEmissao);
    Self.FAppPedidos.AtualizarPedido(AID,AIDCliente,LDataEmissao,LTotalLiquido,ACodPedido);
  end;

  //DELETAR
  procedure TControllerPedidos.DeletarPedido(AID:Integer);
  begin
    Self.FAppPedidos.DeletarPedido(AID);
  end;

  //FILTRAR
  procedure TControllerPedidos.FiltrarPedido(AFiltro:String);
  begin
    Self.FRepPedidos.FiltrarDataSetLegado('CLI_NOME',AFiltro);
  end;

  // ***** ITENS PEDIDO *****

  //BUSCAR
  function TControllerPedidos.BuscarItemPedido(AID:Integer):TItensPedidos;
  begin
    Result := FAppItensPedidos.BuscarItemPedidoByID(AID);
  end;

  function TControllerPedidos.BuscarItensPedidos(AID:Integer):TObjectList<TItensPedidos>;
  begin
    Result := FAppItensPedidos.BuscarITensDoPedido(AID);
  end;

  //EXIBIR ITENS PEDIDOS
  procedure TControllerPedidos.ExibirItensPedidos(AID: Integer);
  var LID: String;
  begin
    LID := IntToStr(AID);
    Self.FAppItensPedidos.BuscarPedidosLegado(LID);
  end;

  //CADASTRAR
  procedure TControllerPedidos.CadastrarItemPedido(
  AIDPedido,
  AIDProduto:Integer;
  AQuantidade,
  APrecoUnit,
  ADescontoPercent,
  ADescontoValor,
  ATotal:String
  );
  var
  LQuantidade: Currency;
  LPrecoUnit: Currency;
  LDescontoPercent: Currency;
  LDescontoValor: Currency;
  LTotal: Currency;
  begin
    //CONVERSÕES
    LQuantidade := StrToFloatDef(StringReplace(AQuantidade, '.', '', [rfReplaceAll]),0);
    LPrecoUnit := StrToFloatDef(StringReplace(APrecoUnit, '.', '', [rfReplaceAll]),0);
    LDescontoPercent := StrToFloatDef(StringReplace(ADescontoPercent, '.', '', [rfReplaceAll]),0);
    LDescontoValor := StrToFloatDef(StringReplace(ADescontoValor, '.', '', [rfReplaceAll]),0);
    LTotal := StrToFloatDef(StringReplace(ATotal, '.', '', [rfReplaceAll]),0);

    Self.FAppItensPedidos.InserirItemPedido(
    AIDPedido,
    AIDProduto,
    LQuantidade,
    LPrecoUnit,
    LDescontoPercent,
    LDescontoValor,
    LTotal
    );
  end;

  //ALTERAR
  procedure TControllerPedidos.AlterarItemPedido(
  AID,
  AIDPedido,
  AIDProduto:Integer;
  AQuantidade,
  APrecoUnit,
  ADescontoPercent,
  ADescontoValor,
  ATotal:String
  );
  var
  LQuantidade: Currency;
  LPrecoUnit: Currency;
  LDescontoPercent: Currency;
  LDescontoValor: Currency;
  LTotal: Currency;
  begin
    //CONVERSÕES
    LQuantidade := StrToFloatDef(StringReplace(AQuantidade, '.', '', [rfReplaceAll]),0);
    LPrecoUnit := StrToFloatDef(StringReplace(APrecoUnit, '.', '', [rfReplaceAll]),0);
    LDescontoPercent := StrToFloatDef(StringReplace(ADescontoPercent, '.', '', [rfReplaceAll]),0);
    LDescontoValor := StrToFloatDef(StringReplace(ADescontoValor, '.', '', [rfReplaceAll]),0);
    LTotal := StrToFloatDef(StringReplace(ATotal, '.', '', [rfReplaceAll]),0);

    Self.FAppItensPedidos.AtualizarItemPedido(
    AID,
    AIDPedido,
    AIDProduto,
    LQuantidade,
    LPrecoUnit,
    LDescontoPercent,
    LDescontoValor,
    LTotal
    );
  end;

   //DELETAR
  procedure TControllerPedidos.DeletarItemPedido(AID:Integer);
  begin
    Self.FAppItensPedidos.DeletarItemPedido(AID);
  end;


  //FILTRAR
  procedure TControllerPedidos.FiltrarItemPedido(AFiltro:String);
  begin
    Self.FRepItensPedidos.FiltrarDataSet('ID_ITEM',AFiltro);
  end;

  // ########### CRUD C/ TRANSAÇÃO ########### CRUD C/ TRANSAÇÃO ########### CRUD C/ TRANSAÇÃO ########### CRUD C/ TRANSAÇÃO ########### CRUD C/ TRANSAÇÃO

  //CRIAR PEDIDO COMPLETO C/ TRANSAÇÃO (PEDIDO + ITENS)
  procedure TControllerPedidos.CriarPedidoComTransacao(APedido:TPedidos;AItensPedido:TOBjectList<TItensPedidos>);
  var
  LID: Integer;
  LITemPedido: TItensPedidos;

  begin
    Self.FConn.StartTransaction;

    //INSERIR PEDIDO
    Self.FAppPedidos.InserirPedido(APedido);

    LID := Self.FAppPedidos.BuscarPedidoPeloCodigo(APedido.CodPedido).ID;

    //ALTERAR ID_PEDIDO PARA ID ATUAL
    for LITemPedido in AItensPedido do
      LITemPedido.IDPedido := LID;

    //INSERIR ITENS
    Self.FAppItensPedidos.InserirItensPedido(AItensPedido);
    Self.FConn.Commit;
  end;

  //ATUALIZAR PEDIDO COMPLETO C/ TRANSAÇÃO (PEDIDO + ITENS)
  procedure TControllerPedidos.AtualizarPedidoComTransacao(APedido:TPedidos;AItensPedido:TOBjectList<TItensPedidos>);
  var
  LITemPedido: TItensPedidos;
  begin
    Self.FConn.StartTransaction;

    //BUSCAR ID DO PEDIDO
    APedido.ID := Self.FAppPedidos.BuscarPedidoPeloCodigo(APedido.CodPedido).ID;

    //ALTERAR ID_PEDIDO PARA ID ATUAL
    for LITemPedido in AItensPedido do
      LITemPedido.IDPedido := APedido.ID;

    //ATUALIZAR PEDIDO
    Self.FAppPedidos.AtualizarPedido(APedido);

    //ATUALIZAR ITENS
    Self.FAppItensPedidos.AtualizarItensPedido(AItensPedido);

    Self.FConn.Commit;
  end;


  // ########## AUX CRUD ########## AUX CRUD ########## AUX CRUD ########## AUX CRUD ########## AUX CRUD ########## AUX CRUD ########## AUX CRUD ########## AUX CRUD ########## AUX CRUD ########## AUX CRUD ########## AUX CRUD ########## AUX CRUD

  // ***** PEDIDOS *****

  //CRIAR DTO PEDIDO PARA TRABALHAR COM TRANSAÇÕES
  function TControllerPedidos.CriarPedidoEmMemoria(
  AIDCliente:Integer;
  ADataEmissao,
  ATotalLiquido,
  ACodPedido:String;
  ACliente:TClientePGTO
  ):TPedidos;
  var
  LData: TDate;
  LTotalLiquido: Currency;
  begin
    //CONVERSÕES
    LData := StrToDate(ADataEmissao);
    LTotalLiquido := StrToCurrDef(ATotalLiquido,0);

    //GERAR O PEDIDO EM MEMÓRIA
    Result := Self.FAppPedidos.CriarDTOPedido(
      -1,
      AIDCliente,
      ACodPedido,
      LTotalLiquido,
      LData,
      ACliente
    );
  end;

  //GERAR CÓDIGO PEDIDO
  function TControllerPedidos.GerarCodPedido:String;
  var
  LResultSet: IDBResultSet;
  LIDPedido: String;
  LDataPedido:String;
  LTemp: String;
  begin
    LResultSet := Self.FRepPedidos.Open('SELECT GEN_ID(GEN_COD_PEDIDO,1) AS COD FROM RDB$DATABASE;');
    LIDPedido := LResultSet.DataSet.FieldByName('COD').AsString;

    //COLOCAR '0' NA FRENTE
    while Length(LIDPedido) < 6 do
    begin
      LTemp :=  LIDPedido;
      LIDPedido := '0' + LTemp;
    end;

    LDataPedido := FormatDateTime('ddmmyy',now);
    Result := LDataPedido + '-' +LIDPedido;
  end;

  //PASSAR VALOR TOTAL
  procedure TControllerPedidos.AtualizarValorTotalPedido(AID:Integer;AValorTotal:String);
  begin
    Self.FAppPedidos.AtualizarTotalPedido(AID,AValorTotal);
  end;

  // ***** ITENS PEDIDOS *****

  //CRIAR PRODUTO PARA TRABALHAR COM TRANSAÇÕES
  procedure TControllerPedidos.CriarItemPedidoEmMemoria(
    AItens:TObjectList<TItensPedidos>;
    AIDPedido:Integer;
    AQuantidade,
    APrecoUnit,
    ADescontoPercent,
    ADescontoValor,
    ATotal:String;
    AProduto:TProdutosECF
    );
  var
  LQuantidade: Double;
  LPrecoUnit: Currency;
  LDescontoPercent: Currency;
  LDescontoValor: Currency;
  LTotal: Currency;
  begin
    //CONVERSÕES
    LPrecoUnit := StrToCurrDef(StringReplace(APrecoUnit, '.', '', [rfReplaceAll]),0);
    LDescontoValor := StrToCurrDef(StringReplace(ADescontoValor, '.', '', [rfReplaceAll]),0);
    LTotal := StrToCurrDef(StringReplace(ATotal, '.', '', [rfReplaceAll]),0);
    LQuantidade := StrToFloatDef(StringReplace(AQuantidade, '.', '', [rfReplaceAll]),0);
    LDescontoPercent := StrToFloatDef(StringReplace(ADescontoPercent, '.', '', [rfReplaceAll]),0);

    //GERAR O PEDIDO EM MEMÓRIA
      Self.FAppItensPedidos.CriarDTOItensPedido(
      AItens,
      -1,
      AIDPedido,
      LPrecoUnit,
      LDescontoValor,
      LTotal,
      LDescontoPercent,
      LQuantidade,
      AProduto
    );
  end;

  procedure TControllerPedidos.AtualizarItemPedidoEmMemoria(
  //ITEM ORIGINAL
  AIndiceItemOriginal:Integer;
  AItens:TObjectList<TItensPedidos>;
  //ITEM NOVO
  AIDItemPedido,
  AIDPedido,
  AIDProduto:Integer;
  AQuantidade,
  APrecoUnit,
  ADescontoPercent,
  ADescontoValor,
  ATotal:String;
  AProduto:TProdutosECF
  );
  var
  LQuantidade: Currency;
  LPrecoUnit: Currency;
  LDescontoPercent: Currency;
  LDescontoValor: Currency;
  LTotal: Currency;
  LITemPedidos: TItensPedidos;
  begin
    //CONVERSÕES
    LPrecoUnit := StrToCurrDef(StringReplace(APrecoUnit, '.', '', [rfReplaceAll]),0);
    LDescontoValor := StrToCurrDef(StringReplace(ADescontoValor, '.', '', [rfReplaceAll]),0);
    LTotal := StrToCurrDef(StringReplace(ATotal, '.', '', [rfReplaceAll]),0);
    LQuantidade := StrToFloatDef(StringReplace(AQuantidade, '.', '', [rfReplaceAll]),0);
    LDescontoPercent := StrToFloatDef(StringReplace(ADescontoPercent, '.', '', [rfReplaceAll]),0);

    //ATUALIZAR ITENS
    Self.FAppItensPedidos.AtualizarDTOItensPedido(
      //ITEM ANTIGO
      AIndiceItemOriginal,
      AItens,
      //NOVO ITEM
      AIDItemPedido,
      AIDPedido,
      AIDProduto,
      LPrecoUnit,
      LDescontoValor,
      LTotal,
      LDescontoPercent,
      LQuantidade,
      AProduto
    );
  end;


  procedure TControllerPedidos.DeletarItemPedidoEmMemoria(AItem:TItensPedidos);
  begin
    Self.FAppItensPedidos.DeletarDTOItensPedido(AITem);
  end;


end.
