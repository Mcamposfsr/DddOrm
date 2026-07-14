unit UAppItensPedidos;


interface
 uses System.Generics.Collections,UDomainItensPedidos, System.SysUtils, Data.DB, Vcl.Dialogs,UIRepository,UDomainProdutosECF;

  type IAppItensPedidos = Interface

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

  End;

  type TAppItensPedidos = class(TInterfacedObject,IAppItensPedidos)
    public

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

  //INSERIR VÁRIOS ITENS
  procedure TAppItensPedidos.InserirItensPedido(AItens:TObjectList<TItensPedidos>);
  var LItens: TItensPedidos;
  begin
    for LItens in AItens do
    begin
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

end.
