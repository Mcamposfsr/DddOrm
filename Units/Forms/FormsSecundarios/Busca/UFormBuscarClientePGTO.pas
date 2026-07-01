unit UFormBuscarClientePGTO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,

  UDomainClientesPGTO,UControllerClientesPGTO,UIRepository
  ;

type
  TFormBuscarClientePGTO = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    ButtonSelect: TButton;
    ButtonCancel: TButton;
    DataSource: TDataSource;
    FDMemTable: TFDMemTable;
    procedure ButtonSelectClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonCancelKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    //FERRAMENTAS
    FRepositoryClientes: IRepository<TClientePGTO>;
    FControllerClientes: IControllerClientesPGTO;
  public
    //VAR CONTROLE
    FCliente: TClientePGTO;

    constructor Create(
    AOwner: Tcomponent;
    ARepositoryClientes: IRepository<TClientePGTO>;
    AControllerClientes: IControllerClientesPGTO
    ); Reintroduce;
  end;

var
  FormBuscarClientePGTO: TFormBuscarClientePGTO;

implementation

  {$R *.dfm}

  constructor TFormBuscarClientePGTO.Create(
    AOwner: Tcomponent;
    ARepositoryClientes: IRepository<TClientePGTO>;
    AControllerClientes: IControllerClientesPGTO
    );
  begin
    inherited Create(AOwner);
    FRepositoryClientes := ARepositoryClientes;
    FControllerClientes := AControllerClientes;

    FRepositoryClientes.ReceberDataSet(Self.FDMemTable);
    FRepositoryClientes.AtualizarDataSet;
  end;

  //SELECIONAR
  procedure TFormBuscarClientePGTO.ButtonSelectClick(Sender: TObject);
   var LID: Integer;
  begin
    LID := Self.FDMemTable.FieldByName('CLI_CODIGO').AsInteger;
    FCliente := FControllerClientes.BuscarClientePGTO(LID);

    ModalResult := mrOk;
  end;

  //CANCELAR
  procedure TFormBuscarClientePGTO.ButtonCancelClick(Sender: TObject);
  begin
    ModalResult := mrCancel;
  end;

  //CANCELAR - ESC
  procedure TFormBuscarClientePGTO.ButtonCancelKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
  begin
    if key = VK_ESCAPE  then
      ModalResult := mrCancel;
  end;

end.
