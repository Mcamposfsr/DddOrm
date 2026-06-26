object FormCadastroPGTO: TFormCadastroPGTO
  Left = 0
  Top = 0
  Caption = 'Cadastro de Pagamentos'
  ClientHeight = 130
  ClientWidth = 427
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
    Width = 427
    Height = 130
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
      Left = 238
      Top = 16
      Width = 48
      Height = 13
      Caption = 'Parcelas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 343
      Top = 16
      Width = 31
      Height = 13
      Caption = 'Juros'
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
      Width = 193
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object EditParcelas: TEdit
      Left = 238
      Top = 38
      Width = 73
      Height = 21
      MaxLength = 5
      NumbersOnly = True
      TabOrder = 1
    end
    object BtnConfirmar: TButton
      Left = 188
      Top = 80
      Width = 105
      Height = 33
      Caption = 'CONFIRMAR'
      TabOrder = 3
      OnClick = BtnConfirmarClick
    end
    object Button1: TButton
      Left = 312
      Top = 80
      Width = 105
      Height = 33
      Caption = 'CANCELAR'
      TabOrder = 4
      OnClick = Button1Click
    end
    object EditJuros: TEdit
      Left = 343
      Top = 35
      Width = 74
      Height = 21
      MaxLength = 5
      TabOrder = 2
      OnKeyPress = EditJurosKeyPress
    end
  end
end
