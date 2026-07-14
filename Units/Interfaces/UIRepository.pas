unit UIRepository;

interface

  Uses Data.DB, System.Generics.Collections, dbebr.factory.interfaces, FireDAC.Comp.Client;

 //ABSTRAÇÃO REPOSITÓRIO GENÉRICO
  type IRepository<T: class, constructor> = interface
    //CRUD REPOSITORY
      function GetConexaoAtual : IDBConnection;
      function Select(AID:String):T;
      function SelectAll:TObjectList<T>;
      function SelectAllByColumn(AColumn:String;AFilter:String): TObjectList<T>;
      procedure Insert(AClass:T);
      procedure Update(AID:String;ANewClass:T);
      procedure Delete(AClass:T);
      procedure FiltrarDataSet(AColumn,AFilter:String);

      //TRABALHAR RETORNO PARA UI

      //PARA FIREBIRD 2.0 +++
      procedure ReceberDataSet(ADataSet: TDataSet);
      //PARA FIREBIRD LEGADO 1.0
      procedure ReceberDataSetFirebirdLegado(ADataSet: TFDMemTable);
      procedure OpenFirebirdLegado(ASQL:String);

      procedure AtualizarDataSet; Overload;
      procedure AtualizarDataSetWhere(AColumn:String;AValue:Integer); Overload;
      function Open(ASQL:String): IDBResultSet;
      procedure ExecSQL(ASQL:String);
      //
      property ConexaoAtual : IDBConnection read GetConexaoAtual;
  end;

implementation

end.
