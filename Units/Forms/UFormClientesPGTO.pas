unit UFormClientesPGTO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids,


  System.Generics.Collections,
  //CLASSE MODELO ORM
  UDomainClientesPGTO,UDM,UGenericRep,UAppClientesPGTO,UControllerClientesPGTO,UIRepository,UFormCadastroClientePGTO,

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
  TFormClientesPGTO = class(TForm)
    PainelPrincipal: TPanel;
    PainelSecundario: TPanel;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    EditFiltroNome: TEdit;
    BtnDeletar: TButton;
    BtnAlterar: TButton;
    BtnCadastrar: TButton;
    BtnBuscar: TButton;
    DataSource: TDataSource;
    FDMemTable: TFDMemTable;
    procedure FormCreate(Sender: TObject);
    procedure BtnBuscarClick(Sender: TObject);
    procedure BtnCadastrarClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnDeletarClick(Sender: TObject);
    procedure EditFiltroNomeChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private

    //FERRAMENTAS
    FRepository: IRepository<TClientePGTO>;
    FApp: IAppClientesPGTO;
    FController: IControllerClientesPGTO;

    //CONTROLE FORM
    FOperacao: String;
    FIDCurrentClient: Integer;


    procedure VerificarSelecao;
  public
    { Public declarations }
  end;

var
  FormClientesPGTO: TFormClientesPGTO;

implementation

{$R *.dfm}



procedure TFormClientesPGTO.FormCreate(Sender: TObject);
  begin

    FIDCurrentClient := -1;
    //INICIAR SEM CLIENTE MARCADO
    FOperacao := '';

    //CRIAR REPOSITORY
    FRepository := TRepository<TClientePGTO>.Create(GDM.GetConnection);
    //PASSAR DATASET PARA LIGAR AO ORM
    FRepository.ReceberDataSet(Self.FDMemTable);

    //CRIAR APPLICATION
    FApp := TAppClientesPGTO.Create(FRepository);

    //CONTROLLER
    FController := TControllerClientesPGTO.Create(FApp,FRepository);

    FRepository.AtualizarDataSet;
  end;



// ########## EVENTOS FORM ########## EVENTOS FORM ########## EVENTOS FORM ########## EVENTOS FORM ########## EVENTOS FORM ########## EVENTOS FORM


  //FILTRAR
  procedure TFormClientesPGTO.EditFiltroNomeChange(Sender: TObject);
  begin
    Self.FController.FiltrarClientesPGTO(Self.EditFiltroNome.Text);
  end;

  //BUSCA
  procedure TFormClientesPGTO.BtnBuscarClick(Sender: TObject);
  var
  LFORMCadastroClientePGTO: TFormCadastroClientes;
  LCOD: Integer;
  begin
    try
      Self.VerificarSelecao;
      LCOD := Self.FDMemTable.FieldByName('CLI_CODIGO').AsInteger;
      try
        LFORMCadastroClientePGTO := TFormCadastroClientes.Create(nil,FController,LCOD,'SELECT');
        LFORMCadastroClientePGTO.ShowModal;
      finally
        LFORMCadastroClientePGTO.Free;
      end;
      
    except
      on E: exception do 
      begin
        ShowMessage(E.Message);
      end;
    end;
  end;

  //CADASTRAR
  procedure TFormClientesPGTO.BtnCadastrarClick(Sender: TObject);
  var
  LFORMCadastroClientePGTO: TFormCadastroClientes;
  LCOD: Integer;
  begin
    LCOD := Self.FDMemTable.FieldByName('CLI_CODIGO').AsInteger;
    try
      LFORMCadastroClientePGTO := TFormCadastroClientes.Create(nil,FController,LCOD,'INSERT');
      LFORMCadastroClientePGTO.ShowModal;
    finally
      LFORMCadastroClientePGTO.Free;
    end;
  end;

  //ALTERAR
  procedure TFormClientesPGTO.BtnAlterarClick(Sender: TObject);
  var
  LFORMCadastroClientePGTO: TFormCadastroClientes;
  LCOD: Integer;
  begin
   try
     Self.VerificarSelecao;

     LCOD := Self.FDMemTable.FieldByName('CLI_CODIGO').AsInteger;
     try
      LFORMCadastroClientePGTO := TFormCadastroClientes.Create(nil,FController,LCOD,'UPDATE');
      LFORMCadastroClientePGTO.ShowModal;
     finally
      LFORMCadastroClientePGTO.Free;
     end;
   except 
    on E: Exception do
    begin
     ShowMessage(E.Message);
    end;
   end;
  end;

  //DELETAR
  procedure TFormClientesPGTO.BtnDeletarClick(Sender: TObject);
  var
  LFORMCadastroClientePGTO: TFormCadastroClientes;
  LCOD: Integer;
  begin
   try
    //VERIFICAR SE HÁ CLIENTE SELECIONADO
    Self.VerificarSelecao;
    
    LCOD := Self.FDMemTable.FieldByName('CLI_CODIGO').AsInteger;
    try
      LFORMCadastroClientePGTO := TFormCadastroClientes.Create(nil,FController,LCOD,'DELETE');
      LFORMCadastroClientePGTO.ShowModal;
    finally
      LFORMCadastroClientePGTO.Free;
    end;
    
   except 
    on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
   end;
  end;

  procedure TFormClientesPGTO.FormKeyPress(Sender: TObject; var Key: Char);
  begin
    if Key = #27 then
      Self.Close;
  end;


// ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES

   procedure TFormClientesPGTO.VerificarSelecao;
   begin
    if Self.FDMemTable.RecordCount = 0 then
    begin
      raise Exception.Create('NENHUM CLIENTE SELECIONADO!');
    end;
   end;






end.
