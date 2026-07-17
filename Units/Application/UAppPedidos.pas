unit UAppPedidos;


interface
 uses System.Generics.Collections,UDomainPedidos, System.SysUtils, Data.DB, Vcl.Dialogs,UIRepository,dbebr.factory.interfaces,UDomainClientesPGTO;

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
    ); Overload;

    procedure InserirPedido(APedido:TPedidos); Overload;

    procedure AtualizarPedido(
      AID:Integer;
      AIDCliente: Integer;
      ADataEmissao: TDate;
      ATotalLiquido: Currency;
      ACodPedido: String
    ); Overload;

    procedure AtualizarPedido(
      APedido:TPedidos
    ); Overload;


    procedure DeletarPedido(ACodigo:Integer);
    //AUX
    procedure AtualizarTotalPedido(AID:Integer; ATotal:String);
    Function CriarDTOPedido(AIDPedido,AIDCliente:Integer;ACodPedido:String;ATotalLiquido:Currency;ADataEmissao:TDate;ACliente:TClientePGTO):TPedidos;

    //DATASET LEGADO
    procedure BuscarPedidosLegado;

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
    ); Overload;
    procedure InserirPedido(APedido:TPedidos); Overload;

    procedure AtualizarPedido(
      AID:Integer;
      AIDCliente: Integer;
      ADataEmissao: TDate;
      ATotalLiquido: Currency;
      ACodPedido: String
    ); Overload;
    procedure AtualizarPedido(
      APedido:TPedidos
    ); Overload;

    procedure DeletarPedido(ACodigo:Integer);

    //AUX
    procedure AtualizarTotalPedido(AID:Integer; ATotal:String);
    Function CriarDTOPedido(AIDPedido,AIDCliente:Integer;ACodPedido:String;ATotalLiquido:Currency;ADataEmissao:TDate;ACliente:TClientePGTO):TPedidos;


    //DATASET LEGADO
    procedure BuscarPedidosLegado;

    constructor Create(
    ARepPedidos:IRepository<TPedidos>;
    ARepClientes:IRepository<TClientePGTO>
    );

    private
    FRepPedidos: IRepository<TPedidos>;
    FRepClientes: IRepository<TClientePGTO>;
  end;

implementation

  //RECEBER REPOSITORY
  constructor TAppPedidos.Create(
    ARepPedidos:IRepository<TPedidos>;
    ARepClientes:IRepository<TClientePGTO>
    );
  begin
    FRepPedidos := ARepPedidos;
    FRepClientes := ARepClientes;
  end;

  //SELECT *
  Function TAppPedidos.BuscarPedido:TObjectList<TPedidos>;
  begin
    Result := FRepPedidos.SelectAll;
  end;

  //SELECT WHERE
  Function TAppPedidos.BuscarPedidoByID(ACodigo:Integer):TPedidos;
  var
  LIDPedido: String;
  LIDCliente: String;
  LTPedidos: TPedidos;
  begin
    LIDPedido := IntToStr(ACodigo);
    //BUSCAR PEDIDO
    LTPedidos := FRepPedidos.Select(LIDPedido);

    LIDCliente := IntToStr(LTPedidos.IDCliente);

    //BUSCAR CLIENTE - JOIN MANUAL
    LTPedidos.Cliente := FRepClientes.Select(LIDCliente);

    Result := LTPedidos;
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

     LPedido.Validar;

     FRepPedidos.Insert(LPedido);
    finally
      LPedido.Free;
    end;
  end;

  //INSERT  - DTO PRONTO
  procedure TAppPedidos.InserirPedido(APedido: TPedidos);
  begin
    APedido.Validar;
    FRepPedidos.Insert(APedido);
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
  LID: String;
  begin
    LID := IntToStr(AID);
    LPedido := nil;
    try
     LPedido := TPedidos.Create(
      AID,
      AIDCliente,
      ADataEmissao,
      ATotalLiquido
      ,ACodPedido
     );

     LPedido.Validar;

     FRepPedidos.Update(LID,LPedido);
    finally
      LPedido.Free;
    end;
  end;

  //UPDATE - DTO PRONTO
  procedure TAppPedidos.AtualizarPedido(APedido: TPedidos);
  var LID: String;
  begin
    APedido.Validar;
    LID := IntToStr(APedido.ID);
    FRepPedidos.Update(LID,APedido);
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
     FRepPedidos.Delete(LPedido);
    finally
      LPedido.Free;
    end;
  end;

  //BUSCAR PEDIDO PELO CÓDIGO DO PEDIDO
  Function TAppPedidos.BuscarPedidoPeloCodigo(ACod:String): TPedidos;
  var
  LResultSet: IDBResultSet;
  LPedido: TPedidos;
  LIDCliente: String;
  LIDPedido: Integer;
  begin
    LResultSet := FRepPedidos.Open('SELECT * FROM PEDIDOS WHERE NUMERO_PEDIDO = ''' + ACod + '''');
    LIDPedido := LResultSet.DataSet.FieldByName('ID_PEDIDO').AsInteger;
    LPedido := Self.BuscarPedidoByID(LIDPedido);


    LIDCliente := IntToStr(LPedido.IDCliente);

    //JOIN MANUAL
    LPedido.Cliente := Self.FRepClientes.Select(LIDCliente);

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
    Self.FRepPedidos.ExecSQL(LSQL);
  end;

  //CRIAR E RETORNAR DTO PEDIDOS
  Function TAppPedidos.CriarDTOPedido(
  AIDPedido,
  AIDCliente:Integer;
  ACodPedido:String;
  ATotalLiquido:Currency;
  ADataEmissao:TDate;
  ACliente:TClientePGTO
  ):TPedidos;
  var LPedido: TPedidos;
  begin
    LPedido :=  TPedidos.Create(
    AIDPedido,
    AIDCliente,
    ADataEmissao,
    ATotalLiquido,
    ACodPedido,
    ACliente
    );

    LPedido.Validar;

    Result := LPedido;
  end;

  //DATASET LEGADO
  procedure TAppPedidos.BuscarPedidosLegado;
  var LSQL: String;
  begin
    LSQL := 'SELECT P.ID_PEDIDO, P.NUMERO_PEDIDO,C.CLI_NOME,C.CLI_DOCUMENTO,P.DATA_EMISSAO,P.TOTAL_LIQUIDO ' +
    'FROM PEDIDOS P INNER JOIN CLIENTES_PGTO C ON C.cli_codigo = P.id_cliente';

    Self.FRepPedidos.OpenFirebirdLegado(LSQL);
  end;

end.
