unit URepManager;

interface

uses
  Vcl.Dialogs, Firedac.comp.Client, FireDAC.Stan.Param, System.SysUtils, Data.DB,
  FireDAC.Stan.Option, FireDAC.Comp.DataSet, DateUtils, System.Classes,
  System.Generics.Collections, UIRepository,
  dbebr.factory.interfaces,
  dbebr.factory.firedac,
  ormbr.dml.generator.firebird,
  ormbr.container.fdmemtable,
  ormbr.container.dataset.interfaces,
  ormbr.manager.objectset,


  //OBJECT SET
  ormbr.container.objectset.interfaces, ormbr.container.objectset;

  //INTERFACE DM
type
  IDM = interface
    function GetConnection: TFDConnection;
    procedure ConectarBD;
    procedure DesconectarBd;
    procedure ConnectionTest;
  end;

type
  TRepository = class
  private
    FConexaoAtual: IDBConnection;
    procedure SetConexaoAtual(const Value: IDBConnection);
  private
    function GetConexaoAtual: IDBConnection;

  public
    //CRUD
    function Select<T:Class, constructor>(AID: string): T;
    function SelectAll<T:Class, constructor>: TObjectList<T>;
    procedure Insert<T:Class, constructor>(AClass: T);
    procedure Update<T:Class, constructor>(AID: string; ANewClass: T);
    procedure Delete<T:Class, constructor>(AClass: T);

    //CONSTRUCTORS
    constructor Create(AConn: TFDConnection); overload;
    constructor Create(AConn: IDBConnection); overload;
    property ConexaoAtual: IDBConnection read GetConexaoAtual;
  private
    //ABSTRAÇÃO CONEXÃO ORMBr
    FConn: IDBConnection;

    //CONTAINER CRUD
    FObjectContainer: TManagerObjectSet;

  end;

implementation

  //CONSTRUCTOR

constructor TRepository.Create(AConn: TFDConnection);
begin
    //ABSTRAÇÃO DO TIPO DE CONEXÃO "IDBConnection" - (FDConnection,enumFireBird)
  FConn := TFactoryFireDAC.Create(AConn, dnFirebird);
    //CONTAINER CRUD
  FObjectContainer := TManagerObjectSet.Create(FConn);
end;


constructor TRepository.Create(AConn: IDBConnection);
begin
  FConn := AConn;
    //CONTAINER CRUD
  FObjectContainer := TManagerObjectSet.Create(FConn);
end;

  // ############### CRUD ############### CRUD ############### CRUD ############### CRUD ############### CRUD ############### CRUD

  //SELECIONAR TODOS
function TRepository.SelectAll<T>: TObjectList<T>;
begin
  Result := FObjectContainer.Find<T>;
end;

//SELECIONAR POR ID
function TRepository.Select<T>(AID: string): T;
begin
  Result := FObjectContainer.Find<T>(AID);
end;

  //INSERIR
procedure TRepository.Insert<T>(AClass: T);
begin
  FObjectContainer.Insert<T>(AClass);
end;

  //ATUALIZAR
procedure TRepository.Update<T>(AID: string; ANewClass: T);
var
  LCurrentClass: T;
begin
  LCurrentClass := nil;
  try
      //BUSCAR CLIENTE ATUAL
    LCurrentClass := FObjectContainer.Find<T>(AID);
    FObjectContainer.Modify<T>(LCurrentClass);
    FObjectContainer.Update<T>(ANewClass);
  finally
      //LIBERAR APENAS A CLASSE ATUAL, CLASSE NOVA, CHAMADOR DA FUNÇÃO LIBERA.
    LCurrentClass.Free;
  end;
end;

  //DELETAR
procedure TRepository.Delete<T>(AClass: T);
begin
  FObjectContainer.Delete<T>(AClass);
end;

procedure TRepository.SetConexaoAtual(const Value: IDBConnection);
begin
  FConexaoAtual := Value;
end;


function TRepository.GetConexaoAtual: IDBConnection;
begin
  result := FConn;
end;

end.

