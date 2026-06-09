unit UControllerFormasPGTO;

interface

uses UDomainFormasPGTO,UIRepository,UAppFormasPGTO, System.Generics.Collections,System.Classes, System.SysUtils, Vcl.Dialogs;

type IControllerFormasPGTO = interface
    function BuscarFormaPGTO(ACOD:Integer):TFormasPGTO;
    procedure CadastrarFormaPGTO(ANome:String;AParcelas:Integer;AJuros:Currency);
    procedure AlterarFormaPGTO(ACOD:Integer;ANome:String;AParcelas:Integer;AJuros:Currency);
    procedure DeletarFormaPGTO(ACOD:Integer);
end;

//CONTROLLER FORM CLIENTES PAGAMENTO
type TControllerFormasPGTO = class(TInterfacedObject,IControllerFormasPGTO)
  public
    function BuscarFormaPGTO(ACOD:Integer):TFormasPGTO;
    procedure CadastrarFormaPGTO(ANome:String;AParcelas:Integer;AJuros:Currency);
    procedure AlterarFormaPGTO(ACOD:Integer;ANome:String;AParcelas:Integer;AJuros:Currency);
    procedure DeletarFormaPGTO(ACOD:Integer);

    constructor Create(AApp:IAppFormasPGTO;ARep:IRepository<TFormasPGTO>);
  private
    FApp: IAppFormasPGTO;
    FRep: IRepository<TFormasPGTO>;
end;

implementation

  constructor TControllerFormasPGTO.Create(AApp:IAppFormasPGTO;ARep:IRepository<TFormasPGTO>);
  begin
    Self.FApp := AApp;
    Self.FRep := ARep;
  end;

  //BUSCAR
  function TControllerFormasPGTO.BuscarFormaPGTO(ACOD:Integer):TFormasPGTO;
  begin
    Result := FApp.BuscarFormasPGTOByID(ACOD);
  end;

  //CADASTRAR
  procedure TControllerFormasPGTO.CadastrarFormaPGTO(ANome:String;AParcelas:Integer;AJuros:Currency);
  var
  LParcelas: Integer;
  LJuros: Currency;
  begin
    try
      Self.FApp.InserirFormasPGTO(ANome,AParcelas,AJuros);
      Self.FRep.AtualizarDataSet;
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //ALTERAR
  procedure TControllerFormasPGTO.AlterarFormaPGTO(
  ACOD:Integer;
  ANome:String;
  AParcelas:Integer;
  AJuros:Currency
  );
  var LValor: Currency;
  begin
    try
      Self.FApp.AtualizarFormasPGTO(ACOD,ANome,AParcelas,AJuros);
      Self.FRep.AtualizarDataSet;
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //DELETAR
  procedure TControllerFormasPGTO.DeletarFormaPGTO(ACOD:Integer);
  begin
    try
      Self.FApp.DeletarFormasPGTO(ACOD);
      Self.FRep.AtualizarDataSet;
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
    end;
  end;
end.
