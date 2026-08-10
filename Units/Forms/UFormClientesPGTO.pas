unit UFormClientesPGTO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.StdCtrls,UErros,
  Vcl.Grids, Vcl.DBGrids,


  System.Generics.Collections,
  //CLASSE MODELO ORM
  UDomainClientesPGTO,UDM,UGenericRep,UAppClientesPGTO,UControllerClientesPGTO,UIRepository,UFormCadastroClientePGTO,


   FireDAC.Stan.Intf, FireDAC.Stan.Option,
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
    procedure BtnFecharClick(Sender: TObject);
    procedure BtnCadastrarClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnDeletarClick(Sender: TObject);
    procedure EditFiltroNomeChange(Sender: TObject);
  private
    FController: IControllerClientesPGTO;
    procedure VerificarSelecao;
  public
    constructor Create(
    AOwner: Tcomponent;
    AController: IControllerClientesPGTO
    ); Reintroduce;
  end;

var
  FormClientesPGTO: TFormClientesPGTO;

implementation

{$R *.dfm}

  constructor TFormClientesPGTO.Create(
  AOwner: Tcomponent;
  AController: IControllerClientesPGTO
  );
  begin
    inherited Create(AOwner);

    FController := AController;

    //PASSAR DATASET PARA LIGAR AO ORM
    FController.ReceberDataset(Self.FDMemTable);

    TTratamentoDeErros.ExecutarOnForm(
      procedure
      begin
        FController.AtualizarDataSet;
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
