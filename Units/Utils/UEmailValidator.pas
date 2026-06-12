unit UEmailValidator;

interface

uses
  System.RegularExpressions;

function ValidarEmail(AEmail: String): Boolean;

implementation

  function ValidarEmail(AEmail: String): Boolean;
  begin
    Result := TRegEx.IsMatch(
      AEmail,
      '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    );
  end;

end.
