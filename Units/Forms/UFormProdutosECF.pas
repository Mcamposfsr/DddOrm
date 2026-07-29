unit UFormProdutosECF;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,

  //FERRAMENTAS
  UIRepository,
  UDomainProdutosECF,
  UControllerProdutosECF,
  UAppProdutosECF,
  UGenericRep,
  UDM,
  UErros,
  //FORMS
  UFormCadastroProdutosECF;

type
  TFormProdutosECF = class(TForm)
    PainelPrincipal: TPanel;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    EditFiltro: TEdit;
    PainelSecundario: TPanel;
    BtnDeletar: TButton;
    BtnAlterar: TButton;
    BtnCadastrar: TButton;
    BtnFechar: TButton;
    FDMemTable: TFDMemTable;
    DataSource: TDataSource;
    procedure EditFiltroChange(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure BtnCadastrarClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnDeletarClick(Sender: TObject);
  private
    FController: IControllerProdutosECF;

    procedure VerificarSelecao;
  public
    constructor Create(AOwner: Tcomponent;AController: IControllerProdutosECF); Reintroduce;
  end;

var
  FormProdutosECF: TFormProdutosECF;

implementation

{$R *.dfm}

  constructor TFormProdutosECF.Create(
  AOwner: Tcomponent;
  AController: IControllerProdutosECF
  );
  begin
    inherited Create(AOwner);

    FController := AController;

    //PASSAR DATASET PARA LIGAR AO ORM
    FController.ReceberDataSet(Self.FDMemTable);

    //CONFIGURAR FORMATO CAMPO DATASET
    TFloatField(FDMemTable.FieldByName('ALIQ_PIS')).DisplayFormat := '0.0 %';
    TFloatField(FDMemTable.FieldByName('ALIQ_COFINS')).DisplayFormat := '0.0 %';
    TFloatField(FDMemTable.FieldByName('DESCONTO_MAX')).DisplayFormat := '0.0 %';

    TTratamentoDeErros.ExecutarOnForm(
      procedure
      begin
        FController.AtualizarDataSet
      end
    );
  end;

// ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM

  //FILTRAR
  procedure TFormProdutosECF.EditFiltroChange(Sender: TObject);
  begin
    TTratamentoDeErros.ExecutarOnForm(
      procedure
      begin
        Self.FController.FiltrarProdutoECF(EditFiltro.Text)
      end
    );
  end;

  //FECHAR FORM
  procedure TFormProdutosECF.BtnFecharClick(Sender: TObject);
  begin
    Self.Close;
  end;


  //CADASTRO
  procedure TFormProdutosECF.BtnCadastrarClick(Sender: TObject);
  var
  LFORMCadastroProduto: TFormCadastroProdutosECF;
  LCOD: Integer;
  begin
    LCOD := Self.FDMemTable.FieldByName('PRO_CODIGO').AsInteger;
    try
      LFORMCadastroProduto := TFormCadastroProdutosECF.Create(nil,FController,LCOD,'INSERT');
      LFORMCadastroProduto.ShowModal;
    finally
      LFORMCadastroProduto.Free;
    end;
  end;



  //ALTERAR
  procedure TFormProdutosECF.BtnAlterarClick(Sender: TObject);
  var
  LFORMCadastroProduto: TFormCadastroProdutosECF;
  LCOD: Integer;
  begin
    try
      Self.VerificarSelecao;
      LCOD := Self.FDMemTable.FieldByName('PRO_CODIGO').AsInteger;
      try
        LFORMCadastroProduto := TFormCadastroProdutosECF.Create(nil,FController,LCOD,'UPDATE');
        LFORMCadastroProduto.ShowModal;
      finally
        LFORMCadastroProduto.Free;
      end;
    except
      on E: Exception do
      begin
        ShowMessage(E.Message);
      end;
    end;
  end;


  //DELETE
  procedure TFormProdutosECF.BtnDeletarClick(Sender: TObject);
  var
  LFORMCadastroProduto: TFormCadastroProdutosECF;
  LCOD: Integer;
  begin
    try
      Self.VerificarSelecao;
      LCOD := Self.FDMemTable.FieldByName('PRO_CODIGO').AsInteger;
      try
        LFORMCadastroProduto := TFormCadastroProdutosECF.Create(nil,FController,LCOD,'DELETE');
        LFORMCadastroProduto.ShowModal;
      finally
        LFORMCadastroProduto.Free;
      end;

    except
      on E: Exception do
      begin
         ShowMessage(E.Message);
      end;
    end;
  end;

   // ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES

   procedure TFormProdutosECF.VerificarSelecao;
   begin
    if Self.FDMemTable.RecordCount = 0 then
    begin
      raise Exception.Create('NENHUMA FORMA DE PAGAMENTO SELECIONADA!');
    end;
   end;

end.
