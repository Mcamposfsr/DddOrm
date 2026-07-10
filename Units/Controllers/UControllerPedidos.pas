unit UControllerPedidos;

interface

uses
System.Generics.Collections,System.Classes,UFormatErrorText, System.SysUtils, Vcl.Dialogs,UErros,

UIRepository,


UDomainPedidos,
UAppPedidos,

UAppItensPedidos,
UDomainItensPedidos,
dbebr.factory.interfaces

;

type IControllerPedidos = interface
  //PEDIDOS
  function BuscarPedido(AID:Integer):TPedidos;
  function BuscarPedidoPeloCodigo(ACod:String):TPedidos;
  //OPÇÃO DE EXIBIÇÃO LEGADO
  procedure ExibirPedidos;
  procedure CadastrarPedido(AIDCliente:Integer;ADataEmissao,ATotalLiquido,ACodPedido:String);
  procedure AlterarPedido(AID,AIDCliente:Integer;ADataEmissao,ATotalLiquido,ACodPedido:String);
  procedure DeletarPedido(AID:Integer);
  procedure FiltrarPedido(AFiltro:String);
  function GerarCodPedido:String;
  procedure AtualizarValorTotalPedido(AID:Integer;AValorTotal:String);


  //ITENS PEDIDOS
  function BuscarItemPedido(AID:Integer):TItensPedidos;
  procedure ExibirItensPedidos(AID: Integer);
  procedure CadastrarItemPedido(AIDPedido,AIDProduto:Integer;AQuantidade,APrecoUnit,ADescontoPercent,ADescontoValor,ATotal:String);
  procedure AlterarItemPedido(AID,AIDPedido,AIDProduto:Integer;AQuantidade,APrecoUnit,ADescontoPercent,ADescontoValor,ATotal:String);
  procedure DeletarItemPedido(AID:Integer);
  procedure FiltrarItemPedido(AFiltro:String);

end;

//CONTROLLER FORM CLIENTES PAGAMENTO
type TControllerPedidos = class(TInterfacedObject,IControllerPedidos)
  public
    //PEDIDOS
    function BuscarPedido(AID:Integer):TPedidos;
    function BuscarPedidoPeloCodigo(ACod:String):TPedidos;
    //OPÇÃO DE EXIBIÇÃO LEGADO
    procedure ExibirPedidos;
    procedure CadastrarPedido(AIDCliente:Integer;ADataEmissao,ATotalLiquido,ACodPedido:String);
    procedure AlterarPedido(AID,AIDCliente:Integer;ADataEmissao,ATotalLiquido,ACodPedido:String);
    procedure DeletarPedido(AID:Integer);
    procedure FiltrarPedido(AFiltro:String);
    function GerarCodPedido:String;
    procedure AtualizarValorTotalPedido(AID:Integer;AValorTotal:String);

    //ITENS PEDIDOS
    function BuscarItemPedido(AID:Integer):TItensPedidos;
    procedure ExibirItensPedidos(AID: Integer);
    procedure CadastrarItemPedido(AIDPedido,AIDProduto:Integer;AQuantidade,APrecoUnit,ADescontoPercent,ADescontoValor,ATotal:String);
    procedure AlterarItemPedido(AID,AIDPedido,AIDProduto:Integer;AQuantidade,APrecoUnit,ADescontoPercent,ADescontoValor,ATotal:String);
    procedure DeletarItemPedido(AID:Integer);
    procedure FiltrarItemPedido(AFiltro:String);

    constructor Create(
    AAppPedidos:IAppPedidos;
    ARepPedidos:IRepository<TPedidos>;
    AAppItensPedidos:IAppItensPedidos;
    ARepItensPedidos:IRepository<TItensPedidos>
    );
  private
    //PEDIDOS
    FAppPedidos: IAppPedidos;
    FRepPedidos: IRepository<TPedidos>;

    //ITENS PEDIDOS
    FAppItensPedidos: IAppItensPedidos;
    FRepItensPedidos: IRepository<TItensPedidos>;
end;

implementation

  constructor TControllerPedidos.Create(
    AAppPedidos:IAppPedidos;
    ARepPedidos:IRepository<TPedidos>;
    AAppItensPedidos:IAppItensPedidos;
    ARepItensPedidos:IRepository<TItensPedidos>
    );
  begin
    //PEDIDOS
    FAppPedidos := AAppPedidos;
    FRepPedidos := ARepPedidos;

    //ITENS PEDIDOS
    FAppItensPedidos := AAppItensPedidos;
    FRepItensPedidos := ARepItensPedidos;
  end;

  //BUSCAR
  function TControllerPedidos.BuscarPedido(AID:Integer):TPedidos;
  begin
    try
      Result := FAppPedidos.BuscarPedidoByID(AID);
    except
    //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  function TControllerPedidos.BuscarPedidoPeloCodigo(ACod:String):TPedidos;
  begin
    try
      Result := FAppPedidos.BuscarPedidoPeloCodigo(ACod);
    except
    //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //EXIBIR PEDIDOS DATASET
  procedure TControllerPedidos.ExibirPedidos;
  begin
    try
      Self.FAppPedidos.BuscarPedidosLegado;
    except
    //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //CADASTRAR
  procedure TControllerPedidos.CadastrarPedido(
  AIDCliente:Integer;
  ADataEmissao,
  ATotalLiquido,
  ACodPedido:String
  );
  var
  LTotalLiquido: Currency;
  LDataEmissao: TDate;
  begin
    try
      //RETIRAR O '.' ANTES DA CONVERSÃO PARA EVITAR ERROS DE CONVERSÃO
      LTotalLiquido := StrToFloatDef(StringReplace(ATotalLiquido, '.', '', [rfReplaceAll]),0);

      LDataEmissao := StrToDate(ADataEmissao);

      Self.FAppPedidos.InserirPedido(AIDCliente,LDataEmissao,LTotalLiquido,ACodPedido);
//      Self.FRepPedidos.AtualizarDataSet;
    except
      //ERROS VALIDAÇÃO FORMULÁRIOS
      on E: EErrorFormInput do
      begin
        raise Exception.Create('Falha ao cadastrar cliente.' + FFormatErrorText(E.FCampos,E.FValores));
      end;
      //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;


  //ALTERAR
  procedure TControllerPedidos.AlterarPedido(
  AID,
  AIDCliente:Integer;
  ADataEmissao,
  ATotalLiquido,
  ACodPedido:String
  );
  var
  LTotalLiquido: Currency;
  LDataEmissao: TDate;
  begin
    try
      LTotalLiquido := StrToFloatDef(StringReplace(ATotalLiquido, '.', '', [rfReplaceAll]),0);
      LDataEmissao := StrToDate(ADataEmissao);
      Self.FAppPedidos.AtualizarPedido(AID,AIDCliente,LDataEmissao,LTotalLiquido,ACodPedido);
      Self.FRepPedidos.AtualizarDataSet;
    except
      //ERROS VALIDAÇÃO FORMULÁRIOS
      on E: EErrorFormInput do
      begin
        raise Exception.Create('Falha ao cadastrar cliente.' +  FFormatErrorText(E.FCampos,E.FValores));
      end;
      //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //DELETAR
  procedure TControllerPedidos.DeletarPedido(AID:Integer);
  begin
    try
      Self.FAppPedidos.DeletarPedido(AID);
//      Self.FRepPedidos.AtualizarDataSet;
    except
      //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //FILTRAR
  procedure TControllerPedidos.FiltrarPedido(AFiltro:String);
  begin
    try
      Self.FRepPedidos.FiltrarDataSet('ID_PEDIDO',AFiltro);
    except
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //GERAR CÓDIGO PEDIDO
  function TControllerPedidos.GerarCodPedido:String;
  var
  LResultSet: IDBResultSet;
  LIDPedido: String;
  LDataPedido:String;
  LTemp: String;
  begin
    try
      LResultSet := Self.FRepPedidos.Open('SELECT GEN_ID(GEN_COD_PEDIDO,1) AS COD FROM RDB$DATABASE;');
      LIDPedido := LResultSet.DataSet.FieldByName('COD').AsString;

      //COLOCAR '0' NA FRENTE
      while Length(LIDPedido) < 6 do
      begin
        LTemp :=  LIDPedido;
        LIDPedido := '0' + LTemp;
      end;

      LDataPedido := FormatDateTime('ddmmyy',now);
      Result := LDataPedido + '-' +LIDPedido;
    except
      //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //PASSAR VALOR TOTAL
  procedure TControllerPedidos.AtualizarValorTotalPedido(AID:Integer;AValorTotal:String);
  var LTotal: Currency;
  begin
    try
//      LTotal := StrToCurrDef(AValorTotal,0);
      Self.FAppPedidos.AtualizarTotalPedido(AID,AValorTotal);
    except
    //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  // ############ ITENS PEDIDOS ############ ITENS PEDIDOS ############ ITENS PEDIDOS ############ ITENS PEDIDOS ############ ITENS PEDIDOS ############ ITENS PEDIDOS ############ ITENS PEDIDOS

  //BUSCAR
  function TControllerPedidos.BuscarItemPedido(AID:Integer):TItensPedidos;
  begin
    try
      Result := FAppItensPedidos.BuscarItemPedidoByID(AID);
    except
    //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //EXIBIR ITENS PEDIDOS
  procedure TControllerPedidos.ExibirItensPedidos(AID: Integer);
  var LID: String;
  begin
    LID := IntToStr(AID);
    try
      Self.FAppItensPedidos.BuscarPedidosLegado(LID);
    except
    //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //CADASTRAR
  procedure TControllerPedidos.CadastrarItemPedido(
  AIDPedido,
  AIDProduto:Integer;
  AQuantidade,
  APrecoUnit,
  ADescontoPercent,
  ADescontoValor,
  ATotal:String
  );
  var
  LQuantidade: Currency;
  LPrecoUnit: Currency;
  LDescontoPercent: Currency;
  LDescontoValor: Currency;
  LTotal: Currency;
  begin
    try
      //RETIRAR O '.' ANTES DA CONVERSÃO PARA EVITAR ERROS DE CONVERSÃO
      LQuantidade := StrToFloatDef(StringReplace(AQuantidade, '.', '', [rfReplaceAll]),0);
      LPrecoUnit := StrToFloatDef(StringReplace(APrecoUnit, '.', '', [rfReplaceAll]),0);
      LDescontoPercent := StrToFloatDef(StringReplace(ADescontoPercent, '.', '', [rfReplaceAll]),0);
      LDescontoValor := StrToFloatDef(StringReplace(ADescontoValor, '.', '', [rfReplaceAll]),0);
      LTotal := StrToFloatDef(StringReplace(ATotal, '.', '', [rfReplaceAll]),0);

      Self.FAppItensPedidos.InserirItemPedido(
      AIDPedido,
      AIDProduto,
      LQuantidade,
      LPrecoUnit,
      LDescontoPercent,
      LDescontoValor,
      LTotal
      );

//      Self.FRepItensPedidos.AtualizarDataSet;
    except
      //ERROS VALIDAÇÃO FORMULÁRIOS
      on E: EErrorFormInput do
      begin
        raise Exception.Create('Falha ao cadastrar cliente.' + FFormatErrorText(E.FCampos,E.FValores));
      end;
      //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  //ALTERAR
  procedure TControllerPedidos.AlterarItemPedido(
  AID,
  AIDPedido,
  AIDProduto:Integer;
  AQuantidade,
  APrecoUnit,
  ADescontoPercent,
  ADescontoValor,
  ATotal:String
  );
  var
  LQuantidade: Currency;
  LPrecoUnit: Currency;
  LDescontoPercent: Currency;
  LDescontoValor: Currency;
  LTotal: Currency;
  begin
    try
      LQuantidade := StrToFloatDef(StringReplace(AQuantidade, '.', '', [rfReplaceAll]),0);
      LPrecoUnit := StrToFloatDef(StringReplace(APrecoUnit, '.', '', [rfReplaceAll]),0);
      LDescontoPercent := StrToFloatDef(StringReplace(ADescontoPercent, '.', '', [rfReplaceAll]),0);
      LDescontoValor := StrToFloatDef(StringReplace(ADescontoValor, '.', '', [rfReplaceAll]),0);
      LTotal := StrToFloatDef(StringReplace(ATotal, '.', '', [rfReplaceAll]),0);

      Self.FAppItensPedidos.AtualizarItemPedido(
      AID,
      AIDPedido,
      AIDProduto,
      LQuantidade,
      LPrecoUnit,
      LDescontoPercent,
      LDescontoValor,
      LTotal
      );
      Self.FRepItensPedidos.AtualizarDataSet;

    except
      //ERROS VALIDAÇÃO FORMULÁRIOS
      on E: EErrorFormInput do
      begin
        raise Exception.Create('Falha ao cadastrar cliente.' +  FFormatErrorText(E.FCampos,E.FValores));
      end;
      //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

   //DELETAR
  procedure TControllerPedidos.DeletarItemPedido(AID:Integer);
  begin
    try
      Self.FAppItensPedidos.DeletarItemPedido(AID);
//      Self.FRepItensPedidos.AtualizarDataSet;
    except
      //ERROS INESPERADOS
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;


  //FILTRAR
  procedure TControllerPedidos.FiltrarItemPedido(AFiltro:String);
  begin
    try
      Self.FRepItensPedidos.FiltrarDataSet('ID_ITEM',AFiltro);
    except
      on E: Exception do
      begin
        raise Exception.Create('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;



end.
