unit UControllerClientesPGTO;

interface

uses UDomainClientesPGTO,UIRepository,UAppClientesPGTO, System.Generics.Collections,System.Classes,UFormatErrorText, System.SysUtils, Vcl.Dialogs,UErros;

type IControllerClientesPGTO = interface
  function BuscarClientePGTO(ACOD:Integer):TClientePGTO;
  procedure CadastrarClientePGTO(ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito:String);
  procedure AlterarClientePGTO(ACOD:Integer;ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito:String);
  procedure DeletarClientePGTO(ACOD:Integer);
  procedure FiltrarClientesPGTO(AFiltro:String);
end;

//CONTROLLER FORM CLIENTES PAGAMENTO
type TControllerClientesPGTO = class(TInterfacedObject,IControllerClientesPGTO)
  public
    function BuscarClientePGTO(ACOD:Integer):TClientePGTO;
    procedure CadastrarClientePGTO(ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito:String);
    procedure AlterarClientePGTO(ACOD:Integer;ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito:String);
    procedure DeletarClientePGTO(ACOD:Integer);
    procedure FiltrarClientesPGTO(AFiltro:String);

    constructor Create(AApp:IAppClientesPGTO;ARep:IRepository<TClientePGTO>);
  private
    FApp: IAppClientesPGTO;
    FRep: IRepository<TClientePGTO>;
end;

implementation

  constructor TControllerClientesPGTO.Create(AApp:IAppClientesPGTO;ARep:IRepository<TClientePGTO>);
  begin
    Self.FApp := AApp;
    Self.FRep := ARep;
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
    Self.FRep.AtualizarDataSet;
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
    Self.FRep.AtualizarDataSet;
  end;

  //DELETAR
  procedure TControllerClientesPGTO.DeletarClientePGTO(ACOD:Integer);
  begin
    Self.FApp.DeletarClientePGTO(ACOD);
    Self.FRep.AtualizarDataSet;
  end;

  //FILTRAR
  procedure TControllerClientesPGTO.FiltrarClientesPGTO(AFiltro:String);
  begin
    Self.FRep.FiltrarDataSet('CLI_NOME',AFiltro);
  end;

end.
