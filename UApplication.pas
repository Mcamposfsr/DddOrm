unit UApplication;

interface
 uses System.Generics.Collections,UClasseModelo, System.SysUtils, Data.DB, Vcl.Dialogs;

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


  type IApp = Interface
    Function BuscarClientes:TObjectList<TComp>;
    Function BuscarClienteByID(AID:Integer):TComp;
    procedure InserirCliente(ANome,ACPF:String);
    procedure AtualizarCliente(AID:Integer;ANome,ACPF:String);
    procedure DeletarCliente(AID:Integer);

  End;

  type TApp = class(TInterfacedObject,IApp)
    public
      Function BuscarClientes:TObjectList<TComp>;
      Function BuscarClienteByID(AID:Integer):TComp;
      procedure InserirCliente(ANome,ACPF:String);
      procedure AtualizarCliente(AID:Integer;ANome,ACPF:String);
      procedure DeletarCliente(AID:Integer);

      constructor Create(ARep:IRepository<TComp>);
    private

      FRepository: IRepository<TComp>;

  end;

implementation

  //RECEBER REPOSITORY
  constructor TApp.Create(ARep:IRepository<TComp>);
  begin
    FRepository := ARep;
  end;

  Function TApp.BuscarClientes:TObjectList<TComp>;
  begin
    Result := FRepository.SelectAll;
  end;

  Function TApp.BuscarClienteByID(AID:Integer):TComp;
  var LID: String;
  begin
    LID := IntToStr(AID);
    Result := FRepository.Select(LID);
  end;

  procedure TApp.InserirCliente(ANome,ACPF:String);
  var LCliente: TComp;
  begin
    LCliente := nil;
    try
     LCliente := TComp.Create(0,ANome,ACPF);

     //REGRA DE NEGÓCIO - VALIDAR CPF
     if not LCliente.ValidarCpf then
      raise Exception.Create('CPF INVÁLIDO');

     FRepository.Insert(LCliente);
    finally
      LCliente.Free;
    end;
  end;

  procedure TApp.AtualizarCliente(AID:Integer;ANome,ACPF:String);
  var
  LCliente: TComp;
  LID: String;
  begin
    LID := IntToStr(AID);
    LCliente := nil;
    try
     LCliente := TComp.Create(AID,ANome,ACPF);

     //REGRA DE NEGÓCIO - VALIDAR CPF
     if not LCliente.ValidarCpf then
      raise Exception.Create('CPF INVÁLIDO');

     FRepository.Update(LID,LCliente);
    finally
      LCliente.Free;
    end;
  end;

  procedure TApp.DeletarCliente(AID:Integer);
  var
  LCliente: TComp;
  LID: String;
  begin
    LID := IntToStr(AID);
    LCliente := nil;
    try
      //CLASSE MÍNIMA APENAS PARA DELETE
     LCliente := TComp.Create(AID,'','');
     FRepository.Delete(LCliente);
    finally
      LCliente.Free;
    end;
  end;

end.
