unit UIRepository;

interface

  Uses Data.DB, System.Generics.Collections, dbebr.factory.interfaces;

 //ABSTRAÇÃO REPOSITÓRIO GENÉRICO
  type IRepository<T: class, constructor> = interface
    //CRUD REPOSITORY
      function GetConexaoAtual : IDBConnection;
      function Select(AID:String):T;
      function SelectAll:TObjectList<T>;
      procedure Insert(AClass:T);
      procedure Update(AID:String;ANewClass:T);
      procedure Delete(AClass:T);
      procedure FiltrarDataSet(AColumn,AFilter:String);

      //TRABALHAR RETORNO PARA UI
      procedure ReceberDataSet(ADataSet: TDataSet);
      procedure AtualizarDataSet; Overload;
      procedure AtualizarDataSetWhere(AColumn:String;AValue:Integer); Overload;
      //
      property ConexaoAtual : IDBConnection read GetConexaoAtual;
  end;

implementation

end.
