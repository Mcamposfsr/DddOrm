unit UFormCadastroClientePGTO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, NumericEdit, Vcl.StdCtrls,

  UControllerClientesPGTO,UDomainClientesPGTO;

type
  TFormCadastroClientes = class(TForm)
    PanelPrincipal: TPanel;
    Label1: TLabel;
    EditNome: TEdit;
    Label2: TLabel;
    EditEndereco: TEdit;
    EditNumero: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EditDocumento: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    MemoTelefone: TMemo;
    ComboBoxPessoa: TComboBox;
    NumericEditCredito: TNumericEdit;
    Label8: TLabel;
    ComboBoxAtivo: TComboBox;
    MemoEmail: TMemo;
    Label9: TLabel;
    BtnFinal: TButton;
    procedure FormShow(Sender: TObject);
    procedure BtnFinalClick(Sender: TObject);
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

  // ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM

  procedure TFormCadastroClientes.BtnFinalClick(Sender: TObject);
  begin
    //VERIFICAR OPERAÇÃO PASSADA PARA FORM E DEFINIR ESTADO.
    if FOperacao = 'INSERT' then
    begin
      FController.CadastrarClientePGTO(
      EditNome.Text,
      EditEndereco.Text,
      EditNumero.Text,
      String.Join(';', MemoTelefone.Lines.ToStringArray),
      ComboBoxPessoa.Text,
      EditDocumento.Text,
      ComboBoxAtivo.Text,
      String.Join(';', MemoEmail.Lines.ToStringArray),
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
      String.Join(';', MemoTelefone.Lines.ToStringArray),
      ComboBoxPessoa.Text,
      EditDocumento.Text,
      ComboBoxAtivo.Text,
      String.Join(';', MemoEmail.Lines.ToStringArray),
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
  end;

  // ########## MÉTODOS AUXÍLIARES ########## MÉTODOS AUXÍLIARES  ########## MÉTODOS AUXÍLIARES  ########## MÉTODOS AUXÍLIARES  ########## MÉTODOS AUXÍLIARES

  // PASSAR VALORES DDO PARA FORM
  procedure TFormCadastroClientes.ReceberValores(ACliente:TClientePGTO);
  begin
    EditNome.Text := ACliente.Nome;
    EditEndereco.Text := ACliente.Endereco;
    EditNumero.Text := ACliente.Numero;
    EditDocumento.Text := ACliente.Documento;

    MemoTelefone.Lines.StrictDelimiter := True;
    MemoTelefone.Lines.Delimiter := ';';
    MemoTelefone.Lines.DelimitedText := ACliente.Telefone;

    ComboBoxPessoa.ItemIndex := ComboBoxPessoa.Items.IndexOf(ACliente.Pessoa);
    NumericEditCredito.Value := ACliente.LimiteCredito;

    ComboBoxAtivo.ItemIndex :=  ComboBoxAtivo.Items.IndexOf(ACliente.Ativo);

    MemoEmail.Lines.StrictDelimiter := True;
    MemoEmail.Lines.Delimiter := ';';
    MemoEmail.Lines.DelimitedText := ACliente.Email;
  end;

  // ATIVAR/DESATIVAR ELEMENTOS
  procedure TFormCadastroClientes.FormControl(AEstado:Boolean);
  begin
    EditNome.Enabled := AEstado;
    EditEndereco.Enabled := AEstado;
    EditNumero.Enabled := AEstado;
    EditDocumento.Enabled := AEstado;
    MemoTelefone.Enabled := AEstado;
    ComboBoxPessoa.Enabled := AEstado;
    NumericEditCredito.Enabled := AEstado;
    ComboBoxAtivo.Enabled := AEstado;
    MemoEmail.Enabled := AEstado;
    BtnFinal.Enabled := AEstado;
  end;

end.
