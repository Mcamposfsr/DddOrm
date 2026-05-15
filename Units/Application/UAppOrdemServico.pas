unit UAppOrdemServico;

interface

uses UDomainOS, System.Generics.Collections, UIRepository, System.SysUtils,VCL.Dialogs;

type IAppOrdemServico = Interface
//    Function BuscarOS(AIDCliente:Integer):TObjectList<TOrdemServico>;
    Function BuscarOSByID(AID:Integer):TOrdemServico;
    procedure InserirOS(AIDCliente:Integer;ADataOS:TDate;AValor:Currency;AEstado:String);
    procedure AtualizarOS(AID,AIDCliente:Integer;ADataOS:TDate;AValor:Currency;AEstado:String);
    procedure DeletarOS(AID:Integer);

  End;

  type TAppOrdemServico = class(TInterfacedObject,IAppOrdemServico)
    public
//      Function BuscarOS(AID:Integer):TObjectList<TOrdemServico>;
      Function BuscarOSByID(AID:Integer):TOrdemServico;
      procedure InserirOS(AIDCliente:Integer;ADataOS:TDate;AValor:Currency;AEstado:String);
      procedure AtualizarOS(AID,AIDCliente:Integer;ADataOS:TDate;AValor:Currency;AEstado:String);
      procedure DeletarOS(AID:Integer);

      constructor Create(ARep:IRepository<TOrdemServico>);
    private

      FRepository: IRepository<TOrdemServico>;

  end;

implementation

  //RECEBER REPOSITORY
  constructor TAppOrdemServico.Create(ARep:IRepository<TOrdemServico>);
  begin
    FRepository := ARep;
  end;

  //BUSCAR ORDEM DE SERVIÇO
  Function TAppOrdemServico.BuscarOSByID(AID:Integer):TOrdemServico;
  var LID: String;
  begin
    LID := IntToStr(AID);
    Result := FRepository.Select(LID);
  end;



  //CADASTRAR OS
  procedure TAppOrdemServico.InserirOS(AIDCliente:Integer;ADataOS:TDate;AValor:Currency;AEstado:String);
  var LOS: TOrdemServico;
  begin
    LOS := nil;
    try
      LOS := TOrdemServico.Create(
      0,
      AIDCliente,
      ADataOS,
      AValor,
      AEstado
      );

      FRepository.Insert(LOS);
    finally
      LOS.Free;
    end;
  end;

  //ATUALIZAR OS
  procedure TAppOrdemServico.AtualizarOS(AID,AIDCliente:Integer;ADataOS:TDate;AValor:Currency;AEstado:String);
  var
  LOS: TOrdemServico;
  LID: String;
  begin
    LID := IntToStr(AID);
    LOS := nil;
    try
      LOS := TOrdemServico.Create(
      0,
      AIDCliente,
      ADataOS,
      AValor,
      AEstado
      );
      FRepository.Update(LID,LOS);
    finally
      LOS.Free;
    end;
  end;

  //DELETAR OS
  procedure TAppOrdemServico.DeletarOS(AID:Integer);
  var
  LOS: TOrdemServico;
  begin
    LOS := nil;
    try
      //CLASSE MÍNIMA PARA DELETE
      LOS := TOrdemServico.Create(
      AID,
      0,
      0,
      0,
      ''
      );

      FRepository.Delete(LOS);
    finally
      LOS.Free;
    end;
  end;

end.
