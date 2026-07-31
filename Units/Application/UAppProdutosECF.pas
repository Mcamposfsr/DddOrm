unit UAppProdutosECF;


interface
 uses System.Generics.Collections,UDomainProdutosECF, System.SysUtils, Data.DB, Vcl.Dialogs,UIRepository;

  type IAppProdutosECF = Interface
    Function BuscarProdutoECF:TObjectList<TProdutosECF>;
    Function BuscarProdutoECFByID(ACodigo:Integer):TProdutosECF;
    procedure InserirProdutoECF(
    ACodigoDeBarras,
    ANome,
    AUniSigla,
    ASitPermiteVenda:String;
    AEstoque:Double;
    APrecoVenda:Currency;
    AAliqPis:Double;
    AAliqCofins: Double;
    ADescontoMax: Double);

    procedure AtualizarProdutoECF(
    ACodigo:Integer;
    ACodigoDeBarras,
    ANome,
    AUniSigla,
    ASitPermiteVenda:String;
    AEstoque:Double;
    APrecoVenda:Currency;
    AAliqPis:Double;
    AAliqCofins: Double;
    ADescontoMax: Double
    );
    procedure DeletarProdutoECF(ACodigo:Integer);

    procedure ReceberDataSet(ADataSet: TDataSet);
    procedure AtualizarDataSet;
    procedure FiltrarDataSet(AFiltro: String);

  End;

  type TAppProdutosECF = class(TInterfacedObject,IAppProdutosECF)
    public
    Function BuscarProdutoECF:TObjectList<TProdutosECF>;
    Function BuscarProdutoECFByID(ACodigo:Integer):TProdutosECF;
    procedure InserirProdutoECF(
    ACodigoDeBarras,
    ANome,
    AUniSigla,
    ASitPermiteVenda:String;
    AEstoque:Double;
    APrecoVenda:Currency;
    AAliqPis:Double;
    AAliqCofins: Double;
    ADescontoMax: Double
    );

    procedure AtualizarProdutoECF(
    ACodigo:Integer;
    ACodigoDeBarras,
    ANome,
    AUniSigla,
    ASitPermiteVenda:String;
    AEstoque:Double;
    APrecoVenda:Currency;
    AAliqPis:Double;
    AAliqCofins: Double;
    ADescontoMax: Double
    );
    procedure DeletarProdutoECF(ACodigo:Integer);

    procedure ReceberDataSet(ADataSet: TDataSet);
    procedure AtualizarDataSet;
    procedure FiltrarDataSet(AFiltro: String);

      constructor Create(ARep:IRepository<TProdutosECF>);
    private

      FRepository: IRepository<TProdutosECF>;

  end;

implementation

  //RECEBER REPOSITORY
  constructor TAppProdutosECF.Create(ARep:IRepository<TProdutosECF>);
  begin
    FRepository := ARep;
  end;

  //RECEBERDATASET
  procedure TAppProdutosECF.ReceberDataSet(ADataSet: TDataSet);
  begin
    FRepository.ReceberDataSet(ADataSet);
  end;

  //ATUALIZAR DATASET
  procedure TAppProdutosECF.AtualizarDataSet;
  begin
    FRepository.AtualizarDataSet;
  end;

  //FILTRAR DATASET
  procedure TAppProdutosECF.FiltrarDataSet(AFiltro: String);
  begin
    FRepository.FiltrarDataSet('PRO_NOME',AFiltro);
  end;

  //SELECT *
  Function TAppProdutosECF.BuscarProdutoECF:TObjectList<TProdutosECF>;
  begin
    Result := FRepository.SelectAll;
  end;

  //SELECT WHERE
  Function TAppProdutosECF.BuscarProdutoECFByID(ACodigo:Integer):TProdutosECF;
  var LID: String;
  begin
    LID := IntToStr(ACodigo);
    Result := FRepository.Select(LID);
  end;

  //INSERT
  procedure TAppProdutosECF.InserirProdutoECF(
    ACodigoDeBarras,
    ANome,
    AUniSigla,
    ASitPermiteVenda:String;
    AEstoque:Double;
    APrecoVenda:Currency;
    AAliqPis:Double;
    AAliqCofins: Double;
    ADescontoMax: Double);
  var LProduto: TProdutosECF;
  begin
    LProduto := nil;
    try
     LProduto := TProdutosECF.Create(
       0,
       ACodigoDeBarras,
       ANome,
       AUniSigla,
       ASitPermiteVenda,
       AEstoque,
       APrecoVenda,
       AAliqPis,
       AAliqCofins,
       ADescontoMax
     );

     LProduto.Validar;

     FRepository.Insert(LProduto);
    finally
      LProduto.Free;
    end;
  end;

  //UPDATE
  procedure TAppProdutosECF.AtualizarProdutoECF(
    ACodigo:Integer;
    ACodigoDeBarras,
    ANome,
    AUniSigla,
    ASitPermiteVenda:String;
    AEstoque:Double;
    APrecoVenda:Currency;
    AAliqPis:Double;
    AAliqCofins: Double;
    ADescontoMax: Double
  );
  var
  LProduto: TProdutosECF;
  LCodigo: String;
  begin
    LCodigo := IntToStr(ACodigo);
    LProduto := nil;
    try
     LProduto := TProdutosECF.Create(
     ACodigo,
     ACodigoDeBarras,
     ANome,
     AUniSigla,
     ASitPermiteVenda,
     AEstoque,
     APrecoVenda,
     AAliqPis,
     AAliqCofins,
     ADescontoMax
     );

     LProduto.Validar;

     FRepository.Update(LCodigo,LProduto);
    finally
      LProduto.Free;
    end;
  end;

  //DELETE
  procedure TAppProdutosECF.DeletarProdutoECF(ACodigo:Integer);
  var
  LProduto: TProdutosECF;
  LCodigo: String;
  begin
    LCodigo := IntToStr(ACodigo);
    LProduto := nil;
    try
      //CLASSE MÍNIMA APENAS PARA DELETE
     LProduto := TProdutosECF.Create(ACodigo,'','','','',0,0,0,0,0);
     FRepository.Delete(LProduto);
    finally
      LProduto.Free;
    end;
  end;

end.
