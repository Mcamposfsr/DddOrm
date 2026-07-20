object FormBuscarProdutos: TFormBuscarProdutos
  Left = 0
  Top = 0
  Caption = 'FormBuscarProdutos'
  ClientHeight = 387
  ClientWidth = 755
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 755
    Height = 387
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 375
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 146
      Height = 23
      Caption = 'Buscar Produto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DBGrid: TDBGrid
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
    end
    object EditFiltrarDataset: TEdit
      Left = 16
      Top = 56
      Width = 321
      Height = 21
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      TextHint = 'Filtrar nome do produto'
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
