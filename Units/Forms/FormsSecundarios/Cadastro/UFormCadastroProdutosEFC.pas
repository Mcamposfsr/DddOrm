unit UFormCadastroProdutosEFC;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,

  UControllerProdutosECF,UDomainProdutosECF,UErros;

type
  TFormCadastroProdutosEFC = class(TForm)
    PanelPrincipal: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EditNome: TEdit;
    EditEstoque: TEdit;
    EditCodigoBarras: TEdit;
    ComboBoxVendaPermitida: TComboBox;
    ComboBoxSigla: TComboBox;
    BtnConfirmar: TButton;
    ButtonCancelar: TButton;
    EditPrecoDeVenda: TEdit;
    EditPIS: TEdit;
    Label4: TLabel;
    EditCOFINS: TEdit;
    Label9: TLabel;
    EditDescontoMax: TEdit;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure BtnConfirmarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

    //FILTRAGEM DE CARACTERES
    procedure FiltrarCaracteres(Sender: TObject; var Key: Char);
  private
    //FERRAMENTAS
    FController: IControllerProdutosECF;
    FCodProduto: Integer;
    FOperacao: String;

    //MÉTODOS AUXÍLIARES
    procedure ReceberValores(AProdutos:TProdutosECF);
    procedure FormControl(AEstado:Boolean);




  public
    constructor Create(
    AOWner: TComponent;
    AController: IControllerProdutosECF;
    ACOD: Integer;
    AOperacao: String
    ); Reintroduce;
  public

  end;

var
  FormCadastroProdutosEFC: TFormCadastroProdutosEFC;

implementation

{$R *.dfm}

  //INICIALIZAÇÃO DE FERRAMENTAS
  constructor TFormCadastroProdutosEFC.Create(
    AOWner: TComponent;
    AController: IControllerProdutosECF;
    ACOD: Integer;
    AOperacao: String
  );
  begin
    inherited Create(AOwner);

    FController := AController;
    FCodProduto := ACOD;
    FOperacao :=  AOperacao;
  end;


//FILTRAR CARACTERES
  procedure TFormCadastroProdutosEFC.FiltrarCaracteres(Sender: TObject;
  var Key: Char);
  begin
    if not (Key in ['0'..'9', ',', '.', #8]) then
    Key := #0;
  end;

//INICIALIZAÇÃO VISUAL


  procedure TFormCadastroProdutosEFC.FormShow(Sender: TObject);
  var LProdutos: TProdutosECF;
  begin
    TTratamentoDeErros.ExecutarOnForm(
    procedure
    begin
      if FOperacao <> 'INSERT' then
      begin
        LProdutos := FController.BuscarProdutoECF(FCodProduto);
        Self.ReceberValores(LProdutos);
      end;

      //VERIFICAR OPERAÇÃO PASSADA PARA FORM E DEFINIR ESTADO.
      if FOperacao = 'SELECT' then
      begin
        Self.FormControl(False);
      end
      else if FOperacao = 'UPDATE' then
      begin
        Self.FormControl(True);
      end
      else if FOperacao = 'DELETE' then
      begin
        Self.FormControl(false);
        BtnConfirmar.Enabled := True;
      end;
    end
    );
  end;


// ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM ######### EVENTOS FORM

procedure TFormCadastroProdutosEFC.ButtonCancelarClick(Sender: TObject);
  begin
    Self.Close;
  end;

//    ACodBarras,ANome,AUniSigla,ASitVenda,AEstoque,APrecoVenda,AALIQPis,AALIQCof:String
  procedure TFormCadastroProdutosEFC.BtnConfirmarClick(Sender: TObject);
  begin
    TTratamentoDeErros.ExecutarOnForm(
    procedure
    begin
      //VERIFICAR OPERAÇÃO PASSADA PARA FORM E DEFINIR ESTADO.
      if FOperacao = 'INSERT' then
      begin
        FController.CadastrarProdutoECF(
        EditCodigoBarras.Text,
        EditNome.Text,
        ComboBoxSigla.Text,
        ComboBoxVendaPermitida.Text,
        EditEstoque.Text,
        EditPrecoDeVenda.Text,
        EditPIS.Text,
        EditCOFINS.Text,
        EditDescontoMax.Text);
        Self.Close;
      end
      else if FOperacao = 'UPDATE' then
      begin
        FController.AlterarProdutoECF(
        Self.FCODProduto,
        EditCodigoBarras.Text,
        EditNome.Text,
        ComboBoxSigla.Text,
        ComboBoxVendaPermitida.Text,
        EditEstoque.Text,
        EditPrecoDeVenda.Text,
        EditPIS.Text,
        EditCOFINS.Text,
        EditDescontoMax.Text
        );
        Self.Close;
      end
      else if FOperacao = 'DELETE' then
      begin
        FController.DeletarProdutoECF(Self.FCODProduto);
        Self.Close;
      end;
    end);
  end;

// ########## MÉTODOS AUXÍLIARES ########## MÉTODOS AUXÍLIARES  ########## MÉTODOS AUXÍLIARES  ########## MÉTODOS AUXÍLIARES  ########## MÉTODOS AUXÍLIARES

  // PASSAR VALORES DDO PARA FORM
  procedure TFormCadastroProdutosEFC.ReceberValores(AProdutos:TProdutosECF);
  begin
    EditNome.Text := AProdutos.Nome;
    EditCodigoBarras.Text := AProdutos.CodigoDeBarras;
    ComboBoxVendaPermitida.ItemIndex := ComboBoxVendaPermitida.Items.IndexOf(AProdutos.SitPermiteVenda);
    EditPrecoDeVenda.Text := FloatToStr(AProdutos.PrecoVenda);
    ComboBoxSigla.ItemIndex :=  ComboBoxSigla.Items.IndexOf(AProdutos.UniSigla);
    EditEstoque.Text := FloatToStr(AProdutos.Estoque);
    EditPIS.Text := CurrToStr(AProdutos.AliqPis);
    EditCOFINS.Text := FloatToStr(AProdutos.AliqCofins);
  end;

  // ATIVAR/DESATIVAR ELEMENTOS
  procedure TFormCadastroProdutosEFC.FormControl(AEstado:Boolean);
  begin
    EditNome.Enabled := AEstado;
    EditCodigoBarras.Enabled := AEstado;
    ComboBoxVendaPermitida.Enabled := AEstado;
    EditPrecoDeVenda.Enabled := AEstado;
    ComboBoxSigla.Enabled := AEstado;
    EditEstoque.Enabled := AEstado;
    EditPIS.Enabled := AEstado;
    EditCOFINS.Enabled := AEstado;
    EditDescontoMax.Enabled := AEstado;
  end;

  procedure TFormCadastroProdutosEFC.FormKeyPress(Sender: TObject; var Key: Char);
  begin
    if Key = #13 then
    begin
      Key := #0;
      SelectNext(ActiveControl, True, True);
    end;
  end;

end.
