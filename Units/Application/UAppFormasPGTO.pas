unit UAppFormasPGTO;


interface
 uses System.Generics.Collections,UDomainFormasPGTO, System.SysUtils, Data.DB, Vcl.Dialogs,UIRepository;

  type IAppFormasPGTO = Interface
    Function BuscarFormasPGTO:TObjectList<TFormasPGTO>;
    Function BuscarFormasPGTOByID(AID:Integer):TFormasPGTO;
    procedure InserirFormasPGTO(ANome:String;AParcelas:Integer;AJuros:Currency);
    procedure AtualizarFormasPGTO(ACodigo:Integer;ANome:String;AParcelas:Integer;AJuros:Currency);
    procedure DeletarFormasPGTO(ACodigo:Integer);

    procedure ReceberDataSet(ADataSet: TDataSet);
    procedure AtualizarDataSet;
    procedure FiltrarDataSet(AFiltro: String);
  End;

  type TAppFormasPGTO = class(TInterfacedObject,IAppFormasPGTO)
    public
      Function BuscarFormasPGTO:TObjectList<TFormasPGTO>;
      Function BuscarFormasPGTOByID(ACodigo:Integer):TFormasPGTO;
      procedure InserirFormasPGTO(ANome:String;AParcelas:Integer;AJuros:Currency);
      procedure AtualizarFormasPGTO(ACodigo:Integer;ANome:String;AParcelas:Integer;AJuros:Currency);
      procedure DeletarFormasPGTO(ACodigo:Integer);

      procedure ReceberDataSet(ADataSet: TDataSet);
      procedure AtualizarDataSet;
      procedure FiltrarDataSet(AFiltro: String);

      constructor Create(ARep:IRepository<TFormasPGTO>);
    private

      FRepository: IRepository<TFormasPGTO>;

  end;

implementation

  //RECEBER REPOSITORY
  constructor TAppFormasPGTO.Create(ARep:IRepository<TFormasPGTO>);
  begin
    FRepository := ARep;
  end;

  //RECEBERDATASET
  procedure TAppFormasPGTO.ReceberDataSet(ADataSet: TDataSet);
  begin
    FRepository.ReceberDataSet(ADataSet);
  end;

  //ATUALIZAR DATASET
  procedure TAppFormasPGTO.AtualizarDataSet;
  begin
    FRepository.AtualizarDataSet;
  end;

  //FILTRAR DATASET
  procedure TAppFormasPGTO.FiltrarDataSet(AFiltro: String);
  begin
    FRepository.FiltrarDataSet('FIN_NOME',AFiltro);
  end;


  //SELECT
  Function TAppFormasPGTO.BuscarFormasPGTO:TObjectList<TFormasPGTO>;
  begin
    Result := FRepository.SelectAll;
  end;

  //SELECT WHERE
  Function TAppFormasPGTO.BuscarFormasPGTOByID(ACodigo:Integer):TFormasPGTO;
  var LCodigo: String;
  begin
    LCodigo := IntToStr(ACodigo);
    Result := FRepository.Select(LCodigo);
  end;

  //INSERT
  procedure TAppFormasPGTO.InserirFormasPGTO(ANome:String;AParcelas:Integer;AJuros:Currency);
  var LFormasPGTO: TFormasPGTO;
  begin
    LFormasPGTO := nil;
    try
     LFormasPGTO := TFormasPGTO.Create(0,ANome,AParcelas,AJuros);

     LFormasPGTO.ValidarCampos;

     FRepository.Insert(LFormasPGTO);
    finally
      LFormasPGTO.Free;
    end;
  end;

  //UPDATE
  procedure TAppFormasPGTO.AtualizarFormasPGTO(ACodigo:Integer;ANome:String;AParcelas:Integer;AJuros:Currency);
  var
  LFormasPGTO: TFormasPGTO;
  LCodigo: String;
  begin
    LCodigo := IntToStr(ACodigo);
    LFormasPGTO := nil;
    try
     LFormasPGTO := TFormasPGTO.Create(ACodigo,ANome,AParcelas,AJuros);

     LFormasPGTO.ValidarCampos;

     FRepository.Update(LCodigo,LFormasPGTO);
    finally
      LFormasPGTO.Free;
    end;
  end;

  //DELETE
  procedure TAppFormasPGTO.DeletarFormasPGTO(ACodigo:Integer);
  var
  LFormasPGTO: TFormasPGTO;
  LCodigo: String;
  begin
    LCodigo := IntToStr(ACodigo);
    LFormasPGTO := nil;
    try
      //CLASSE MÍNIMA APENAS PARA DELETE
     LFormasPGTO := TFormasPGTO.Create(ACodigo,'',0,0);
     FRepository.Delete(LFormasPGTO);
    finally
      LFormasPGTO.Free;
    end;
  end;

end.
