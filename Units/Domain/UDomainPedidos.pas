unit UDomainPedidos;

interface

uses
  Classes,
  DB,
  SysUtils,
  Generics.Collections,

  /// ORM
  dbcbr.mapping.attributes,
  ormbr.types.nullable,
  dbcbr.types.mapping,
  dbcbr.mapping.register,
  ormbr.types.blob,

  UDomainClientesPGTO,

  UErros,UGenericValidator,UDocValidator,Vcl.Dialogs;

  type

  [Entity]
  [Table('PEDIDOS','')]
  [PrimaryKey('ID_PEDIDO',NotInc,NoSort,False,'Chave Primária')]
  TPedidos = class

  private
    FID: Integer;
    FIDCliente: Integer;
    FDataEmissao: TDate;
    FTotalLiquido: Currency;
    FCodPedido: String;

    //JOIN MANUAL
    FCLiente: TClientePGTO;
  public



  Constructor Create(
    AID:Integer;
    AIDCliente: Integer;
    ADataEmissao: TDate;
    ATotalLiquido: Currency;
    ACodPedido: String;
    ACliente: TClientePGTO = nil
    ); Overload;

    Destructor Destroy;

    procedure Validar;
  published

    //CÓDIGO PEDIDO
    [Restrictions([NotNull])]
    [Column('NUMERO_PEDIDO',ftString,13)]
    [Dictionary('NUMERO PEDIDO','','','','')]
    property CodPedido: String Read  FCodPedido Write FCodPedido;

     //JOINS
     property Cliente: TClientePGTO Read FCliente Write FCliente;

    //PK
    [Restrictions([NotNull,NoInsert,NoUpdate,HIDDEN])] //CONTROLE DA CHAVE PRIMÁRIA
    [Column('ID_PEDIDO', ftInteger)]
    [Dictionary('CODIGO PEDIDO','','','','')]
    property ID: Integer Read FID Write FID;

    //FK - ID_CLIENT
    [Restrictions([Hidden])]
    [Column('ID_CLIENTE',ftInteger)]
    property IDCliente: Integer Read FIDCliente Write FIDCliente;

    //DATA DE EMISSAO
    [Column('DATA_EMISSAO',ftDate,3)]
    [Dictionary('DATA DE EMISSÃO','','','','')]
    property DataEmissao: TDate Read FDataEmissao Write FDataEmissao;

    //TOTAL LIQUIDO
    [Column('TOTAL_LIQUIDO',ftCurrency)]
    [Dictionary('VALOR LÍQUIDO','','','','')]
    property TotalLiquido: Currency Read FTotalLiquido Write FTotalLiquido;

  end;

implementation
  //RECEBER VALORES
  Constructor TPedidos.Create(
      AID:Integer;
      AIDCliente: Integer;
      ADataEmissao: TDate;
      ATotalLiquido: Currency;
      ACodPedido: String;
      ACliente: TClientePGTO = nil
       );
  begin
    FID := AID;
    FIDCliente := AIDCliente;
    FDataEmissao := ADataEmissao;
    FTotalLiquido := ATotalLiquido;
    FCodPedido := ACodPedido;
    FCLiente := ACliente;
  end;

  //LIBERAR CLIENTE JOIN MANUAL
  destructor TPedidos.Destroy;
  begin
    if assigned(Self.FCliente) then
      Self.FCliente.Free;
    inherited
  end;



  // ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES ############## VALIDAÇÕES

  procedure TPedidos.Validar;
  var
   LErrorCadastro: EValidationError;
   LEstado: Boolean;
   begin
    LErrorCadastro := EValidationError.Create;
    LEstado := True;


    //VERIFICAR SE JOIN FOI FEITO
    if not assigned(Self.FCLiente) then
      raise Exception.Create('Falha interna, cliente não incluso no domain pedido');

    if Self.FCLiente.Ativo = 'N' then
      begin
        LEstado  := False;
        LErrorCadastro.FCampos.Add('Cliente Ativo');
        LErrorCadastro.FValores.Add('Pedidos estão disponíveis apenas para clientes ativos!');
      end;

    if not LEstado then
      raise LErrorCadastro
    else
      LErrorCadastro.Free;

   end;

end.
