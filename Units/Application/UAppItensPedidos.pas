unit UAppItensPedidos;


interface
 uses
 //SYSTEM
 System.Generics.Collections,
 System.SysUtils,
 Data.DB,
 Vcl.Dialogs,
 //FERRAMENTAS
 UDomainProdutosECF,
 UDomainItensPedidos,
 UIRepository;


  type IAppItensPedidos = Interface

    //CRUD
    Function BuscarItensPedido:TObjectList<TItensPedidos>;
    Function BuscarItemPedidoByID(ACodigo:Integer):TItensPedidos;
    Function BuscarITensDoPedido(AID:Integer):TObjectList<TItensPedidos>;
    procedure BuscarPedidosLegado(AID: String);
    procedure InserirItemPedido(
      AIDPedido: Integer;
      AIDProduto: Integer;
      AQuantidade: Double;
      APrecoUnit: Currency;
      ADescontoPercent: Double;
      ADescontoValor: Currency;
      ATotal: Currency
    );
    procedure InserirItensPedido(AItens:TObjectList<TItensPedidos>);
    procedure AtualizarItemPedido(
      FID: Integer;
      FIDPedido: Integer;
      FIDProduto: Integer;
      FQuantidade: Double;
      FPrecoUnit: Currency;
      FDescontoPercent: Double;
      FDescontoValor: Currency;
      FTotal: Currency
    );
    procedure AtualizarItensPedido(AItens:TObjectList<TItensPedidos>);
    procedure DeletarItemPedido(AID:Integer);

    //CRUD EM MEMÓRIA

    //CREATE
    procedure CriarDTOItensPedido(
      AItens:TObjectList<TItensPedidos>;
      AIDItemPedido,
      AIDPedido:Integer;
      APrecoUnit,
      ADescontoValor,
      ATotal:Currency;
      ADescontoPercent,
      AQuantidade:Double;
      AProduto:TProdutosECF
      );

    //UPDATE
    procedure AtualizarDTOItensPedido(
      //ITEM ORIGINAL
      AIndiceItemOriginal:Integer;
      AItens:TObjectList<TItensPedidos>;

      //ITEM NOVO
      AIDItemPedido,
      AIDPedido,
      AIDProduto:Integer;
      APrecoUnit,
      ADescontoValor,
      ATotal:Currency;
      ADescontoPercent,
      AQuantidade:Double;
      AProduto:TProdutosECF
    );

    //DELETE
    procedure DeletarDTOItensPedido(AItem:TItensPedidos);

  End;

  type TAppItensPedidos = class(TInterfacedObject,IAppItensPedidos)
    public

    //CRUD
    Function BuscarItensPedido:TObjectList<TItensPedidos>;
    Function BuscarItemPedidoByID(ACodigo:Integer):TItensPedidos;
    Function BuscarITensDoPedido(AID:Integer):TObjectList<TItensPedidos>;
    procedure BuscarPedidosLegado(AID: String);
    procedure InserirItemPedido(
      AIDPedido: Integer;
      AIDProduto: Integer;
      AQuantidade: Double;
      APrecoUnit: Currency;
      ADescontoPercent: Double;
      ADescontoValor: Currency;
      ATotal: Currency
    );
    procedure InserirItensPedido(AItens:TObjectList<TItensPedidos>);
    procedure AtualizarItemPedido(
      FID: Integer;
      FIDPedido: Integer;
      FIDProduto: Integer;
      FQuantidade: Double;
      FPrecoUnit: Currency;
      FDescontoPercent: Double;
      FDescontoValor: Currency;
      FTotal: Currency
    );
    procedure AtualizarItensPedido(AItens:TObjectList<TItensPedidos>);
    procedure DeletarItemPedido(AID:Integer);

    //CRUD EM MEMÓRIA

    //CREATE
    procedure CriarDTOItensPedido(
      AItens:TObjectList<TItensPedidos>;
      AIDItemPedido,
      AIDPedido:Integer;
      APrecoUnit,
      ADescontoValor,
      ATotal:Currency;
      ADescontoPercent,
      AQuantidade:Double;
      AProduto:TProdutosECF
      );

    //UPDATE
    procedure AtualizarDTOItensPedido(
      //ITEM ORIGINAL
      AIndiceItemOriginal:Integer;
      AItens:TObjectList<TItensPedidos>;

      //ITEM NOVO
      AIDItemPedido,
      AIDPedido,
      AIDProduto:Integer;
      APrecoUnit,
      ADescontoValor,
      ATotal:Currency;
      ADescontoPercent,
      AQuantidade:Double;
      AProduto:TProdutosECF
    );

    //DELETE
    procedure DeletarDTOItensPedido(AItem:TItensPedidos);

    constructor Create(
    ARepItensPedido:IRepository<TItensPedidos>;
    ARepProduto:IRepository<TProdutosECF>
    );
    private
      FRepItensPedido: IRepository<TItensPedidos>;
      FRepProduto: IRepository<TProdutosECF>;
  end;

implementation

  //RECEBER REPOSITORY
  constructor TAppItensPedidos.Create(
    ARepItensPedido:IRepository<TItensPedidos>;
    ARepProduto:IRepository<TProdutosECF>
  );
  begin
    FRepItensPedido := ARepItensPedido;
    FRepProduto := ARepProduto;
  end;

  //SELECT *
  Function TAppItensPedidos.BuscarItensPedido:TObjectList<TItensPedidos>;
  begin
    Result := FRepItensPedido.SelectAll;
  end;

  //SELECT WHERE
  Function TAppItensPedidos.BuscarItemPedidoByID(ACodigo:Integer):TItensPedidos;
  var
  LIDItemPedido: String;
  LIDProduto: String;
  LITemPedido: TItensPedidos;
  begin
    LIDItemPedido := IntToStr(ACodigo);

    LITemPedido := FRepItensPedido.Select(LIDItemPedido);

    LIDProduto := IntToStr(LITemPedido.IDProduto);

    LITemPedido.Produto := FRepProduto.Select(LIDProduto);

    Result := LITemPedido;
  end;

  //SELECT * WHERE
  Function TAppItensPedidos.BuscarITensDoPedido(AID:Integer):TObjectList<TItensPedidos>;
  var
  LID: String;
  LITens: TObjectList<TItensPedidos>;
  LItem: TItensPedidos;
  begin
    LID := IntToStr(AID);
    LITens := Self.FRepItensPedido.SelectAllByColumn('ID_PEDIDO',LID);
    for LItem in LITens do
    begin
      LItem.Produto := FRepProduto.Select(IntToStr(LItem.IDProduto));
      //DEFINIR ITENS VINDOS DO BANCO COMO INALTERADOS
      LItem.State := siDefault;
    end;

    LID := IntToStr(AID);
    Result := LITens;
  end;

  //INSERT
  procedure TAppItensPedidos.InserirItemPedido(
      AIDPedido: Integer;
      AIDProduto: Integer;
      AQuantidade: Double;
      APrecoUnit: Currency;
      ADescontoPercent: Double;
      ADescontoValor: Currency;
      ATotal: Currency
    );
  var LItemPedido: TItensPedidos;
  begin
    LItemPedido := nil;
    try
     LItemPedido := TItensPedidos.Create(
      0,
      AIDPedido,
      AIDProduto,
      AQuantidade,
      APrecoUnit,
      ADescontoPercent,
      ADescontoValor,
      ATotal
     );

     FRepItensPedido.Insert(LItemPedido);
    finally
      LItemPedido.Free;
    end;
  end;

  //INSERIR VÁRIOS ITENS (JÁ PRONTOS)
  procedure TAppItensPedidos.InserirItensPedido(AItens:TObjectList<TItensPedidos>);
  var
  LItem: TItensPedidos;
  LID: String;
  begin
    for LItem in AItens do
    begin
      LID := IntToStr(LItem.Produto.Codigo);

      //INSERIR INTENS DELETADOS
      if not (LItem.State = siDeleted) then
      begin
        //INSERIR ITEM NO PEDIDO
        FRepItensPedido.Insert(LITem);

        //ATUALIZAR PRODUTO VENDIDO
        Self.FRepProduto.Update(LID,LITem.Produto);
      end;
    end;
  end;

  //UPDATE
  procedure TAppItensPedidos.AtualizarItemPedido(
      FID: Integer;
      FIDPedido: Integer;
      FIDProduto: Integer;
      FQuantidade: Double;
      FPrecoUnit: Currency;
      FDescontoPercent: Double;
      FDescontoValor: Currency;
      FTotal: Currency
    );
  var
  LItemPedido: TItensPedidos;
  LCodigo: String;
  begin
    LCodigo := IntToStr(FID);
    LItemPedido := nil;
    try
     LItemPedido := TItensPedidos.Create(
      FID,
      FIDPedido,
      FIDProduto,
      FQuantidade,
      FPrecoUnit,
      FDescontoPercent,
      FDescontoValor,
      FTotal
     );

     FRepItensPedido.Update(LCodigo,LItemPedido);
    finally
      LItemPedido.Free;
    end;
  end;

  //ATUALIZAR VÁRIOS ITENS
  procedure TAppItensPedidos.AtualizarItensPedido(AItens:TObjectList<TItensPedidos>);
  var
  LItem: TItensPedidos;
  LID: String;
  LIDProduto: String;
  begin
    for LItem in AItens do
    begin
      //ATUALIZAR ESTOQUE
      LIDProduto := IntToStr(LItem.Produto.Codigo);
      Self.FRepProduto.Update(LIDProduto,LITem.Produto);

      //ITENS FLAGADOS COMO CRIADOS
      if LItem.State = siCreated then
      begin
        //INSERIR ITEM
        Self.FRepItensPedido.Insert(LItem);
      end
      //ITENS FLAGADOS COMO DELETADOS
      else if LItem.State = siDeleted then
      begin
        //DELETAR ITEM
        Self.FRepItensPedido.Delete(LItem);
      end
      //ITENS FLAGADOS COMO ALTERADO
      else if LItem.State = siAltered then
      begin
        //ATUALIZAR ITEM
        LID := IntToStr(LItem.ID);
        Self.FRepItensPedido.Update(LID,LItem);
      end;
    end;
  end;

  //DELETE
  procedure TAppItensPedidos.DeletarItemPedido(AID:Integer);
  var
  LItemPedido: TItensPedidos;
  LCodigo: String;
  begin
    LCodigo := IntToStr(AID);
    LItemPedido := nil;
    try

      //CLASSE MÍNIMA APENAS PARA DELETE
     LItemPedido := TItensPedidos.Create(AID,0,0,0,0,0,0,0);
//     ShowMessage(IntToStr(LItemPedido.ID));
     FRepItensPedido.Delete(LItemPedido);
    finally
      LItemPedido.Free;
    end;
  end;

  //DATASET LEGADO
  procedure TAppItensPedidos.BuscarPedidosLegado(AID: String);
  var LSQL: String;
  begin
    LSQL := 'SELECT I.ID_ITEM,I.ID_PEDIDO,I.id_produto,P.PRO_NOME,'
    + 'I.quantidade,I.PRECO_UNIT,I.desconto_percent, I.DESCONTO_VALOR,'
    + 'I.TOTAL  FROM ITENS_PEDIDO I INNER JOIN produtos_ecf p on I.ID_PRODUTO = P.pro_codigo '
    + 'where ID_PEDIDO = ''' + AID + '''';;

    Self.FRepItensPedido.AtualizarDataSetFirebirdLegado(LSQL);
  end;

  //CRIAR DTO -> TRABALHAR COM OS ITENS EM MEMÓRIA
  procedure TAppItensPedidos.CriarDTOItensPedido(
    AItens:TObjectList<TItensPedidos>;
    AIDItemPedido,
    AIDPedido:Integer;
    APrecoUnit,
    ADescontoValor,
    ATotal:Currency;
    ADescontoPercent,
    AQuantidade:Double;
    AProduto:TProdutosECF
    );
  var LITemPedidos: TItensPedidos;
  begin
    LITemPedidos := TItensPedidos.Create(
    AIDItemPedido,
    AIDPedido,
    AProduto.Codigo,
    AQuantidade,
    APrecoUnit,
    ADescontoPercent,
    ADescontoValor,
    ATotal,
    //ENUM PARA INFORMAR PRODUTO NÃO ALTERADO
    siCreated,
    AProduto
    );

    //VALIDAÇÃO INTERNA
    LITemPedidos.Validar;

    //TRABALHAR ESTOQUE EM MEMÓRIA PARA AO FIM ATUALIZAR.
    LItemPedidos.DescontarEstoque;

    AItens.add(LITemPedidos);
  end;

  //ATUALIZAR DTO -> TRABALHAR COM OS ITENS EM MEMÓRIA
  procedure TAppItensPedidos.AtualizarDTOItensPedido(
      //ITEM ORIGINAL
      AIndiceItemOriginal:Integer;
      AItens:TObjectList<TItensPedidos>;

      //ITEM NOVO
      AIDItemPedido,
      AIDPedido,
      AIDProduto:Integer;
      APrecoUnit,
      ADescontoValor,
      ATotal:Currency;
      ADescontoPercent,
      AQuantidade:Double;
      AProduto:TProdutosECF
    );
    var
    LITemNovo: TItensPedidos;
    LITemAntigo: TItensPedidos;
    begin
      //BUSCAR ITEM ANTIGO NO ARRRAY
      LITemAntigo := AItens.Items[AIndiceItemOriginal];

      //DEVOLVER ANTIGO ESTOQUE
      LITemAntigo.DevolverEstoque;

      //ALTERAÇÃO NO MESMO PRODUTO
      if LITemAntigo.Produto.CodigoDeBarras = AProduto.CodigoDeBarras then
      begin
        //ATUALIZAR CONFIGURAÇÕES

        LITemAntigo.Quantidade := AQuantidade;
        LITemAntigo.DescontoPercent := ADescontoPercent;
        LITemAntigo.DescontoValor := ADescontoValor;
        LITemAntigo.Total := ATotal;

        //MARCAR COMO ALTERADO
        LITemAntigo.State :=  siAltered;

        //VERIFICAR SE ATUALIZAÇÃO ESTÁ OK
        LITemAntigo.Validar;

        //AJUSTAR NOVO ESTOQUE EM MEMÓRIA
        LITemAntigo.DescontarEstoque;
      end
      //ALTERAÇÃO DE PRODUTOS DIFERENTES
      else if LITemAntigo.Produto.CodigoDeBarras <> AProduto.CodigoDeBarras then
      begin
        //FLAG PARA LIMPAR ITEM ANTIGO DO BANCO
        LITemAntigo.State := siDeleted;

        //CRIAR NOVO ITEM
        LITemNovo := TItensPedidos.Create(
        AIDItemPedido,
        AIDPedido,
        AIDProduto,
        AQuantidade,
        APrecoUnit,
        ADescontoPercent,
        ADescontoValor,
        ATotal,
        //ENUM PARA INFORMAR PRODUTO NÃO ALTERADO
        siCreated,
        AProduto
        );

        //VERIFICAR SE NOVO ITEM ESTÁ OK
        LITemNovo.Validar;

        //AJUSTAR NOVO ESTOQUE EM MEMÓRIA
        LITemNovo.DescontarEstoque;

        AItens.Add(LITemNovo);
      end;
    end;

    //DELETAR DTO -> TRABALHAR COM OS ITENS EM MEMÓRIA
    procedure TAppItensPedidos.DeletarDTOItensPedido(AItem:TItensPedidos);
    begin
      //REGRAS DE NEGÓCIO PARA DELETE AQUI.
      AItem.DevolverEstoque;
      AItem.State := siDeleted;
    end;

end.
