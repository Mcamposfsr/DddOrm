unit UFormProdutosEFC;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,


  UIRepository,UDomainProdutosECF,UControllerProdutosECF,UAppProdutosECF,UGenericRep,UDM,UFormCadastroProdutosEFC;

type
  TFormProdutosEFC = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure EditFiltroChange(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure BtnCadastrarClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnDeletarClick(Sender: TObject);
  private
    //FERRAMENTAS
    FRepository: IRepository<TProdutosECF>;
    FApp: IAppProdutosECF;
    FController: IControllerProdutosECF;

    procedure VerificarSelecao;
  public
    { Public declarations }
  end;

var
  FormProdutosEFC: TFormProdutosEFC;

implementation

{$R *.dfm}



procedure TFormProdutosEFC.FormCreate(Sender: TObject);
  begin
    //CRIAR REPOSITORY
    FRepository := TRepository<TProdutosECF>.Create(GDM.GetConnection);
    //PASSAR DATASET PARA LIGAR AO ORM
    FRepository.ReceberDataSet(Self.FDMemTable);

    //CRIAR APPLICATION
    FApp := TAppProdutosECF.Create(FRepository);

    //CONTROLLER
    FController := TControllerProdutosECF.Create(FApp,FRepository);

    //CONFIGURAR FORMATO CAMPO DATASET
    TFloatField(FDMemTable.FieldByName('ALIQ_PIS')).DisplayFormat := '0.0 %';
    TFloatField(FDMemTable.FieldByName('ALIQ_COFINS')).DisplayFormat := '0.0 %';
    TFloatField(FDMemTable.FieldByName('DESCONTO_MAX')).DisplayFormat := '0.0 %';

    FRepository.AtualizarDataSet;

  end;


// ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM

  //FILTRAR
  procedure TFormProdutosEFC.EditFiltroChange(Sender: TObject);
  begin
    Self.FController.FiltrarProdutoECF(EditFiltro.Text);
  end;

  //FECHAR FORM
  procedure TFormProdutosEFC.BtnFecharClick(Sender: TObject);
  begin
    Self.Close;
  end;


  //CADASTRO
  procedure TFormProdutosEFC.BtnCadastrarClick(Sender: TObject);
  var
  LFORMCadastroProduto: TFormCadastroProdutosEFC;
  LCOD: Integer;
  begin
    LCOD := Self.FDMemTable.FieldByName('PRO_CODIGO').AsInteger;
    try
      LFORMCadastroProduto := TFormCadastroProdutosEFC.Create(nil,FController,LCOD,'INSERT');
      LFORMCadastroProduto.ShowModal;
    finally
      LFORMCadastroProduto.Free;
    end;
  end;



  //ALTERAR
  procedure TFormProdutosEFC.BtnAlterarClick(Sender: TObject);
  var
  LFORMCadastroProduto: TFormCadastroProdutosEFC;
  LCOD: Integer;
  begin
    try
      Self.VerificarSelecao;
      LCOD := Self.FDMemTable.FieldByName('PRO_CODIGO').AsInteger;
      try
        LFORMCadastroProduto := TFormCadastroProdutosEFC.Create(nil,FController,LCOD,'UPDATE');
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
  procedure TFormProdutosEFC.BtnDeletarClick(Sender: TObject);
  var
  LFORMCadastroProduto: TFormCadastroProdutosEFC;
  LCOD: Integer;
  begin
    try
      Self.VerificarSelecao;
      LCOD := Self.FDMemTable.FieldByName('PRO_CODIGO').AsInteger;
      try
        LFORMCadastroProduto := TFormCadastroProdutosEFC.Create(nil,FController,LCOD,'DELETE');
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

   procedure TFormProdutosEFC.VerificarSelecao;
   begin
    if Self.FDMemTable.RecordCount = 0 then
    begin
      raise Exception.Create('NENHUMA FORMA DE PAGAMENTO SELECIONADA!');
    end;
   end;

end.
