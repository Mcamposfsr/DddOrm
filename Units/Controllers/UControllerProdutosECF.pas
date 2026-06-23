unit UControllerProdutosECF;

interface

uses UDomainProdutosECF,UIRepository,UAppProdutosECF, System.Generics.Collections,System.Classes,UFormatErrorText, System.SysUtils, Vcl.Dialogs,UErros;

type IControllerProdutosECF = interface
  function BuscarProdutoECF(ACOD:Integer):TProdutosECF;
  procedure CadastrarProdutoECF(ACodBarras,ANome,AUniSigla,ASitVenda,AEstoque,APrecoVenda,AALIQPis,AALIQCof:String);
  procedure AlterarProdutoECF(ACOD:Integer;ACodBarras,ANome,AUniSigla,ASitVenda,AEstoque,APrecoVenda,AALIQPis,AALIQCof:String);
  procedure DeletarProdutoECF(ACOD:Integer);
  procedure FiltrarProdutoECF(AFiltro:String);
end;

//CONTROLLER FORM CLIENTES PAGAMENTO
type TControllerProdutosECF = class(TInterfacedObject,IControllerProdutosECF)
  public
    function BuscarProdutoECF(ACOD:Integer):TProdutosECF;
    procedure CadastrarProdutoECF(ACodBarras,ANome,AUniSigla,ASitVenda,AEstoque,APrecoVenda,AALIQPis,AALIQCof:String);
    procedure AlterarProdutoECF(ACOD:Integer;ACodBarras,ANome,AUniSigla,ASitVenda,AEstoque,APrecoVenda,AALIQPis,AALIQCof:String);
    procedure DeletarProdutoECF(ACOD:Integer);
    procedure FiltrarProdutoECF(AFiltro:String);

    constructor Create(AApp:IAppProdutosECF;ARep:IRepository<TProdutosECF>);
  private
    FApp: IAppProdutosECF;
    FRep: IRepository<TProdutosECF>;
end;

implementation

  constructor TControllerProdutosECF.Create(AApp:IAppProdutosECF;ARep:IRepository<TProdutosECF>);
  begin
    Self.FApp := AApp;
    Self.FRep := ARep;
  end;

  //BUSCAR
  function TControllerProdutosECF.BuscarProdutoECF(ACOD:Integer):TProdutosECF;
  begin
    try
      Result := FApp.BuscarProdutoECFByID(ACOD);
    except
    //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //CADASTRAR
  procedure TControllerProdutosECF.CadastrarProdutoECF(
  ACodBarras,
  ANome,
  AUniSigla,
  ASitVenda,
  AEstoque,
  APrecoVenda,
  AALIQPis,
  AALIQCof:String
  );
  var
  LEstoque: Double;
  LPrecoVenda: Currency;
  LAliqPis: Currency;
  LAliqCofins: Currency;
  begin
    try
      //CONVERSÕES
      LEstoque := StrToFloat(StringReplace(AEstoque, '.', '', [rfReplaceAll]));
      LPrecoVenda := StrToFloat(StringReplace(APrecoVenda, '.', '', [rfReplaceAll]));
      LAliqPis := StrToFloat(StringReplace(AALIQPis, '.', '', [rfReplaceAll]));
      LAliqCofins := StrToFloat(StringReplace(AALIQCof, '.', '', [rfReplaceAll]));

      Self.FApp.InserirProdutoECF(ACodBarras,ANome,AUniSigla,ASitVenda,LEstoque,LPrecoVenda,LAliqPis,LAliqCofins);
      Self.FRep.AtualizarDataSet;
    except
      //ERROS VALIDAÇÃO FORMULÁRIOS
//      on E: EErrorFormInput do
//      begin
//        raise Exception.Create('Falha ao cadastrar produto.' + FFormatErrorText(E.FCampos,E.FValores));
//      end;
      //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro produto: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //ALTERAR
  procedure TControllerProdutosECF.AlterarProdutoECF(
  ACOD:Integer;
  ACodBarras,
  ANome,
  AUniSigla,
  ASitVenda,
  AEstoque,
  APrecoVenda,
  AALIQPis,
  AALIQCof:String
  );
  var
  LEstoque: Double;
  LPrecoVenda: Currency;
  LAliqPis: Currency;
  LAliqCofins: Currency;
  begin
    try
      //CONVERSÕES
      LEstoque := StrToFloat(StringReplace(AEstoque, '.', '', [rfReplaceAll]));
      LPrecoVenda := StrToFloat(StringReplace(APrecoVenda, '.', '', [rfReplaceAll]));
      LAliqPis := StrToFloat(StringReplace(AALIQPis, '.', '', [rfReplaceAll]));
      LAliqCofins := StrToFloat(StringReplace(AALIQCof, '.', '', [rfReplaceAll]));

      Self.FApp.AtualizarProdutoECF(ACOD,ACodBarras,ANome,AUniSigla,ASitVenda,LEstoque,LPrecoVenda,LAliqPis,LAliqCofins);
      Self.FRep.AtualizarDataSet;
    except
      //ERROS VALIDAÇÃO FORMULÁRIOS
//      on E: EErrorFormInput do
//      begin
//        raise Exception.Create('Falha ao cadastrar cliente.' +  FFormatErrorText(E.FCampos,E.FValores));
//      end;
      //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //DELETAR
  procedure TControllerProdutosECF.DeletarProdutoECF(ACOD:Integer);
  begin
    try
      Self.FApp.DeletarProdutoECF(ACOD);
      Self.FRep.AtualizarDataSet;
    except
      //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //FILTRAR
  procedure TControllerProdutosECF.FiltrarProdutoECF(AFiltro:String);
  begin
    try
      Self.FRep.FiltrarDataSet('CLI_NOME',AFiltro);
    except
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;
end.
