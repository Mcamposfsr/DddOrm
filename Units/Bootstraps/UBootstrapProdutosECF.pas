unit UBootstrapProdutosECF;

interface

uses UDomainProdutosECF,UDM,UGenericRep,UAppProdutosECF,UControllerProdutosECF,UIRepository,UErros;

type IBootstrapProdutosEFC = interface
  function GetController: IControllerProdutosECF;
  property Controller: IControllerProdutosECF read GetController;
end;

type TBootstrapProdutosEFC = class(TInterfacedObject,IBootstrapProdutosEFC)
  private
    //FERRAMENTAS
    FRepository: IRepository<TProdutosECF>;
    FApplication: IAppProdutosECF;
    FController: IControllerProdutosECF;

    //EXPOSIÇÃO DAS FERRAMENTAS
    function GetController: IControllerProdutosECF;
  public
    property Controller: IControllerProdutosECF read GetController;

    //CRIAÇÃO DAS FERRAMENTAS
    constructor Create(ADM:TDM);
end;

implementation

  //CRIAÇÃO DAS FERRAMENTAS
  constructor TBootstrapProdutosEFC.Create(ADM:TDM);
  begin
    //CRIAR REPOSITORY
    FRepository := TRepository<TProdutosECF>.Create(ADM.GetConnection);

    //CRIAR APPLICATION
    FApplication := TAppProdutosECF.Create(FRepository);

    //CONTROLLER
    FController := TControllerProdutosECF.Create(FApplication,FRepository);
  end;

  function TBootstrapProdutosEFC.GetController: IControllerProdutosECF;
  begin
    Result := Self.FController;
  end;
end.
