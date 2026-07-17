unit UAppItensPedidos;


interface
 uses System.Generics.Collections,UDomainItensPedidos, System.SysUtils, Data.DB, Vcl.Dialogs,UIRepository,UDomainProdutosECF;

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
    procedure AtualizarItensPedido(AIDPedido:Integer;AItens:TObjectList<TItensPedidos>);
    procedure DeletarItemPedido(AID:Integer);

    // AUX CRUD
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
    procedure AtualizarItensPedido(AIDPedido:Integer;AItens:TObjectList<TItensPedidos>);
    procedure DeletarItemPedido(AID:Integer);

    // AUX CRUD
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
  LItens: TItensPedidos;
  LID: String;
  begin
    for LItens in AItens do
    begin
      LID := IntToStr(LItens.Produto.Codigo);

      //ATUALIZAR PRODUTO VENDIDO
      Self.FRepProduto.Update(LID,LITens.Produto);

      //INSERIR ITEM NO PEDIDO
      FRepItensPedido.Insert(LItens);
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
  procedure TAppItensPedidos.AtualizarItensPedido(AIDPedido:Integer;AItens:TObjectList<TItensPedidos>);
  var LID: String;
  begin
    LID := IntToStr(AIDPedido);

    //LIMPAR ITENS DO PEDIDO
    Self.FRepItensPedido.ExecSQL('DELETE FROM ITENS_PEDIDO WHERE ID_PEDIDO = ''' + LID + '''');
    //INSERIR LISTA DE ITENS
    Self.InserirItensPedido(AItens);
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

    Self.FRepItensPedido.OpenFirebirdLegado(LSQL);
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
    siNotAltered,
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
        siNotAltered,
        AProduto
        );

        //VERIFICAR SE NOVO ITEM ESTÁ OK
        LITemNovo.Validar;

        //AJUSTAR NOVO ESTOQUE EM MEMÓRIA
        LITemNovo.DescontarEstoque;

        AItens.Add(LITemNovo);
      end;
    end;

end.
