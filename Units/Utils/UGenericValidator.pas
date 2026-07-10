unit UGenericValidator;

interface
  uses System.RegularExpressions;

  function ValidarTelefone(ATelefone:String):Boolean;

  function ValidarNome(Anome:String):Boolean;
implementation

  function ValidarTelefone(ATelefone:String):Boolean;
  begin
    result :=  (TRegEx.IsMatch(ATelefone, '^(?:\d{11}|\(?\d{2}\)?\s?(?:\d{4,5}|\d\s\d{4})-\d{4})$'));
  end;

  function ValidarNome(Anome:String):Boolean;
  begin
    Result := (TRegEx.IsMatch(Anome, '^[A-Za-zÀ-ÖØ-öø-ÿ]+(?:[-''][A-Za-zÀ-ÖØ-öø-ÿ]+)?(?:\s+[A-Za-zÀ-ÖØ-öø-ÿ]+(?:[-''][A-Za-zÀ-ÖØ-öø-ÿ]+)?)*$'));
  end;

end.
