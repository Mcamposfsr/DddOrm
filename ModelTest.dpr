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
  UFormClientesPGTO in 'Units\Forms\UFormClientesPGTO.pas' {FormClientesPGTO},
  UFormFormasPGTO in 'Units\Forms\UFormFormasPGTO.pas' {FormFormasPGTO},
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
  UDomainPedidos in 'Units\Domain\UDomainPedidos.pas',
  UDomainItensPedidos in 'Units\Domain\UDomainItensPedidos.pas',
  UAppPedidos in 'Units\Application\UAppPedidos.pas',
  UAppItensPedidos in 'Units\Application\UAppItensPedidos.pas',
  UControllerPedidos in 'Units\Controllers\UControllerPedidos.pas',
  UFormPedidos in 'Units\Forms\UFormPedidos.pas' {FormPedidos},
  UFormBuscarClientePGTO in 'Units\Forms\FormsSecundarios\Busca\UFormBuscarClientePGTO.pas' {FormBuscarClientePGTO},
  UFormBuscarPedido in 'Units\Forms\FormsSecundarios\Busca\UFormBuscarPedido.pas' {FormBuscarPedido},
  UFormCadastroClientePGTO in 'Units\Forms\FormsSecundarios\Cadastro\UFormCadastroClientePGTO.pas' {FormCadastroClientes},
  UFormCadastroFormaPGTO in 'Units\Forms\FormsSecundarios\Cadastro\UFormCadastroFormaPGTO.pas' {FormCadastroPGTO},
  UFormCadastroPedido in 'Units\Forms\FormsSecundarios\Cadastro\UFormCadastroPedido.pas' {FormCadastroPedido},
  UFormCadastroProdutosEFC in 'Units\Forms\FormsSecundarios\Cadastro\UFormCadastroProdutosEFC.pas' {FormCadastroProdutosEFC};

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


  Application.CreateForm(TFormPedidos, FormPedidos);
  Application.CreateForm(TDDDORM, DDDORM);
  Application.CreateForm(TFormProdutosEFC, FormProdutosEFC);
  Application.CreateForm(TFormClientesPGTO, FormClientesPGTO);
  Application.CreateForm(TFormFormasPGTO, FormFormasPGTO);
  Application.CreateForm(TFormClienteTest, FormClienteTest);
  Application.CreateForm(TFormOS, FormOS);
  Application.CreateForm(TFormBuscarPedido, FormBuscarPedido);
  Application.CreateForm(TFormBuscarClientePGTO, FormBuscarClientePGTO);
  Application.CreateForm(TFormBuscarPedido, FormBuscarPedido);
  Application.CreateForm(TFormCadastroClientes, FormCadastroClientes);
  Application.CreateForm(TFormCadastroPGTO, FormCadastroPGTO);
  Application.CreateForm(TFormCadastroPedido, FormCadastroPedido);
  Application.CreateForm(TFormCadastroProdutosEFC, FormCadastroProdutosEFC);
  Application.Run;

  finally
    GDM.Free;
  end;



end.
