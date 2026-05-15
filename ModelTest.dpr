program ModelTest;

uses
  Vcl.Forms,
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
  UFormOS in 'Units\Forms\UFormOS.pas' {FormOS};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormOS, FormOS);
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
