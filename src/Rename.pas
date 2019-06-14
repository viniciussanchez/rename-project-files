unit Rename;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.ExprFuncs;

type
  TFrmMain = class(TForm)
    Panel1: TPanel;
    dsFiles: TDataSource;
    mtFiles: TFDMemTable;
    DBGrid1: TDBGrid;
    mtFilesOLD_FILE_NAME: TStringField;
    mtFilesNEW_FILE_NAME: TStringField;
    mtFilesOLD_CLASS_NAME: TStringField;
    mtFilesNEW_CLASS_NAME: TStringField;
    mtFilesEXTENSION: TStringField;
    Panel2: TPanel;
    Button1: TButton;
    mtFilesDIRECTORY: TStringField;
    Button2: TButton;
    Button3: TButton;
    mtFilesRENAME: TStringField;
    Panel3: TPanel;
    Label1: TLabel;
    edtDirectory: TEdit;
    btnSearch: TButton;
    Panel4: TPanel;
    Label2: TLabel;
    edtFilterFileName: TEdit;
    btnFilter: TButton;
    Panel5: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    edtTextFind: TEdit;
    btnReplace: TButton;
    edtReplace: TEdit;
    Button4: TButton;
    procedure btnSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure mtFilesAfterInsert(DataSet: TDataSet);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnFilterClick(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure edtFilterFileNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    function GetDataFileName: string;
  end;

var
  FrmMain: TFrmMain;

implementation

uses Vcl.FileCtrl, Rename.Utils, DataSet.Serialize.Helper, System.JSON, VCL.Wait, Dialogs4D.Factory;

{$R *.dfm}

procedure TFrmMain.btnFilterClick(Sender: TObject);
begin
  if not mtFiles.Active then
    Exit;
  mtFiles.Filtered := False;
  if not Trim(edtFilterFileName.Text).IsEmpty then
  begin
    mtFiles.Filter :=
      'Lower(OLD_FILE_NAME) like ' + QuotedStr('%' + Trim(edtFilterFileName.Text).ToLower + '%') +
      ' or Lower(NEW_FILE_NAME) like ' + QuotedStr('%' + Trim(edtFilterFileName.Text).ToLower + '%');
    mtFiles.Filtered := True;
  end;
end;

procedure TFrmMain.btnReplaceClick(Sender: TObject);
begin
  if Trim(edtTextFind.Text).IsEmpty or mtFiles.IsEmpty then
    Exit;
  TDirectoryUtils.ReplaceFileName(edtTextFind.Text, edtReplace.Text, mtFiles);
end;

procedure TFrmMain.btnSearchClick(Sender: TObject);
var
  Directory: string;
  DirectoryList: TStrings;
begin
  if SelectDirectory(Directory, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
  begin
    edtDirectory.Text := Directory;
    DirectoryList := TStringList.Create;
    try
      DirectoryList.Add(Directory);
      TDirectoryUtils.GetSubDirectorys(Directory, DirectoryList);
      TDirectoryUtils.ListAllFiles(DirectoryList, mtFiles);
    finally
      DirectoryList.Free;
    end;
  end;
end;

procedure TFrmMain.Button1Click(Sender: TObject);
begin
  if mtFiles.IsEmpty then
    Exit;
  if TDialogs.Confirm('Do you want to rename the files?') then
  begin
    if TDirectoryUtils.ValidateFileName(mtFiles) then
    begin
      if TDirectoryUtils.RenameFiles(mtFiles) then
        TDirectoryUtils.UpdateFiles(mtFiles);
    end
    else
      TDialogs.Warning('Invalid filename');
  end;
end;

procedure TFrmMain.Button2Click(Sender: TObject);
var
  DataArray: TJSONArray;
  Data: TStrings;
begin
  if not FileExists(GetDataFileName) then
  begin
    TDialogs.Warning('Data file not found!');
    Exit;
  end;
  Data := TStringList.Create;
  try
    Data.LoadFromFile(GetDataFileName);
    DataArray := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Data.Text),0) as TJSONArray;
    mtFiles.DisableControls;
    try
      mtFiles.EmptyDataSet;
      TWait.Create('Loading...').Start(
        procedure
        begin
          mtFiles.LoadFromJSONArray(DataArray);
        end);
    finally
      mtFiles.EnableControls;
      DataArray.Free;
    end;
  finally
    Data.Free;
  end;
end;

procedure TFrmMain.Button3Click(Sender: TObject);
var
  Data: TJSONArray;
  SaveFile: TStrings;
begin
  mtFiles.DisableControls;
  try
    Data := mtFiles.ToJSONArray;
    try
      SaveFile := TStringList.Create;
      try
        SaveFile.Text := Data.ToString;
        SaveFile.SaveToFile(GetDataFileName);
      finally
        SaveFile.Free;
      end;
      TDialogs.Info('Exported: ' + GetDataFileName);
    finally
      Data.Free;
    end;
  finally
    mtFiles.EnableControls;
  end;
end;

procedure TFrmMain.Button4Click(Sender: TObject);
begin
  TDirectoryUtils.LoadNewFileName(mtFiles);
end;

procedure TFrmMain.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if mtFilesRENAME.AsString = 'S' then
    DBGrid1.Canvas.Brush.Color := clRed;
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFrmMain.DBGrid1TitleClick(Column: TColumn);
begin
  mtFiles.IndexFieldNames := Column.FieldName;
end;

procedure TFrmMain.edtFilterFileNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      btnFilter.Click;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  mtFiles.Active := True;
  mtFiles.Filter := 'EXTENSION = ''.pas''';
  mtFiles.Filtered := True;
end;

function TFrmMain.GetDataFileName: string;
begin
  Result := ExtractFilePath(Application.ExeName) + 'Rename.json';
end;

procedure TFrmMain.mtFilesAfterInsert(DataSet: TDataSet);
begin
  mtFilesRENAME.AsString := 'N';
end;

end.
