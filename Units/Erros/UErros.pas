unit UErros;

interface

uses System.SysUtils,System.Classes,UFormatErrorText,Vcl.Dialogs;

type TTratamentoDeErros = class
  public
    class procedure ExecutarOnForm(AProcedure: TProc) overload;
    class function ExecutarOnForm<T>(AFunction: TFunc<T>):T overload;
//    class procedure ExecutarOnRepository(AProcedure: TProc);

end;


type EValidationError = class(Exception)
  public
    FCampos: TStringList;
    FValores: TStringList;

  constructor Create;
  destructor Destroy;
end;






implementation

  //EXECUTAR TRATAMENTO PADRONIZADO
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
      //ERROS INESPERADOS
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro inesperado: ' +  sLineBreak + E.Message);
      end;
    end;
  end;


  //ERRORS DE VALIDAÇÃO NO DOMAIN

  constructor EValidationError.Create;
  begin
    Self.FCampos := TStringList.Create;
    Self.FValores := TStringList.Create;
    inherited Create('');
  end;

  //LIBERAR LISTAS
  destructor EValidationError.Destroy;
  begin
    Self.FCampos.Free;
    Self.FValores.Free;

    inherited;
  end;

  end.
