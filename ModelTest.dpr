program ModelTest;

uses
  Vcl.Forms,
  FormModelTest in 'FormModelTest.pas' {FormPrincipal},
  UClasseModelo in 'UClasseModelo.pas',
  URepository in 'URepository.pas',
  UDM in 'UDM.pas',
  UApplication in 'UApplication.pas',
  UController in 'UController.pas',
  UCPFValidator in 'UCPFValidator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
