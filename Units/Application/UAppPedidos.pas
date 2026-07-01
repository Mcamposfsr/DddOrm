unit UAppPedidos;


interface
 uses System.Generics.Collections,UDomainPedidos, System.SysUtils, Data.DB, Vcl.Dialogs,UIRepository;

  type IAppPedidos = Interface
    Function BuscarPedido:TObjectList<TPedidos>;
    Function BuscarPedidoByID(ACodigo:Integer):TPedidos;
    procedure InserirPedido(
    AIDCliente: Integer;
    ADataEmissao: TDate;
    ATotalLiquido: Currency
    );

    procedure AtualizarPedido(
      AID:Integer;
      AIDCliente: Integer;
      ADataEmissao: TDate;
      ATotalLiquido: Currency
    );
    procedure DeletarPedido(ACodigo:Integer);

  End;

  type TAppPedidos = class(TInterfacedObject,IAppPedidos)
    public
    Function BuscarPedido:TObjectList<TPedidos>;
    Function BuscarPedidoByID(ACodigo:Integer):TPedidos;
    procedure InserirPedido(
    AIDCliente: Integer;
    ADataEmissao: TDate;
    ATotalLiquido: Currency
    );

    procedure AtualizarPedido(
      AID:Integer;
      AIDCliente: Integer;
      ADataEmissao: TDate;
      ATotalLiquido: Currency
    );
    procedure DeletarPedido(ACodigo:Integer);

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
    ATotalLiquido: Currency
    );
  var LPedido: TPedidos;
  begin
    LPedido := nil;
    try
     LPedido := TPedidos.Create(
       0,
       AIDCliente,
       ADataEmissao,
       ATotalLiquido
     );
     FRepository.Insert(LPedido);
     ShowMessage(IntToStr(LPedido.ID));
    finally
      LPedido.Free;
    end;
  end;

  //UPDATE
  procedure TAppPedidos.AtualizarPedido(
      AID:Integer;
      AIDCliente: Integer;
      ADataEmissao: TDate;
      ATotalLiquido: Currency
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
     LPedido := TPedidos.Create(ACodigo,0,0,0);
     FRepository.Delete(LPedido);
    finally
      LPedido.Free;
    end;
  end;

end.
