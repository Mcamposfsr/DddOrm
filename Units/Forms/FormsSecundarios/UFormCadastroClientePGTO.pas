unit UFormCadastroClientePGTO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, NumericEdit, Vcl.StdCtrls,

  UControllerClientesPGTO,UDomainClientesPGTO, Vcl.Buttons,UTelefoneValidator;

type
  TFormCadastroClientes = class(TForm)
    PanelPrincipal: TPanel;
    Label1: TLabel;
    EditNome: TEdit;
    Label2: TLabel;
    EditEndereco: TEdit;
    EditNumero: TEdit;
    Label3: TLabel;
    Label5: TLabel;
    EditDocumento: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    ComboBoxPessoa: TComboBox;
    NumericEditCredito: TNumericEdit;
    Label8: TLabel;
    ComboBoxAtivo: TComboBox;
    BtnFinal: TButton;
    GroupBox1: TGroupBox;
    EditEmail: TEdit;
    BitBtnRemoverEmail: TBitBtn;
    ListBoxEmail: TListBox;
    BitBtnAdicionarEmail: TBitBtn;
    GroupBox2: TGroupBox;
    EditTelefone: TEdit;
    BitBtnAdicionarTelefone: TBitBtn;
    BitBtnRemoverTelefone: TBitBtn;
    ListBoxTelefones: TListBox;
    procedure FormShow(Sender: TObject);
    procedure BtnFinalClick(Sender: TObject);
    procedure BitBtnAdicionarEmailClick(Sender: TObject);
    procedure BitBtnRemoverEmailClick(Sender: TObject);
    procedure BitBtnAdicionarTelefoneClick(Sender: TObject);
    procedure BitBtnRemoverTelefoneClick(Sender: TObject);
    procedure GroupBox2Click(Sender: TObject);
  private

    //FERRAMENTAS
    FController: IControllerClientesPGTO;
    FCODCliente: Integer;
    FOperacao: String;

    //MÉTODOS AUXÍLIARES
    procedure ReceberValores(ACliente:TClientePGTO);
    procedure FormControl(AEstado:Boolean);


  public
    constructor Create(
    AOWner: TComponent;
    AController: IControllerClientesPGTO;
    AIDCliente: Integer;
    AOperacao: String
    ); Reintroduce;

  end;

var
  FormCadastroClientes: TFormCadastroClientes;

implementation

{$R *.dfm}

                 //INICIALIZAÇÃO DE FERRAMENTAS
  constructor TFormCadastroClientes.Create(
  AOWner: TComponent;
  AController: IControllerClientesPGTO;
  AIDCliente: Integer;
  AOperacao: String
  );
  begin
    inherited Create(AOwner);

    FController := AController;
    FCODCliente := AIDCliente;
    FOperacao :=  AOperacao;
  end;

  //INICIALIZAÇÃO VISUAL
  procedure TFormCadastroClientes.FormShow(Sender: TObject);
  var LCliente: TClientePGTO;
  begin
    //VERIFICAR OPERAÇÃO PASSADA PARA FORM E DEFINIR ESTADO.
    if FOperacao = 'SELECT' then
    begin
      LCliente := FController.BuscarClientePGTO(FCODCliente);
      Self.ReceberValores(LCliente);
      Self.FormControl(False);
    end
    else if FOperacao = 'INSERT' then
    begin
      BtnFinal.Caption := 'CADASTRAR';
    end
    else if FOperacao = 'UPDATE' then
    begin
      LCliente := FController.BuscarClientePGTO(FCODCliente);
      Self.ReceberValores(LCliente);
      Self.FormControl(True);
      BtnFinal.Caption := 'ATUALIZAR';
    end
    else if FOperacao = 'DELETE' then
    begin
      LCliente := FController.BuscarClientePGTO(FCODCliente);
      Self.ReceberValores(LCliente);
      Self.FormControl(FALSE);
      BtnFinal.Enabled := True;
      BtnFinal.Caption := 'DELETAR';
    end;
  end;

  procedure TFormCadastroClientes.GroupBox2Click(Sender: TObject);
begin

end;

// ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM





procedure TFormCadastroClientes.BtnFinalClick(Sender: TObject);
  begin
    try
       //VERIFICAR OPERAÇÃO PASSADA PARA FORM E DEFINIR ESTADO.
      if FOperacao = 'INSERT' then
      begin
        FController.CadastrarClientePGTO(
        EditNome.Text,
        EditEndereco.Text,
        EditNumero.Text,
        String.Join(';', ListBoxTelefones.Items.ToStringArray),
        ComboBoxPessoa.Text,
        EditDocumento.Text,
        ComboBoxAtivo.Text,
        String.Join(';', ListBoxEmail.Items.ToStringArray),
        NumericEditCredito.Text
        );
        ShowMessage('CLIENTE CADASTRADO!');
        Self.Close;
      end
      else if FOperacao = 'UPDATE' then
      begin
        FController.AlterarClientePGTO(
        Self.FCODCliente,
        EditNome.Text,
        EditEndereco.Text,
        EditNumero.Text,
        String.Join(';', ListBoxTelefones.Items.ToStringArray),
        ComboBoxPessoa.Text,
        EditDocumento.Text,
        ComboBoxAtivo.Text,
        String.Join(';', ListBoxEmail.Items.ToStringArray),
        NumericEditCredito.Text
        );
        ShowMessage('CLIENTE ATUALIZADO!');
        Self.Close;
      end
      else if FOperacao = 'DELETE' then
      begin
        FController.DeletarClientePGTO(Self.FCODCliente);
        ShowMessage('CLIENTE DELETADO!');
        Self.Close;
      end;

    except
      on E: Exception do
      begin
        ShowMessage(E.Message);
      end;
    end;
  end;

  //ADICIONAR EMAIL A LISTA
  procedure TFormCadastroClientes.BitBtnAdicionarEmailClick(Sender: TObject);
  begin
    if Self.EditEmail.Text = '' then
      Exit;
    ListBoxEmail.Items.Add(Self.EditEmail.Text);
    Self.EditEmail.Clear;
  end;

  //REMOVER EMAIL DA LISTA
  procedure TFormCadastroClientes.BitBtnRemoverEmailClick(Sender: TObject);
  begin
    if ListBoxEmail.ItemIndex >= 0 then
      ListBoxEmail.Items.Delete(ListBoxEmail.ItemIndex)
    else
      ShowMessage('SELECIONE UM EMAIL!');
  end;

  //ADICIONAR TELEFONE A LISTA
  procedure TFormCadastroClientes.BitBtnAdicionarTelefoneClick(Sender: TObject);
  begin
    if Self.EditTelefone.Text = '' then
      Exit;
    ListBoxTelefones.Items.Add(Self.EditTelefone.Text);
    Self.EditTelefone.Clear;
  end;

  //REMOVER TELEFONE DA LISTA
  procedure TFormCadastroClientes.BitBtnRemoverTelefoneClick(Sender: TObject);
  begin
    if ListBoxTelefones.ItemIndex >= 0 then
      ListBoxTelefones.Items.Delete(ListBoxTelefones.ItemIndex)
    else
      ShowMessage('SELECIONE UM TELEFONE!');
  end;

  // ########## MÉTODOS AUXÍLIARES ########## MÉTODOS AUXÍLIARES  ########## MÉTODOS AUXÍLIARES  ########## MÉTODOS AUXÍLIARES  ########## MÉTODOS AUXÍLIARES

  // PASSAR VALORES DDO PARA FORM
  procedure TFormCadastroClientes.ReceberValores(ACliente:TClientePGTO);
  begin
    EditNome.Text := ACliente.Nome;
    EditEndereco.Text := ACliente.Endereco;
    EditNumero.Text := ACliente.Numero;
    EditDocumento.Text := ACliente.Documento;

    ListBoxTelefones.Items.StrictDelimiter := True;
    ListBoxTelefones.Items.Delimiter := ';';
    ListBoxTelefones.Items.DelimitedText := ACliente.Telefone;

    ComboBoxPessoa.ItemIndex := ComboBoxPessoa.Items.IndexOf(ACliente.Pessoa);
    NumericEditCredito.Value := ACliente.LimiteCredito;

    ComboBoxAtivo.ItemIndex :=  ComboBoxAtivo.Items.IndexOf(ACliente.Ativo);

    ListBoxEmail.Items.StrictDelimiter := True;
    ListBoxEmail.Items.Delimiter := ';';
    ListBoxEmail.Items.DelimitedText := ACliente.Email;
  end;

  // ATIVAR/DESATIVAR ELEMENTOS
  procedure TFormCadastroClientes.FormControl(AEstado:Boolean);
  begin
    EditNome.Enabled := AEstado;
    EditEndereco.Enabled := AEstado;
    EditNumero.Enabled := AEstado;
    EditDocumento.Enabled := AEstado;

    ComboBoxPessoa.Enabled := AEstado;
    NumericEditCredito.Enabled := AEstado;
    ComboBoxAtivo.Enabled := AEstado;


    ListBoxTelefones.Enabled := AEstado;
    EditTelefone.Enabled := AEstado;
    BitBtnRemoverTelefone.Enabled := AEstado;
    BitBtnAdicionarTelefone.Enabled := AEstado;

    ListBoxEmail.Enabled := AEstado;
    EditEmail.Enabled := AEstado;
    BitBtnAdicionarEmail.Enabled := AEstado;
    BitBtnRemoverEmail.Enabled := AEstado;

    BtnFinal.Enabled := AEstado;
  end;

end.
