program ModelTest;

uses
  Vcl.Forms,
  System.IOUtils,
  System.SysUtils,
  UDM in 'Units\DM\UDM.pas',
  UGenericRep in 'Units\Repository\UGenericRep.pas',
  UDocValidator in 'Units\Utils\UDocValidator.pas',
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
  UFormPrincipal in 'Units\Forms\UFormPrincipal.pas' {DDDORM},
  UErros in 'Units\Erros\UErros.pas',
  UGenericValidator in 'Units\Utils\UGenericValidator.pas',
  UEmailValidator in 'Units\Utils\UEmailValidator.pas',
  UFormatErrorText in 'Units\Utils\UFormatErrorText.pas',
  URepManager in 'Units\Repository\URepManager.pas',
  UDomainOSTeste in 'Units\Domain\teste\UDomainOSTeste.pas',
  UDomainClientesTeste in 'Units\Domain\teste\UDomainClientesTeste.pas',
  UControllerClientesTeste in 'Units\Controllers\teste\UControllerClientesTeste.pas',
  UControllerOSTeste in 'Units\Controllers\teste\UControllerOSTeste.pas',
  UAppClientesTeste in 'Units\Application\teste\UAppClientesTeste.pas',
  UAppOrdemServicoTeste in 'Units\Application\teste\UAppOrdemServicoTeste.pas',
  UIDM in 'Units\Interfaces\UIDM.pas',
  UFormClienteTest in 'Units\Forms\Teste\UFormClienteTest.pas' {FormClienteTest},
  UFormOSTeste in 'Units\Forms\Teste\UFormOSTeste.pas' {FormOS},
  UDomainProdutosECF in 'Units\Domain\UDomainProdutosECF.pas',
  UAppProdutosECF in 'Units\Application\UAppProdutosECF.pas',
  UControllerProdutosECF in 'Units\Controllers\UControllerProdutosECF.pas',
  UFormProdutosEFC in 'Units\Forms\UFormProdutosEFC.pas' {FormProdutosEFC},
  UFormCadastroProdutosEFC in 'Units\Forms\FormsSecundarios\UFormCadastroProdutosEFC.pas' {FormCadastroProdutosEFC};

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
  Application.CreateForm(TFormProdutosEFC, FormProdutosEFC);
  Application.CreateForm(TFormClientesPGTO, FormClientesPGTO);
  Application.CreateForm(TFormFormasPGTO, FormFormasPGTO);
  Application.CreateForm(TFormClienteTest, FormClienteTest);
  Application.CreateForm(TFormOS, FormOS);
  Application.Run;

  finally
    GDM.Free;
  end;



end.
