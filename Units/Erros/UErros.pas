unit UErros;

interface

uses System.SysUtils,System.Classes;

type EErrorFormInput = class(Exception)
  public
    FCampos: TStringList;
    FValores: TStringList;

  constructor Create;
  destructor Destroy;
end;


implementation

  // ############# CADASTRO CLIENTES ############# CADASTRO CLIENTES ############# CADASTRO CLIENTES ############# CADASTRO CLIENTES ############# CADASTRO CLIENTES

  constructor EErrorFormInput.Create;
  begin
    Self.FCampos := TStringList.Create;
    Self.FValores := TStringList.Create;
    inherited Create('');
  end;

  //LIBERAR LISTAS
  destructor EErrorFormInput.Destroy;
  begin
    Self.FCampos.Free;
    Self.FValores.Free;

    inherited;
  end;

  end.
