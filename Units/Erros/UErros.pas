unit UErros;

interface

uses
//SYSTEM
System.SysUtils,
System.Classes,
UFormatErrorText,
Vcl.Dialogs,
//ERRORS LIBS
FireDAC.Stan.Error,
FireDAC.Phys.IBWrapper;

type ECustomException = class(Exception)
  private
    FInnerClass: String;
  public
    property InnerClass: String read FInnerClass;
    constructor Create(AError: Exception;AMSG:String = '');
end;

type EValidationError = class(Exception)
  public
    FCampos: TStringList;
    FValores: TStringList;

  constructor Create;
  destructor Destroy;
end;

//ABSTRAIR ERROS DO FIREDAC DAS DEMAIS PARTES DA APLICAÇÃO
type TRepositoryErrorOperation = (opInsert,opSelect,opUpdate,opDelete,opGeneric);

type ERepositoryError = Class(ECustomException)
  private
    FErrorOperation: TRepositoryErrorOperation;
  public
    Property ErrorType: TRepositoryErrorOperation Read FErrorOperation Write FErrorOperation;
    Constructor Create(AError: Exception;AMSG:String;ATypeError:TRepositoryErrorOperation);
End;


//ABSTRAIR ERROS DE CONEXÃO AO BANCO
type EDMError = Class(ECustomException);


type TTratamentoDeErros = class
  public
    //TRATAMENTO NO FORMULÁRIO
    class procedure ExecutarOnForm(AProcedure: TProc) overload;
    class function ExecutarOnForm<T>(AFunction: TFunc<T>):T overload;

    //TRATAMENTO NO REPOSITORY
    class procedure ExecutarOnRepository(AProcedure: TProc; AOperation: TRepositoryErrorOperation) overload;
    class function ExecutarOnRepository<T>(AFunction: TFunc<T>; AOperation: TRepositoryErrorOperation):T overload;

    //TRATAMENTO DM
    class procedure ExecutarOnDM(AProcedure: TProc);
    //TRATAMENTO SOURCE
    class procedure ExecutarOnStart(AProcedure: TProc);

end;

implementation

  // ######## ERROS ######## ERROS ######## ERROS ######## ERROS ######## ERROS ######## ERROS ######## ERROS ######## ERROS ######## ERROS

  //ERROS DE VALIDAÇÃO
  constructor EValidationError.Create;
  begin
    Self.FCampos := TStringList.Create;
    Self.FValores := TStringList.Create;
    inherited Create('');
  end;

  destructor EValidationError.Destroy;
  begin
    Self.FCampos.Free;
    Self.FValores.Free;

    inherited;
  end;

  //ERROS CUSTOM
  constructor ECustomException.Create(AError: Exception;AMSG:String = '');
  begin
    //VERIFICAR QUAL MSG VAI SER PASSADA
    if AMSG = '' then
      inherited Create(AError.Message)
    else if AMSG <> '' then
      inherited Create(AMSG);


    FInnerClass := AError.ClassName;
  end;

  //ERROS REPOSITORY
  Constructor ERepositoryError.Create(AError: Exception;AMSG:String;ATypeError:TRepositoryErrorOperation);
  begin
    //VERIFICAR QUAL MSG VAI SER PASSADA
    inherited Create(AError,AMSG);

    FErrorOperation := ATypeError;
    FInnerClass := AError.ClassName;
  end;

  // ########## TRATAMENTO ########## TRATAMENTO ########## TRATAMENTO ########## TRATAMENTO ########## TRATAMENTO ########## TRATAMENTO ########## TRATAMENTO

  // ***** TRATAMENTO NOS FORMULÁRIOS *****
  class procedure TTratamentoDeErros.ExecutarOnForm(AProcedure: TProc) overload;
  begin
    try
      //EXECUTAR MÉTODO
      AProcedure();
    except
      //TRATAMENTO
      //ERROS VALIDAÇÃO FORMULÁRIOS
      on E: EValidationError do
      begin
        ShowMessage('Falha ao validar valores.' + FFormatErrorText(E.FCampos,E.FValores));
      end;
      //TRATAMENTO ERROS CONEXÃO AO BANCO
      on E: EDMError do
      begin
        ShowMessage('Falha ao tentar se conectar ao banco' + sLineBreak + E.Message);
      end;
      //TRATAMENTO ERROS REPOSITORY
      on E: ERepositoryError do
      begin
        //INSERT
        if E.FErrorOperation = opInsert then
        begin
          ShowMessage('Falha ao criar registro: ' +  sLineBreak + E.Message);
        end
        //SELECT
        else if E.FErrorOperation = opSelect then
        begin
          ShowMessage('Falha ao buscar registro: ' +  sLineBreak + E.Message);
        end
        //UPDATE
        else if E.FErrorOperation = opUpdate then
        begin
          ShowMessage('Falha ao atualizar registro: ' +  sLineBreak + E.Message);
        end
        //DELETE
        else if E.FErrorOperation = opDelete then
        begin
          //EXCLUSÃO COM FK REFERENCIADA
          if E.Message.Contains('violation of FOREIGN KEY constraint') then
            ShowMessage('Falha ao deletar registro: ' +  sLineBreak + 'Registro em uso por outra operação. altere seu status para inativo')
          else
            ShowMessage('Falha ao deletar registro: ' +  sLineBreak + E.Message);
        end
        else if E.FErrorOperation = opGeneric then
        begin
          ShowMessage('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
        end

      end;
      //ERROS INESPERADOS
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  class function TTratamentoDeErros.ExecutarOnForm<T>(AFunction: TFunc<T>):T overload;
  begin
    try
      //EXECUTAR MÉTODO
      Result := AFunction();
    except
      //TRATAMENTO
      //ERROS VALIDAÇÃO FORMULÁRIOS
      on E: EValidationError do
      begin
        ShowMessage('Falha ao validar valores.' + FFormatErrorText(E.FCampos,E.FValores));
      end;
      //TRATAMENTO ERROS CONEXÃO AO BANCO
      on E: EDMError do
      begin
        ShowMessage('Falha ao tentar se conectar ao banco. Error:' + sLineBreak + E.Message);
      end;
      //TRATAMENTO ERROS DO BANCO
      on E: ERepositoryError do
      begin
        ShowMessage('Falha interna no banco. Error:' + sLineBreak + E.Message);
      end;
      //ERROS INESPERADOS
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  // ***** TRATAMENTO NO REPOSITORY *****
  class procedure TTratamentoDeErros.ExecutarOnRepository(AProcedure: TProc; AOperation: TRepositoryErrorOperation) overload;
  begin
    try
      //EXECUTAR MÉTODO
      AProcedure();
    except
      //TRADUÇÃO DE ERROS DO FIREDAC
      on E: Exception do
      begin
        raise ERepositoryError.Create(E,'',AOperation);
      end;
    end;
  end;

  class function TTratamentoDeErros.ExecutarOnRepository<T>(AFunction: TFunc<T>;AOperation: TRepositoryErrorOperation):T overload;
  begin
    try
      //EXECUTAR MÉTODO
      Result := AFunction();
    except
      //TRADUÇÃO DE ERROS DO FIREDAC
      on E: Exception do
      begin
        raise ERepositoryError.Create(E,'',AOperation);;
      end;
    end;
  end;

  // ***** TRATAMENTO CONEXÃO DM *****

  class procedure TTratamentoDeErros.ExecutarOnDM(AProcedure: TProc) overload;
  begin
    try
      //EXECUTAR MÉTODO
      AProcedure();
    except
      //TRADUÇÃO DE ERROS CONEXÃO
      on E: Exception do
      begin
        raise EDMError.Create(E);
      end;

    end;
  end;

  // ***** TRATAMENTO *****

  class procedure TTratamentoDeErros.ExecutarOnStart(AProcedure: TProc);
  begin
    try
      //EXECUTAR MÉTODO
      AProcedure();
    except
      //TRATAMENTO ERROS CONEXÃO AO BANCO
      on E: EDMError do
      begin
        ShowMessage('Falha ao tentar se conectar ao banco. Error:' + sLineBreak + E.Message);
      end;

      on E: Exception do
      begin
        ShowMessage('Falha na inicialização do programa. Error:' + sLineBreak + E.Message);
      end;
    end;
  end;

end.
