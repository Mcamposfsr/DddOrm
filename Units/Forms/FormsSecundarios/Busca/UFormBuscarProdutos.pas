unit UFormBuscarProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls,UErros,

  UDomainProdutosECF,UGenericRep,UIRepository,UControllerProdutosECF,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFormBuscarProdutos = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    DBGrid: TDBGrid;
    ButtonSelect: TButton;
    ButtonCancel: TButton;
    DataSource: TDataSource;
    FDMemTable: TFDMemTable;
    EditFiltrarDataset: TEdit;
    procedure ButtonSelectClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure EditFiltrarDatasetChange(Sender: TObject);
  private
    //FERRAMENTAS
    FControllerProdutosECF: IControllerProdutosECF;
  public
    //VAR CONTROLE
    FProduto: TProdutosECF;

    constructor Create(
      AOwner: TComponent;
      AControllerProdutosECF: IControllerProdutosECF
    );
  end;

var
  FormBuscarProdutos: TFormBuscarProdutos;

implementation

  {$R *.dfm}

  constructor TFormBuscarProdutos.Create(
    AOwner: TComponent;
    AControllerProdutosECF: IControllerProdutosECF
  );
  begin
    inherited Create(AOwner);
    FControllerProdutosECF := AControllerProdutosECF;

    //PASSAR DATASET
    FControllerProdutosECF.ReceberDataSet(Self.FDMemTable);
    TTratamentoDeErros.ExecutarOnForm(
    procedure
    begin
      FControllerProdutosECF.AtualizarDataSet;
    end
    );
  end;

  //BUSCAR
  procedure TFormBuscarProdutos.ButtonSelectClick(Sender: TObject);
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

      LID := Self.FDMemTable.FieldByName('PRO_CODIGO').AsInteger;
      FProduto := FControllerProdutosECF.BuscarProdutoECF(LID);
      ModalResult := mrOK;
    end);
  end;

  //FILTRAR CLIENTES
  procedure TFormBuscarProdutos.EditFiltrarDatasetChange(Sender: TObject);
  begin
    Self.FControllerProdutosECF.FiltrarProdutoECF(EditFiltrarDataset.Text);
  end;

  //CANCELAR
  procedure TFormBuscarProdutos.ButtonCancelClick(Sender: TObject);
  begin
    ModalResult := mrCancel;
  end;

end.
