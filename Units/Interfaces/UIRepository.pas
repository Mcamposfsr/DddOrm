unit UIRepository;

interface

  Uses Data.DB, System.Generics.Collections, dbebr.factory.interfaces, FireDAC.Comp.Client;

 //ABSTRAÇÃO REPOSITÓRIO GENÉRICO
  type IRepository<T: class, constructor> = interface
    //CONFIG
    procedure SetConexaoAtual(const Value: IDBConnection);
    function GetConexaoAtual: IDBConnection;

    //CRUD
    function Select(AID: string): T;
    function SelectAll: TObjectList<T>;
    function SelectAllByColumn(AColumn:String;AFilter:String): TObjectList<T>;
    procedure Insert(AClass: T);
    procedure Update(AID: string; ANewClass: T);
    procedure Delete(AClass: T);
    function Open(ASQL:String): IDBResultSet;
    procedure ExecSQL(ASQL:String);

    //AUX PARA FIREBIRD 2.0 +++
    procedure ReceberDataSet(ADataSet: TDataSet);
    procedure FiltrarDataSet(AColumn,AFilter:String);
    procedure AtualizarDataSet; overload;
    procedure AtualizarDataSetWhere(AColumn: string; AValue: Integer); overload;

    //AUX PARA FIREBIRD LEGADO 1.5
    procedure ReceberDataSetFirebirdLegado(ADataSet: TFDMemTable);
    procedure OpenFirebirdLegado(ASQL:String);
    procedure FiltrarDataSetLegado(AColumn,AFilter:String);
  end;

implementation

end.
