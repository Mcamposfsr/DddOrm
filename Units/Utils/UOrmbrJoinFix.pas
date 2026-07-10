unit uFirebird15SQLGenerator;

interface

uses
  ormbr.dml.generator.firebird,     // Gerador original do Firebird
  ormbr.dml.generator.abstract,     // Este é o correto (base)
  dbcbr.mapping.attributes;         // Para TJoin

type
  TFirebird15SQLGenerator = class(TFirebirdSQLGenerator)
  protected
    function GetJoinClause(const AJoin: TJoin): string; override;
  end;

implementation

function TFirebird15SQLGenerator.GetJoinClause(const AJoin: TJoin): string;
begin
  Result := inherited GetJoinClause(AJoin);

  // Remove " AS " → Firebird 1.5 não gosta
  Result := StringReplace(Result, ' AS ', ' ', [rfReplaceAll, rfIgnoreCase]);
end;

initialization
  TSQLGeneratorRegister.RegisterGenerator(dnFirebird, TFirebird15SQLGenerator);
end.
