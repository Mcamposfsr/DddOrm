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
    BtnBuscar: TButton;
    PainelPrincipal: TPanel;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    DataSource: TDataSource;
    FDMemTable: TFDMemTable;
    procedure FormCreate(Sender: TObject);
    procedure BtnBuscarClick(Sender: TObject);
    procedure BtnCadastrarClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnDeletarClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    //FERRAMENTAS
    FRepository: IRepository<TFormasPGTO>;
    FApp: IAppFormasPGTO;
    FController: IControllerFormasPGTO;

    //CONTROLE FORM
    FOperacao: String;
    FIDCurrentClient: Integer;
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

    FRepository.AtualizarDataSet;
  end;

  // ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM

  //FILTRAR
  procedure TFormFormasPGTO.Edit1Change(Sender: TObject);
  begin
//    DASDAS
  end;

  //BUSCAR
  procedure TFormFormasPGTO.BtnBuscarClick(Sender: TObject);
  var
  LFORMCadastroPGTO: TFormCadastroPGTO;
  LCOD: Integer;
  begin
    LCOD := Self.FDMemTable.FieldByName('FIN_CODIGO').AsInteger;
    try
      LFORMCadastroPGTO := TFormCadastroPGTO.Create(nil,FController,LCOD,'SELECT');
      LFORMCadastroPGTO.ShowModal;
    finally
      LFORMCadastroPGTO.Free;
    end;
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
    LCOD := Self.FDMemTable.FieldByName('FIN_CODIGO').AsInteger;
    try
      LFORMCadastroPGTO := TFormCadastroPGTO.Create(nil,FController,LCOD,'UPDATE');
      LFORMCadastroPGTO.ShowModal;
    finally
      LFORMCadastroPGTO.Free;
    end;
  end;

  //DELETAR
  procedure TFormFormasPGTO.BtnDeletarClick(Sender: TObject);
  var
  LFORMCadastroPGTO: TFormCadastroPGTO;
  LCOD: Integer;
  begin
    LCOD := Self.FDMemTable.FieldByName('FIN_CODIGO').AsInteger;
    try
      LFORMCadastroPGTO := TFormCadastroPGTO.Create(nil,FController,LCOD,'DELETE');
      LFORMCadastroPGTO.ShowModal;
    finally
      LFORMCadastroPGTO.Free;
    end;
  end;

end.
