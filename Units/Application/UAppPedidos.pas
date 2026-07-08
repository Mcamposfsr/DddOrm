unit UAppPedidos;


interface
 uses System.Generics.Collections,UDomainPedidos, System.SysUtils, Data.DB, Vcl.Dialogs,UIRepository,dbebr.factory.interfaces;

  type IAppPedidos = Interface
    //CRUD
    Function BuscarPedido:TObjectList<TPedidos>;
    Function BuscarPedidoPeloCodigo(ACod:String): TPedidos;
    Function BuscarPedidoByID(ACodigo:Integer):TPedidos;
    procedure InserirPedido(
    AIDCliente: Integer;
    ADataEmissao: TDate;
    ATotalLiquido: Currency;
    ACodPedido: String
    );

    procedure AtualizarPedido(
      AID:Integer;
      AIDCliente: Integer;
      ADataEmissao: TDate;
      ATotalLiquido: Currency;
      ACodPedido: String
    );
    procedure DeletarPedido(ACodigo:Integer);
    //AUX
    procedure AtualizarTotalPedido(AID:Integer; ATotal:String);

  End;

  type TAppPedidos = class(TInterfacedObject,IAppPedidos)
    public
    //CRUD
    Function BuscarPedido:TObjectList<TPedidos>;
    Function BuscarPedidoPeloCodigo(ACod:String): TPedidos;
    Function BuscarPedidoByID(ACodigo:Integer):TPedidos;
    procedure InserirPedido(
    AIDCliente: Integer;
    ADataEmissao: TDate;
    ATotalLiquido: Currency;
    ACodPedido: String
    );
    procedure AtualizarPedido(
      AID:Integer;
      AIDCliente: Integer;
      ADataEmissao: TDate;
      ATotalLiquido: Currency;
      ACodPedido: String
    );
    procedure DeletarPedido(ACodigo:Integer);

    //AUX
    procedure AtualizarTotalPedido(AID:Integer; ATotal:String);

    constructor Create(ARep:IRepository<TPedidos>);
    private
      FRepository: IRepository<TPedidos>;

  end;

implementation

  //RECEBER REPOSITORY
  constructor TAppPedidos.Create(ARep:IRepository<TPedidos>);
  begin
    FRepository := ARep;
  end;

  //SELECT *
  Function TAppPedidos.BuscarPedido:TObjectList<TPedidos>;
  begin
    Result := FRepository.SelectAll;
  end;

  //SELECT WHERE
  Function TAppPedidos.BuscarPedidoByID(ACodigo:Integer):TPedidos;
  var LID: String;
  begin
    LID := IntToStr(ACodigo);
    Result := FRepository.Select(LID);
  end;

  //INSERT
  procedure TAppPedidos.InserirPedido(
    AIDCliente: Integer;
    ADataEmissao: TDate;
    ATotalLiquido: Currency;
    ACodPedido: String
    );
  var LPedido: TPedidos;
  begin
    LPedido := nil;
    try
     LPedido := TPedidos.Create(
       -1,
       AIDCliente,
       ADataEmissao,
       ATotalLiquido,
       ACodPedido
     );
     FRepository.Insert(LPedido);
    finally
      LPedido.Free;
    end;
  end;

  //UPDATE
  procedure TAppPedidos.AtualizarPedido(
      AID:Integer;
      AIDCliente: Integer;
      ADataEmissao: TDate;
      ATotalLiquido: Currency;
      ACodPedido: String
    );
  var LPedido: TPedidos;
  LCodigo: String;
  begin
    LCodigo := IntToStr(AID);
    LPedido := nil;
    try
     LPedido := TPedidos.Create(
      AID,
      AIDCliente,
      ADataEmissao,
      ATotalLiquido
      ,ACodPedido
     );

     FRepository.Update(LCodigo,LPedido);
    finally
      LPedido.Free;
    end;
  end;

  //DELETE
  procedure TAppPedidos.DeletarPedido(ACodigo:Integer);
  var
  LPedido: TPedidos;
  LCodigo: String;
  begin
    LCodigo := IntToStr(ACodigo);
    LPedido := nil;
    try
      //CLASSE MÍNIMA APENAS PARA DELETE
     LPedido := TPedidos.Create(ACodigo,0,0,0,'');
     FRepository.Delete(LPedido);
    finally
      LPedido.Free;
    end;
  end;

  //BUSCAR PEDIDO PELO CÓDIGO DO PEDIDO
  Function TAppPedidos.BuscarPedidoPeloCodigo(ACod:String): TPedidos;
  var
  LResultSet: IDBResultSet;
  LPedido: TPedidos;
  LID: Integer;
  begin
    LResultSet := FRepository.Open('SELECT * FROM PEDIDOS WHERE NUMERO_PEDIDO = ''' + ACod + '''');
    LID := LResultSet.DataSet.FieldByName('ID_PEDIDO').AsInteger;
    LPedido := Self.BuscarPedidoByID(LID);

     Result := LPedido;
  end;

  //ATUALIZAR VALOR TOTAL DO PEDIDO
  procedure TAppPedidos.AtualizarTotalPedido(AID:Integer; ATotal:String);
  var
  LID: String;
  LTotal: String;
  LSQL: String;
  begin
    LID := IntToStr(AID);
    LTotal := StringReplace(ATotal,',','.',[rfReplaceAll]);
    LSQL := 'UPDATE PEDIDOS SET TOTAL_LIQUIDO = ' + LTotal + ' WHERE ID_PEDIDO = ' + LID;
    Self.FRepository.ExecSQL(LSQL);
  end;

end.
