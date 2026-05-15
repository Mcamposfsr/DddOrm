unit UFormOS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls,

  UDM,UIRepository,UAppOrdemServico,UDomainOS,UGenericRep,UControllerOS,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client
  ;

type
  TFormOS = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBGrid1: TDBGrid;
    EditValor: TEdit;
    Panel2: TPanel;
    ButtonDeletar: TButton;
    ButtonCadastrar: TButton;
    ButtonBuscar: TButton;
    ButtonAlterar: TButton;
    ButtonCancel: TButton;
    ButtonSalvar: TButton;
    ComboBoxSituacao: TComboBox;
    DataSource: TDataSource;
    FDMemTable: TFDMemTable;
    DateTimePickerOS: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure ButtonBuscarClick(Sender: TObject);
    procedure ButtonCadastrarClick(Sender: TObject);
    procedure ButtonAlterarClick(Sender: TObject);
    procedure ButtonDeletarClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonSalvarClick(Sender: TObject);
    procedure EditValorKeyPress(Sender: TObject; var Key: Char);
  private
    //FERRAMENTAS
    FDM: IDM;
    FRepository: IRepository<TOrdemServico>;
    FApp: IAppOrdemServico;
    FController: IControllerOrdemServico;
    FIDCurrentOS: Integer;
    FIDCliente: Integer;
    FOperacao: String;

    procedure FormControl(AState:Boolean);

  public
    { Public declarations }
  end;


var
  FormOS: TFormOS;

implementation

{$R *.dfm}

procedure TFormOS.FormCreate(Sender: TObject);
  var LLocationDB: String;
  begin
    FIDCliente := 32;

    LLocationDB := ExtractFilePath(ParamStr(0)) + '\..\..\DataBase\TESTE.FDB';
    //AJUSTAR CLIENTE - SERÁ RECEBIDO NO CREATE DO FORM
    FIDCurrentOS := -1;

    //INICIAR SEM CLIENTE MARCADO
    FOperacao := '';


    //CRIAR DM
    FDM := TDM.Create(
    'SYSDBA',
    'masterkey',
    'localhost',
    '3050',
    LLocationDB
    );

    //CRIAR REPOSITORY
    FRepository := TRepository<TOrdemServico>.Create(FDM.GetConnection);

    //PASSAR DATASET PARA LIGAR AO ORM
    FRepository.ReceberDataSet(Self.FDMemTable);

    //CRIAR APPLICATION
    FApp := TAppOrdemServico.Create(FRepository);

    //CONTROLLER
    FController := TControllerOrdemServico.Create(FApp,FRepository);

    FRepository.AtualizarDataSet;
  end;

  //BUSCAR O.S
  procedure TFormOS.ButtonBuscarClick(Sender: TObject);
  var
  LID: Integer;
  LOS: TOrdemServico;
  begin
    LOS := nil;
    try
      if Self.FDMemTable.RecordCount = 0 then
      begin
        ShowMessage('Nenhum cliente cadastrado');
        Exit;
      end;

      LID := Self.FDMemTable.FieldByName('ID_OS').AsInteger;
      LOS := FController.BuscarOS(LID);
      Self.FIDCurrentOS := LOS.ID;
      Self.EditValor.Text := CurrToStr(LOS.ValorOS);
      Self.ComboBoxSituacao.ItemIndex := Self.ComboBoxSituacao.Items.IndexOf(LOS.EstadoOS);
      Self.DateTimePickerOS.DateTime := LOS.DataOS;
    finally
      LOS.Free;
    end;
  end;

  //INICIAR CADASTRO O.S
  procedure TFormOS.ButtonCadastrarClick(Sender: TObject);
  begin
      FIDCurrentOS := -1;
      Self.FOperacao := '';
      Self.EditValor.Text := '';
      Self.ComboBoxSituacao.ItemIndex := -1;
      Self.DateTimePickerOS.DateTime := 0;
      Self.FormControl(True);
      Self.FOperacao := 'INSERT';
  end;


//INICIAR ALTERAÇÃO O.S
  procedure TFormOS.ButtonAlterarClick(Sender: TObject);
  begin
    if FIDCurrentOS <> -1 then
    begin
      Self.FormControl(True);
      Self.FOperacao := 'UPDATE';
    end
    else
      ShowMessage('SELECIONE UMA O.S!');
  end;

  //DELETAR O.S
  procedure TFormOS.ButtonDeletarClick(Sender: TObject);
  begin
    if FIDCurrentOS <> -1 then
    begin
      //CHAMADA CONTROLLER
      Self.FController.DeletarOS(FIDCurrentOS);

      //CONTROLE DE ESTADO FORMULÁRIO
      Self.FormControl(False);

      ShowMessage('Cliente Deletado!');
    end
    else
      ShowMessage('SELECIONE UM CLIENTE!');

  end;


// ############ CANCEL / SAVE ############ CANCEL / SAVE ############ CANCEL / SAVE ############ CANCEL / SAVE ############ CANCEL / SAVE

  //SALVAR OPERAÇÃO
  procedure TFormOS.ButtonSalvarClick(Sender: TObject);
  begin
    if Self.FOperacao = 'INSERT' then
      begin
        Self.FController.CadastrarOS(
        FIDCliente,
        Self.DateTimePickerOS.Date,
        StrToCurr(Self.EditValor.Text),
        Self.ComboBoxSituacao.Text
        );
       Self.FormControl(False);
      end
    else if Self.FOperacao = 'UPDATE' then
      begin
        Self.FController.AlterarOS(
        Self.FDMemTable.FieldByName('ID_OS').AsInteger,
        FIDCliente,
        Self.DateTimePickerOS.Date,
        StrToCurr(Self.EditValor.Text),
        Self.ComboBoxSituacao.Text
        );
        Self.FormControl(False);
      end;
  end;

//CANCELAR OPERAÇÃO
  procedure TFormOS.ButtonCancelClick(Sender: TObject);
  begin
    Self.FormControl(False);
  end;

  // ########### FORM AUX ########### FORM AUX ########### FORM AUX ########### FORM AUX ########### FORM AUX


  //CONTROLE ESTADO FORM
  procedure TFormOS.FormControl(AState:Boolean);
  begin
    if AState then
    begin
      Self.EditValor.Enabled := AState;
      Self.ComboBoxSituacao.Enabled := AState;
      Self.DateTimePickerOS.Enabled := AState;
      Self.ButtonCancel.Enabled := AState;
      Self.ButtonSalvar.Enabled := AState;
      Self.ComboBoxSituacao.Enabled := AState;
    end
    else
    begin
      Self.EditValor.Enabled := AState;
      Self.ComboBoxSituacao.Enabled := AState;
      Self.DateTimePickerOS.Enabled := AState;
      Self.ButtonCancel.Enabled := AState;
      Self.ButtonSalvar.Enabled := AState;
      Self.ComboBoxSituacao.Enabled := AState;

      FIDCurrentOS := -1;
      Self.FOperacao := '';
      Self.EditValor.Text := '';
      Self.ComboBoxSituacao.ItemIndex := -1;
      Self.DateTimePickerOS.DateTime := 0;
    end;
  end;

  procedure TFormOS.EditValorKeyPress(Sender: TObject; var Key: Char);
  begin

    // aceita números
    if Key in ['0'..'9', #8, ','] then
      Exit;

    // bloqueia o resto
    Key := #0;

  end;

end.
