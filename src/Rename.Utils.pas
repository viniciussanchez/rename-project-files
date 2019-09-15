unit Rename.Utils;

interface

uses System.Classes, FireDAC.Comp.Client, Winapi.Windows;

type
  TDirectoryUtils = class
  private
    class function ValidateExtension(const AExtension: string): Boolean;
    class function AddDirectorySeparator(const ARoot: string): string;
  public
    class procedure UpdateFiles(const ADataSet: TFDMemTable);
    class function RenameFiles(const ADataSet: TFDMemTable): Boolean;
    class function ValidateFileName(const ADataSet: TFDMemTable): Boolean;
    class procedure GetSubDirectorys(const ADirectory: string; var ADirectoryList: TStrings);
    class procedure ListAllFiles(const ADirectorys: TStrings; const ADataSet: TFDMemTable);
    class procedure Replace(const AFieldName, AOldValue, ANewValue: string; const ADataSet: TFDMemTable);
    class procedure LoadNewFileName(const ADataSet: TFDMemTable);
    class procedure LoadNewClassName(const ADataSet: TFDMemTable);
    class procedure SetOldClassName(const ADataSet: TFDMemTable);
  end;

implementation

uses System.SysUtils, VCL.Wait, VCL.StdCtrls, Vcl.Forms, System.StrUtils;

var
  Extensions: array [0 .. 1] of string = (
    '.pas',
    '.dfm'
  );

{ TDirectoryUtils }

class function TDirectoryUtils.AddDirectorySeparator(const ARoot: string): string;
begin
  Result := ARoot;
  if Result[Length(Result)] <> '\' then
    Result := Result + '\';
end;

class procedure TDirectoryUtils.GetSubDirectorys(const ADirectory: string; var ADirectoryList: TStrings);
var
  LSearch: TSearchRec;
  LSearchPath: string;
  LSubDirectoryList: TStrings;
  I: Integer;
begin
  LSubDirectoryList := TStringList.Create;
  ADirectoryList.BeginUpdate;
  try
    LSearchPath := AddDirectorySeparator(ADirectory);
    if FindFirst(LSearchPath + '*', faDirectory, LSearch) = 0 then
      repeat
        if ((LSearch.Attr and faDirectory) = faDirectory) and (LSearch.Name <> 'modules') and (LSearch.Name <> '.') and (LSearch.Name <> '..') then
        begin
          ADirectoryList.Add(LSearchPath + LSearch.Name);
          LSubDirectoryList.Add(LSearchPath + LSearch.Name);
        end;
      until (FindNext(LSearch) <> 0);
    FindClose(LSearch);
    for I := 0 to LSubDirectoryList.Count - 1 do
      GetSubDirectorys(LSubDirectoryList.Strings[I], ADirectoryList);
  finally
    ADirectoryList.EndUpdate;
    FreeAndNil(LSubDirectoryList);
  end;
end;

class procedure TDirectoryUtils.ListAllFiles(const ADirectorys: TStrings; const ADataSet: TFDMemTable);
var
  LSearch: TSearchRec;
begin
  ADataSet.DisableControls;
  try
    TWait.Create('Searching files...').Start(
      procedure
      var
        I: Integer;
      begin
        for I := 0 to Pred(ADirectorys.Count) do
          if FindFirst(ADirectorys[I] + '\*.*', faAnyFile, LSearch) = 0 then
          begin
            repeat
              if (LSearch.Attr <> faDirectory) then
              begin
                ADataSet.Append;
                ADataSet.FieldByName('DIRECTORY').AsString := ADirectorys[I];
                ADataSet.FieldByName('EXTENSION').AsString := ExtractFileExt(LSearch.Name);
                ADataSet.FieldByName('OLD_FILE_NAME').AsString := ChangeFileExt(LSearch.Name, EmptyStr);
                ADataSet.Post;
              end;
            until FindNext(LSearch) <> 0;
            FindClose(LSearch);
          end;
        end);
  finally
    ADataSet.EnableControls;
  end;
end;

class procedure TDirectoryUtils.LoadNewClassName(const ADataSet: TFDMemTable);
begin
  ADataSet.DisableControls;
  try
    ADataSet.First;
    while not ADataSet.Eof do
    begin
      if ADataSet.FieldByName('NEW_CLASS_NAME').AsString.Trim.IsEmpty then
      begin
        ADataSet.Edit;
        ADataSet.FieldByName('NEW_CLASS_NAME').AsString := ADataSet.FieldByName('OLD_CLASS_NAME').AsString;
        ADataSet.Post;
      end;
      ADataSet.Next;
    end;
  finally
    ADataSet.EnableControls;
  end;
end;

class procedure TDirectoryUtils.LoadNewFileName(const ADataSet: TFDMemTable);
begin
  ADataSet.DisableControls;
  try
    ADataSet.First;
    while not ADataSet.Eof do
    begin
      if ADataSet.FieldByName('NEW_FILE_NAME').AsString.Trim.IsEmpty then
      begin
        ADataSet.Edit;
        ADataSet.FieldByName('NEW_FILE_NAME').AsString := ADataSet.FieldByName('OLD_FILE_NAME').AsString;
        ADataSet.Post;
      end;
      ADataSet.Next;
    end;
  finally
    ADataSet.EnableControls;
  end;
end;

class function TDirectoryUtils.RenameFiles(const ADataSet: TFDMemTable): Boolean;
var
  LWaiting: TWait;
  LOldFile, LNewFile: string;
begin
  LWaiting := TWait.Create('Renaming files...');
  LWaiting.ProgressBar.SetMax(ADataSet.RecordCount);
  ADataSet.DisableControls;
  ADataSet.Filtered := False;
  try
    LWaiting.Start(
      procedure
      var
        I: Integer;
      begin
        ADataSet.First;
        while not ADataSet.Eof do
        begin
          if ADataSet.FieldByName('NEW_FILE_NAME').AsString.Trim.IsEmpty then
          begin
            ADataSet.Next;
            Continue;
          end;
          LOldFile := ADataSet.FieldByName('DIRECTORY').AsString + '\' + ADataSet.FieldByName('OLD_FILE_NAME').AsString;
          LNewFile := ADataSet.FieldByName('DIRECTORY').AsString + '\' + ADataSet.FieldByName('NEW_FILE_NAME').AsString;
          for I := 0 to 1 do
            if FileExists(LOldFile + Extensions[I]) then
              RenameFile(LOldFile + Extensions[I], LNewFile + Extensions[I]);
          LWaiting.ProgressBar.Step;
          ADataSet.Next;
        end;
      end);
    Result := True;
  finally
    ADataSet.EnableControls;
  end;
end;

class procedure TDirectoryUtils.Replace(const AFieldName, AOldValue, ANewValue: string; const ADataSet: TFDMemTable);
begin
  ADataSet.DisableControls;
  try
    ADataSet.First;
    while not ADataSet.Eof do
    begin
      ADataSet.Edit;
      ADataSet.FieldByName(AFieldName).AsString := StringReplace(ADataSet.FieldByName(AFieldName).AsString, AOldValue, ANewValue, [rfReplaceAll]);
      ADataSet.Post;
      ADataSet.Next;
    end;
  finally
    ADataSet.EnableControls;
  end;
end;

class procedure TDirectoryUtils.SetOldClassName(const ADataSet: TFDMemTable);
var
  LWaiting: TWait;
  LDirectory, LOldClassName: string;
  LArchive: TStrings;
  LIsName: Boolean;
begin
  ADataSet.DisableControls;
  LArchive := TStringList.Create;
  LWaiting := TWait.Create('Waiting...');
  LWaiting.ProgressBar.SetMax(ADataSet.RecordCount);
  try
    LWaiting.Start(
      procedure
      var
        I: Integer;
      begin
        ADataSet.First;
        while not ADataSet.Eof do
        begin
          LWaiting.SetContent('Waiting: File ' + ADataSet.RecNo.ToString + ' of ' + ADataSet.RecordCount.ToString + '...');
          LDirectory := ADataSet.FieldByName('DIRECTORY').AsString + '\' + ADataSet.FieldByName('OLD_FILE_NAME').AsString + '.dfm';
          if FileExists(LDirectory) then
          begin
            LIsName := False;
            LOldClassName := EmptyStr;
            LArchive.LoadFromFile(LDirectory);
            for I := 0 to Pred(LArchive.Text.Length) do
            begin
              if LArchive.Text[I] = ' ' then
              begin
                LIsName := True;
                Continue;
              end;
              if LArchive.Text[I] = ':' then
              begin
                ADataSet.Edit;
                ADataSet.FieldByName('OLD_CLASS_NAME').AsString := LOldClassName;
                ADataSet.Post;
                Break;
              end;
              if LIsName then
                LOldClassName := LOldClassName + LArchive.Text[I];
            end;
            LArchive.SaveToFile(LDirectory);
          end;
          LWaiting.ProgressBar.Step;
          ADataSet.Next;
        end;
      end);
  finally
    ADataSet.Filtered := True;
    ADataSet.EnableControls;
    LArchive.Free;
  end;
end;

class procedure TDirectoryUtils.UpdateFiles(const ADataSet: TFDMemTable);
var
  LWaiting: TWait;
  LClone: TFDMemTable;
  LDirectory: string;
  LArchive: TStrings;
begin
  LWaiting := TWait.Create('Updating files...');
  LWaiting.ProgressBar.SetMax(ADataSet.RecordCount);
  LClone := TFDMemTable.Create(nil);
  ADataSet.DisableControls;
  try
    LWaiting.Start(
      procedure
      begin
        LClone.CloneCursor(ADataSet);
        ADataSet.First;
        while not ADataSet.Eof do
        begin
          LWaiting.SetContent('Updating files ' + ADataSet.RecNo.ToString + ' of ' + ADataSet.RecordCount.ToString + '...');
          if (not ADataSet.FieldByName('NEW_FILE_NAME').AsString.Trim.IsEmpty) or (not ADataSet.FieldByName('NEW_CLASS_NAME').AsString.Trim.IsEmpty) then
          begin
            LClone.First;
            LArchive := TStringList.Create;
            try
              while not LClone.Eof do
              begin
                if not ValidateExtension(LClone.FieldByName('EXTENSION').AsString) then
                begin
                  LClone.Next;
                  Continue;
                end;
                LDirectory := LClone.FieldByName('DIRECTORY').AsString + '\' + LClone.FieldByName('OLD_FILE_NAME').AsString + LClone.FieldByName('EXTENSION').AsString;
                if not LClone.FieldByName('NEW_FILE_NAME').AsString.Trim.IsEmpty then
                  LDirectory := LClone.FieldByName('DIRECTORY').AsString + '\' + LClone.FieldByName('NEW_FILE_NAME').AsString + LClone.FieldByName('EXTENSION').AsString;
                try
                  LArchive.LoadFromFile(LDirectory);
                  if not ADataSet.FieldByName('NEW_FILE_NAME').AsString.Trim.IsEmpty then
                    LArchive.Text := StringReplace(LArchive.Text, ADataSet.FieldByName('OLD_FILE_NAME').AsString, ADataSet.FieldByName('NEW_FILE_NAME').AsString, [rfReplaceAll, rfIgnoreCase]);
                  if not ADataSet.FieldByName('NEW_CLASS_NAME').AsString.Trim.IsEmpty then
                    LArchive.Text := StringReplace(LArchive.Text, ADataSet.FieldByName('OLD_CLASS_NAME').AsString, ADataSet.FieldByName('NEW_CLASS_NAME').AsString, [rfReplaceAll, rfIgnoreCase]);
                  LArchive.SaveToFile(LDirectory);
                except
                  { TODO -oAll -cImplementation : handler exception }
                end;
                LClone.Next;
              end;
            finally
              FreeAndNil(LArchive);
            end;
          end;
          LWaiting.ProgressBar.Step;
          ADataSet.Next;
        end;
      end);
  finally
    ADataSet.Filtered := True;
    ADataSet.EnableControls;
    FreeAndNil(LClone);
  end;
end;

class function TDirectoryUtils.ValidateExtension(const AExtension: string): Boolean;
begin
  case AnsiIndexStr(AExtension.ToLower, ['.pas', '.dfm', '.dpr', '.dproj']) of
    0..3:
      Result := True;
    else
      Result := False;
  end;
end;

class function TDirectoryUtils.ValidateFileName(const ADataSet: TFDMemTable): Boolean;
var
  LValidate: Boolean;
  LClone: TFDMemTable;
begin
  LValidate := True;
  ADataSet.DisableControls;
  LClone := TFDMemTable.Create(nil);
  try
    TWait.Create('Validating file name...').Start(
      procedure
      begin
        ADataSet.First;
        LClone.CloneCursor(ADataSet);
        while not ADataSet.Eof do
        begin
          LClone.First;
          while not LClone.Eof do
          begin
            if not LClone.FieldByName('NEW_FILE_NAME').AsString.Trim.IsEmpty then
              if (LClone.FieldByName('NEW_FILE_NAME').AsString.Equals(ADataSet.FieldByName('NEW_FILE_NAME').AsString) or
                LClone.FieldByName('OLD_FILE_NAME').AsString.Equals(ADataSet.FieldByName('NEW_FILE_NAME').AsString) or
                LClone.FieldByName('NEW_FILE_NAME').AsString.Equals(ADataSet.FieldByName('OLD_FILE_NAME').AsString) or
                LClone.FieldByName('OLD_FILE_NAME').AsString.Equals(ADataSet.FieldByName('OLD_FILE_NAME').AsString)) and
                LClone.FieldByName('DIRECTORY').AsString.Equals(ADataSet.FieldByName('DIRECTORY').AsString) and
                (LClone.RecNo <> ADataSet.RecNo) then
              begin
                LValidate := False;
                ADataSet.Edit;
                ADataSet.FieldByName('RENAME').AsString := 'S';
                ADataSet.Post;
              end;
            LClone.Next;
          end;
          ADataSet.Next;
        end;
      end);
  finally
    FreeAndNil(LClone);
    ADataSet.EnableControls;
    Result := LValidate;
  end;
end;

end.
