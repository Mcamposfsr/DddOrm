unit UFormBuscarProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls,

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
    FRepositoryProdutosECF: IRepository<TProdutosECF>;
    FControllerProdutosECF: IControllerProdutosECF;
  public
    //VAR CONTROLE
    FProduto: TProdutosECF;


    constructor Create(
      AOwner: TComponent;
      ARepositoryProdutosECF: IRepository<TProdutosECF>;
      AControllerProdutosECF: IControllerProdutosECF
    );
  end;

var
  FormBuscarProdutos: TFormBuscarProdutos;

implementation

  {$R *.dfm}

  constructor TFormBuscarProdutos.Create(
    AOwner: TComponent;
    ARepositoryProdutosECF: IRepository<TProdutosECF>;
    AControllerProdutosECF: IControllerProdutosECF
  );
  begin
    inherited Create(AOwner);
    FRepositoryProdutosECF := ARepositoryProdutosECF;
    FControllerProdutosECF := AControllerProdutosECF;

    //PASSAR DATASET
    FRepositoryProdutosECF.ReceberDataSet(Self.FDMemTable);
    FRepositoryProdutosECF.AtualizarDataSet;
  end;



  //BUSCAR
  procedure TFormBuscarProdutos.ButtonSelectClick(Sender: TObject);
  var LID: Integer;
  begin
    if Self.FDMemTable.IsEmpty then
    begin
      ShowMessage('Selecione um Cliente!');
      Exit;
    end;

    LID := Self.FDMemTable.FieldByName('PRO_CODIGO').AsInteger;
    FProduto := FControllerProdutosECF.BuscarProdutoECF(LID);
    ModalResult := mrOK;
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
