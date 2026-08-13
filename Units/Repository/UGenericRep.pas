unit UGenericRep;

interface

uses
  //SYSTEM
  Vcl.Dialogs,
  Firedac.comp.Client,
  FireDAC.Stan.Param,
  System.SysUtils,
  Data.DB,
  FireDAC.Stan.Option,
  FireDAC.Comp.DataSet,
  DateUtils,
  System.Classes,
  System.Generics.Collections,
  //INTERFACES
  UIRepository,
  UIDM,
  //ORM
  dbebr.factory.interfaces,
  dbebr.factory.firedac,
  ormbr.dml.generator.firebird,
  ormbr.container.fdmemtable,
  ormbr.container.dataset.interfaces,
  ormbr.form.monitor,UErros,
  ormbr.container.objectset.interfaces,
  ormbr.container.objectset;

type
  TRepository<T: class, constructor> = class(TInterFacedObject, IRepository<T>)
  private
    //ABSTRAÇÃO CONEXÃO ORMBr
    FConn: IDBConnection;

    //CONTROLE DE DATASET
    FContainerDataSet: IContainerDataSet<T>;

    //CONTROLE DATASET FB LEGADO - APENAS REFERÊNCIA AO REAL.
    FDataSet: TFDMemTable;

    //CONTAINER CRUD
    FObjectContainer: IContainerObjectSet<T>;

    //SETTER / GETTER CONEXÃO
    procedure SetConexaoAtual(const Value: IDBConnection);
    function GetConexaoAtual: IDBConnection;

    public
    //CRUD
    function Select(AID: string): T;
    function SelectAll: TObjectList<T>;
    function SelectAllByColumn(AColumn:String;AFilter:String): TObjectList<T>;
    procedure Insert(AClass: T);
    procedure Update(AID: string; ANewClass: T);
    procedure Delete(AClass: T);
    function Open(ASQL:String): TFDMemTable;
    procedure ExecSQL(ASQL:String);

    // ***** TRABALHAR DATASETS *****
    //PARA FIREBIRD 2.0 +++
    procedure ReceberDataSet(ADataSet: TDataSet);
    procedure FiltrarDataSet(AColumn,AFilter:String);
    procedure AtualizarDataSet; overload;
    procedure AtualizarDataSetWhere(AColumn: string; AValue: Integer); overload;

    //PARA FIREBIRD LEGADO 1.5
    procedure ReceberDataSetFirebirdLegado(ADataSet: TFDMemTable);
    procedure AtualizarDataSetFirebirdLegado(ASQL:String);
    procedure FiltrarDataSetLegado(AColumn,AFilter:String);

    //TRABALHAR COM TRANSAÇÕES MANUAIS
    procedure ExecuteInTransaction(AProcedure: TProc);

    constructor Create(AConn: TFDConnection); overload;
    constructor Create(AConn: IDBConnection); overload;

    property ConexaoAtual: IDBConnection read GetConexaoAtual;
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
    Result :=  TTratamentoDeErros.ExecutarOnRepository<TObjectList<T>>(
    function: TObjectList<T>
    begin
      Result := FObjectContainer.Find
    end,
    opSelect
    );
  end;

  //SELECIONAR TODOS DE UMA COLUNA
  function TRepository<T>.SelectAllByColumn(AColumn:String;AFilter:String): TObjectList<T>;
  var LWhere: String;
  begin
    if (AColumn = '') or (AFilter = '') then
      raise Exception.Create('Falha ao executar SelectAllByColumn do Repository, Coluna ou Filtro vazio');
      
    LWhere := AColumn + ' = ' + AFilter;

    Result := TTratamentoDeErros.ExecutarOnRepository<TObjectList<T>>(
    function: TObjectList<T>
    begin
      Result := FObjectContainer.FindWhere(LWhere);
    end,
    opSelect
    );

  end;

  procedure TRepository<T>.SetConexaoAtual(const Value: IDBConnection);
  begin
    Self.FConn := Value;
  end;

  //SELECIONAR POR ID
  function TRepository<T>.Select(AID: string): T;
  begin
    Result := TTratamentoDeErros.ExecutarOnRepository<T>(
    function: T
    begin
      Result := FObjectContainer.Find(AID);
    end,
    opSelect
    );
  end;

  //INSERIR
  procedure TRepository<T>.Insert(AClass: T);
  begin
    TTratamentoDeErros.ExecutarOnRepository(
    procedure
    begin
      FObjectContainer.Insert(AClass);
    end,
    opInsert
    );
  end;

    //ATUALIZAR
  procedure TRepository<T>.Update(AID: string; ANewClass: T);
  var
    LCurrentClass: T;
  begin
    LCurrentClass := nil;
    try
      TTratamentoDeErros.ExecutarOnRepository(
      procedure
      begin
        //BUSCAR CLIENTE ATUAL
        LCurrentClass := FObjectContainer.Find(AID);
        FObjectContainer.Modify(LCurrentClass);
        FObjectContainer.Update(ANewClass);
      end,
      opUpdate
      );
    finally
        //LIBERAR APENAS A CLASSE ATUAL, CLASSE NOVA, CHAMADOR DA FUNÇÃO LIBERA.
      LCurrentClass.Free;
    end;
  end;

    //DELETAR
  procedure TRepository<T>.Delete(AClass: T);
  begin
    TTratamentoDeErros.ExecutarOnRepository(
    procedure
    begin
      FObjectContainer.Delete(AClass);
    end,
    opDelete
    );
  end;

  function TRepository<T>.GetConexaoAtual: IDBConnection;
  begin
    result := FConn;
  end;


  //################# DATASET FB 2.0 ++ ################# DATASET FB 2.0 ++################# DATASET FB 2.0 ++################# DATASET FB 2.0 ++################# DATASET FB 2.0 ++################# DATASET FB 2.0 ++

  //FILTRAR DATASET
  procedure TRepository<T>.FiltrarDataSet(AColumn,AFilter:String);
  begin
    TTratamentoDeErros.ExecutarOnRepository(
    procedure
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
    end,
    opGeneric
    );

  end;

  //PASSAR CONTROLE DO DATA-SET PARA ORM REPOSITORY
  procedure TRepository<T>.ReceberDataSet(ADataSet: TDataSet);
  begin
    TTratamentoDeErros.ExecutarOnRepository(
    procedure
    begin
      Self.FContainerDataSet := TContainerFDMemTable<T>.Create(FConn, ADataSet);
    end,
    opGeneric
    );
  end;

  procedure TRepository<T>.AtualizarDataSetWhere(AColumn: string; AValue: Integer);
  var
    LSQL: string;
    LID: string;
  begin
    TTratamentoDeErros.ExecutarOnRepository(
    procedure
    begin
      LID := IntToStr(AValue);
      LSQL := AColumn + '=' + LID;
      if Assigned(Self.FContainerDataSet) then
        Self.FContainerDataSet.OpenWhere(LSQL)
      else
        raise Exception.Create('ERROR: NÃO FOI POSSÍVEL ATUALIZAR O DATASET: DATASET NÃO ATRIBUÍDO');
    end,
    opGeneric
    );
  end;

    //ATUALIZAR DATASET
  procedure TRepository<T>.AtualizarDataSet;
  begin
    TTratamentoDeErros.ExecutarOnRepository(
    procedure
    begin
      if Assigned(Self.FContainerDataSet) then
        Self.FContainerDataSet.Open
      else
        raise Exception.Create('ERROR: NÃO FOI POSSÍVEL ATUALIZAR O DATASET: DATASET NÃO ATRIBUÍDO');
    end,
    opGeneric
    );
  end;

 // ################# DATASET FB 1.5 LEGADO ################# DATASET FB 1.5 LEGADO ################# DATASET FB 1.5 LEGADO ################# DATASET FB 1.5 LEGADO ################# DATASET FB 1.5 LEGADO

  //RECEBER DATASET
  procedure TRepository<T>.ReceberDataSetFirebirdLegado(ADataSet: TFDMemTable);
  begin
    //RECEBER DATASET DIRETO
    Self.FDataSet := ADataSet;
  end;

  //FAZER BUSCAS PARA DATASET
  procedure TRepository<T>.AtualizarDataSetFirebirdLegado(ASQL:String);
  var LDataSet: TFDMemTable;
  begin
    TTratamentoDeErros.ExecutarOnRepository(
    procedure
    begin
      if not assigned(Self.FDataSet) then
        raise Exception.Create('ERROR: NÃO FOI POSSÍVEL ATUALIZAR O DATASET: DATASET NÃO ATRIBUÍDO');



      Self.FDataSet.DisableControls;
      try
        //RECEBER RESULTADO DA BUSCA
        LDataSet := Self.Open(ASQL);

        Self.FDataSet.Close;
        Self.FDataSet.CopyDataSet(
          LDataSet,
          [coStructure,coAppend]
        );
      finally
        Self.FDataSet.EnableControls;
        LDataSet.Free;
      end;
    end,
    opGeneric
    );
  end;

    //FILTRAR DATASET
  procedure TRepository<T>.FiltrarDataSetLegado(AColumn,AFilter:String);
  begin
    TTratamentoDeErros.ExecutarOnRepository(
    procedure
    begin
      if not assigned(Self.FDataSet) then
      raise Exception.Create('ERROR: NÃO FOI POSSÍVEL FILTRAR O DATASET: DATASET NÃO ATRIBUÍDO');

      if AFilter = '' then
      begin
       Self.FDataSet.Filtered := False;
       Self.FDataSet.Filter := '';
       Exit
      end;
      Self.FDataSet.FilterOptions := [foCaseInsensitive];
      Self.FDataSet.Filter := Format('%s like ''%%%s%%''', [AColumn, AFilter]);
      Self.FDataSet.Filtered := True;
    end,
    opGeneric
    );
  end;

  // ########## GENERICS ########## GENERICS ########## GENERICS ########## GENERICS ########## GENERICS ########## GENERICS ########## GENERICS ########## GENERICS

  // EXECUTAR SELECT
  function TRepository<T>.Open(ASQL:String): TFDMemTable;
  var
  LResultSet: IDBResultSet;
  LDataSet: TFDMemTable;
  begin
    Result := TTratamentoDeErros.ExecutarOnRepository<TFDMemTable>(
    function: TFDMemTable
    var I: Integer;
    begin
      LDataSet := TFDMemTable.Create(nil);
      LResultSet := Self.FConn.CreateResultSet(ASQL);

      //DESATIVAR READ ONLY -> (CAMPOS VINDOS DE JOINS SÃO DEFINIDOS COMO READONLY PELO ORMBR)
      for I := 0 to LResultSet.DataSet.FieldCount - 1 do
      begin
        if LResultSet.DataSet.Fields[I].ReadOnly then
          LResultSet.DataSet.Fields[I].ReadOnly := False;
      end;

      LDataSet.CopyDataSet(LResultSet.DataSet,[coRestart,coStructure,coAppend]);
      Result := LDataSet;
    end,
    opSelect
    );
  end;

  // EXECUTAR SCRIPT QUE NÃO RETORNA NADA
 procedure TRepository<T>.ExecSQL(ASQL:String);
 begin
  TTratamentoDeErros.ExecutarOnRepository(
  procedure
  begin
    Self.FConn.ExecuteScript(ASQL);
  end,
  opGeneric
  );
 end;

 //TRABALHAR COM TRANSAÇÕES MANUAIS
  procedure TRepository<T>.ExecuteInTransaction(AProcedure: TProc);
  begin
    TTratamentoDeErros.ExecutarOnRepository(
    procedure
    begin
      try
        Self.FConn.StartTransaction;
        AProcedure();
        Self.FConn.Commit;
      except
        //FAZER ROLLBACK E DEIXAR EXCEPTION SEGUIR FLUXO
        on E: Exception do
        begin
          Self.FConn.RollBack;
          raise;
        end;
      end
    end,
    opGeneric
    );
  end;
end.

