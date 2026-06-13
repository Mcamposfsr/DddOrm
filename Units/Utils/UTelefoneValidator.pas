unit UTelefoneValidator;

interface
  uses System.RegularExpressions;

  function ValidarTelefone(ATelefone:String):Boolean;
implementation

  function ValidarTelefone(ATelefone:String):Boolean;
  begin
    result :=  (TRegEx.IsMatch(ATelefone, '^\(?\d{2}\)?\s?\d{4,5}-\d{4}$'));
  end;

end.
