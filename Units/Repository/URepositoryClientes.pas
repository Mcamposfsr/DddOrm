unit URepositoryClientes;

interface

uses Vcl.Dialogs,Firedac.comp.Client, FireDAC.Stan.Param,
  System.SysUtils,Data.DB, FireDAC.Stan.Option, FireDAC.Comp.DataSet,
  DateUtils, System.Classes,System.Generics.Collections,

  UAppClientes,


  dbebr.factory.interfaces,
  dbebr.factory.firedac,
  ormbr.dml.generator.firebird,
  ormbr.container.fdmemtable,
  ormbr.container.dataset.interfaces,


  //OBJECT SET
  ormbr.container.objectset.interfaces,
  ormbr.container.objectset;

  //INTERFACE DM
 type IDM = Interface
  Function GetConnection:TFDConnection;
  procedure ConectarBD;
  procedure DesconectarBd;
  procedure ConnectionTest;
End;

type TRepository<T: class, constructor> = class(TInterFacedObject,IRepository<T>)

  public

    function Select(AID:String):T;
    function SelectAll:TObjectList<T>;
    procedure Insert(AClass:T);
    procedure Update(AID:String;ANewClass:T);
    procedure Delete(AClass:T);

    procedure ReceberDataSet(ADataSet: TDataSet);
    procedure AtualizarDataSet;

    constructor Create(AConn:TFDConnection);

  private
    //ABSTRAÇÃO CONEXÃO ORMBr
    FConn: IDBConnection;

    //CONTROLE DE DATASET
    FContainerDataSet: IContainerDataSet<T>;

    //CONTAINER CRUD
    FObjectContainer: IContainerObjectSet<T>;

    function Teste:IDBResultSet;

end;

implementation

  //CONSTRUCTOR
  constructor TRepository<T>.Create(AConn:TFDConnection);
  begin
    //ABSTRAÇÃO DO TIPO DE CONEXÃO "IDBConnection" - (FDConnection,enumFireBird)
    FConn := TFactoryFireDAC.Create(AConn,dnFirebird);
    //CONTAINER CRUD
    FObjectContainer := TContainerObjectSet<T>.Create(FConn);
  end;

  // ############### CRUD ############### CRUD ############### CRUD ############### CRUD ############### CRUD ############### CRUD

  //SELECIONAR TODOS
  function TRepository<T>.SelectAll: TObjectList<T>;
  begin
    Result := FObjectContainer.Find;
  end;

  //SELECIONAR POR ID
  function TRepository<T>.Select(AID:String):T;
  begin
    Result := FObjectContainer.Find(AID);
  end;

  //INSERIR
  procedure TRepository<T>.Insert(AClass:T);
  begin
    FObjectContainer.Insert(AClass);
  end;

  //ATUALIZAR
  procedure TRepository<T>.Update(AID:String;ANewClass:T);
  var LCurrentClass: T;
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
  procedure TRepository<T>.Delete(AClass:T);
  begin
    FObjectContainer.Delete(AClass);
  end;

  //SQL DIRETO
  function TRepository<T>.Teste:IDBResultSet;
  var LDataSet: IDBResultSet;
  begin
     LDataSet := FConn.CreateResultSet('SELECT COUNT(*) AS CONTAGEM FROM CLIENTES');
     Result := LDataSet;
  end;

  //################# DATASET ################# DATASET ################# DATASET ################# DATASET ################# DATASET

  //PASSAR CONTROLE DO DATA-SET PARA ORM REPOSITORY
  procedure TRepository<T>.ReceberDataSet(ADataSet: TDataSet);
  begin
    Self.FContainerDataSet := TContainerFDMemTable<T>.Create(FConn,ADataSet);
  end;

  //ATUALIZAR DATASET
  procedure TRepository<T>.AtualizarDataSet;
  begin
    if Assigned(Self.FContainerDataSet) then
      Self.FContainerDataSet.Open
    else
      Raise Exception.Create('ERROR: NÃO FOI POSSÍVEL ATUALIZAR O DATASET: DATASET NÃO ATRIBUÍDO');
  end;

end.
