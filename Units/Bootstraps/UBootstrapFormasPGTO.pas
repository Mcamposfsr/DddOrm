unit UBootsTrapFormasPGTO;

interface

uses UDomainFormasPGTO,UDM,UGenericRep,UAppFormasPGTO,UControllerFormasPGTO,UIRepository,UErros;

type IBootstrapFormasPGTO = interface
  function GetController: IControllerFormasPGTO;
  property Controller: IControllerFormasPGTO read GetController;
end;

type TBootstrapFormasPGTO = class(TInterfacedObject,IBootstrapFormasPGTO)
  private
    //FERRAMENTAS
    FRepository: IRepository<TFormasPGTO>;
    FApplication: IAppFormasPGTO;
    FController: IControllerFormasPGTO;

    //EXPOSIÇÃO DAS FERRAMENTAS
    function GetController: IControllerFormasPGTO;

  public

    property Controller: IControllerFormasPGTO read GetController;

    //CRIAÇÃO DAS FERRAMENTAS
    constructor Create(ADM:TDM);
end;

implementation

  //CRIAÇÃO DAS FERRAMENTAS
  constructor TBootsTrapFormasPGTO.Create(ADM:TDM);
  begin
    //CRIAR REPOSITORY
    FRepository := TRepository<TFormasPGTO>.Create(ADM.GetConnection);

    //CRIAR APPLICATION
    FApplication := TAppFormasPGTO.Create(FRepository);

    //CONTROLLER
    FController := TControllerFormasPGTO.Create(FApplication,FRepository);
  end;

  // *** GETTERS ***
  function TBootsTrapFormasPGTO.GetController: IControllerFormasPGTO;
  begin
    Result := Self.FController;
  end;
end.
