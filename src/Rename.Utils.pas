unit Rename.Utils;

interface

uses System.Classes, FireDAC.Comp.Client, Winapi.Windows;

type
  TDirectoryUtils = class
  private
    class function AddDirectorySeparator(const Root: string): string;
  public
    class procedure UpdateFiles(const DataSet: TFDMemTable);
    class function RenameFiles(const DataSet: TFDMemTable): Boolean;
    class function ValidateFileName(const DataSet: TFDMemTable): Boolean;
    class procedure GetSubDirectorys(const Directory: string; var DirectoryList: TStrings);
    class procedure ListAllFiles(const Directorys: TStrings; const DataSet: TFDMemTable);
  end;

implementation

uses System.SysUtils, VCL.Wait.Intf, VCL.Wait, VCL.StdCtrls, Vcl.Forms;

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
  Waiting: IWait;
begin
  Waiting := TWait.Create('Searching files...');
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

class function TDirectoryUtils.RenameFiles(const DataSet: TFDMemTable): Boolean;
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
          RenameFile(OldFile + Extensions[I], NewFile + Extensions[I]);
      Waiting.ProgressBar.Step;
      Application.ProcessMessages;
      DataSet.Next;
    end;
    Result := True;
  finally
    DataSet.EnableControls;
  end;
end;

class procedure TDirectoryUtils.UpdateFiles(const DataSet: TFDMemTable);
var
  Waiting: IWait;
  mtClone: TFDMemTable;
  Archive: TStrings;
  Directory: string;
begin
  Waiting := TWait.Create('Updating files...');
  Waiting.ShowProgressBar(True);
  Waiting.ProgressBar.SetPosition(0);
  mtClone := TFDMemTable.Create(nil);
  DataSet.DisableControls;
  try
    DataSet.Filtered := False;
    Waiting.ProgressBar.SetMax(DataSet.RecordCount);
    mtClone.CloneCursor(DataSet);
    DataSet.First;
    while not DataSet.Eof do
    begin
      Waiting.SetContent('Updating files ' + DataSet.RecNo.ToString + ' of ' + DataSet.RecordCount.ToString + '...');
      if not DataSet.FieldByName('NEW_FILE_NAME').AsString.Trim.IsEmpty then
      begin
        mtClone.First;
        while not mtClone.Eof do
        begin
          if not mtClone.FieldByName('NEW_FILE_NAME').AsString.IsEmpty then
          begin
            Archive := TStringList.Create;
            try
              Directory := DataSet.FieldByName('DIRECTORY').AsString + '\' + DataSet.FieldByName('NEW_FILE_NAME').AsString + DataSet.FieldByName('EXTENSION').AsString;
              Archive.LoadFromFile(Directory);
              Archive.Text := StringReplace(Archive.Text, mtClone.FieldByName('OLD_FILE_NAME').AsString, mtClone.FieldByName('NEW_FILE_NAME').AsString, [rfReplaceAll, rfIgnoreCase]);
              Archive.SaveToFile(Directory);
            finally
              Archive.Free;
            end;
          end;
          mtClone.Next;
        end;
      end;
      Waiting.ProgressBar.Step;
      Application.ProcessMessages;
      DataSet.Next;
    end;
  finally
    DataSet.Filtered := True;
    DataSet.EnableControls;
    mtClone.Free;
  end;
end;

class function TDirectoryUtils.ValidateFileName(const DataSet: TFDMemTable): Boolean;
var
  Waiting: IWait;
  mtClone: TFDMemTable;
begin
  Result := True;
  Waiting := TWait.Create('Validating file name...');
  DataSet.DisableControls;
  mtClone := TFDMemTable.Create(nil);
  try
    DataSet.First;
    mtClone.CloneCursor(DataSet);
    while not DataSet.Eof do
    begin
      mtClone.First;
      while not mtClone.Eof do
      begin
        if not mtClone.FieldByName('NEW_FILE_NAME').AsString.Trim.IsEmpty then
          if (mtClone.FieldByName('NEW_FILE_NAME').AsString.Equals(DataSet.FieldByName('NEW_FILE_NAME').AsString) or
            mtClone.FieldByName('OLD_FILE_NAME').AsString.Equals(DataSet.FieldByName('NEW_FILE_NAME').AsString) or
            mtClone.FieldByName('NEW_FILE_NAME').AsString.Equals(DataSet.FieldByName('OLD_FILE_NAME').AsString) or
            mtClone.FieldByName('OLD_FILE_NAME').AsString.Equals(DataSet.FieldByName('OLD_FILE_NAME').AsString)) and
            mtClone.FieldByName('DIRECTORY').AsString.Equals(DataSet.FieldByName('DIRECTORY').AsString) and
            (mtClone.RecNo <> DataSet.RecNo) then
          begin
            Result := False;
            DataSet.Edit;
            DataSet.FieldByName('RENAME').AsString := 'S';
            DataSet.Post;
          end;
        mtClone.Next;
      end;
      DataSet.Next;
    end;
  finally
    mtClone.Free;
    DataSet.EnableControls;
  end;
end;

end.
