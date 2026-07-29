unit UFormBuscarPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  UErros,

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
    EditFiltrarDataset: TEdit;
    procedure ButtonSelectClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditFiltrarDatasetChange(Sender: TObject);
  private
    FController: IControllerPedidos;
    FRepository: IRepository<TPedidos>;

    procedure ConfigurarDataSet;
  public
    //VAR CONTROLE
    FPedido: TPedidos;
    FCLiente: TClientePGTO;

    constructor Create(
    AOWner: TComponent;
    AController: IControllerPedidos
    ); Reintroduce;
  end;

var
  FormBuscarPedido: TFormBuscarPedido;

implementation

{$R *.dfm}

constructor TFormBuscarPedido.Create(
    AOWner: TComponent;
    AController: IControllerPedidos
 );
 var LDataSet: IDBResultSet;
 begin
  inherited Create(AOwner);

  FController := AController;
  DBGrid1.DataSource := DataSource;

  //BUSCA LEGADO - JOINS DO ORMBR NÃO FUNCIONAM NO FB 1.5;
  FController.ReceberDataSet(Self.FDMemTable);

  TTratamentoDeErros.ExecutarOnForm(
    procedure
    begin
    FController.ExibirPedidos
    end
  );

  Self.ConfigurarDataSet;
 end;

  //SELECIONAR;
  procedure TFormBuscarPedido.ButtonSelectClick(Sender: TObject);
  var LID: Integer;
  begin
    TTratamentoDeErros.ExecutarOnForm(
    procedure
    begin
      if Self.FDMemTable.IsEmpty then
      begin
        ShowMessage('Selecione um Cliente!');
        Exit;
      end;

      LID := Self.FDMemTable.FieldByName('ID_PEDIDO').AsInteger;
      FPedido := FController.BuscarPedido(LID);

      ModalResult := mrOk;
    end);
  end;

  //FILTRAR NOME CLIENTE
  procedure TFormBuscarPedido.EditFiltrarDatasetChange(Sender: TObject);
  begin
    TTratamentoDeErros.ExecutarOnForm(
      procedure
      begin
        Self.FController.FiltrarPedido(EditFiltrarDataset.Text)
      end
    );
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

  //CONFIGURAR DATASET
  procedure TFormBuscarPedido.ConfigurarDataSet;
  begin
    Self.FDMemTable.FieldByName('ID_PEDIDO').Visible := False;
    Self.FDMemTable.FieldByName('CLI_DOCUMENTO').Visible := False;
  end;

end.
