object FormCadastroProdutosEFC: TFormCadastroProdutosEFC
  Left = 0
  Top = 0
  Caption = 'FormCadastroProdutosEFC'
  ClientHeight = 246
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelPrincipal: TPanel
    Left = 0
    Top = 0
    Width = 486
    Height = 246
    Align = alClient
    TabOrder = 0
    ExplicitLeft = -169
    ExplicitTop = -77
    ExplicitWidth = 804
    ExplicitHeight = 376
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
      Left = 128
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
      Left = 208
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
      Left = 336
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
      Left = 267
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
      Left = 377
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
    object EditNome: TEdit
      Left = 16
      Top = 38
      Width = 457
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object EditEstoque: TEdit
      Left = 128
      Top = 146
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      NumbersOnly = True
      TabOrder = 3
    end
    object EditCodigoBarras: TEdit
      Left = 17
      Top = 92
      Width = 161
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 18
      NumbersOnly = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object ComboBoxVendaPermitida: TComboBox
      Left = 208
      Top = 92
      Width = 105
      Height = 21
      Style = csDropDownList
      TabOrder = 4
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
      Left = 240
      Top = 200
      Width = 105
      Height = 33
      Caption = 'CONFIRMAR'
      TabOrder = 6
      OnClick = BtnConfirmarClick
    end
    object ButtonCancelar: TButton
      Left = 368
      Top = 200
      Width = 105
      Height = 33
      Caption = 'CANCELAR'
      TabOrder = 7
      OnClick = ButtonCancelarClick
    end
    object EditPrecoDeVenda: TEdit
      Left = 336
      Top = 92
      Width = 137
      Height = 21
      TabOrder = 2
    end
    object EditPIS: TEdit
      Left = 267
      Top = 146
      Width = 96
      Height = 21
      NumbersOnly = True
      TabOrder = 8
    end
    object EditCOFINS: TEdit
      Left = 369
      Top = 146
      Width = 96
      Height = 21
      NumbersOnly = True
      TabOrder = 9
    end
  end
end
