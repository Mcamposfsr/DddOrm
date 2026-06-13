unit UFormFormasPGTO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls,

  System.Generics.Collections,
  //CLASSE MODELO ORM
  UDomainFormasPGTO,UDM,UGenericRep,UAppFormasPGTO,UControllerFormasPGTO,UIRepository,UFormCadastroFormaPGTO,

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
    procedure FormCreate(Sender: TObject);
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

    //CONTROLE FORM
    FOperacao: String;
    FIDCurrentClient: Integer;

    procedure VerificarSelecao;
  public
    { Public declarations }
  end;

var
  FormFormasPGTO: TFormFormasPGTO;

implementation

{$R *.dfm}





procedure TFormFormasPGTO.FormCreate(Sender: TObject);
 begin
    FIDCurrentClient := -1;
    //INICIAR SEM CLIENTE MARCADO
    FOperacao := '';

    //CRIAR REPOSITORY
    FRepository := TRepository<TFormasPGTO>.Create(GDM.GetConnection);
    //PASSAR DATASET PARA LIGAR AO ORM
    FRepository.ReceberDataSet(Self.FDMemTable);

    //CRIAR APPLICATION
    FApp := TAppFormasPGTO.Create(FRepository);

    //CONTROLLER
    FController := TControllerFormasPGTO.Create(FApp,FRepository);

    //CONFIGURAR FORMATO CAMPO DATASET
    TFloatField(FDMemTable.FieldByName('FIN_JUROS')).DisplayFormat := '0.0 %';

    FRepository.AtualizarDataSet;
  end;




// ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM

  //FILTRAR
  procedure TFormFormasPGTO.EditFiltroChange(Sender: TObject);
  begin
    Self.FController.FiltrarClientesPGTO(EditFiltro.Text);
  end;

  //BUSCAR
  procedure TFormFormasPGTO.BtnFecharClick(Sender: TObject);
  var
  LFORMCadastroPGTO: TFormCadastroPGTO;
  LCOD: Integer;
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
