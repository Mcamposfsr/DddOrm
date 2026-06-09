object FormCadastroPGTO: TFormCadastroPGTO
  Left = 0
  Top = 0
  Caption = 'Cadastro Clientes'
  ClientHeight = 130
  ClientWidth = 469
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelPrincipal: TPanel
    Left = 0
    Top = 0
    Width = 469
    Height = 130
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 35
      Height = 16
      Caption = 'Nome'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 384
      Top = 16
      Width = 55
      Height = 16
      Caption = 'Parcelas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 236
      Top = 16
      Width = 35
      Height = 16
      Caption = 'Juros'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object EditNome: TEdit
      Left = 16
      Top = 38
      Width = 193
      Height = 21
      TabOrder = 0
    end
    object EditParcelas: TEdit
      Left = 384
      Top = 38
      Width = 73
      Height = 21
      NumbersOnly = True
      TabOrder = 1
    end
    object NumericEditJuros: TNumericEdit
      Left = 236
      Top = 38
      Width = 126
      Height = 21
      TabOrder = 2
      Text = '0,00%'
      Format = '0.00%'
    end
    object BtnFinal: TButton
      Left = 352
      Top = 88
      Width = 105
      Height = 33
      TabOrder = 3
      OnClick = BtnFinalClick
    end
  end
end
