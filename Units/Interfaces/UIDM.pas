unit UIDM;

interface
  uses Firedac.Comp.Client;

//INTERFACE DM
type
  IDM = interface
    function GetConnection: TFDConnection;
    procedure ConectarBD;
    procedure DesconectarBd;
    procedure ConnectionTest;
  end;

implementation

end.
