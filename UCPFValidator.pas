unit UCPFValidator;

interface

uses
  System.SysUtils;

type
  TCPFValidator = class
  public
    class function NormalizeCPF(const ACPF: String): String;
    class function Validate(const ACPF: String): Boolean;
  end;

implementation
  //NORMALIZAR CPF
  class function TCPFValidator.NormalizeCPF(const ACPF: String): String;
  var
  I: Integer;
  begin
    Result := '';

    for I := 1 to Length(ACPF) do
    begin
      if ACPF[I] in ['0'..'9'] then
        Result := Result + ACPF[I];
    end;
  end;

  //VALIDAR CPF
  class function TCPFValidator.Validate(const ACPF: String): Boolean;
  var
  CPF: String;
  Soma, Resto: Integer;
  Digito1, Digito2: Integer;
  I: Integer;
  begin
    CPF := NormalizeCPF(ACPF);

    if Length(CPF) <> 11 then
      Exit(False);

    // EVITAR 11111111111, 00000000000
    if CPF = StringOfChar(CPF[1], 11) then
      Exit(False);

    // PRIMEIRO DÍGITO
    Soma := 0;

    for I := 1 to 9 do
      Soma := Soma + (Ord(CPF[I]) - Ord('0')) * (11 - I);

    Resto := (Soma * 10) mod 11;

    if Resto = 10 then
      Resto := 0;

    Digito1 := Resto;

    // SEGUNDO DÍGITO
    Soma := 0;

    for I := 1 to 10 do
      Soma := Soma + (Ord(CPF[I]) - Ord('0')) * (12 - I);

    Resto := (Soma * 10) mod 11;

    if Resto = 10 then
      Resto := 0;

    Digito2 := Resto;

    Result :=
      (Digito1 = (Ord(CPF[10]) - Ord('0'))) and
      (Digito2 = (Ord(CPF[11]) - Ord('0')));
  end;

end.
