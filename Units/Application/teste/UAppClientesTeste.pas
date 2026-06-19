unit UAppClientesTeste;

interface
 uses System.Generics.Collections,UDomainClientesTeste, System.SysUtils, Data.DB, Vcl.Dialogs,URepManager;

  type IAppClientes = Interface
    Function BuscarClientes:TObjectList<TCliente>;
    Function BuscarClienteByID(AID:Integer):TCliente;
    procedure InserirCliente(ANome,ACPF,AEstado:String);
    procedure AtualizarCliente(AID:Integer;ANome,ACPF,AEstado:String);
    procedure DeletarCliente(AID:Integer);

  End;

  type TAppClientes = class(TInterfacedObject,IAppClientes)
    public
      Function BuscarClientes:TObjectList<TCliente>;
      Function BuscarClienteByID(AID:Integer):TCliente;
      procedure InserirCliente(ANome,ACPF,AEstado:String);
      procedure AtualizarCliente(AID:Integer;ANome,ACPF,AEstado:String);
      procedure DeletarCliente(AID:Integer);

      constructor Create(ARep:TRepositoryManager);
    private

      FRepository: TRepositoryManager;

  end;

implementation

  //RECEBER REPOSITORY
  constructor TAppClientes.Create(ARep:TRepositoryManager);
  begin
    FRepository := ARep;
  end;

  Function TAppClientes.BuscarClientes:TObjectList<TCliente>;
  begin
    Result := FRepository.SelectAll<TCliente>;
  end;

  Function TAppClientes.BuscarClienteByID(AID:Integer):TCliente;
  var LID: String;
  begin
    LID := IntToStr(AID);
    Result := FRepository.Select<TCliente>(LID);
  end;

  procedure TAppClientes.InserirCliente(ANome,ACPF,AEstado:String);
  var LCliente: TCliente;
  begin
    LCliente := nil;
    try
     LCliente := TCliente.Create(0,ANome,ACPF,AEstado);

      //REGRA DE NEGÓCIO - VALIDAR DOMÍNIO CLIENTE
     LCliente.Validar;

     FRepository.Insert<TCliente>(LCliente);
    finally
      LCliente.Free;
    end;
  end;

  procedure TAppClientes.AtualizarCliente(AID:Integer;ANome,ACPF,AEstado:String);
  var
  LCliente: TCliente;
  LID: String;
  begin
    LID := IntToStr(AID);
    LCliente := nil;
    try
     LCliente := TCliente.Create(AID,ANome,ACPF,AEstado);

     //REGRA DE NEGÓCIO - VALIDAR DOMÍNIO CLIENTE
     LCliente.Validar;

     FRepository.Update<TCliente>(LID,LCliente);
    finally
      LCliente.Free;
    end;
  end;

  procedure TAppClientes.DeletarCliente(AID:Integer);
  var
  LCliente: TCliente;
  LID: String;
  begin
    LID := IntToStr(AID);
    LCliente := nil;
    try
      //CLASSE MÍNIMA APENAS PARA DELETE
     LCliente := TCliente.Create(AID,'','','');
     FRepository.Delete<TCliente>(LCliente);
    finally
      LCliente.Free;
    end;
  end;

end.
