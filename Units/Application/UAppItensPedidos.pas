unit UAppItensPedidos;


interface
 uses System.Generics.Collections,UDomainItensPedidos, System.SysUtils, Data.DB, Vcl.Dialogs,UIRepository;

  type IAppItensPedidos = Interface
    Function BuscarItensPedido:TObjectList<TItensPedidos>;
    Function BuscarItemPedidoByID(ACodigo:Integer):TItensPedidos;
    procedure InserirItemPedido(
      AIDPedido: Integer;
      AIDProduto: Integer;
      AQuantidade: Double;
      APrecoUnit: Currency;
      ADescontoPercent: Double;
      ADescontoValor: Currency;
      ATotal: Currency
    );

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
    procedure DeletarItemPedido(AID:Integer);
  End;

  type TAppItensPedidos = class(TInterfacedObject,IAppItensPedidos)
    public

    Function BuscarItensPedido:TObjectList<TItensPedidos>;
    Function BuscarItemPedidoByID(ACodigo:Integer):TItensPedidos;
    procedure InserirItemPedido(
      AIDPedido: Integer;
      AIDProduto: Integer;
      AQuantidade: Double;
      APrecoUnit: Currency;
      ADescontoPercent: Double;
      ADescontoValor: Currency;
      ATotal: Currency
    );

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
    procedure DeletarItemPedido(AID:Integer);
    constructor Create(ARep:IRepository<TItensPedidos>);
    private
      FRepository: IRepository<TItensPedidos>;
  end;

implementation

  //RECEBER REPOSITORY
  constructor TAppItensPedidos.Create(ARep:IRepository<TItensPedidos>);
  begin
    FRepository := ARep;
  end;

  //SELECT *
  Function TAppItensPedidos.BuscarItensPedido:TObjectList<TItensPedidos>;
  begin
    Result := FRepository.SelectAll;
  end;

  //SELECT WHERE
  Function TAppItensPedidos.BuscarItemPedidoByID(ACodigo:Integer):TItensPedidos;
  var LID: String;
  begin
    LID := IntToStr(ACodigo);
    Result := FRepository.Select(LID);
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

     FRepository.Insert(LItemPedido);
    finally
      LItemPedido.Free;
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
     LItemPedido := LItemPedido.Create(
      FID,
      FIDPedido,
      FIDProduto,
      FQuantidade,
      FPrecoUnit,
      FDescontoPercent,
      FDescontoValor,
      FTotal
     );

     FRepository.Update(LCodigo,LItemPedido);
    finally
      LItemPedido.Free;
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
     LItemPedido := LItemPedido.Create(AID,0,0,0,0,0,0,0);
     FRepository.Delete(LItemPedido);
    finally
      LItemPedido.Free;
    end;
  end;

end.
