unit UFormBuscarClientePGTO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  UErros,

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
    EditFiltrarDataset: TEdit;
    procedure ButtonSelectClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonCancelKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditFiltrarDatasetChange(Sender: TObject);
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

    TTratamentoDeErros.ExecutarOnForm(
      procedure
      begin
        FRepositoryClientes.AtualizarDataSet
      end
    );
  end;



//SELECIONAR
  procedure TFormBuscarClientePGTO.ButtonSelectClick(Sender: TObject);
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

      LID := Self.FDMemTable.FieldByName('CLI_CODIGO').AsInteger;
      FCliente := FControllerClientes.BuscarClientePGTO(LID);

      ModalResult := mrOk;
    end
    );
  end;

  //FILTRAR CLIENTE
  procedure TFormBuscarClientePGTO.EditFiltrarDatasetChange(Sender: TObject);
  begin
    TTratamentoDeErros.ExecutarOnForm(
      procedure
      begin
        Self.FControllerClientes.FiltrarClientesPGTO(EditFiltrarDataset.Text)
      end
    );
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
