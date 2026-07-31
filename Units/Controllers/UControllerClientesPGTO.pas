unit UControllerClientesPGTO;

interface

uses UDomainClientesPGTO,UIRepository,UAppClientesPGTO,Data.DB, System.Generics.Collections,System.Classes,UFormatErrorText, System.SysUtils, Vcl.Dialogs,UErros;

type IControllerClientesPGTO = interface
  function BuscarClientePGTO(ACOD:Integer):TClientePGTO;
  procedure CadastrarClientePGTO(ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito:String);
  procedure AlterarClientePGTO(ACOD:Integer;ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito:String);
  procedure DeletarClientePGTO(ACOD:Integer);
  procedure FiltrarClientesPGTO(AFiltro:String);

  procedure ReceberDataset(ADataSet: TDataSet);
  procedure AtualizarDataSet;
end;

//CONTROLLER FORM CLIENTES PAGAMENTO
type TControllerClientesPGTO = class(TInterfacedObject,IControllerClientesPGTO)
  public
    function BuscarClientePGTO(ACOD:Integer):TClientePGTO;
    procedure CadastrarClientePGTO(ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito:String);
    procedure AlterarClientePGTO(ACOD:Integer;ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito:String);
    procedure DeletarClientePGTO(ACOD:Integer);
    procedure FiltrarClientesPGTO(AFiltro:String);

    procedure ReceberDataset(ADataSet: TDataSet);
    procedure AtualizarDataSet;

    constructor Create(AApp:IAppClientesPGTO);
  private
    FApp: IAppClientesPGTO;
end;

implementation

  constructor TControllerClientesPGTO.Create(AApp:IAppClientesPGTO);
  begin
    Self.FApp := AApp;
  end;

  //PASSAR DATASET PARA REPOSITORY
  procedure TControllerClientesPGTO.ReceberDataset(ADataSet: TDataSet);
  begin
    FApp.ReceberDataSet(ADataSet);
  end;

  //ATUALIZAR DATASET
  procedure TControllerClientesPGTO.AtualizarDataSet;
  begin
    FApp.AtualizarDataSet;
  end;

  //BUSCAR
  function TControllerClientesPGTO.BuscarClientePGTO(ACOD:Integer):TClientePGTO;
  begin
    Result := FApp.BuscarClientePGTOByID(ACOD);
  end;

  //CADASTRAR
  procedure TControllerClientesPGTO.CadastrarClientePGTO(
  ANome,
  AEndereco,
  ANum,
  AFone,
  APessoa,
  ADocumento,
  AAtivo,
  AEmail,
  ALimiteCredito: String
  );
  var
  LLimiteCredito: Currency;
  begin
    //CONVERSÕES
    LLimiteCredito := StrToFloat(StringReplace(ALimiteCredito, '.', '', [rfReplaceAll]));

    Self.FApp.InserirClientePGTO(ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,LLimiteCredito);
    Self.FApp.AtualizarDataSet;
  end;

  //ALTERAR
  procedure TControllerClientesPGTO.AlterarClientePGTO(
  ACOD:Integer;
  ANome,
  AEndereco,
  ANum,
  AFone,
  APessoa,
  ADocumento,
  AAtivo,
  AEmail,
  ALimiteCredito:String
  );
  var LLimiteCredito: Currency;
  begin
    //CONVERSÕES
    LLimiteCredito := StrToFloat(StringReplace(ALimiteCredito, '.', '', [rfReplaceAll]));

    Self.FApp.AtualizarClientePGTO(ACOD,ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,LLimiteCredito);
    Self.FApp.AtualizarDataSet;
  end;

  //DELETAR
  procedure TControllerClientesPGTO.DeletarClientePGTO(ACOD:Integer);
  begin
    Self.FApp.DeletarClientePGTO(ACOD);
    Self.FApp.AtualizarDataSet;
  end;

  //FILTRAR
  procedure TControllerClientesPGTO.FiltrarClientesPGTO(AFiltro:String);
  begin
    Self.FApp.FiltrarDataSet(AFiltro);
  end;

end.
