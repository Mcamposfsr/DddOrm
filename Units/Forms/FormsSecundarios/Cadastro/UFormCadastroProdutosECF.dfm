object FormCadastroProdutosECF: TFormCadastroProdutosECF
  Left = 0
  Top = 0
  Caption = 'FormCadastroProdutosECF'
  ClientHeight = 250
  ClientWidth = 572
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelPrincipal: TPanel
    Left = 0
    Top = 0
    Width = 572
    Height = 250
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 32
      Height = 13
      Caption = 'Nome'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 148
      Top = 127
      Width = 45
      Height = 13
      Caption = 'Estoque'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 176
      Top = 73
      Width = 93
      Height = 13
      Caption = 'Venda Permitida'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 17
      Top = 71
      Width = 95
      Height = 13
      Caption = 'Codigo de Barras'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 304
      Top = 73
      Width = 87
      Height = 13
      Caption = 'Pre'#231'o de Venda'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 17
      Top = 127
      Width = 93
      Height = 13
      Caption = 'Sigla de Unidade'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 313
      Top = 127
      Width = 69
      Height = 13
      Caption = 'Aliquota PIS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 462
      Top = 127
      Width = 90
      Height = 13
      Caption = 'Aliquota COFINS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 448
      Top = 73
      Width = 104
      Height = 13
      Caption = 'Desconto M'#225'ximo '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object EditNome: TEdit
      Left = 16
      Top = 38
      Width = 536
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object EditEstoque: TEdit
      Left = 148
      Top = 146
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 6
      OnKeyPress = FiltrarCaracteres
    end
    object EditCodigoBarras: TEdit
      Left = 17
      Top = 92
      Width = 136
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 14
      NumbersOnly = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object ComboBoxVendaPermitida: TComboBox
      Left = 176
      Top = 92
      Width = 105
      Height = 21
      Style = csDropDownList
      TabOrder = 2
      Items.Strings = (
        'S'
        'N')
    end
    object ComboBoxSigla: TComboBox
      Left = 17
      Top = 146
      Width = 93
      Height = 21
      Style = csDropDownList
      TabOrder = 5
      Items.Strings = (
        'UN'
        'PC'
        'KG'
        'LT'
        'CX')
    end
    object BtnConfirmar: TButton
      Left = 320
      Top = 201
      Width = 105
      Height = 33
      Caption = 'CONFIRMAR'
      TabOrder = 9
      OnClick = BtnConfirmarClick
    end
    object ButtonCancelar: TButton
      Left = 447
      Top = 201
      Width = 105
      Height = 33
      Caption = 'CANCELAR'
      TabOrder = 10
      OnClick = ButtonCancelarClick
    end
    object EditPrecoDeVenda: TEdit
      Left = 304
      Top = 92
      Width = 121
      Height = 21
      TabOrder = 3
      OnKeyPress = FiltrarCaracteres
    end
    object EditPIS: TEdit
      Left = 313
      Top = 146
      Width = 96
      Height = 21
      MaxLength = 5
      TabOrder = 7
      OnKeyPress = FiltrarCaracteres
    end
    object EditCOFINS: TEdit
      Left = 456
      Top = 146
      Width = 96
      Height = 21
      MaxLength = 5
      TabOrder = 8
      OnKeyPress = FiltrarCaracteres
    end
    object EditDescontoMax: TEdit
      Left = 448
      Top = 92
      Width = 104
      Height = 21
      TabOrder = 4
      OnKeyPress = FiltrarCaracteres
    end
  end
end
