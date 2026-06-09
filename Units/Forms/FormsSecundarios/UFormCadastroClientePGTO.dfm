object FormCadastroClientes: TFormCadastroClientes
  Left = 0
  Top = 0
  Caption = 'Cadastro Clientes'
  ClientHeight = 352
  ClientWidth = 768
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
    Width = 768
    Height = 352
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 32
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
    object Label2: TLabel
      Left = 16
      Top = 158
      Width = 60
      Height = 16
      Caption = 'Endere'#231'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 16
      Top = 224
      Width = 49
      Height = 16
      Caption = 'Numero'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 480
      Top = 158
      Width = 55
      Height = 16
      Caption = 'Telefone'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 184
      Top = 224
      Width = 46
      Height = 16
      Caption = 'Pessoa'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 16
      Top = 96
      Width = 73
      Height = 16
      Caption = 'Documento'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 236
      Top = 96
      Width = 109
      Height = 16
      Caption = 'Limite de Cr'#233'dito'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 304
      Top = 224
      Width = 35
      Height = 16
      Caption = 'Ativo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 480
      Top = 9
      Width = 32
      Height = 16
      Caption = 'Email'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object EditNome: TEdit
      Left = 16
      Top = 54
      Width = 377
      Height = 21
      TabOrder = 0
    end
    object EditEndereco: TEdit
      Left = 16
      Top = 180
      Width = 377
      Height = 21
      TabOrder = 3
    end
    object EditNumero: TEdit
      Left = 16
      Top = 246
      Width = 137
      Height = 21
      NumbersOnly = True
      TabOrder = 4
    end
    object EditDocumento: TEdit
      Left = 16
      Top = 118
      Width = 209
      Height = 21
      MaxLength = 18
      TabOrder = 1
    end
    object MemoTelefone: TMemo
      Left = 480
      Top = 180
      Width = 273
      Height = 107
      Hint = 'Cada telefone separado por linha'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
    end
    object ComboBoxPessoa: TComboBox
      Left = 184
      Top = 246
      Width = 89
      Height = 21
      TabOrder = 5
      Items.Strings = (
        'J'
        'F')
    end
    object NumericEditCredito: TNumericEdit
      Left = 236
      Top = 118
      Width = 157
      Height = 21
      TabOrder = 2
      Text = '0,00'
      Format = ',0.00'
    end
    object ComboBoxAtivo: TComboBox
      Left = 304
      Top = 246
      Width = 89
      Height = 21
      TabOrder = 6
      Items.Strings = (
        'S'
        'N')
    end
    object MemoEmail: TMemo
      Left = 480
      Top = 31
      Width = 273
      Height = 107
      Hint = 'Cada telefone separado por linha'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
    end
    object BtnFinal: TButton
      Left = 648
      Top = 312
      Width = 105
      Height = 33
      TabOrder = 9
      OnClick = BtnFinalClick
    end
  end
end
