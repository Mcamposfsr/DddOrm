unit UFormBuscarPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  UIRepository,UDomainPedidos,UDomainClientesPGTO,UControllerPedidos,dbebr.factory.interfaces;

type
  TFormBuscarPedido = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    ButtonSelect: TButton;
    ButtonCancel: TButton;
    DataSource: TDataSource;
    FDMemTable: TFDMemTable;
    procedure ButtonSelectClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FController: IControllerPedidos;
    FRepository: IRepository<TPedidos>;
  public
    //VAR CONTROLE
    FPedido: TPedidos;
    FCLiente: TClientePGTO;

    constructor Create(
    AOWner: TComponent;
    ARepository: IRepository<TPedidos>;
    AController: IControllerPedidos
    ); Reintroduce;
  end;

var
  FormBuscarPedido: TFormBuscarPedido;

implementation

{$R *.dfm}

constructor TFormBuscarPedido.Create(
    AOWner: TComponent;
    ARepository: IRepository<TPedidos>;
    AController: IControllerPedidos
 );
 var LDataSet: IDBResultSet;
 begin
  inherited Create(AOwner);

  FController := AController;
  FRepository := ARepository;
  DBGrid1.DataSource := DataSource;
  LDataSet := FRepository.Open('SELECT P.NUMERO_PEDIDO,C.CLI_NOME,C.CLI_DOCUMENTO,P.DATA_EMISSAO,P.TOTAL_LIQUIDO FROM PEDIDOS P INNER JOIN CLIENTES_PGTO C ON C.cli_codigo = P.id_cliente;');


  FDMemTable.DisableControls;
  try
    FDMemTable.Close;
    FDMemTable.CopyDataSet(
      LDataSet.DataSet,
      [coStructure, coRestart, coAppend]
    );
  finally
    FDMemTable.EnableControls;
  end;

  //BUSCA LEGADO - JOINS DO ORMBR NÃO FUNCIONAM NO FB 1.5;
  FRepository.ReceberDataSetFirebirdLegado(Self.FDMemTable);
  FController.ExibirPedidos;
 end;

  //SELECIONAR;
  procedure TFormBuscarPedido.ButtonSelectClick(Sender: TObject);
  var LID: Integer;
  begin
    LID := Self.FDMemTable.FieldByName('ID_PEDIDO').AsInteger;
    FPedido := FController.BuscarPedido(LID);

    ModalResult := mrOk;
  end;

  //CANCELAR
  procedure TFormBuscarPedido.ButtonCancelClick(Sender: TObject);
  begin
    ModalResult := mrCancel;
  end;

  //CANCELAR - ESC
  procedure TFormBuscarPedido.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin
    if key = VK_ESCAPE  then
      ModalResult := mrCancel;
  end;

end.
