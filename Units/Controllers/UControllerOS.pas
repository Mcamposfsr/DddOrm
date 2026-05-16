unit UControllerOS;

interface

uses UDomainOS,UIRepository,UAppOrdemServico, System.Generics.Collections,System.Classes, System.SysUtils, Vcl.Dialogs;

type IControllerOrdemServico = interface
  function BuscarOS(AID:Integer):TOrdemServico;
  procedure CadastrarOS(AIDCliente:Integer;ADataOS:TDate;AValor,AEstado:String);
  procedure AlterarOS(AID,AIDCliente:Integer;ADataOS:TDate;AValor,AEstado:String);
  procedure DeletarOS(AID,AIDCliente:Integer);
end;

//CONTROLLER FORM O.S
type TControllerOrdemServico = class(TInterfacedObject,IControllerOrdemServico)
  public
    function BuscarOS(AID:Integer):TOrdemServico;
    procedure CadastrarOS(AIDCliente:Integer;ADataOS:TDate;AValor,AEstado:String);
    procedure AlterarOS(AID,AIDCliente:Integer;ADataOS:TDate;AValor,AEstado:String);
    procedure DeletarOS(AID,AIDCliente:Integer);

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
  procedure TControllerOrdemServico.CadastrarOS(AIDCliente:Integer;ADataOS:TDate;AValor,AEstado:String);
  var LValor: Currency;
  begin
    try
      if AValor = '' then
      raise Exception.Create('Valor inválido')
      else
        LValor := StrToCurr(AValor);

      Self.FApp.InserirOS(AIDCliente,ADataOS,LValor,AEstado);
      Self.FRep.AtualizarDataSetWhere('ID_CLIENTE',AIDCliente);
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //ALTERAR NOVA O.S
  procedure TControllerOrdemServico.AlterarOS(AID,AIDCliente:Integer;ADataOS:TDate;AValor,AEstado:String);
  var LValor: Currency;
  begin
    try
      if AValor = '' then
      raise Exception.Create('Valor inválido')
      else
        LValor := StrToCurr(AValor);

      Self.FApp.AtualizarOS(AID,AIDCliente,ADataOS,LValor,AEstado);
      Self.FRep.AtualizarDataSetWhere('ID_CLIENTE',AIDCliente);
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //DELETAR NOVA O.S
  procedure TControllerOrdemServico.DeletarOS(AID,AIDCliente:Integer);
  begin
    try
      Self.FApp.DeletarOS(AID);
      //ID CLIENTE PARA ATUALIZAR DATASET
      Self.FRep.AtualizarDataSetWhere('ID_CLIENTE',AIDCliente);
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
    end;
  end;
end.
