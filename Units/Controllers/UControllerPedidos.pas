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
  procedure CadastrarPedido(AIDCliente:Integer;ADataEmissao,ATotalLiquido:String);
  procedure AlterarPedido(AID,AIDCliente:Integer;ADataEmissao,ATotalLiquido:String);
  procedure DeletarPedido(AID:Integer);
  procedure FiltrarPedido(AFiltro:String);


  //ITENS PEDIDOS
  function BuscarItemPedido(AID:Integer):TItensPedidos;
  procedure CadastrarItemPedido(AIDPedido,AIDProduto:Integer;AQuantidade,APrecoUnit,ADescontoPercent,ADescontoValor,ATotal:String);
  procedure AlterarItemPedido(AID,AIDPedido,AIDProduto:Integer;AQuantidade,APrecoUnit,ADescontoPercent,ADescontoValor,ATotal:String);
  procedure DeletarItemPedido(AID:Integer);
  procedure FiltrarItemPedido(AFiltro:String);

  function PlotarDataSetPedidos: IDBResultSet;
end;

//CONTROLLER FORM CLIENTES PAGAMENTO
type TControllerPedidos = class(TInterfacedObject,IControllerPedidos)
  public
    //PEDIDOS
    function BuscarPedido(AID:Integer):TPedidos;
    procedure CadastrarPedido(AIDCliente:Integer;ADataEmissao,ATotalLiquido:String);
    procedure AlterarPedido(AID,AIDCliente:Integer;ADataEmissao,ATotalLiquido:String);
    procedure DeletarPedido(AID:Integer);
    procedure FiltrarPedido(AFiltro:String);
//    procedure AlterarTotalPedido(AID:Integer;AValorTotal);


    //ITENS PEDIDOS
    function BuscarItemPedido(AID:Integer):TItensPedidos;
    procedure CadastrarItemPedido(AIDPedido,AIDProduto:Integer;AQuantidade,APrecoUnit,ADescontoPercent,ADescontoValor,ATotal:String);
    procedure AlterarItemPedido(AID,AIDPedido,AIDProduto:Integer;AQuantidade,APrecoUnit,ADescontoPercent,ADescontoValor,ATotal:String);
    procedure DeletarItemPedido(AID:Integer);
    procedure FiltrarItemPedido(AFiltro:String);

    function PlotarDataSetPedidos: IDBResultSet;

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

  //CADASTRAR
  procedure TControllerPedidos.CadastrarPedido(
  AIDCliente:Integer;
  ADataEmissao,
  ATotalLiquido:String
  );
  var
  LTotalLiquido: Currency;
  LDataEmissao: TDate;
  begin
    try
      //RETIRAR O '.' ANTES DA CONVERSÃO PARA EVITAR ERROS DE CONVERSÃO
      LTotalLiquido := StrToFloatDef(StringReplace(ATotalLiquido, '.', '', [rfReplaceAll]),0);

      LDataEmissao := StrToDate(ADataEmissao);

      Self.FAppPedidos.InserirPedido(AIDCliente,LDataEmissao,LTotalLiquido);
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
  procedure TControllerPedidos.AlterarPedido(AID,AIDCliente:Integer;ADataEmissao,ATotalLiquido:String);
  var
  LTotalLiquido: Currency;
  LDataEmissao: TDate;
  begin
    try
      LTotalLiquido := StrToFloatDef(StringReplace(ATotalLiquido, '.', '', [rfReplaceAll]),0);
      LDataEmissao := StrToDate(ADataEmissao);
      Self.FAppPedidos.AtualizarPedido(AID,AIDCliente,LDataEmissao,LTotalLiquido);
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

  function TControllerPedidos.PlotarDataSetPedidos;
  var LSQL: String;
  begin
    LSQL := 'SELECT P.ID_PEDIDO,C.NOME_CLIENTE,C.CPF_CLIENTE,P.DATA_EMISSAO ' +
    'FROM CLIENTES C JOIN PEDIDOS P ON ' +
    'C.id_cliente = P.id_cliente';
    Result := Self.FRepPedidos.ExecutarSQL(LSQL);
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
