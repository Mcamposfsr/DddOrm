object FormOS: TFormOS
  Left = 0
  Top = 0
  Caption = 'FormOS'
  ClientHeight = 493
  ClientWidth = 684
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 684
    Height = 493
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 355
      Width = 36
      Height = 21
      Caption = 'Valor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 259
      Top = 355
      Width = 57
      Height = 21
      Caption = 'Data OS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 530
      Top = 355
      Width = 84
      Height = 21
      Caption = 'Situa'#231#227'o OS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 682
      Height = 272
      Align = alTop
      DataSource = DataSource
      TabOrder = 3
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
    object EditValor: TEdit
      Left = 16
      Top = 382
      Width = 153
      Height = 23
      Enabled = False
      TabOrder = 0
      OnKeyPress = EditValorKeyPress
    end
    object Panel2: TPanel
      Left = 1
      Top = 296
      Width = 683
      Height = 41
      TabOrder = 4
      object ButtonDeletar: TButton
        AlignWithMargins = True
        Left = 570
        Top = 1
        Width = 112
        Height = 39
        Margins.Left = 80
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alRight
        Caption = 'DELETAR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = ButtonDeletarClick
      end
      object ButtonCadastrar: TButton
        AlignWithMargins = True
        Left = 193
        Top = 1
        Width = 112
        Height = 39
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 80
        Margins.Bottom = 0
        Align = alLeft
        Caption = 'CADASTRAR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = ButtonCadastrarClick
      end
      object ButtonBuscar: TButton
        AlignWithMargins = True
        Left = 1
        Top = 1
        Width = 112
        Height = 39
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 80
        Margins.Bottom = 0
        Align = alLeft
        Caption = 'BUSCAR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = ButtonBuscarClick
      end
      object ButtonAlterar: TButton
        AlignWithMargins = True
        Left = 378
        Top = 1
        Width = 112
        Height = 39
        Margins.Left = 80
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alRight
        Caption = 'ALTERAR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = ButtonAlterarClick
      end
    end
    object ButtonCancel: TButton
      Left = 411
      Top = 451
      Width = 112
      Height = 34
      Caption = 'CANCELAR'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = ButtonCancelClick
    end
    object ButtonSalvar: TButton
      Left = 546
      Top = 451
      Width = 129
      Height = 34
      Caption = 'SALVAR'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = ButtonSalvarClick
    end
    object ComboBoxSituacao: TComboBox
      Left = 530
      Top = 382
      Width = 145
      Height = 23
      Style = csDropDownList
      Enabled = False
      TabOrder = 5
      Items.Strings = (
        'P'
        'F')
    end
    object DateTimePickerOS: TDateTimePicker
      Left = 259
      Top = 382
      Width = 152
      Height = 23
      Date = 46157.476318831020000000
      Time = 46157.476318831020000000
      Enabled = False
      TabOrder = 6
    end
  end
  object DataSource: TDataSource
    DataSet = FDMemTable
    Left = 32
    Top = 424
  end
  object FDMemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 112
    Top = 424
  end
end
