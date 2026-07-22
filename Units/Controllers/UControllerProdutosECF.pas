unit UControllerProdutosECF;

interface

uses UDomainProdutosECF,UIRepository,UAppProdutosECF, System.Generics.Collections,System.Classes,UFormatErrorText, System.SysUtils, Vcl.Dialogs,UErros;

type IControllerProdutosECF = interface
  function BuscarProdutoECF(ACOD:Integer):TProdutosECF;
  procedure CadastrarProdutoECF(ACodBarras,ANome,AUniSigla,ASitVenda,AEstoque,APrecoVenda,AALIQPis,AALIQCof,ADescontoMax:String);
  procedure AlterarProdutoECF(ACOD:Integer;ACodBarras,ANome,AUniSigla,ASitVenda,AEstoque,APrecoVenda,AALIQPis,AALIQCof,ADescontoMax:String);
  procedure DeletarProdutoECF(ACOD:Integer);
  procedure FiltrarProdutoECF(AFiltro:String);
end;

//CONTROLLER FORM CLIENTES PAGAMENTO
type TControllerProdutosECF = class(TInterfacedObject,IControllerProdutosECF)
  public
    function BuscarProdutoECF(ACOD:Integer):TProdutosECF;
    procedure CadastrarProdutoECF(ACodBarras,ANome,AUniSigla,ASitVenda,AEstoque,APrecoVenda,AALIQPis,AALIQCof,ADescontoMax:String);
    procedure AlterarProdutoECF(ACOD:Integer;ACodBarras,ANome,AUniSigla,ASitVenda,AEstoque,APrecoVenda,AALIQPis,AALIQCof,ADescontoMax:String);
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
    Result := FApp.BuscarProdutoECFByID(ACOD);
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
  AALIQCof,
  ADescontoMax:String
  );
  var
  LEstoque: Double;
  LPrecoVenda: Currency;
  LAliqPis: Double;
  LAliqCofins: Double;
  LDescontoMax: Double;
  begin
    //CONVERSÕES
    LEstoque := StrToFloatDef(StringReplace(AEstoque, '.', ',', [rfReplaceAll]),0);
    LPrecoVenda := StrToFloatDef(StringReplace(APrecoVenda, '.', ',', [rfReplaceAll]),0);
    LAliqPis := StrToFloatDef(StringReplace(AALIQPis, '.', ',', [rfReplaceAll]),0);
    LAliqCofins := StrToFloatDef(StringReplace(AALIQCof, '.', ',', [rfReplaceAll]),0);
    LDescontoMax := StrToFloatDef(StringReplace(ADescontoMax, '.', ',', [rfReplaceAll]),0);

    Self.FApp.InserirProdutoECF(ACodBarras,ANome,AUniSigla,ASitVenda,LEstoque,LPrecoVenda,LAliqPis,LAliqCofins,LDescontoMax);
    Self.FRep.AtualizarDataSet;
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
  AALIQCof,
  ADescontoMax:String
  );
  var
  LEstoque: Double;
  LPrecoVenda: Currency;
  LAliqPis: Double;
  LAliqCofins: Double;
  LDescontoMax: Double;
  begin
    //CONVERSÕES
    LEstoque := StrToFloat(StringReplace(AEstoque, '.', '', [rfReplaceAll]));
    LPrecoVenda := StrToFloat(StringReplace(APrecoVenda, '.', '', [rfReplaceAll]));
    LAliqPis := StrToFloat(StringReplace(AALIQPis, '.', '', [rfReplaceAll]));
    LAliqCofins := StrToFloat(StringReplace(AALIQCof, '.', '', [rfReplaceAll]));
    LDescontoMax := StrToFloatDef(StringReplace(ADescontoMax, '.', ',', [rfReplaceAll]),0);

    Self.FApp.AtualizarProdutoECF(ACOD,ACodBarras,ANome,AUniSigla,ASitVenda,LEstoque,LPrecoVenda,LAliqPis,LAliqCofins,LDescontoMax);
    Self.FRep.AtualizarDataSet;
  end;

  //DELETAR
  procedure TControllerProdutosECF.DeletarProdutoECF(ACOD:Integer);
  begin
    Self.FApp.DeletarProdutoECF(ACOD);
    Self.FRep.AtualizarDataSet;
  end;

  //FILTRAR
  procedure TControllerProdutosECF.FiltrarProdutoECF(AFiltro:String);
  begin
    Self.FRep.FiltrarDataSet('PRO_NOME',AFiltro);
  end;
end.
