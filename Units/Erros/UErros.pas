unit UErros;

interface

uses System.SysUtils,System.Classes,UFormatErrorText,Vcl.Dialogs,FireDAC.Stan.Error;


type EValidationError = class(Exception)
  public
    FCampos: TStringList;
    FValores: TStringList;

  constructor Create;
  destructor Destroy;
end;

//ABSTRAIR ERROS DO FIREDAC DAS DEMAIS PARTES DA APLICAÇÃO
type EDataError = class(Exception)
  private
   FInnerException: Exception;
  public
    property InnerException: Exception read FInnerException;
    constructor Create(AError:Exception);
end;

type TTratamentoDeErros = class
  public
    //TRATAMENTO NO FORMULÁRIO
    class procedure ExecutarOnForm(AProcedure: TProc) overload;
    class function ExecutarOnForm<T>(AFunction: TFunc<T>):T overload;
    //TRATAMENTO NO REPOSITORY
    class procedure ExecutarOnRepository(AProcedure: TProc) overload;
    class function ExecutarOnRepository<T>(AFunction: TFunc<T>):T overload;

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

  //ERROS DO BANCO DE DADOS
  constructor EDataError.Create(AError:Exception);
  begin
    inherited Create('Falha interna no banco de dados');
    Self.FInnerException := AError;
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
      //TRATAMENTO ERROS DO BANCO
      on E: EDataError do
      begin
        ShowMessage('Falha interna no banco. Error:' + sLineBreak + E.InnerException.Message);
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
      //TRATAMENTO ERROS DO BANCO
      on E: EDataError do
      begin
        ShowMessage('Falha interna no banco. Error:' + sLineBreak + E.InnerException.Message);
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

end.
