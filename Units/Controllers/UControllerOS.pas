unit UControllerOS;

interface

uses UDomainOS,UIRepository,UAppOrdemServico, System.Generics.Collections,System.Classes, System.SysUtils, Vcl.Dialogs;

type IControllerOrdemServico = interface
  function BuscarOS(AID:Integer):TOrdemServico;
  procedure CadastrarOS(AIDCliente:Integer;ADataOS:TDate;AValor:Currency;AEstado:String);
  procedure AlterarOS(AID,AIDCliente:Integer;ADataOS:TDate;AValor:Currency;AEstado:String);
  procedure DeletarOS(AID:Integer);
end;

//CONTROLLER FORM O.S
type TControllerOrdemServico = class(TInterfacedObject,IControllerOrdemServico)
  public
    function BuscarOS(AID:Integer):TOrdemServico;
    procedure CadastrarOS(AIDCliente:Integer;ADataOS:TDate;AValor:Currency;AEstado:String);
    procedure AlterarOS(AID,AIDCliente:Integer;ADataOS:TDate;AValor:Currency;AEstado:String);
    procedure DeletarOS(AID:Integer);

    constructor Create(AApp:IAppOrdemServico;ARep:IRepository<TOrdemServico>);
  private
    FApp: IAppOrdemServico;
    FRep: IRepository<TOrdemServico>;
end;

implementation

  constructor TControllerOrdemServico.Create(AApp:IAppOrdemServico;ARep:IRepository<TOrdemServico>);
  begin
    Self.FApp := AApp;
    Self.FRep := ARep;
  end;

  //BUSCAR DADOS O.S
  function TControllerOrdemServico.BuscarOS(AID:Integer):TOrdemServico;
  begin
    Result := FApp.BuscarOSByID(AID);
  end;

  //CADASTRAR NOVA O.S
  procedure TControllerOrdemServico.CadastrarOS(AIDCliente:Integer;ADataOS:TDate;AValor:Currency;AEstado:String);
  begin
    try
      Self.FApp.InserirOS(AIDCliente,ADataOS,AValor,AEstado);
      Self.FRep.AtualizarDataSet;
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //ALTERAR NOVA O.S
  procedure TControllerOrdemServico.AlterarOS(AID,AIDCliente:Integer;ADataOS:TDate;AValor:Currency;AEstado:String);
  begin
    try
      Self.FApp.AtualizarOS(AID,AIDCliente,ADataOS,AValor,AEstado);
      Self.FRep.AtualizarDataSet;
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //DELETAR NOVA O.S
  procedure TControllerOrdemServico.DeletarOS(AID:Integer);
  begin
    try
      Self.FApp.DeletarOS(AID);
      Self.FRep.AtualizarDataSet;
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
    end;
  end;
end.
