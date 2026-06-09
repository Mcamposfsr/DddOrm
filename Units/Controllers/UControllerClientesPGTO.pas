unit UControllerClientesPGTO;

interface

uses UDomainClientesPGTO,UIRepository,UAppClientesPGTO, System.Generics.Collections,System.Classes, System.SysUtils, Vcl.Dialogs;

type IControllerClientesPGTO = interface
  function BuscarClientePGTO(ACOD:Integer):TClientePGTO;
  procedure CadastrarClientePGTO(ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito:String);
  procedure AlterarClientePGTO(ACOD:Integer;ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito:String);
  procedure DeletarClientePGTO(ACOD:Integer);
  procedure FiltrarClientesPGTO(ANome:String);
end;

//CONTROLLER FORM CLIENTES PAGAMENTO
type TControllerClientesPGTO = class(TInterfacedObject,IControllerClientesPGTO)
  public
    function BuscarClientePGTO(ACOD:Integer):TClientePGTO;
    procedure CadastrarClientePGTO(ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito:String);
    procedure AlterarClientePGTO(ACOD:Integer;ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito:String);
    procedure DeletarClientePGTO(ACOD:Integer);
    procedure FiltrarClientesPGTO(ANome:String);

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
    try
      //RETIRAR O '.' ANTES DA CONVERSÃO PARA EVITAR ERROS DE CONVERSÃO
      LLimiteCredito := StrToFloat(StringReplace(ALimiteCredito, '.', '', [rfReplaceAll]));
      Self.FApp.InserirClientePGTO(ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,LLimiteCredito);
      Self.FRep.AtualizarDataSet;
    except
      on E: Exception do
        ShowMessage('Ocorreu um erro: ' + sLineBreak + E.Message);
    end;
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
    try
      LLimiteCredito := StrToFloat(StringReplace(ALimiteCredito, '.', '', [rfReplaceAll]));
      Self.FApp.AtualizarClientePGTO(ACOD,ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,LLimiteCredito);
      Self.FRep.AtualizarDataSet;
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //DELETAR
  procedure TControllerClientesPGTO.DeletarClientePGTO(ACOD:Integer);
  begin
    try
      Self.FApp.DeletarClientePGTO(ACOD);
      Self.FRep.AtualizarDataSet;
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //FILTRAR
  procedure TControllerClientesPGTO.FiltrarClientesPGTO(ANome:String);
  begin
    try
      Self.FRep.FiltrarDataSet('CLI_NOME',ANome);
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
    end;
  end;
end.
