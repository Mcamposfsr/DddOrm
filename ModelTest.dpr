program ModelTest;

uses
  Vcl.Forms,
  System.IOUtils,
  System.SysUtils,
  UDM in 'Units\DM\UDM.pas',
  UGenericRep in 'Units\Repository\UGenericRep.pas',
  UCPFValidator in 'Units\Utils\UCPFValidator.pas',
  UIRepository in 'Units\Interfaces\UIRepository.pas',
  UDomainFormasPGTO in 'Units\Domain\UDomainFormasPGTO.pas',
  UDomainClientesPGTO in 'Units\Domain\UDomainClientesPGTO.pas',
  UAppClientesPGTO in 'Units\Application\UAppClientesPGTO.pas',
  UAppFormasPGTO in 'Units\Application\UAppFormasPGTO.pas',
  UControllerClientesPGTO in 'Units\Controllers\UControllerClientesPGTO.pas',
  UControllerFormasPGTO in 'Units\Controllers\UControllerFormasPGTO.pas',
  UFormCadastroFormaPGTO in 'Units\Forms\FormsSecundarios\UFormCadastroFormaPGTO.pas' {FormCadastroPGTO},
  UFormClientesPGTO in 'Units\Forms\UFormClientesPGTO.pas' {FormClientesPGTO},
  UFormFormasPGTO in 'Units\Forms\UFormFormasPGTO.pas' {FormFormasPGTO},
  UFormCadastroClientePGTO in 'Units\Forms\FormsSecundarios\UFormCadastroClientePGTO.pas' {FormCadastroClientes},
  UFormPrincipal in 'Units\Forms\UFormPrincipal.pas' {DDDORM};

//VARIÁVEL DE AJUSTE PARA BANCO.
  var LLocationDB: String;
{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  try


    // para banco Firebird 5
    LLocationDB := ExtractFilePath(ParamStr(0)) + '..\..\DataBase\TESTE.FDB';

    // para banco Firebird 1.5
//    LLocationDB := TPath.GetFullPath(ExtractFilePath(ParamStr(0)) + '\..\..\..\TESTE_ORM.FDB');

    GDM := TDM.Create(
    'SYSDBA',
    'masterkey',
    'localhost',
    '3050',
    LLocationDB
    );


    GDM.ConectarBD;

    Application.CreateForm(TDDDORM, DDDORM);
    Application.CreateForm(TFormClientesPGTO, FormClientesPGTO);
    Application.CreateForm(TFormFormasPGTO, FormFormasPGTO);
    Application.Run;

  finally
    GDM.Free;
  end;



end.
