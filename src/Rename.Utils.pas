unit Rename.Utils;

interface

uses System.Classes, FireDAC.Comp.Client, Winapi.Windows;

type
  TDirectoryUtils = class
  private
    class function ValidateExtension(const Extension: string): Boolean;
    class function AddDirectorySeparator(const Root: string): string;
  public
    class procedure UpdateFiles(const DataSet: TFDMemTable);
    class function RenameFiles(const DataSet: TFDMemTable): Boolean;
    class function ValidateFileName(const DataSet: TFDMemTable): Boolean;
    class procedure GetSubDirectorys(const Directory: string; var DirectoryList: TStrings);
    class procedure ListAllFiles(const Directorys: TStrings; const DataSet: TFDMemTable);
    class procedure ReplaceFileName(const OldValue, NewValue: string; const DataSet: TFDMemTable);
    class procedure LoadNewFileName(const DataSet: TFDMemTable);
    class procedure SetOldClassName(const DataSet: TFDMemTable);
  end;

implementation

uses System.SysUtils, VCL.Wait, VCL.StdCtrls, Vcl.Forms, System.StrUtils;

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
        if ((Search.Attr and faDirectory) = faDirectory) and (Search.Name <> 'modules') and (Search.Name <> '.') and (Search.Name <> '..') then
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
  Search: TSearchRec;
begin
  DataSet.DisableControls;
  try
    TWait.Create('Searching files...').Start(
      procedure
      var
        I: Integer;
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
        end);
  finally
    DataSet.EnableControls;
  end;
end;

class procedure TDirectoryUtils.LoadNewFileName(const DataSet: TFDMemTable);
begin
  DataSet.DisableControls;
  try
    DataSet.First;
    while not DataSet.Eof do
    begin
      if DataSet.FieldByName('NEW_FILE_NAME').AsString.Trim.IsEmpty then
      begin
        DataSet.Edit;
        DataSet.FieldByName('NEW_FILE_NAME').AsString := DataSet.FieldByName('OLD_FILE_NAME').AsString;
        DataSet.Post;
      end;
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;
end;

class function TDirectoryUtils.RenameFiles(const DataSet: TFDMemTable): Boolean;
var
  Waiting: TWait;
  OldFile, NewFile: string;
begin
  Waiting := TWait.Create('Renaming files...');
  Waiting.ProgressBar.SetMax(DataSet.RecordCount);
  DataSet.DisableControls;
  DataSet.Filtered := False;
  try
    Waiting.Start(
      procedure
      var
        I: Integer;
      begin
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
          DataSet.Next;
        end;
      end);
    Result := True;
  finally
    DataSet.EnableControls;
  end;
end;

class procedure TDirectoryUtils.ReplaceFileName(const OldValue, NewValue: string; const DataSet: TFDMemTable);
begin
  DataSet.DisableControls;
  try
    DataSet.First;
    while not DataSet.Eof do
    begin
      DataSet.Edit;
      DataSet.FieldByName('NEW_FILE_NAME').AsString := StringReplace(DataSet.FieldByName('NEW_FILE_NAME').AsString, OldValue, NewValue, [rfReplaceAll]);
      DataSet.Post;
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;
end;

class procedure TDirectoryUtils.SetOldClassName(const DataSet: TFDMemTable);
var
  Waiting: TWait;
  Directory, OldClassName: string;
  Archive: TStrings;
  IsName: Boolean;
begin
  DataSet.DisableControls;
  Archive := TStringList.Create;
  Waiting := TWait.Create('Waiting...');
  Waiting.ProgressBar.SetMax(DataSet.RecordCount);
  try
    Waiting.Start(
      procedure
      var
        I: Integer;
      begin
        DataSet.First;
        while not DataSet.Eof do
        begin
          Waiting.SetContent('Waiting: File ' + DataSet.RecNo.ToString + ' of ' + DataSet.RecordCount.ToString + '...');
          Directory := DataSet.FieldByName('DIRECTORY').AsString + '\' + DataSet.FieldByName('OLD_FILE_NAME').AsString + '.dfm';
          if FileExists(Directory) then
          begin
            IsName := False;
            OldClassName := EmptyStr;
            Archive.LoadFromFile(Directory);
            for I := 0 to Pred(Archive.Text.Length) do
            begin
              if Archive.Text[I] = ' ' then
              begin
                IsName := True;
                Continue;
              end;
              if Archive.Text[I] = ':' then
              begin
                DataSet.Edit;
                DataSet.FieldByName('OLD_CLASS_NAME').AsString := OldClassName;
                DataSet.Post;
                Break;
              end;
              if IsName then
                OldClassName := OldClassName + Archive.Text[I];
            end;
            Archive.SaveToFile(Directory);
          end;
          Waiting.ProgressBar.Step;
          DataSet.Next;
        end;
      end);
  finally
    DataSet.Filtered := True;
    DataSet.EnableControls;
    Archive.Free;
  end;
end;

class procedure TDirectoryUtils.UpdateFiles(const DataSet: TFDMemTable);
var
  Waiting: TWait;
  mtClone: TFDMemTable;
  Directory: string;
  Archive: TStrings;
begin
  Waiting := TWait.Create('Updating files...');
  Waiting.ProgressBar.SetMax(DataSet.RecordCount);
  mtClone := TFDMemTable.Create(nil);
  DataSet.DisableControls;
  try
    Waiting.Start(
      procedure
      begin
        mtClone.CloneCursor(DataSet);
        DataSet.First;
        while not DataSet.Eof do
        begin
          Waiting.SetContent('Updating files ' + DataSet.RecNo.ToString + ' of ' + DataSet.RecordCount.ToString + '...');
          if (not DataSet.FieldByName('NEW_FILE_NAME').AsString.Trim.IsEmpty) or (not DataSet.FieldByName('NEW_CLASS_NAME').AsString.Trim.IsEmpty) then
          begin
            mtClone.First;
            Archive := TStringList.Create;
            try
              while not mtClone.Eof do
              begin
                if not ValidateExtension(mtClone.FieldByName('EXTENSION').AsString) then
                begin
                  mtClone.Next;
                  Continue;
                end;
                Directory := mtClone.FieldByName('DIRECTORY').AsString + '\' + mtClone.FieldByName('OLD_FILE_NAME').AsString + mtClone.FieldByName('EXTENSION').AsString;
                if not mtClone.FieldByName('NEW_FILE_NAME').AsString.Trim.IsEmpty then
                  Directory := mtClone.FieldByName('DIRECTORY').AsString + '\' + mtClone.FieldByName('NEW_FILE_NAME').AsString + mtClone.FieldByName('EXTENSION').AsString;
                try
                  Archive.LoadFromFile(Directory);
                  if not DataSet.FieldByName('NEW_FILE_NAME').AsString.Trim.IsEmpty then
                    Archive.Text := StringReplace(Archive.Text, DataSet.FieldByName('OLD_FILE_NAME').AsString, DataSet.FieldByName('NEW_FILE_NAME').AsString, [rfReplaceAll, rfIgnoreCase]);
                  if not DataSet.FieldByName('NEW_CLASS_NAME').AsString.Trim.IsEmpty then
                    Archive.Text := StringReplace(Archive.Text, DataSet.FieldByName('OLD_CLASS_NAME').AsString, DataSet.FieldByName('NEW_CLASS_NAME').AsString, [rfReplaceAll, rfIgnoreCase]);
                  Archive.SaveToFile(Directory);
                except
                  { TODO -oAll -cImplementation : handler exception }
                end;
                mtClone.Next;
              end;
            finally
              FreeAndNil(Archive);
            end;
          end;
          Waiting.ProgressBar.Step;
          DataSet.Next;
        end;
      end);
  finally
    DataSet.Filtered := True;
    DataSet.EnableControls;
    FreeAndNil(mtClone);
  end;
end;

class function TDirectoryUtils.ValidateExtension(const Extension: string): Boolean;
begin
  case AnsiIndexStr(Extension.ToLower, ['.pas', '.dfm', '.dpr', '.dproj']) of
    0..3:
      Result := True;
    else
      Result := False;
  end;
end;

class function TDirectoryUtils.ValidateFileName(const DataSet: TFDMemTable): Boolean;
var
  Validate: Boolean;
  mtClone: TFDMemTable;
begin
  Validate := True;
  DataSet.DisableControls;
  mtClone := TFDMemTable.Create(nil);
  try
    TWait.Create('Validating file name...').Start(
      procedure
      begin
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
                Validate := False;
                DataSet.Edit;
                DataSet.FieldByName('RENAME').AsString := 'S';
                DataSet.Post;
              end;
            mtClone.Next;
          end;
          DataSet.Next;
        end;
      end);
  finally
    FreeAndNil(mtClone);
    DataSet.EnableControls;
    Result := Validate;
  end;
end;

end.
