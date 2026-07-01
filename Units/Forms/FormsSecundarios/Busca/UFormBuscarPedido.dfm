object FormBuscarPedido: TFormBuscarPedido
  Left = 0
  Top = 0
  Caption = 'Buscar Pedido'
  ClientHeight = 373
  ClientWidth = 762
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 762
    Height = 373
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 135
      Height = 23
      Caption = 'Buscar Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DBGrid1: TDBGrid
      Left = 16
      Top = 75
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
      Top = 327
      Width = 91
      Height = 35
      Caption = 'SELECIONAR'
      TabOrder = 1
      OnClick = ButtonSelectClick
    end
    object ButtonCancel: TButton
      Left = 654
      Top = 327
      Width = 91
      Height = 35
      Caption = 'CANCELAR'
      TabOrder = 2
      OnClick = ButtonCancelClick
    end
  end
  object DataSource: TDataSource
    DataSet = FDMemTable
    Left = 664
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
    Left = 712
    Top = 16
  end
end
