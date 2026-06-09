unit UAppClientesPGTO;


interface
 uses System.Generics.Collections,UDomainClientesPGTO, System.SysUtils, Data.DB, Vcl.Dialogs,UIRepository;

  type IAppClientesPGTO = Interface
    Function BuscarClientesPGTO:TObjectList<TClientePGTO>;
    Function BuscarClientePGTOByID(ACodigo:Integer):TClientePGTO;
    procedure InserirClientePGTO(ANome,AEndereco,ANumero,ATelefone,APessoa,ADocumento,AAtivo,AEmail:String;ALimiteCredito:Currency);
    procedure AtualizarClientePGTO(ACodigo:Integer;ANome,AEndereco,ANumero,ATelefone,APessoa,ADocumento,AAtivo,AEmail:String;ALimiteCredito:Currency);
    procedure DeletarClientePGTO(ACodigo:Integer);

  End;

  type TAppClientesPGTO = class(TInterfacedObject,IAppClientesPGTO)
    public
      Function BuscarClientesPGTO:TObjectList<TClientePGTO>;
      Function BuscarClientePGTOByID(ACodigo:Integer):TClientePGTO;
      procedure InserirClientePGTO(ANome,AEndereco,ANumero,ATelefone,APessoa,ADocumento,AAtivo,AEmail:String;ALimiteCredito:Currency);
      procedure AtualizarClientePGTO(ACodigo:Integer;ANome,AEndereco,ANumero,ATelefone,APessoa,ADocumento,AAtivo,AEmail:String;ALimiteCredito:Currency);
      procedure DeletarClientePGTO(ACodigo:Integer);

      constructor Create(ARep:IRepository<TClientePGTO>);
    private

      FRepository: IRepository<TClientePGTO>;

  end;

implementation

  //RECEBER REPOSITORY
  constructor TAppClientesPGTO.Create(ARep:IRepository<TClientePGTO>);
  begin
    FRepository := ARep;
  end;

  Function TAppClientesPGTO.BuscarClientesPGTO:TObjectList<TClientePGTO>;
  begin
    Result := FRepository.SelectAll;
  end;

  Function TAppClientesPGTO.BuscarClientePGTOByID(ACodigo:Integer):TClientePGTO;
  var LID: String;
  begin
    LID := IntToStr(ACodigo);
    Result := FRepository.Select(LID);
  end;

  procedure TAppClientesPGTO.InserirClientePGTO(
  ANome,
  AEndereco,
  ANumero,
  ATelefone,
  APessoa,
  ADocumento,
  AAtivo,
  AEmail:String;
  ALimiteCredito:Currency);
  var LCliente: TClientePGTO;
  begin
    LCliente := nil;
    try
     LCliente := TClientePGTO.Create(0,ANome,AEndereco,ANumero,ATelefone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito);
     FRepository.Insert(LCliente);
    finally
      LCliente.Free;
    end;
  end;

  procedure TAppClientesPGTO.AtualizarClientePGTO(
  ACodigo:Integer;
  ANome,
  AEndereco,
  ANumero,
  ATelefone,
  APessoa,
  ADocumento,
  AAtivo,
  AEmail:String;
  ALimiteCredito:Currency
  );
  var
  LCliente: TClientePGTO;
  LCodigo: String;
  begin
    LCodigo := IntToStr(ACodigo);
    LCliente := nil;
    try
     LCliente := TClientePGTO.Create(ACodigo,ANome,AEndereco,ANumero,ATelefone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito);
     FRepository.Update(LCodigo,LCliente);
    finally
      LCliente.Free;
    end;
  end;

  procedure TAppClientesPGTO.DeletarClientePGTO(ACodigo:Integer);
  var
  LCliente: TClientePGTO;
  LCodigo: String;
  begin
    LCodigo := IntToStr(ACodigo);
    LCliente := nil;
    try
      //CLASSE MÍNIMA APENAS PARA DELETE
     LCliente := TClientePGTO.Create(ACodigo,'','','','','','','','',0);
     FRepository.Delete(LCliente);
    finally
      LCliente.Free;
    end;
  end;

end.
