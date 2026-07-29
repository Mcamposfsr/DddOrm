unit UFormFormasPGTO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls,

  System.Generics.Collections,
  //CLASSE MODELO ORM
  UDomainFormasPGTO,UDM,UGenericRep,UAppFormasPGTO,UControllerFormasPGTO,UIRepository,UFormCadastroFormaPGTO,UErros,

  dbebr.factory.interfaces,
  dbebr.factory.firedac,
  ormbr.dml.generator.firebird,
  ormbr.container.fdmemtable,
  ormbr.container.dataset.interfaces,


  //OBJECT SET
  ormbr.container.objectset.interfaces,
  ormbr.container.objectset, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client
  ;

type
  TFormFormasPGTO = class(TForm)
    PainelSecundario: TPanel;
    BtnDeletar: TButton;
    BtnAlterar: TButton;
    BtnCadastrar: TButton;
    BtnFechar: TButton;
    PainelPrincipal: TPanel;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    EditFiltro: TEdit;
    DataSource: TDataSource;
    FDMemTable: TFDMemTable;
    procedure BtnFecharClick(Sender: TObject);
    procedure BtnCadastrarClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnDeletarClick(Sender: TObject);
    procedure EditFiltroChange(Sender: TObject);
  private
    //FERRAMENTAS
    FRepository: IRepository<TFormasPGTO>;
    FApp: IAppFormasPGTO;
    FController: IControllerFormasPGTO;

    procedure VerificarSelecao;
  public
    constructor Create(AOwner: Tcomponent;AController: IControllerFormasPGTO); Reintroduce;
  end;

var
  FormFormasPGTO: TFormFormasPGTO;

implementation

{$R *.dfm}

  constructor TFormFormasPGTO.Create(
  AOwner: Tcomponent;
  AController: IControllerFormasPGTO
  );
  begin
    inherited Create(AOwner);

    FController := AController;

    //PASSAR DATASET PARA LIGAR AO ORM
    FController.ReceberDataset(Self.FDMemTable);

    //CONFIGURAR FORMATO CAMPO DATASET
    TFloatField(FDMemTable.FieldByName('FIN_JUROS')).DisplayFormat := '0.0 %';

    TTratamentoDeErros.ExecutarOnForm(
      procedure
      begin
        FController.AtualizarDataSet;
      end
    );
  end;

// ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM

  //FILTRAR
  procedure TFormFormasPGTO.EditFiltroChange(Sender: TObject);
  begin
    TTratamentoDeErros.ExecutarOnForm(
      procedure
      begin
        Self.FController.FiltrarClientesPGTO(EditFiltro.Text)
      end
    );
  end;

  //FECHAR
  procedure TFormFormasPGTO.BtnFecharClick(Sender: TObject);
  begin
    Self.Close;
  end;

  //CADASTRO
  procedure TFormFormasPGTO.BtnCadastrarClick(Sender: TObject);
  var
  LFORMCadastroPGTO: TFormCadastroPGTO;
  LCOD: Integer;
  begin
    LCOD := Self.FDMemTable.FieldByName('FIN_CODIGO').AsInteger;
    try
      LFORMCadastroPGTO := TFormCadastroPGTO.Create(nil,FController,LCOD,'INSERT');
      LFORMCadastroPGTO.ShowModal;
    finally
      LFORMCadastroPGTO.Free;
    end;
  end;

  //ALTERAR
  procedure TFormFormasPGTO.BtnAlterarClick(Sender: TObject);
  var
  LFORMCadastroPGTO: TFormCadastroPGTO;
  LCOD: Integer;
  begin
    try
      Self.VerificarSelecao;
      LCOD := Self.FDMemTable.FieldByName('FIN_CODIGO').AsInteger;
      try
        LFORMCadastroPGTO := TFormCadastroPGTO.Create(nil,FController,LCOD,'UPDATE');
        LFORMCadastroPGTO.ShowModal;
      finally
        LFORMCadastroPGTO.Free;
      end;
    except
      on E: Exception do
      begin
        ShowMessage(E.Message);
      end;
    end;
  end;

  //DELETAR
  procedure TFormFormasPGTO.BtnDeletarClick(Sender: TObject);
  var
  LFORMCadastroPGTO: TFormCadastroPGTO;
  LCOD: Integer;
  begin
    try
      Self.VerificarSelecao;
      LCOD := Self.FDMemTable.FieldByName('FIN_CODIGO').AsInteger;
      try
        LFORMCadastroPGTO := TFormCadastroPGTO.Create(nil,FController,LCOD,'DELETE');
        LFORMCadastroPGTO.ShowModal;
      finally
        LFORMCadastroPGTO.Free;
      end;
    except
      on E: Exception do
      begin
         ShowMessage(E.Message);
      end;
    end;
  end;

  // ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES

   procedure TFormFormasPGTO.VerificarSelecao;
   begin
    if Self.FDMemTable.RecordCount = 0 then
    begin
      raise Exception.Create('NENHUMA FORMA DE PAGAMENTO SELECIONADA!');
    end;
   end;

end.
