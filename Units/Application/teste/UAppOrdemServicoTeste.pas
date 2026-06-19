unit UAppOrdemServicoTeste;

interface

uses UDomainOSTeste, System.Generics.Collections, URepManager, System.SysUtils,VCL.Dialogs,UDomainClientesTeste;

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

      constructor Create(ARep:TRepositoryManager);
    private

      FRep: TRepositoryManager;
  end;

implementation

  //RECEBER REPOSITORY
  constructor TAppOrdemServico.Create(ARep:TRepositoryManager);
  begin
    FRep := ARep;
  end;

  //BUSCAR ORDEM DE SERVIÇO
  Function TAppOrdemServico.BuscarOSByID(AID:Integer):TOrdemServico;
  var LID: String;
  begin
    LID := IntToStr(AID);

    Result := FRep.Select<TOrdemServico>(LID);
  end;

//     <TOrdemServico>
//     <TCliente>

  //CADASTRAR OS
  procedure TAppOrdemServico.InserirOS(AIDCliente:Integer;ADataOS:TDate;AValor:Currency;AEstado:String);
  var
  LOS: TOrdemServico;
  LID: String;
  LCLiente: TCliente;
  begin
    LID := IntToStr(AIDCliente);
    LOS := nil;
    LCliente := nil;
    try
      LCliente := FRep.Select<TCliente>(LID);

      //REGRA DE FLUXO UTILIZANDO REPOSITORY CLIENTES
      LCliente.VerificarEstado;

      LOS := TOrdemServico.Create(
      0,
      AIDCliente,
      ADataOS,
      AValor,
      AEstado
      );

      LOS.Validar;

      FRep.Insert<TOrdemServico>(LOS);
    finally
      LCliente.Free;
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
      AID,
      AIDCliente,
      ADataOS,
      AValor,
      AEstado
      );

      LOS.Validar;

      FRep.Update<TOrdemServico>(LID,LOS);
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

      FRep.Delete<TOrdemServico>(LOS);
    finally
      LOS.Free;
    end;
  end;

end.
