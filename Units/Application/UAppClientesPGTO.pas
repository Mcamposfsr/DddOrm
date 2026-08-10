unit UAppClientesPGTO;


interface
 uses
 //SYSTEM
 System.Generics.Collections,
 System.SysUtils,
 Data.DB,
 Vcl.Dialogs,
 //FERRAMENTAS
 UDomainClientesPGTO,
 UIRepository;

  type IAppClientesPGTO = Interface
    Function BuscarClientesPGTO:TObjectList<TClientePGTO>;
    Function BuscarClientePGTOByID(ACodigo:Integer):TClientePGTO;
    procedure InserirClientePGTO(ANome,AEndereco,ANumero,ATelefone,APessoa,ADocumento,AAtivo,AEmail:String;ALimiteCredito:Currency);
    procedure AtualizarClientePGTO(ACodigo:Integer;ANome,AEndereco,ANumero,ATelefone,APessoa,ADocumento,AAtivo,AEmail:String;ALimiteCredito:Currency);
    procedure DeletarClientePGTO(ACodigo:Integer);

    procedure ReceberDataSet(ADataSet: TDataSet);
    procedure AtualizarDataSet;
    procedure FiltrarDataSet(AFiltro: String);
  End;

  type TAppClientesPGTO = class(TInterfacedObject,IAppClientesPGTO)
    public
      Function BuscarClientesPGTO:TObjectList<TClientePGTO>;
      Function BuscarClientePGTOByID(ACodigo:Integer):TClientePGTO;
      procedure InserirClientePGTO(ANome,AEndereco,ANumero,ATelefone,APessoa,ADocumento,AAtivo,AEmail:String;ALimiteCredito:Currency);
      procedure AtualizarClientePGTO(ACodigo:Integer;ANome,AEndereco,ANumero,ATelefone,APessoa,ADocumento,AAtivo,AEmail:String;ALimiteCredito:Currency);
      procedure DeletarClientePGTO(ACodigo:Integer);

      procedure ReceberDataSet(ADataSet: TDataSet);
      procedure AtualizarDataSet;
      procedure FiltrarDataSet(AFiltro: String);

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

  //RECEBERDATASET
  procedure TAppClientesPGTO.ReceberDataSet(ADataSet: TDataSet);
  begin
    FRepository.ReceberDataSet(ADataSet);
  end;

  //ATUALIZAR DATASET
  procedure TAppClientesPGTO.AtualizarDataSet;
  begin
    FRepository.AtualizarDataSet;
  end;

  //FILTRAR DATASET
  procedure TAppClientesPGTO.FiltrarDataSet(AFiltro: String);
  begin
    FRepository.FiltrarDataSet('CLI_NOME',AFiltro);
  end;

  //SELECT *
  Function TAppClientesPGTO.BuscarClientesPGTO:TObjectList<TClientePGTO>;
  begin
    Result := FRepository.SelectAll;
  end;

  //SELECT WHERE
  Function TAppClientesPGTO.BuscarClientePGTOByID(ACodigo:Integer):TClientePGTO;
  var LID: String;
  begin
    LID := IntToStr(ACodigo);
    Result := FRepository.Select(LID);
  end;

  //INSERT
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

     //VALIDAR CAMPOS INTERNOS (REGRAS NO DOMAIN DO DDD)
     LCliente.ValidarCampos;

     FRepository.Insert(LCliente);
    finally
      LCliente.Free;
    end;
  end;

  //UPDATE
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

     //VALIDAR CAMPOS INTERNOS (REGRAS NO DOMAIN DO DDD)
     LCliente.ValidarCampos;

     FRepository.Update(LCodigo,LCliente);
    finally
      LCliente.Free;
    end;
  end;

  //DELETE
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
