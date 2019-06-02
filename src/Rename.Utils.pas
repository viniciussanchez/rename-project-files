unit Rename.Utils;

interface

uses System.Classes, FireDAC.Comp.Client, Winapi.Windows;

type
  TDirectoryUtils = class
  private
    class function AddDirectorySeparator(const Root: string): string;
  public
    class procedure RenameFiles(const DataSet: TFDMemTable);
    class procedure GetSubDirectorys(const Directory: string; var DirectoryList: TStrings);
    class procedure ListAllFiles(const Directorys: TStrings; const DataSet: TFDMemTable);
  end;

implementation

uses System.SysUtils, VCL.Wait.Intf, VCL.Wait;

var
  Extensions: array [0 .. 1] of string = (
    '.pas',
    '.dfm'
  );

{ TDirectoryUtils }

class function TDirectoryUtils.AddDirectorySeparator(const Root: string): string;
begin
  Result := Root;
  if Result[Length(Result)] <> '\' then
    Result := Result + '\';
end;

class procedure TDirectoryUtils.GetSubDirectorys(const Directory: string; var DirectoryList: TStrings);
var
  Search: TSearchRec;
  SearchPath: string;
  SubDirectoryList: TStrings;
  I: Integer;
begin
  SubDirectoryList := TStringList.Create;
  DirectoryList.BeginUpdate;
  try
    SearchPath := AddDirectorySeparator(Directory);
    if FindFirst(SearchPath + '*', faDirectory, Search) = 0 then
      repeat
        if ((Search.Attr and faDirectory) = faDirectory) and (Search.Name <> '.') and (Search.Name <> '..') then
        begin
          DirectoryList.Add(SearchPath + Search.Name);
          SubDirectoryList.Add(SearchPath + Search.Name);
        end;
      until (FindNext(Search) <> 0);
    FindClose(Search);
    for I := 0 to SubDirectoryList.Count - 1 do
      GetSubDirectorys(SubDirectoryList.Strings[I], DirectoryList);
  finally
    DirectoryList.EndUpdate;
    FreeAndNil(SubDirectoryList);
  end;
end;

class procedure TDirectoryUtils.ListAllFiles(const Directorys: TStrings; const DataSet: TFDMemTable);
var
  I: Integer;
  Search: TSearchRec;
begin
  for I := 0 to Pred(Directorys.Count) do
    if FindFirst(Directorys[I] + '\*.*', faAnyFile, Search) = 0 then
    begin
      repeat
        if (Search.Attr <> faDirectory) then
        begin
          DataSet.Append;
          DataSet.FieldByName('DIRECTORY').AsString := Directorys[I];
          DataSet.FieldByName('EXTENSION').AsString := ExtractFileExt(Search.Name);
          DataSet.FieldByName('OLD_FILE_NAME').AsString := ChangeFileExt(Search.Name, EmptyStr);
          DataSet.Post;
        end;
      until FindNext(Search) <> 0;
      FindClose(Search);
    end;
end;

class procedure TDirectoryUtils.RenameFiles(const DataSet: TFDMemTable);
var
  I: Integer;
  Waiting: IWait;
  OldFile, NewFile: string;
begin
  Waiting := TWait.Create('Renaming files...');
  Waiting.ShowProgressBar(True);
  Waiting.ProgressBar.SetMax(DataSet.RecordCount);
  Waiting.ProgressBar.SetPosition(0);
  DataSet.DisableControls;
  try
    DataSet.First;
    while not DataSet.Eof do
    begin
      if DataSet.FieldByName('NEW_FILE_NAME').AsString.Trim.IsEmpty then
      begin
        DataSet.Next;
        Continue;
      end;
      OldFile := DataSet.FieldByName('DIRECTORY').AsString + '\' + DataSet.FieldByName('OLD_FILE_NAME').AsString;
      NewFile := DataSet.FieldByName('DIRECTORY').AsString + '\' + DataSet.FieldByName('NEW_FILE_NAME').AsString;
      for I := 0 to 1 do
        if FileExists(OldFile + Extensions[I]) then
          if not RenameFile(OldFile + Extensions[I], NewFile + Extensions[I]) then
            raise Exception.Create('Could not rename file: ' + OldFile + Extensions[I]);
      Waiting.ProgressBar.Step;
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;
end;

end.
