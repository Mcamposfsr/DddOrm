unit UControllerFormasPGTO;

interface

uses UDomainFormasPGTO,UIRepository,UAppFormasPGTO, System.Generics.Collections,System.Classes, System.SysUtils, Vcl.Dialogs;

type IControllerFormasPGTO = interface
    function BuscarFormaPGTO(ACOD:Integer):TFormasPGTO;
    procedure CadastrarFormaPGTO(ANome,AParcelas,AJuros:String);
    procedure AlterarFormaPGTO(ACOD:Integer;ANome,AParcelas,AJuros:String);
    procedure DeletarFormaPGTO(ACOD:Integer);
    procedure FiltrarClientesPGTO(ANome:String);
end;

//CONTROLLER FORM CLIENTES PAGAMENTO
type TControllerFormasPGTO = class(TInterfacedObject,IControllerFormasPGTO)
  public
    function BuscarFormaPGTO(ACOD:Integer):TFormasPGTO;
    procedure CadastrarFormaPGTO(ANome,AParcelas,AJuros:String);
    procedure AlterarFormaPGTO(ACOD:Integer;ANome,AParcelas,AJuros:String);
    procedure DeletarFormaPGTO(ACOD:Integer);
    procedure FiltrarClientesPGTO(ANome:String);

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
  procedure TControllerFormasPGTO.CadastrarFormaPGTO(ANome,AParcelas,AJuros:String);
  var
  LParcelas: Integer;
  LJuros: Currency;
  begin
    try
      LParcelas := StrToInt(AParcelas);
      LJuros := StrToCurr(StringReplace(AJuros, '%', '', [rfReplaceAll]));

      Self.FApp.InserirFormasPGTO(ANome,LParcelas,LJuros);
      Self.FRep.AtualizarDataSet;
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //ALTERAR
  procedure TControllerFormasPGTO.AlterarFormaPGTO(ACOD:Integer;ANome,AParcelas,AJuros:String);
  var
  LParcelas: Integer;
  LJuros: Currency;
  begin
    try
      LParcelas := StrToInt(AParcelas);
      LJuros := StrToCurr(StringReplace(AJuros, '%', '', [rfReplaceAll]));

      Self.FApp.AtualizarFormasPGTO(ACOD,ANome,LParcelas,LJuros);
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

  //FILTRAR
  procedure TControllerFormasPGTO.FiltrarClientesPGTO(ANome:String);
  begin
    try
      Self.FRep.FiltrarDataSet('FIN_NOME',ANome);
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
    end;
  end;
end.
