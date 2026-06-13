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
    BtnConfirmar: TButton;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure BtnConfirmarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
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
      //NADA A FAZER
    end
    else if FOperacao = 'UPDATE' then
    begin
      LFormaPagamento := FController.BuscarFormaPGTO(Self.FCODPGTO);
      Self.ReceberValores(LFormaPagamento);
      Self.FormControl(True);
    end
    else if FOperacao = 'DELETE' then
    begin
      LFormaPagamento := FController.BuscarFormaPGTO(Self.FCODPGTO);
      Self.ReceberValores(LFormaPagamento);
      Self.FormControl(FALSE);
      BtnConfirmar.Enabled := True;
    end;
  end;

  // ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS ########## EVENTOS

  procedure TFormCadastroPGTO.Button1Click(Sender: TObject);
  begin
    Self.Close;
  end;

  procedure TFormCadastroPGTO.BtnConfirmarClick(Sender: TObject);
  begin
    try
      //VERIFICAR OPERAÇÃO PASSADA PARA FORM E DEFINIR ESTADO.
      if FOperacao = 'INSERT' then
      begin
        FController.CadastrarFormaPGTO(
        EditNome.Text,
        EditParcelas.Text,
        NumericEditJuros.Text
        );
        Self.Close;
      end
      else if FOperacao = 'UPDATE' then
      begin
        FController.AlterarFormaPGTO(
        Self.FCODPGTO,
        EditNome.Text,
        EditParcelas.Text,
        NumericEditJuros.Text);
        Self.Close;
      end
      else if FOperacao = 'DELETE' then
      begin
        FController.DeletarFormaPGTO(Self.FCODPGTO);
        Self.Close;
      end;
    except
      on E: Exception do
      begin
        ShowMessage(E.Message);
      end;

    end;
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
    BtnConfirmar.Enabled := AEstado;
  end;

  // ENTER >>  TAB
  procedure TFormCadastroPGTO.FormKeyPress(Sender: TObject; var Key: Char);
  begin
       if Key = #13 then
    begin
      Key := #0;
      SelectNext(ActiveControl, True, True);
    end;
  end;

end.
