unit UDataSetColumnSum;

interface

uses Data.DB;

  function SomarColunaDataSet(ADataSet:TDataSet;AColumn:String): Currency;

implementation

  //SOMAR UMA COLUNA DO DATASET E OBTER RESULTADO
  function SomarColunaDataSet(ADataSet:TDataSet;AColumn:String): Currency;
  var LBookMark: TBookMark;
  begin
    Result := 0;
    //GUARDAR INDICE ATUAL DO DATASET
    LBookMark := ADataSet.GetBookmark;
    //DESATIVAR LIGAÇÃO COM GRID
      ADataSet.DisableControls;
      try
        ADataSet.First;
        while not ADataSet.Eof do
        begin
          //CALCULAR
          Result := Result + ADataSet.FieldByName(AColumn).AsCurrency;
          ADataSet.Next;
        end;
      finally
        if ADataSet.BookmarkValid(LBookmark) then
        ADataSet.GotoBookmark(LBookmark);
        ADataSet.FreeBookmark(LBookmark);
        ADataSet.EnableControls;
      end;
  end;

end.
