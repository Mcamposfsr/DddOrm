unit UErros;

interface

uses System.SysUtils,System.Classes,UFormatErrorText,Vcl.Dialogs,FireDAC.Stan.Error;

type ECustomException = class(Exception)
  private
    FInnerMessage: String;
    FInnerClass: String;
  public
    property InnerMessage: String read FInnerMessage;
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
type EDataError = Class(ECustomException);

//ABSTRAIR ERROS DE CONEXÃO AO BANCO
type EDataConnectionError = Class(ECustomException);


type TTratamentoDeErros = class
  public
    //TRATAMENTO NO FORMULÁRIO
    class procedure ExecutarOnForm(AProcedure: TProc) overload;
    class function ExecutarOnForm<T>(AFunction: TFunc<T>):T overload;
    //TRATAMENTO NO REPOSITORY
    class procedure ExecutarOnRepository(AProcedure: TProc) overload;
    class function ExecutarOnRepository<T>(AFunction: TFunc<T>):T overload;
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
    inherited Create(AMSG);
    FInnerMessage := AError.Message;
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
      on E: EDataConnectionError do
      begin
        ShowMessage('Falha ao tentar se conectar ao banco' + sLineBreak + E.InnerMessage);
      end;
      //TRATAMENTO ERROS DO BANCO
      on E: EDataError do
      begin
        ShowMessage('Falha interna no banco. Error:' + sLineBreak + E.InnerMessage);
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
      on E: EDataConnectionError do
      begin
        ShowMessage('Falha ao tentar se conectar ao banco. Error:' + sLineBreak + E.InnerMessage);
      end;
      //TRATAMENTO ERROS DO BANCO
      on E: EDataError do
      begin
        ShowMessage('Falha interna no banco. Error:' + sLineBreak + E.InnerMessage);
      end;
      //ERROS INESPERADOS
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;

  // ***** TRATAMENTO NO REPOSITORY *****
  class procedure TTratamentoDeErros.ExecutarOnRepository(AProcedure: TProc) overload;
  begin
    try
      //EXECUTAR MÉTODO
      AProcedure();
    except
      //TRADUÇÃO DE ERROS DO FIREDAC
      on E: EFDDBEngineException do
        raise EDataError.Create(E);
    end;
  end;

  class function TTratamentoDeErros.ExecutarOnRepository<T>(AFunction: TFunc<T>):T overload;
  begin
    try
      //EXECUTAR MÉTODO
      Result := AFunction();
    except
      //TRADUÇÃO DE ERROS DO FIREDAC
      on E: EFDDBEngineException do
        raise EDataError.Create(E);
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
        raise EDataConnectionError.Create(E);
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
      on E: EDataConnectionError do
      begin
        ShowMessage('Falha ao tentar se conectar ao banco. Error:' + sLineBreak + E.InnerMessage);
      end;

      on E: Exception do
      begin
        ShowMessage('Falha na inicialização do programa. Error:' + sLineBreak + E.Message);
      end;
    end;
  end;

end.
