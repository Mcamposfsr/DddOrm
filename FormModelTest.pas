unit FormModelTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, System.IOUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client,FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet,UFormOS,

  System.Generics.Collections,
  //CLASSE MODELO ORM
  UDomainClientes,UDM,UGenericRep,UAppClientes,UControllerClientes,UIRepository,

  dbebr.factory.interfaces,
  dbebr.factory.firedac,
  ormbr.dml.generator.firebird,
  ormbr.container.fdmemtable,
  ormbr.container.dataset.interfaces,


  //OBJECT SET
  ormbr.container.objectset.interfaces,
  ormbr.container.objectset
  ;

type
  TFormPrincipal = class(TForm)
    Panel1: TPanel;
    DataSource: TDataSource;
    DBGrid1: TDBGrid;
    EditCPF: TEdit;
    EditNome: TEdit;
    Panel2: TPanel;
    ButtonDeletar: TButton;
    ButtonCadastrar: TButton;
    ButtonBuscar: TButton;
    ButtonAlterar: TButton;
    FDMemTable: TFDMemTable;
    ButtonCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ButtonSalvar: TButton;
    ButtonOS: TButton;
    Label3: TLabel;
    ComboBoxSituacao: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure ButtonSalvarClick(Sender: TObject);
    procedure ButtonBuscarClick(Sender: TObject);
    procedure ButtonDeletarClick(Sender: TObject);
    procedure ButtonCadastrarClick(Sender: TObject);
    procedure ButtonAlterarClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOSClick(Sender: TObject);
  private
    //FERRAMENTAS
    FDM: IDM;
    FRepository: IRepository<TCliente>;
    FApp: IAppClientes;
    FController: IController;

    //CONTROLE FORM
    FOperacao: String;
    FIDCurrentClient: Integer;
    procedure FormControl(AState:Boolean);




  public

  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

  // INCIALIZAR FERRAMENTAS
  procedure TFormPrincipal.FormCreate(Sender: TObject);
  var LLocationDB: String;
  begin
    // para banco Firebird 5
    //LLocationDB := ExtractFilePath(ParamStr(0)) + '..\..\DataBase\TESTE.FDB';

    // para banco Firebird 1.5
    LLocationDB := TPath.GetFullPath(ExtractFilePath(ParamStr(0)) + '\..\..\..\TESTE_ORM.FDB');


    FIDCurrentClient := -1;
    //INICIAR SEM CLIENTE MARCADO
    FOperacao := '';


    //CRIAR DM
    FDM := TDM.Create(
    'SYSDBA',
    'managerx',
    'localhost',
    '3055',
    LLocationDB
    );

    //CRIAR REPOSITORY
    FRepository := TRepository<TCliente>.Create(FDM.GetConnection);
    //PASSAR DATASET PARA LIGAR AO ORM
    FRepository.ReceberDataSet(Self.FDMemTable);

    //CRIAR APPLICATION
    FApp := TAppClientes.Create(FRepository);

    //CONTROLLER
    FController := TController.Create(FRepository,FApp);

    FRepository.AtualizarDataSet;
  end;

// ##################### EVENTOS BTN ##################### EVENTOS BTN ##################### EVENTOS BTN ##################### EVENTOS BTN

  //BUSCAR DADOS DO CLIENTE SELECIONADO
  procedure TFormPrincipal.ButtonBuscarClick(Sender: TObject);
  var
  LCLiente: TCliente;
  begin
    LCliente := nil;
    try
      if Self.FDMemTable.RecordCount = 0 then
      begin
        ShowMessage('Nenhum cliente cadastrado');
        Exit;
      end;

      //BUSCAR ID DATASET.
      FIDCurrentClient := Self.FDMemTable.FieldByName('ID_CLIENTE').AsInteger;

      //CHAMADA DO CONTROLLER
      LCliente := Self.FController.BuscarCliente(FIDCurrentClient);

      //PASSAGEM DE VALORES
      Self.EditNome.Text := LCliente.Nome;
      Self.EditCPF.Text := LCliente.CPF;
      Self.ComboBoxSituacao.ItemIndex := Self.ComboBoxSituacao.Items.IndexOf(LCliente.Estado);
    finally
      LCliente.Free;
    end;
  end;

  procedure TFormPrincipal.ButtonOSClick(Sender: TObject);
  var
  LForm: TFormOS;
  LID: Integer;
  begin
    LID := Self.FDMemTable.FieldByName('ID_CLIENTE').AsInteger;
    LForm := nil;
    try
      LForm := TFormOS.Create(nil,LID,Self.FRepository);
      LForm.ShowModal;
    finally
      LForm.Free;
    end;
  end;


  //CADASTRO
  procedure TFormPrincipal.ButtonCadastrarClick(Sender: TObject);
  begin
    FIDCurrentClient := -1;
    Self.FormControl(True);
    Self.EditNome.Text := '';
    Self.EditCPF.Text := '';
    Self.ComboBoxSituacao.ItemIndex := -1;
    Self.FOperacao := 'INSERT';
  end;

//ALTERAR CLIENTE
  procedure TFormPrincipal.ButtonAlterarClick(Sender: TObject);
  var LID: Integer;
  begin
    if FIDCurrentClient <> -1 then
    begin
      Self.FormControl(True);
      Self.FOperacao := 'UPDATE';
    end
    else
      ShowMessage('SELECIONE UM CLIENTE!');
  end;


  //DELETAR
  procedure TFormPrincipal.ButtonDeletarClick(Sender: TObject);
  begin
    if FIDCurrentClient <> -1 then
    begin
      //CHAMADA CONTROLLER
      Self.FController.DeletarCliente(FIDCurrentClient);

      //CONTROLE DE ESTADO FORMULÁRIO
      Self.FormControl(False);

      ShowMessage('Cliente Deletado!');
    end
    else
      ShowMessage('SELECIONE UM CLIENTE!');
  end;


// ############ CANCEL / SAVE ############ CANCEL / SAVE ############ CANCEL / SAVE ############ CANCEL / SAVE ############ CANCEL / SAVE

  //SALVAR
  procedure TFormPrincipal.ButtonSalvarClick(Sender: TObject);
  begin
    if Self.FOperacao = 'INSERT' then
      begin
        Self.FController.CadastrarCliente(
        Self.EditNome.Text,
        Self.EditCPF.Text,
        Self.ComboBoxSituacao.Text
        );
       Self.FormControl(False);
      end
    else if Self.FOperacao = 'UPDATE' then
      begin
        Self.FController.AlterarCLiente(
        Self.FDMemTable.FieldByName('ID_CLIENTE').AsInteger,
        Self.EditNome.Text,
        Self.EditCPF.Text,
        Self.ComboBoxSituacao.Text
        );
        Self.FormControl(False);
      end;
  end;

  //RESETAR ESTADO FORM
  procedure TFormPrincipal.ButtonCancelClick(Sender: TObject);
  begin
    Self.FormControl(False);
  end;


  // ########### FORM AUX ########### FORM AUX ########### FORM AUX ########### FORM AUX ########### FORM AUX


  //CONTROLE ESTADO FORM
  procedure TFormPrincipal.FormControl(AState:Boolean);
  begin
    if AState then
    begin
      Self.EditNome.Enabled := AState;
      Self.EditCPF.Enabled := AState;
      Self.ButtonCancel.Enabled := AState;
      Self.ButtonSalvar.Enabled := AState;
      Self.ComboBoxSituacao.Enabled := AState;
    end
    else
    begin
      Self.EditNome.Enabled := AState;
      Self.EditCPF.Enabled := AState;
      Self.ButtonCancel.Enabled := AState;
      Self.ButtonSalvar.Enabled := AState;
      Self.ComboBoxSituacao.Enabled := AState;

      FIDCurrentClient := -1;
      Self.FOperacao := '';
      Self.EditNome.Text := '';
      Self.EditCPF.Text := '';
      Self.ComboBoxSituacao.ItemIndex := -1;
    end;
  end;

end.
