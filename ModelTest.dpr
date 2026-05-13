program ModelTest;

uses
  Vcl.Forms,
  FormModelTest in 'FormModelTest.pas' {FormPrincipal},
  UAppClientes in 'Units\Application\UAppClientes.pas',
  UControllerClientes in 'Units\Controllers\UControllerClientes.pas',
  UDM in 'Units\DM\UDM.pas',
  UDomainClientes in 'Units\Domain\UDomainClientes.pas',
  URepositoryClientes in 'Units\Repository\URepositoryClientes.pas',
  UCPFValidator in 'Units\Utils\UCPFValidator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
