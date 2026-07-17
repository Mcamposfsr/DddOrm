unit UFormatErrorText;

interface
  uses System.Generics.Collections, System.Classes;

  Function FFormatErrorText(ACampos,AValores:TStringList):String;

implementation

  // FORMATAR MENSAGEM DE ERROR -> EErrorFormInput
  Function FFormatErrorText(ACampos,AValores:TStringList):String;
  var
  LMsg: String;
  I: Integer;
  begin
    LMsg := sLineBreak + sLineBreak + 'Campos inválidos:' + sLineBreak;

    for  I:= 0  to ACampos.Count -1 do
    begin
      LMsg := LMsg + ACampos[I] + sLineBreak;
    end;

    LMsg := LMsg + sLineBreak + 'Valores inválidos:' + sLineBreak;

    for  I:= 0  to AValores.Count -1 do
    begin
      LMsg := LMsg + AValores[I] + sLineBreak;
    end;

    result := LMsg;
  end;







end.
