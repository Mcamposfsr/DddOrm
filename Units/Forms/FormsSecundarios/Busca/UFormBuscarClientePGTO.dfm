object FormBuscarClientePGTO: TFormBuscarClientePGTO
  Left = 0
  Top = 0
  Caption = 'Buscar Cliente'
  ClientHeight = 395
  ClientWidth = 761
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = ButtonCancelKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 761
    Height = 395
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 137
      Height = 23
      Caption = 'Buscar Cliente'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DBGrid1: TDBGrid
      Left = 16
      Top = 91
      Width = 729
      Height = 238
      DataSource = DataSource
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object ButtonSelect: TButton
      Left = 542
      Top = 343
      Width = 91
      Height = 35
      Caption = 'SELECIONAR'
      TabOrder = 1
      OnClick = ButtonSelectClick
    end
    object ButtonCancel: TButton
      Left = 654
      Top = 343
      Width = 91
      Height = 35
      Caption = 'CANCELAR'
      TabOrder = 2
      OnClick = ButtonCancelClick
      OnKeyDown = ButtonCancelKeyDown
    end
    object EditFiltrarDataset: TEdit
      Left = 16
      Top = 56
      Width = 321
      Height = 21
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      TextHint = 'Filtrar nome do cliente'
      OnChange = EditFiltrarDatasetChange
    end
  end
  object DataSource: TDataSource
    DataSet = FDMemTable
    Left = 656
    Top = 16
  end
  object FDMemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 704
    Top = 16
  end
end
