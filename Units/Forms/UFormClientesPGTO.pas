unit UFormClientesPGTO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.StdCtrls,UErros,
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
    BtnFechar: TButton;
    DataSource: TDataSource;
    FDMemTable: TFDMemTable;
    procedure FormCreate(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure BtnCadastrarClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnDeletarClick(Sender: TObject);
    procedure EditFiltroNomeChange(Sender: TObject);
  private

    //FERRAMENTAS
    FRepository: IRepository<TClientePGTO>;
    FApp: IAppClientesPGTO;
    FController: IControllerClientesPGTO;

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
    //CRIAR REPOSITORY
    FRepository := TRepository<TClientePGTO>.Create(GDM.GetConnection);
    //PASSAR DATASET PARA LIGAR AO ORM
    FRepository.ReceberDataSet(Self.FDMemTable);

    //CRIAR APPLICATION
    FApp := TAppClientesPGTO.Create(FRepository);

    //CONTROLLER
    FController := TControllerClientesPGTO.Create(FApp,FRepository);

    TTratamentoDeErros.ExecutarOnForm(
      procedure
      begin
        FRepository.AtualizarDataSet
      end
    );
  end;



// ########## EVENTOS FORM ########## EVENTOS FORM ########## EVENTOS FORM ########## EVENTOS FORM ########## EVENTOS FORM ########## EVENTOS FORM


  //FILTRAR
  procedure TFormClientesPGTO.EditFiltroNomeChange(Sender: TObject);
  begin
    TTratamentoDeErros.ExecutarOnForm(
    procedure
      begin
        Self.FController.FiltrarClientesPGTO(Self.EditFiltroNome.Text)
      end
    );
  end;

  //FECHAR
  procedure TFormClientesPGTO.BtnFecharClick(Sender: TObject);
  begin
    Self.Close;
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


// ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES ########## METODOS AUXÍLIARES

   procedure TFormClientesPGTO.VerificarSelecao;
   begin
    if Self.FDMemTable.RecordCount = 0 then
    begin
      raise Exception.Create('NENHUM CLIENTE SELECIONADO!');
    end;
   end;






end.
