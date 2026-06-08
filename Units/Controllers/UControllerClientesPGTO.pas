unit UControllerClientesPGTO;

interface

uses UDomainClientesPGTO,UIRepository,UAppClientesPGTO, System.Generics.Collections,System.Classes, System.SysUtils, Vcl.Dialogs;

type IControllerClientesPGTO = interface
  function BuscarClientePGTO(ACOD:Integer):TClientePGTO;
  procedure CadastrarClientePGTO(ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail:String;ALimiteCredito:Currency);
  procedure AlterarClientePGTO(ACOD:Integer;ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail:String;ALimiteCredito:Currency);
  procedure DeletarClientePGTO(ACOD:Integer);
end;

//CONTROLLER FORM CLIENTES PAGAMENTO
type TControllerClientesPGTO = class(TInterfacedObject,IControllerClientesPGTO)
  public
    function BuscarClientePGTO(ACOD:Integer):TClientePGTO;
    procedure CadastrarClientePGTO(ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail:String;ALimiteCredito:Currency);
    procedure AlterarClientePGTO(ACOD:Integer;ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail:String;ALimiteCredito:Currency);
    procedure DeletarClientePGTO(ACOD:Integer);

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
  AEmail:String;
  ALimiteCredito:Currency);
  var LValor: Currency;
  begin
    try
      Self.FApp.InserirClientePGTO(ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito);
      Self.FRep.AtualizarDataSet;
    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro: ' +  sLineBreak + E.Message);
      end;
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
  AEmail:String;
  ALimiteCredito:Currency
  );
  var LValor: Currency;
  begin
    try
      Self.FApp.AtualizarClientePGTO(ACOD,ANome,AEndereco,ANum,AFone,APessoa,ADocumento,AAtivo,AEmail,ALimiteCredito);
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
end.
