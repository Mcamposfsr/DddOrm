unit UBootstrapPedidos;

interface

uses
//FERRAMENTAS
UDM,
UGenericRep,
UIRepository,
UErros,
//DOMAINS
UDomainClientesPGTO,
UDomainProdutosECF,
UDomainPedidos,
UDomainItensPedidos,
//APPS
UAppProdutosECF,
UAppPedidos,
UAppItensPedidos,
UAppClientesPGTO,
//CONTROLLERS
UControllerPedidos, //POSSUI PEDIDOS E ITENS PEDIDOS INTERNAMENTE
UControllerClientesPGTO,
UControllerProdutosECF;

type IBootstrapPedidos = interface
  //CLIENTES
  function GetControllerClientes: IControllerClientesPGTO;
  property ControllerClientes: IControllerClientesPGTO read GetControllerClientes;

  //PEDIDOS
  function GetControllerPedidos: IControllerPedidos;
  property ControllerPedidos: IControllerPedidos read GetControllerPedidos;

  //PRODUTOS
  function GetControllerProdutoECF: IControllerProdutosECF;
  property ControllerProdutosECF: IControllerProdutosECF read GetControllerProdutoECF;
end;

type TBootstrapPedidos = class(TInterfacedObject,IBootstrapPedidos)
  private
    //FERRAMENTAS

    //CLIENTES
    FRepositoryClientes: IRepository<TClientePGTO>;
    FApplicationClientes: IAppClientesPGTO;
    FControllerClientes: IControllerClientesPGTO;

    //PEDIDOS
    FRepositoryPedidos: IRepository<TPedidos>;
    FRepositoryItensPedidos: IRepository<TItensPedidos>;
    FApplicationPedidos: IAppPedidos;
    FApplicationItensPedidos: IAppItensPedidos;
    FControllerPedidos: IControllerPedidos;

    //PRODUTOS
    FRepositoryProdutosECF: IRepository<TProdutosECF>;
    FApplicationProdutosECF: IAppProdutosECF;
    FControllerProdutosECF: IControllerProdutosECF;

    function GetControllerClientes: IControllerClientesPGTO;
    function GetControllerPedidos: IControllerPedidos;
    function GetControllerProdutoECF: IControllerProdutosECF;
  public

    property ControllerClientes: IControllerClientesPGTO read GetControllerClientes;
    property ControllerPedidos: IControllerPedidos read GetControllerPedidos;
    property ControllerProdutosECF: IControllerProdutosECF read GetControllerProdutoECF;

    //CRIAÇÃO DAS FERRAMENTAS
    constructor Create(ADM:TDM);
end;

implementation

  //CRIAÇÃO DE FERRAMENTAS
  constructor TBootstrapPedidos.Create(ADM:TDM);
  begin
    //CRIAR REPOSITORY
    FRepositoryClientes := TRepository<TClientePGTO>.Create(ADM.GetConnection);
    FRepositoryPedidos :=  TRepository<TPedidos>.Create(ADM.GetConnection);
    FRepositoryItensPedidos := TRepository<TItensPedidos>.Create(ADM.GetConnection);
    FRepositoryProdutosECF :=  TRepository<TProdutosECF>.Create(ADM.GetConnection);

    //CRIAR APPLICATION
    FApplicationClientes := TAppClientesPGTO.Create(FRepositoryClientes);
    FApplicationPedidos := TAppPedidos.Create(FRepositoryPedidos,FRepositoryClientes);
    FApplicationItensPedidos := TAppItensPedidos.Create(FRepositoryItensPedidos,FRepositoryProdutosECF);
    FApplicationProdutosECF := TAppProdutosECF.Create(FRepositoryProdutosECF);

    //CONTROLLER
    FControllerClientes := TControllerClientesPGTO.Create(FApplicationClientes,FRepositoryClientes);

    FControllerPedidos := TControllerPedidos.Create(
    ADM.GetConnection,
    FApplicationPedidos,
    FRepositoryPedidos,
    FApplicationItensPedidos,
    FRepositoryItensPedidos,
    FApplicationProdutosECF,
    FRepositoryProdutosECF
    );

    FControllerProdutosECF := TControllerProdutosECF.Create(FApplicationProdutosECF,FRepositoryProdutosECF);
  end;

  // *** GETTERS ***

  //CLIENTES
  function TBootstrapPedidos.GetControllerClientes: IControllerClientesPGTO;
  begin
    Result := Self.FControllerClientes;
  end;

  //PEDIDOS
  function TBootstrapPedidos.GetControllerPedidos: IControllerPedidos;
  begin
    Result := Self.FControllerPedidos;
  end;

  //PRODUTOS
  function TBootstrapPedidos.GetControllerProdutoECF: IControllerProdutosECF;
  begin
    Result := Self.FControllerProdutosECF;
  end;


end.
