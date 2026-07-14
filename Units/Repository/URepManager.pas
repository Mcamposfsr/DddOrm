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
  ormbr.manager.dataset,
  ormbr.form.monitor,


  //OBJECT SET
  ormbr.container.objectset.interfaces, ormbr.container.objectset;

type
  TRepositoryManager = class
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
    //DOMAIN RECEIVER
    procedure AddDomain<T:Class, constructor>;

    //DATASETS
    procedure FiltrarDataSet<T: Class, constructor>(AColumn,AFilter:String);
    procedure AtualizarDataSetWhere<T: Class, constructor>(AColumn: string; AValue: Integer);
    procedure AtualizarDataSet<T: Class, constructor>;
    //DATASET RECEIVER
    procedure ReceberDataSet<T: Class, Constructor>(ADataSet: TDataSet);


    //CONSTRUCTORS
    constructor Create(AConn: TFDConnection); overload;
//    constructor Create(AConn: IDBConnection); overload;

    destructor Destroy;

    property ConexaoAtual: IDBConnection read GetConexaoAtual;
  private
    //ABSTRAÇÃO CONEXÃO ORMBr
    FConn: IDBConnection;

    //MANAGER DE OBJECTS --DOMAINS--
    FObjectsManager: TManagerObjectSet;

    //MANAGER DATASETS
    FDataSetsManager: TManagerDataSet;


  end;

implementation

  //CONSTRUCTOR

  constructor TRepositoryManager.Create(AConn: TFDConnection);
  begin
      //ABSTRAÇÃO DO TIPO DE CONEXÃO "IDBConnection" - (FDConnection,enumFireBird)
    FConn := TFactoryFireDAC.Create(AConn, dnFirebird);

    //CONTAINER DOMAINS
    FObjectsManager := TManagerObjectSet.Create(FConn);

    //CONTAINER DATASETS
    FDataSetsManager := TManagerDataSet.Create(FConn);
  end;

  //DESTRUCTOR
  destructor TRepositoryManager.Destroy;
  begin
    FObjectsManager.Free;
    FDataSetsManager.Free;

    inherited
  end;



// ############### RECEIVER DOMAINS ############### RECEIVER DOMAINS ############### RECEIVER DOMAINS  ############### RECEIVER DOMAINS


  procedure TRepositoryManager.AddDomain<T>;
  begin
    FObjectsManager.AddAdapter<T>;
  end;


// ############### CRUD ############### CRUD ############### CRUD ############### CRUD ############### CRUD ############### CRUD

    //SELECIONAR TODOS
  function TRepositoryManager.SelectAll<T>: TObjectList<T>;
  begin
    Result := FObjectsManager.Find<T>;
  end;

  //SELECIONAR POR ID
  function TRepositoryManager.Select<T>(AID: string): T;
  begin
    Result := FObjectsManager.Find<T>(AID);
  end;

    //INSERIR
  procedure TRepositoryManager.Insert<T>(AClass: T);
  begin
    FObjectsManager.Insert<T>(AClass);
  end;

    //ATUALIZAR
  procedure TRepositoryManager.Update<T>(AID: string; ANewClass: T);
  var
    LCurrentClass: T;
  begin
    LCurrentClass := nil;
    try
        //BUSCAR CLIENTE ATUAL
      LCurrentClass := FObjectsManager.Find<T>(AID);
      FObjectsManager.Modify<T>(LCurrentClass);
      FObjectsManager.Update<T>(ANewClass);
    finally
        //LIBERAR APENAS A CLASSE ATUAL, CLASSE NOVA, CHAMADOR DA FUNÇÃO LIBERA.
      LCurrentClass.Free;
    end;
  end;

    //DELETAR
  procedure TRepositoryManager.Delete<T>(AClass: T);
  begin
    FObjectsManager.Delete<T>(AClass);
  end;

  procedure TRepositoryManager.SetConexaoAtual(const Value: IDBConnection);
  begin
    FConexaoAtual := Value;
  end;


  function TRepositoryManager.GetConexaoAtual: IDBConnection;
  begin
    result := FConn;
  end;

  //################# DATASET ################# DATASET ################# DATASET ################# DATASET ################# DATASET


   //RECEBER REPOSITORY
  procedure TRepositoryManager.ReceberDataSet<T>(ADataSet: TDataSet);
  begin
    Self.FDataSetsManager.AddAdapter<T>(ADataSet);
  end;

  //FILTRAR DATASET
  procedure TRepositoryManager.FiltrarDataSet<T>(AColumn,AFilter:String);
  begin
    if AFilter = '' then
    begin
     Self.FDataSetsManager.DataSet<T>.Filtered := False;
     Self.FDataSetsManager.DataSet<T>.Filter := '';
     Exit
    end;
    Self.FDataSetsManager.DataSet<T>.FilterOptions := [foCaseInsensitive];
    Self.FDataSetsManager.DataSet<T>.Filter := Format('%s like ''%%%s%%''', [AColumn, AFilter]);
    Self.FDataSetsManager.DataSet<T>.Filtered := True;
  end;

  procedure TRepositoryManager.AtualizarDataSetWhere<T>(AColumn: string; AValue: Integer);
  var
    LSQL: string;
    LID: string;
  begin
    LID := IntToStr(AValue);
    LSQL := AColumn + '=' + LID;
//    if Assigned(Self.FDataSetsManager.DataSet<T>) then
      Self.FDataSetsManager.OpenWhere<T>(LSQL)
//    else
//      raise Exception.Create('ERROR: NÃO FOI POSSÍVEL ATUALIZAR O DATASET: DATASET NÃO ATRIBUÍDO');
  end;

    //ATUALIZAR DATASET
  procedure TRepositoryManager.AtualizarDataSet<T>;
  begin
//    if Assigned(Self.FDataSetsManager.DataSet<T>) then
      Self.FDataSetsManager.Open<T>
//    else
//      raise Exception.Create('ERROR: NÃO FOI POSSÍVEL ATUALIZAR O DATASET: DATASET NÃO ATRIBUÍDO');
  end;


end.

