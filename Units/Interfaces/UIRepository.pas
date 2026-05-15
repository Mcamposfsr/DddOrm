unit UIRepository;

interface

  Uses Data.DB, System.Generics.Collections;

 //ABSTRAÇÃO REPOSITÓRIO
  type IRepository<T: class, constructor> = interface
    //CRUD REPOSITORY
      function Select(AID:String):T;
      function SelectAll:TObjectList<T>;
      procedure Insert(AClass:T);
      procedure Update(AID:String;ANewClass:T);
      procedure Delete(AClass:T);

      //TRABALHAR RETORNO PARA UI
      procedure ReceberDataSet(ADataSet: TDataSet);
      procedure AtualizarDataSet;
  end;

implementation

end.
