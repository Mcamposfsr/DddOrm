unit UBootsTrapClientesPGTO;

interface

uses UDomainClientesPGTO,UDM,UGenericRep,UAppClientesPGTO,UControllerClientesPGTO,UIRepository,UErros;

type IBootsTrapClientesPGTO = interface
  function GetController: IControllerClientesPGTO;
  property Controller: IControllerClientesPGTO read GetController;
end;

type TBootsTrapClientesPGTO = class(TInterfacedObject,IBootsTrapClientesPGTO)
  private
    //FERRAMENTAS
    FRepository: IRepository<TClientePGTO>;
    FApplication: IAppClientesPGTO;
    FController: IControllerClientesPGTO;

    //EXPOSIÇÃO DAS FERRAMENTAS
    function GetController: IControllerClientesPGTO;

  public
    property Controller: IControllerClientesPGTO read GetController;

    //CRIAÇÃO DAS FERRAMENTAS
    constructor Create(ADM:TDM);
end;

implementation

  //CRIAÇÃO DAS FERRAMENTAS
  constructor TBootsTrapClientesPGTO.Create(ADM:TDM);
  begin
    //CRIAR REPOSITORY
    FRepository := TRepository<TClientePGTO>.Create(ADM.GetConnection);

    //CRIAR APPLICATION
    FApplication := TAppClientesPGTO.Create(FRepository);

    //CONTROLLER
    FController := TControllerClientesPGTO.Create(FApplication);
  end;

  // *** GETTERS ***
  function TBootsTrapClientesPGTO.GetController: IControllerClientesPGTO;
  begin
    Result := Self.FController;
  end;
end.
