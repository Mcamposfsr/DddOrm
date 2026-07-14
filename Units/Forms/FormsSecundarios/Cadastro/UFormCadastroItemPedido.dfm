object FormItensPedido: TFormItensPedido
  Left = 0
  Top = 0
  Caption = 'Inserir Produto'
  ClientHeight = 428
  ClientWidth = 416
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
  object TPanel: TPanel
    Left = 0
    Top = 0
    Width = 416
    Height = 428
    Align = alClient
    TabOrder = 0
    object Label6: TLabel
      Left = 17
      Top = 245
      Width = 65
      Height = 13
      Caption = 'Quantidade'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 155
      Top = 245
      Width = 53
      Height = 13
      Caption = 'Desconto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 301
      Top = 309
      Width = 29
      Height = 13
      Caption = 'Total'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 301
      Top = 245
      Width = 98
      Height = 13
      Caption = 'Valor descontado'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GroupBox3: TGroupBox
      Left = 17
      Top = 16
      Width = 384
      Height = 209
      Caption = 'Produto'
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
      object Label9: TLabel
        Left = 16
        Top = 92
        Width = 79
        Height = 13
        Caption = 'Pre'#231'o unit'#225'rio'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label10: TLabel
        Left = 138
        Top = 92
        Width = 91
        Height = 13
        Caption = 'Limite Desconto'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 264
        Top = 92
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
      object Label3: TLabel
        Left = 19
        Top = 148
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
      object BitBtnBuscarProduto: TBitBtn
        Left = 337
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
        OnClick = BitBtnBuscarProdutoClick
      end
      object EditNomeProduto: TEdit
        Left = 16
        Top = 57
        Width = 347
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
      object EditPrecoUnitario: TEdit
        Left = 19
        Top = 111
        Width = 100
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
        TabOrder = 2
      end
      object EditLimiteDesconto: TEdit
        Left = 138
        Top = 111
        Width = 100
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
        TabOrder = 3
      end
      object EditEstoque: TEdit
        Left = 263
        Top = 111
        Width = 100
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
        TabOrder = 4
      end
      object EditVendaPermitida: TEdit
        Left = 19
        Top = 167
        Width = 100
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
        TabOrder = 5
      end
    end
    object EditQuantidade: TEdit
      Left = 17
      Top = 264
      Width = 100
      Height = 21
      CharCase = ecUpperCase
      NumbersOnly = True
      TabOrder = 1
      Text = '1'
      OnChange = EditQuantidadeChange
    end
    object ButtonCancelar: TButton
      Left = 294
      Top = 378
      Width = 105
      Height = 33
      Caption = 'CANCELAR'
      TabOrder = 5
      OnClick = ButtonCancelarClick
    end
    object ButtonConfirmar: TButton
      Left = 164
      Top = 378
      Width = 105
      Height = 33
      Caption = 'CONFIRMAR'
      TabOrder = 4
      OnClick = ButtonConfirmarClick
    end
    object EditDesconto: TEdit
      Left = 155
      Top = 264
      Width = 100
      Height = 21
      CharCase = ecUpperCase
      NumbersOnly = True
      TabOrder = 2
      Text = '0'
      OnChange = EditDescontoChange
    end
    object EditValorTotal: TEdit
      Left = 301
      Top = 328
      Width = 100
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      NumbersOnly = True
      TabOrder = 6
    end
    object EditValorDescontado: TEdit
      Left = 301
      Top = 264
      Width = 100
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      NumbersOnly = True
      TabOrder = 3
      Text = '0'
    end
  end
end
