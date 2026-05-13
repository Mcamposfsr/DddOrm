object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  Caption = 'FormPrincipal'
  ClientHeight = 507
  ClientWidth = 684
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 684
    Height = 507
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 355
      Width = 48
      Height = 21
      Caption = 'Cliente'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 504
      Top = 355
      Width = 27
      Height = 21
      Caption = 'CPF'
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
      TabOrder = 4
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
    object EditCPF: TEdit
      Left = 504
      Top = 382
      Width = 161
      Height = 23
      Enabled = False
      TabOrder = 1
    end
    object EditNome: TEdit
      Left = 16
      Top = 382
      Width = 457
      Height = 23
      Enabled = False
      TabOrder = 0
    end
    object Panel2: TPanel
      Left = 1
      Top = 296
      Width = 683
      Height = 41
      TabOrder = 5
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
      Left = 425
      Top = 458
      Width = 112
      Height = 31
      Caption = 'CANCELAR'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = ButtonCancelClick
    end
    object ButtonSalvar: TButton
      Left = 553
      Top = 458
      Width = 112
      Height = 31
      Caption = 'SALVAR'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = ButtonSalvarClick
    end
  end
  object DataSource: TDataSource
    DataSet = FDMemTable
    Left = 32
    Top = 432
  end
  object FDMemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 120
    Top = 432
  end
end
