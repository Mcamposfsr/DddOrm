program ModelTest;

uses
  Vcl.Forms,
  System.IOUtils,
  System.SysUtils,
  FormModelTest in 'FormModelTest.pas' {FormPrincipal},
  UAppClientes in 'Units\Application\UAppClientes.pas',
  UControllerClientes in 'Units\Controllers\UControllerClientes.pas',
  UDM in 'Units\DM\UDM.pas',
  UDomainClientes in 'Units\Domain\UDomainClientes.pas',
  UGenericRep in 'Units\Repository\UGenericRep.pas',
  UCPFValidator in 'Units\Utils\UCPFValidator.pas',
  UDomainOS in 'Units\Domain\UDomainOS.pas',
  UAppOrdemServico in 'Units\Application\UAppOrdemServico.pas',
  UIRepository in 'Units\Interfaces\UIRepository.pas',
  UControllerOS in 'Units\Controllers\UControllerOS.pas',
  UFormOS in 'Units\Forms\UFormOS.pas' {FormOS},
  UDomainFormasPagamento in 'Units\Domain\UDomainFormasPagamento.pas',
  UDomainClientesPGTO in 'Units\Domain\UDomainClientesPGTO.pas',
  UAppClientesPGTO in 'Units\Application\UAppClientesPGTO.pas',
  UAppFormasPGTO in 'Units\Application\UAppFormasPGTO.pas',
  UControllerClientesPGTO in 'Units\Controllers\UControllerClientesPGTO.pas',
  UControllerFormasPGTO in 'Units\Controllers\UControllerFormasPGTO.pas';

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

    Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;

  finally
    GDM.Free;
  end;



end.
