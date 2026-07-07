object FormCadastroPedido: TFormCadastroPedido
  Left = 0
  Top = 0
  Caption = 'Cadastrar Pedido'
  ClientHeight = 327
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object TPanel: TPanel
    Left = 0
    Top = 0
    Width = 441
    Height = 327
    Align = alClient
    TabOrder = 0
    ExplicitTop = -8
    ExplicitWidth = 443
    ExplicitHeight = 402
    object Label6: TLabel
      Left = 16
      Top = 197
      Width = 68
      Height = 13
      Caption = 'Data Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 184
      Top = 197
      Width = 85
      Height = 13
      Caption = 'Numero Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 16
      Width = 409
      Height = 161
      Caption = 'Cliente'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 38
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
      object Label10: TLabel
        Left = 251
        Top = 92
        Width = 30
        Height = 13
        Caption = 'Ativo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 16
        Top = 92
        Width = 65
        Height = 13
        Caption = 'Documento'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object BitBtnBuscarCliente: TBitBtn
        Left = 367
        Top = 16
        Width = 26
        Height = 21
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB7B7
          B7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFB7B7B7000000B7B7B8FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB8B8B7000000B7B7
          B7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFE0DFB9B9B8FF
          FFFFFFFFFFB7B8B8000000B7B7B7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFF7F7F7000000010101010000000000090909000000B7B8B7FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000100606160FFFFFFFFFFFFFF
          FFFF181818111110FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          A8A8A8000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF010000FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF585858484948FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF000000BFBFC0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          888889010000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF010000EFF0F0FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF010000AFAFAFFFFFFFFFFFFFFF
          FFFF606061000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFC8C8C7000100000000383838000000000100EFEFEFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080805050519F
          A09FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        TabOrder = 0
        OnClick = BitBtnBuscarClienteClick
      end
      object EditNomeCliente: TEdit
        Left = 16
        Top = 57
        Width = 377
        Height = 21
        CharCase = ecUpperCase
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object EditClienteAtivo: TEdit
        Left = 248
        Top = 111
        Width = 145
        Height = 21
        CharCase = ecUpperCase
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        NumbersOnly = True
        ParentFont = False
        TabOrder = 2
      end
      object EditDocumentoCliente: TEdit
        Left = 16
        Top = 111
        Width = 209
        Height = 21
        CharCase = ecUpperCase
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxLength = 18
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
      end
    end
    object EditDataPedido: TEdit
      Left = 16
      Top = 216
      Width = 137
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      NumbersOnly = True
      TabOrder = 1
    end
    object ButtonCancelar: TButton
      Left = 320
      Top = 282
      Width = 105
      Height = 33
      Caption = 'CANCELAR'
      TabOrder = 3
      OnClick = ButtonCancelarClick
    end
    object ButtonConfirmar: TButton
      Left = 192
      Top = 282
      Width = 105
      Height = 33
      Caption = 'CONFIRMAR'
      TabOrder = 2
      OnClick = ButtonConfirmarClick
    end
    object EditNumeroPedido: TEdit
      Left = 184
      Top = 216
      Width = 137
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      NumbersOnly = True
      TabOrder = 4
    end
  end
end
