unit UControllerClientes;

interface

uses UAppClientes, System.Generics.Collections, System.Classes, UDomainClientes, System.SysUtils,Vcl.Dialogs,UIRepository;

type IController = interface
  function BuscarCliente(AID:Integer):TCliente;
  procedure CadastrarCliente(ANome,ACPF,AEstado:String);
  procedure AlterarCLiente(AID:Integer;ANome,ACPF,AEstado:String);
  procedure DeletarCliente(AID:Integer);
end;

type TController = class(TInterfacedObject,IController)

  public
    function BuscarCliente(AID:Integer):TCliente;
//    procedure BuscarTodosOsClientes:TObjectList<TCliente>;
    procedure CadastrarCliente(ANome,ACPF,AEstado:String);
    procedure AlterarCLiente(AID:Integer;ANome,ACPF,AEstado:String);
    procedure DeletarCliente(AID:Integer);

    constructor Create(ARep:IRepository<TCliente>;AApp:IAppClientes);
  private
    //REPOSITÓRIO QUE ENGLOBA ORM(PARA ATUALIZAR DATASET).
    FRep: IRepository<TCliente>;

    //APLICATION - CONTROLE DE FLUXO.
    FApp: IAppClientes;
end;

implementation
  //CONSTRUCTOR
  constructor TController.Create(ARep:IRepository<TCliente>;AApp:IAppClientes);
  begin
    FRep := ARep;
    FApp := AApp;
  end;

  //BUSCAR CLIENTE
  function TController.BuscarCliente(AID:Integer):TCliente;
  begin
    Result := FApp.BuscarClienteByID(AID);
  end;

  //CADASTRO
  procedure TController.CadastrarCliente(ANome,ACPF,AEstado:String);
  begin
    try
      FApp.InserirCliente(ANome,ACPF,AEstado);
      FRep.AtualizarDataSet;
      ShowMessage('Cliente Cadastrado!');
    except
     on E: Exception do
      ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
    end;
  end;

  //ATUALIZAR CLIENTE
  procedure TController.AlterarCLiente(AID:Integer;ANome,ACPF,AEstado:String);
  begin
    try
      FApp.AtualizarCliente(AID,ANome,ACPF,AEstado);
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
