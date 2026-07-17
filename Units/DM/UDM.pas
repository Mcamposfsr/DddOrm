unit UDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error,FireDac.Phys.FB,FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, UGenericRep,

  //INTERFACE DM
  UIDM;

type
  TDM = class(TInterfacedObject,IDM)
  private
    //CONEXÃO
    FConnection: TFDConnection;
  public
    constructor Create(AUserName,APassWord,AServer,APort,ADataBasePath:String);
    destructor Destroy; override;

    //ACESSO A CONEXÃO
    Function GetConnection:TFDConnection;

    procedure ConectarBD;
    procedure DesconectarBd;
    procedure ConnectionTest;
  end;

  var GDM: TDM;


implementation


  //INSTANCIA DM
  constructor TDM.Create(AUserName,APassWord,AServer,APort,ADataBasePath:String);
  begin
    inherited Create;

    FConnection := TFDConnection.Create(nil);

    //CONFIGURAR CONEXÃO
    Self.FConnection.Params.DriverID := 'FB';
    Self.FConnection.Params.UserName := AUserName;
    Self.FConnection.Params.Password := APassWord;
    Self.FConnection.Params.Values['Server'] := AServer;
    Self.FConnection.Params.Values['Port'] := APort;
    Self.FConnection.Params.Database := ADataBasePath;
    Self.FConnection.LoginPrompt := False;
    Self.FConnection.TxOptions.AutoCommit := False;
  end;

  // DESTRUCTOR
  destructor TDM.Destroy;
  begin
      if Assigned(Self.FConnection) then
    begin
      if Self.FConnection.Connected then
        Self.FConnection.Connected := False;
      FConnection.Free;
    end;
    inherited Destroy;
  end;

  // CONFIGURAR/INICIAR CONEXÃO
  procedure TDM.ConectarBD;
  begin
    if not Self.FConnection.Connected then
      Self.FConnection.Connected := True;
  end;

  // DESCONECTAR DO BANCO DE DADOS
  procedure TDM.DesconectarBd;
  begin
    if FConnection.Connected then
    FConnection.Connected := False;
  end;

  // RETORNAR TFDCONNECTION
  Function TDM.GetConnection:TFDConnection;

  begin
    Result := Self.FConnection;
  end;

  //TESTAR CONEXÃO
  procedure TDM.ConnectionTest;
  begin
    Self.DesconectarBd;
    Self.ConectarBD;
    Self.DesconectarBd;
  end;

end.
