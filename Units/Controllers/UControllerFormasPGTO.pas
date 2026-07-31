unit UControllerFormasPGTO;

interface

uses UDomainFormasPGTO,UIRepository,UAppFormasPGTO, System.Generics.Collections,
System.Classes, System.SysUtils, Vcl.Dialogs, System.StrUtils,UErros,UFormatErrorText,Data.DB;

type IControllerFormasPGTO = interface
    function BuscarFormaPGTO(ACOD:Integer):TFormasPGTO;
    procedure CadastrarFormaPGTO(ANome,AParcelas,AJuros:String);
    procedure AlterarFormaPGTO(ACOD:Integer;ANome,AParcelas,AJuros:String);
    procedure DeletarFormaPGTO(ACOD:Integer);
    procedure FiltrarClientesPGTO(AFiltro:String);

    procedure ReceberDataset(ADataSet: TDataSet);
    procedure AtualizarDataSet;
end;

//CONTROLLER FORM CLIENTES PAGAMENTO
type TControllerFormasPGTO = class(TInterfacedObject,IControllerFormasPGTO)
  public
    function BuscarFormaPGTO(ACOD:Integer):TFormasPGTO;
    procedure CadastrarFormaPGTO(ANome,AParcelas,AJuros:String);
    procedure AlterarFormaPGTO(ACOD:Integer;ANome,AParcelas,AJuros:String);
    procedure DeletarFormaPGTO(ACOD:Integer);
    procedure FiltrarClientesPGTO(AFiltro:String);

    procedure ReceberDataset(ADataSet: TDataSet);
    procedure AtualizarDataSet;

    constructor Create(AApp:IAppFormasPGTO);
  private
    FApp: IAppFormasPGTO;
end;

implementation

  constructor TControllerFormasPGTO.Create(AApp:IAppFormasPGTO);
  begin
    Self.FApp := AApp;
  end;

  //PASSAR DATASET PARA REPOSITORY
  procedure TControllerFormasPGTO.ReceberDataset(ADataSet: TDataSet);
  begin
    FApp.ReceberDataSet(ADataSet);
  end;

  //ATUALIZAR DATASET
  procedure TControllerFormasPGTO.AtualizarDataSet;
  begin
    FApp.AtualizarDataSet;
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
    //CONVERSÕES
    LParcelas := StrToIntDef(AParcelas, -1);
    LJuros := StrToCurr(StringReplace(AJuros, '%', '', [rfReplaceAll]));

    Self.FApp.InserirFormasPGTO(ANome,LParcelas,LJuros);
    Self.FApp.AtualizarDataSet;
  end;

  //ALTERAR
  procedure TControllerFormasPGTO.AlterarFormaPGTO(ACOD:Integer;ANome,AParcelas,AJuros:String);
  var
  LParcelas: Integer;
  LJuros: Currency;
  begin
    //CONVERSÕES
    LParcelas := StrToInt(AParcelas);
    LJuros := StrToCurr(StringReplace(AJuros, '%', '', [rfReplaceAll]));

    Self.FApp.AtualizarFormasPGTO(ACOD,ANome,LParcelas,LJuros);
    Self.FApp.AtualizarDataSet;
  end;

  //DELETAR
  procedure TControllerFormasPGTO.DeletarFormaPGTO(ACOD:Integer);
  begin
    Self.FApp.DeletarFormasPGTO(ACOD);
    Self.FApp.AtualizarDataSet;
  end;

  //FILTRAR
  procedure TControllerFormasPGTO.FiltrarClientesPGTO(AFiltro:String);
  begin
    Self.FApp.FiltrarDataSet(AFiltro);
  end;
end.
