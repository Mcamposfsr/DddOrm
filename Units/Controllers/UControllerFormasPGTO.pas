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

  //PASSAR DATASET PARA REPOSITORY
  procedure TControllerFormasPGTO.ReceberDataset(ADataSet: TDataSet);
  begin
    FRep.ReceberDataSet(ADataSet);
  end;

  //ATUALIZAR DATASET
  procedure TControllerFormasPGTO.AtualizarDataSet;
  begin
    FRep.AtualizarDataSet;
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
    Self.FRep.AtualizarDataSet;
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
    Self.FRep.AtualizarDataSet;
  end;

  //DELETAR
  procedure TControllerFormasPGTO.DeletarFormaPGTO(ACOD:Integer);
  begin
    Self.FApp.DeletarFormasPGTO(ACOD);
    Self.FRep.AtualizarDataSet;
  end;

  //FILTRAR
  procedure TControllerFormasPGTO.FiltrarClientesPGTO(AFiltro:String);
  begin
    Self.FRep.FiltrarDataSet('FIN_NOME',AFiltro);
  end;
end.
