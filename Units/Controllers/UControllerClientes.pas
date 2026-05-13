unit UControllerClientes;

interface

uses UAppClientes, System.Generics.Collections, System.Classes, UDomainClientes, System.SysUtils,Vcl.Dialogs;

type IController = interface
  function BuscarCliente(AID:Integer):TComp;
  procedure CadastrarCliente(ACPF,ANome:String);
  procedure AlterarCLiente(AID:Integer;ANome,ACPF:String);
  procedure DeletarCliente(AID:Integer);
end;

type TController = class(TInterfacedObject,IController)

  public
    function BuscarCliente(AID:Integer):TComp;
//    procedure BuscarTodosOsClientes:TObjectList<TComp>;
    procedure CadastrarCliente(ANome,ACPF:String);
    procedure AlterarCLiente(AID:Integer;ANome,ACPF:String);
    procedure DeletarCliente(AID:Integer);

    constructor Create(ARep:IRepository<TComp>;AApp:IApp);
  private
    //REPOSITÓRIO QUE ENGLOBA ORM(PARA ATUALIZAR DATASET).
    FRep: IRepository<TComp>;

    //APLICATION - CONTROLE DE FLUXO.
    FApp: IApp;
end;

implementation
  //CONSTRUCTOR
  constructor TController.Create(ARep:IRepository<TComp>;AApp:IApp);
  begin
    FRep := ARep;
    FApp := AApp;
  end;

  //BUSCAR CLIENTE
  function TController.BuscarCliente(AID:Integer):TComp;
  begin
    Result := FApp.BuscarClienteByID(AID);
  end;

  //CADASTRO
  procedure TController.CadastrarCliente(ANome,ACPF:String);
  begin
    try
      FApp.InserirCliente(ANome,ACPF);
      FRep.AtualizarDataSet;
      ShowMessage('Cliente Cadastrado!');
    except
     on E: Exception do
      ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
    end;
  end;

  //ATUALIZAR CLIENTE
  procedure TController.AlterarCLiente(AID:Integer;ANome,ACPF:String);
  begin
    try
      FApp.AtualizarCliente(AID,ANome,ACPF);
      FRep.AtualizarDataSet;
      ShowMessage('Cliente Alterado!');
    except
     on E: Exception do
      ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
    end;

  end;

  //DELETAR CLIENTE
  procedure TController.DeletarCliente(AID:Integer);
  begin
    FApp.DeletarCliente(AID);
    FRep.AtualizarDataSet;
  end;

end.
