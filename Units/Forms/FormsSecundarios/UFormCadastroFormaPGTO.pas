unit UFormCadastroFormaPGTO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, NumericEdit, Vcl.StdCtrls,


  UControllerFormasPGTO,UDomainFormasPGTO;

type
  TFormCadastroPGTO = class(TForm)
    PanelPrincipal: TPanel;
    Label1: TLabel;
    EditNome: TEdit;
    EditParcelas: TEdit;
    Label3: TLabel;
    Label7: TLabel;
    NumericEditJuros: TNumericEdit;
    BtnFinal: TButton;
    procedure FormShow(Sender: TObject);
    procedure BtnFinalClick(Sender: TObject);
  private

    //FERRAMENTAS
    FController: IControllerFormasPGTO;
    FCODPGTO: Integer;
    FOperacao: String;

    //MÉTODOS AUXÍLIARES
    procedure ReceberValores(APag:TFormasPGTO);
    procedure FormControl(AEstado:Boolean);

  public
    constructor Create(
    AOWner: TComponent;
    AController: IControllerFormasPGTO;
    AIDCliente: Integer;
    AOperacao: String
    ); Reintroduce;

  end;

var
  FormCadastroPGTO: TFormCadastroPGTO;

implementation

{$R *.dfm}


constructor TFormCadastroPGTO.Create(
  AOWner: TComponent;
  AController: IControllerFormasPGTO;
  AIDCliente: Integer;
  AOperacao: String
  );
  begin
    inherited Create(AOwner);

    FController := AController;
    FCODPGTO := AIDCliente;
    FOperacao :=  AOperacao;
  end;

  //INICIALIZAÇÃO VISUAL
  procedure TFormCadastroPGTO.FormShow(Sender: TObject);
  var LFormaPagamento: TFormasPGTO;
  begin
    //VERIFICAR OPERAÇÃO PASSADA PARA FORM E DEFINIR ESTADO.
    if FOperacao = 'SELECT' then
    begin
      LFormaPagamento := FController.BuscarFormaPGTO(Self.FCODPGTO);
      Self.ReceberValores(LFormaPagamento);
      Self.FormControl(False);
    end
    else if FOperacao = 'INSERT' then
    begin
      BtnFinal.Caption := 'CADASTRAR';
    end
    else if FOperacao = 'UPDATE' then
    begin
      LFormaPagamento := FController.BuscarFormaPGTO(Self.FCODPGTO);
      Self.ReceberValores(LFormaPagamento);
      Self.FormControl(True);
      BtnFinal.Caption := 'ATUALIZAR';
    end
    else if FOperacao = 'DELETE' then
    begin
      LFormaPagamento := FController.BuscarFormaPGTO(Self.FCODPGTO);
      Self.ReceberValores(LFormaPagamento);
      Self.FormControl(FALSE);
      BtnFinal.Enabled := True;
      BtnFinal.Caption := 'DELETAR';
    end;
  end;

  // ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS

  procedure TFormCadastroPGTO.BtnFinalClick(Sender: TObject);
  begin
      //VERIFICAR OPERAÇÃO PASSADA PARA FORM E DEFINIR ESTADO.
//      if FOperacao = 'INSERT' then
//      begin
//        FController.CadastrarFormaPGTO(
//        EditNome.Text,
//        EditParcelas.Text,
//        NumericEditJuros.Text
//        );
//        ShowMessage('FORMA DE PAGAMENTO CADASTRADA!');
//        Self.Close;
//      end
//      else if FOperacao = 'UPDATE' then
//      begin
//        FController.AlterarFormaPGTO(
//        Self.FCODPGTO,
//        EditNome.Text,
//        EditParcelas.Text);
//        ShowMessage('FORMA DE PAGAMENTO ATUALIZADA!');
//        Self.Close;
//      end
//      else if FOperacao = 'DELETE' then
//      begin
//        FController.DeletarFormaPGTO(Self.FCODPGTO);
//        ShowMessage('CLIENTE DELETADO!');
//        Self.Close;
//      end;
    end;


  // ########## MÉTODOS AUXÍLIARES ########## MÉTODOS AUXÍLIARES  ########## MÉTODOS AUXÍLIARES  ########## MÉTODOS AUXÍLIARES  ########## MÉTODOS AUXÍLIARES

  // PASSAR VALORES DDO PARA FORM
  procedure TFormCadastroPGTO.ReceberValores(APag:TFormasPGTO);
  begin
    EditNome.Text := APag.Nome;
    EditParcelas.Text := IntToStr(APag.Parcelas);
    NumericEditJuros.Text := CurrToStr(APag.Juros);
  end;

  // ATIVAR/DESATIVAR ELEMENTOS
  procedure TFormCadastroPGTO.FormControl(AEstado:Boolean);
  begin
    EditNome.Enabled := AEstado;
    EditParcelas.Enabled := AEstado;
    NumericEditJuros.Enabled := AEstado;
    BtnFinal.Enabled := AEstado;
  end;

end.
