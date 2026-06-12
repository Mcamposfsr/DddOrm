unit UDocValidator;

interface

uses
  System.SysUtils,System.Classes,System.Generics.Collections,Vcl.Dialogs;

type
  TDocValidator = class
  public
    //RETIRAR SINAIS DO DOCUMENTO
    class function NormalizarDocumento(const ADoc: String): String;

    //RECEBER DOCUMENTO NORMALIZADO PARA ANÁLISE
    class function ValidarCPF(const ACPF: String): Boolean;
    class function ValidarCNPJ(ACnpj:string):Boolean;
    class function ValidarDOC(ADoc:String):Boolean;
  end;

implementation
  //NORMALIZAR CPF
  class function TDocValidator.NormalizarDocumento(const ADoc: String): String;
  var
  I: Integer;
  begin
    Result := '';

    for I := 1 to Length(ADoc) do
    begin
      if ADoc[I] in ['0'..'9'] then
        Result := Result + ADoc[I];
    end;
  end;

  //VALIDAR CPF
  class function TDocValidator.ValidarCPF(const ACPF: String): Boolean;
  var
  CPF: String;
  Soma, Resto: Integer;
  Digito1, Digito2: Integer;
  I: Integer;
  begin
    CPF := NormalizarDocumento(ACPF);

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

   class function TDocValidator.ValidarCNPJ(ACnpj:string):Boolean;
  var
    LPesos1, LPesos2: TList<Integer>;
    LSoma1, LSoma2, I: Integer;
    LDigito1, LDigito2: String;
  begin
    if ACnpj = StringOfChar(ACnpj[1], 14) then
      Exit(False);

    LSoma1 := 0;
    LSoma2 := 0;

    LPesos1 := TList<Integer>.Create;
    LPesos1.AddRange([5,4,3,2,9,8,7,6,5,4,3,2]);

    LPesos2 := TList<Integer>.Create;
    LPesos2.AddRange([6,5,4,3,2,9,8,7,6,5,4,3,2]);
    try
      for I := 1 to LPesos1.Count do
        LSoma1 := LSoma1 + LPesos1[I-1] * (Ord(ACnpj[I]) - Ord('0'));

      for I := 1 to LPesos2.Count - 1 do
        LSoma2 := LSoma2 + LPesos2[I-1] * (Ord(ACnpj[I]) - Ord('0'));

      // DÍGITO 1
      if (LSoma1 mod 11) < 2 then
        LDigito1 := '0'
      else
        LDigito1 := IntToStr(11 - (LSoma1 mod 11));

      // DÍGITO 2
      LSoma2 := LSoma2 + LPesos2[12] * (Ord(LDigito1[1]) - Ord('0'));

      if (LSoma2 mod 11) < 2 then
        LDigito2 := '0'
      else
        LDigito2 := IntToStr(11 - (LSoma2 mod 11));


      if(ACnpj[13] <> LDigito1) or (ACnpj[14] <> LDigito2)then
        Result := False
      else
        Result := True;

    finally
      LPesos1.Free;
      LPesos2.Free;
    end;
  end;

  class function TDocValidator.ValidarDOC(ADoc:String):Boolean;
  begin
    Result := True;
    //VALIDAR CPF
    if ADOC.Length = 11 then
    begin
      Result := Self.ValidarCPF(ADoc);
    end;

    //VALIDAR CNPJ
    if ADOC.Length = 14 then
    begin
      Result := Self.ValidarCNPJ(ADoc);
    end;
  end;

end.
