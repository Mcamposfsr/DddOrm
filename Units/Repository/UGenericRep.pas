unit UGenericRep;

interface

uses
  Vcl.Dialogs, Firedac.comp.Client, FireDAC.Stan.Param, System.SysUtils, Data.DB,
  FireDAC.Stan.Option, FireDAC.Comp.DataSet, DateUtils, System.Classes,
  System.Generics.Collections, UIRepository, dbebr.factory.interfaces,
  dbebr.factory.firedac, ormbr.dml.generator.firebird,
  ormbr.container.fdmemtable, ormbr.container.dataset.interfaces,

  //INTERFACE DM
  UIDM,

  //OBJECT SET
  ormbr.container.objectset.interfaces, ormbr.container.objectset;

type
  TRepository<T: class, constructor> = class(TInterFacedObject, IRepository<T>)
  private
    FConexaoAtual: IDBConnection;
    procedure SetConexaoAtual(const Value: IDBConnection);
  private
    function GetConexaoAtual: IDBConnection;

  public
    function Select(AID: string): T;
    function SelectAll: TObjectList<T>;
    procedure Insert(AClass: T);
    procedure Update(AID: string; ANewClass: T);
    procedure Delete(AClass: T);
    procedure FiltrarDataSet(AColumn,AFilter:String);

    procedure ReceberDataSet(ADataSet: TDataSet);
    procedure AtualizarDataSet; overload;
    procedure AtualizarDataSetWhere(AColumn: string; AValue: Integer); overload;



    constructor Create(AConn: TFDConnection); overload;
    constructor Create(AConn: IDBConnection); overload;
    property ConexaoAtual: IDBConnection read GetConexaoAtual;
  private
    //ABSTRAÇÃO CONEXÃO ORMBr
    FConn: IDBConnection;

    //CONTROLE DE DATASET
    FContainerDataSet: IContainerDataSet<T>;

    //CONTAINER CRUD
    FObjectContainer: IContainerObjectSet<T>;

    function Teste: IDBResultSet;

  end;

implementation

  //CONSTRUCTOR

constructor TRepository<T>.Create(AConn: TFDConnection);
begin
    //ABSTRAÇÃO DO TIPO DE CONEXÃO "IDBConnection" - (FDConnection,enumFireBird)
  FConn := TFactoryFireDAC.Create(AConn, dnFirebird);
    //CONTAINER CRUD
  FObjectContainer := TContainerObjectSet<T>.Create(FConn);
end;


constructor TRepository<T>.Create(AConn: IDBConnection);
begin
    //ABSTRAÇÃO DO TIPO DE CONEXÃO "IDBConnection" - (FDConnection,enumFireBird)
  FConn := AConn;
    //CONTAINER CRUD
  FObjectContainer := TContainerObjectSet<T>.Create(FConn);
end;

  // ############### CRUD ############### CRUD ############### CRUD ############### CRUD ############### CRUD ############### CRUD

  //SELECIONAR TODOS
function TRepository<T>.SelectAll: TObjectList<T>;
begin
  Result := FObjectContainer.Find;
end;

procedure TRepository<T>.SetConexaoAtual(const Value: IDBConnection);
begin
  FConexaoAtual := Value;
end;

//SELECIONAR POR ID
function TRepository<T>.Select(AID: string): T;
begin
  Result := FObjectContainer.Find(AID);
end;

  //INSERIR
procedure TRepository<T>.Insert(AClass: T);
begin
  FObjectContainer.Insert(AClass);
end;

  //ATUALIZAR
procedure TRepository<T>.Update(AID: string; ANewClass: T);
var
  LCurrentClass: T;
begin
  LCurrentClass := nil;
  try
      //BUSCAR CLIENTE ATUAL
    LCurrentClass := FObjectContainer.Find(AID);
    FObjectContainer.Modify(LCurrentClass);
    FObjectContainer.Update(ANewClass);
  finally
      //LIBERAR APENAS A CLASSE ATUAL, CLASSE NOVA, CHAMADOR DA FUNÇÃO LIBERA.
    LCurrentClass.Free;
  end;
end;

  //DELETAR
procedure TRepository<T>.Delete(AClass: T);
begin
  FObjectContainer.Delete(AClass);
end;

function TRepository<T>.GetConexaoAtual: IDBConnection;
begin
  result := FConn;
end;

//SQL DIRETO
function TRepository<T>.Teste: IDBResultSet;
var
  LDataSet: IDBResultSet;
begin
  LDataSet := FConn.CreateResultSet('SELECT COUNT(*) AS CONTAGEM FROM CLIENTES');
  Result := LDataSet;
end;

  //################# DATASET ################# DATASET ################# DATASET ################# DATASET ################# DATASET

  //FILTRAR DATASET
procedure TRepository<T>.FiltrarDataSet(AColumn,AFilter:String);
begin
  if AFilter = '' then
  begin
   Self.FContainerDataSet.DataSet.Filtered := False;
   Self.FContainerDataSet.DataSet.Filter := '';
   Exit
  end;
  Self.FContainerDataSet.DataSet.FilterOptions := [foCaseInsensitive];
  Self.FContainerDataSet.DataSet.Filter := Format('%s like ''%%%s%%''', [AColumn, AFilter]);
  Self.FContainerDataSet.DataSet.Filtered := True;
end;

  //PASSAR CONTROLE DO DATA-SET PARA ORM REPOSITORY
procedure TRepository<T>.ReceberDataSet(ADataSet: TDataSet);
begin
  Self.FContainerDataSet := TContainerFDMemTable<T>.Create(FConn, ADataSet);
end;

procedure TRepository<T>.AtualizarDataSetWhere(AColumn: string; AValue: Integer);
var
  LSQL: string;
  LID: string;
begin
  LID := IntToStr(AValue);
  LSQL := AColumn + '=' + LID;
  if Assigned(Self.FContainerDataSet) then
    Self.FContainerDataSet.OpenWhere(LSQL)
  else
    raise Exception.Create('ERROR: NÃO FOI POSSÍVEL ATUALIZAR O DATASET: DATASET NÃO ATRIBUÍDO');
end;

  //ATUALIZAR DATASET
procedure TRepository<T>.AtualizarDataSet;
begin
  if Assigned(Self.FContainerDataSet) then
    Self.FContainerDataSet.Open
  else
    raise Exception.Create('ERROR: NÃO FOI POSSÍVEL ATUALIZAR O DATASET: DATASET NÃO ATRIBUÍDO');
end;

end.

